#!/usr/bin/env python3
"""
Check batch regole STEMI con due modalità iniziali:
1) creazione gold standard
2) comparazione tra modelli

In modalità comparazione:
- modello test selezionabile dal menu dei modelli di comparazione
- dopo ogni check confronta il risultato con la GOLD omonima e stampa
  un punteggio di conformità 0..10.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from time import perf_counter
from urllib import error, request

ROOT = Path(__file__).resolve().parent
STEMI_DIR = ROOT / "CARDIO" / "STEMI"
EPISODES_DIR = STEMI_DIR / "EPISODES"
RULES_DIR = STEMI_DIR / "RULES"
CHECK_SCHEMA_PATH = ROOT / "SRS" / "check_rule_schema.json"
BASE_PROMPT_PATH = ROOT / "SRS" / "PROMPT_CheckRegoleSTEMI_plain.md"
REFERENCE_PROMPT_TEMPLATE_PATH = ROOT / "SRS" / "PROMPT_CheckRegoleSTEMI_reference_template.md"
RATIONALE_ALIGNMENT_PROMPT_PATH = ROOT / "SRS" / "PROMPT_RationaleAlignmentJudge.md"

OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
DEFAULT_GOLD_MODEL = "anthropic/claude-opus-4.6"
DEFAULT_RATIONALE_ALIGNMENT_MODEL = "anthropic/claude-sonnet-4.6"
COMPARISON_MODELS = {
    "1": "qwen/qwen3.5-35b-a3b",
    "2": "google/gemini-3-flash-preview",
    "3": "google/gemini-3.1-flash-lite-preview",
    "4": "google/gemini-3.1-pro-preview",
    "5": "openai/gpt-oss-120b",
    "6": "openai/gpt-5.4",
    "7": "anthropic/claude-haiku-4.5",
    "8": "anthropic/claude-sonnet-4.5",
    "9": "deepseek/deepseek-v3.2",
    "10": "z-ai/glm-5",
    "11": "mistralai/mistral-small-2603",
    "12": "x-ai/grok-4.1-fast",
    "13": "google/gemma-4-26b-a4b-it",
    "14": "google/gemma-4-31b-it",
    "15": "openai/gpt-5.4-pro",
}

REASONING_EFFORTS = {
    "1": "low",
    "2": "medium",
    "3": "high",
}

RUNAWAY_TOKEN_LIMITS_BY_MODEL: dict[str, int | None] = {
    model_name: None for model_name in COMPARISON_MODELS.values()
}
# Modello 3 (google/gemini-3.1-flash-lite-preview): cap esplicito richiesto.
RUNAWAY_TOKEN_LIMITS_BY_MODEL["google/gemini-3.1-flash-lite-preview"] = 10000
_RUNAWAY_TOKEN_LIMITS_BY_MODEL_NORM = {
    model_name.lower(): limit for model_name, limit in RUNAWAY_TOKEN_LIMITS_BY_MODEL.items()
}

OUTCOME_ALIGNMENT_TRUTH_MATRIX: dict[tuple[str, str], float] = {
    ("non_compliant", "probable_non_compliance"): 0.75,
    ("probable_non_compliance", "non_compliant"): 0.75,
    ("non_compliant", "justified_deviation"): 0.50,
    ("justified_deviation", "non_compliant"): 0.50,
    ("justified_deviation", "probable_non_compliance"): 0.40,
    ("probable_non_compliance", "justified_deviation"): 0.40,
    ("not_applicable", "not_evaluable"): 0.60,
    ("not_evaluable", "not_applicable"): 0.60,
}


def _provider_for_model(model: str) -> dict | None:
    m = (model or "").strip().lower()
    if "gpt-oss-120b" in m or "gpt-oss120b" in m:
        return {"order": ["baseten/fp4"], "allow_fallbacks": False}
    if m == "google/gemma-4-26b-a4b-it":
        return {"order": ["novita/bf16"], "allow_fallbacks": False}
    if m.startswith("google/gemini"):
        return {"order": ["google-vertex"], "allow_fallbacks": False}
    if m.startswith("qwen/"):
        return {"order": ["parasail/fp8"], "allow_fallbacks": False}
    return None


def _runaway_token_limit_for_model(model: str) -> int | None:
    m = (model or "").strip().lower()
    return _RUNAWAY_TOKEN_LIMITS_BY_MODEL_NORM.get(m)


def _is_runaway_cap_hit(finish_reason: str | None) -> bool:
    if not finish_reason:
        return False
    fr = finish_reason.strip().lower()
    return (fr == "length") or (fr == "max_tokens") or ("length" in fr) or ("max_tokens" in fr)


class RuleCheckError(Exception):
    pass


@dataclass(frozen=True)
class EpisodeSelection:
    label: str
    episode_input_path: Path
    output_dir: Path


def _read_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _write_json(path: Path, payload: dict) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
        f.write("\n")


def _strip_markdown_fences(text: str) -> str:
    t = text.strip()
    if t.startswith("```"):
        lines = t.splitlines()
        if lines and lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip() == "```":
            lines = lines[:-1]
        return "\n".join(lines).strip()
    return t


def _sanitize_json_schema_for_openrouter(schema: object) -> object:
    unsupported_keywords = {
        "minimum",
        "maximum",
        "exclusiveMinimum",
        "exclusiveMaximum",
        "multipleOf",
        "minLength",
        "maxLength",
        "pattern",
        "format",
        "minItems",
        "maxItems",
        "uniqueItems",
        "minProperties",
        "maxProperties",
    }

    if isinstance(schema, dict):
        cleaned: dict = {}
        for k, v in schema.items():
            if k in unsupported_keywords:
                continue
            cleaned[k] = _sanitize_json_schema_for_openrouter(v)
        return cleaned

    if isinstance(schema, list):
        return [_sanitize_json_schema_for_openrouter(item) for item in schema]

    return schema


def _post_openrouter_with_meta(api_key: str, payload: dict) -> tuple[str, str | None]:
    data = json.dumps(payload).encode("utf-8")
    req = request.Request(
        OPENROUTER_URL,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://local.stemi-rule-checker",
            "X-Title": "STEMI Rule Checker",
        },
    )

    try:
        with request.urlopen(req, timeout=240) as resp:
            raw = resp.read().decode("utf-8")
    except error.HTTPError as e:
        details = e.read().decode("utf-8", errors="replace")
        raise RuleCheckError(f"OpenRouter HTTP {e.code}: {details}") from e
    except Exception as e:
        raise RuleCheckError(f"Errore chiamata OpenRouter: {e}") from e

    try:
        body = json.loads(raw)
        choice0 = body["choices"][0]
        content = choice0["message"]["content"]
        finish_reason = choice0.get("finish_reason")
    except Exception as e:
        raise RuleCheckError(f"Risposta OpenRouter non valida: {raw}") from e

    if isinstance(content, list):
        content = "\n".join(str(block.get("text", "")) for block in content if isinstance(block, dict))

    if not isinstance(content, str) or not content.strip():
        raise RuleCheckError("La risposta del modello non contiene JSON testuale.")

    return content, finish_reason


def _post_openrouter(api_key: str, payload: dict) -> str:
    content, _ = _post_openrouter_with_meta(api_key=api_key, payload=payload)
    return content


def _load_jsonschema_validator(schema: dict):
    try:
        from jsonschema import Draft202012Validator
    except Exception as e:
        raise RuleCheckError("Dipendenza mancante: installare 'jsonschema'.") from e

    return Draft202012Validator(schema)


def _discover_episodes(episodes_dir: Path) -> list[EpisodeSelection]:
    if not episodes_dir.exists():
        return []

    selections: list[EpisodeSelection] = []

    for item in sorted(episodes_dir.iterdir(), key=lambda p: p.name.lower()):
        # Mostriamo solo i JSON episodio "sorgente" nella root EPISODES.
        # Le sottocartelle (che contengono GOLD/CHECK/PROMPT) NON sono selezionabili.
        if item.is_file() and item.suffix.lower() == ".json":
            out_dir = episodes_dir / item.stem
            selections.append(
                EpisodeSelection(
                    label=item.name,
                    episode_input_path=item,
                    output_dir=out_dir,
                )
            )

    return selections


def _choose_episode(episodes_dir: Path) -> EpisodeSelection:
    options = _discover_episodes(episodes_dir)
    if not options:
        raise RuleCheckError(f"Nessun episodio selezionabile trovato in: {episodes_dir}")

    print("\nEpisodi disponibili:")
    for i, opt in enumerate(options, start=1):
        print(f"  {i:>2}) {opt.label}")

    raw = input("Seleziona episodio [numero]: ").strip()
    if not raw.isdigit():
        raise RuleCheckError("Selezione non valida: inserire un numero.")

    idx = int(raw)
    if idx < 1 or idx > len(options):
        raise RuleCheckError("Selezione fuori intervallo.")

    selected = options[idx - 1]
    selected.output_dir.mkdir(parents=True, exist_ok=True)
    return selected


def _extract_rule_index(path: Path) -> tuple[int, int]:
    m = re.match(r"^STEMI-(DO|DONOT)-(\d{3})\.json$", path.name, flags=re.IGNORECASE)
    if not m:
        return (10**9, 10**9)
    kind = 0 if m.group(1).upper() == "DO" else 1
    return (int(m.group(2)), kind)


def _load_rule_files(rules_dir: Path) -> list[Path]:
    if not rules_dir.exists():
        return []

    files = [
        p
        for p in rules_dir.iterdir()
        if p.is_file() and re.match(r"^STEMI-(DO|DONOT)-\d{3}\.json$", p.name, flags=re.IGNORECASE)
    ]
    return sorted(files, key=_extract_rule_index)


def _build_prompt(base_prompt: str, episode: dict, rule: dict) -> str:
    return (
        f"{base_prompt.strip()}\n\n"
        "---\n"
        "INPUT EPISODIO (JSON):\n"
        f"{json.dumps(episode, ensure_ascii=False, indent=2)}\n\n"
        "INPUT REGOLA DA VERIFICARE (JSON):\n"
        f"{json.dumps(rule, ensure_ascii=False, indent=2)}\n\n"
        "ISTRUZIONI FINALI:\n"
        "- Restituisci SOLO JSON valido, senza markdown e senza testo extra.\n"
        "- L'output deve essere conforme allo schema check_rule_schema.\n"
        "- In supporting_documents includi almeno un documento clinico con: document_id, rationale sintetico, confidence (0..1).\n"
        "- Il rationale di ogni documento deve essere coerente con il rationale generale dell'output.\n"
    )


def _call_openrouter_check(*, api_key: str, model: str, prompt_text: str, check_schema: dict, reasoning_effort: str) -> dict:
    system_prompt = (
        "Sei un valutatore clinico STEMI. "
        "Ricevi episodio + regola e devi produrre esclusivamente un JSON conforme "
        "allo schema di check fornito. Nessun testo extra."
    )

    schema_for_provider = _sanitize_json_schema_for_openrouter(check_schema)
    provider_cfg = _provider_for_model(model)
    runaway_limit = _runaway_token_limit_for_model(model)

    def _invoke_once(user_prompt_text: str, *, effort: str, temperature: float) -> tuple[str, str | None]:
        payload = {
            "model": model,
            "reasoning": {"effort": effort},
            "temperature": temperature,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt_text},
            ],
            "response_format": {
                "type": "json_schema",
                "json_schema": {
                    "name": "check_rule_output",
                    "strict": True,
                    "schema": schema_for_provider,
                },
            },
        }
        if provider_cfg is not None:
            payload["provider"] = provider_cfg
        if runaway_limit is not None:
            payload["max_tokens"] = runaway_limit

        try:
            return _post_openrouter_with_meta(api_key=api_key, payload=payload)
        except RuleCheckError as e:
            if "compiled grammar is too large" not in str(e).lower():
                raise

            fallback_payload = {
                "model": model,
                "reasoning": {"effort": effort},
                "temperature": temperature,
                "messages": [
                    {
                        "role": "system",
                        "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente.",
                    },
                    {
                        "role": "user",
                        "content": (
                            f"{user_prompt_text}\n\n"
                            f"SCHEMA JSON DA RISPETTARE:\n{json.dumps(check_schema, ensure_ascii=False)}"
                        ),
                    },
                ],
                "response_format": {"type": "json_object"},
            }
            if provider_cfg is not None:
                fallback_payload["provider"] = provider_cfg
            if runaway_limit is not None:
                fallback_payload["max_tokens"] = runaway_limit
            return _post_openrouter_with_meta(api_key=api_key, payload=fallback_payload)

    content, finish_reason = _invoke_once(prompt_text, effort=reasoning_effort, temperature=0.1)

    if runaway_limit is not None and _is_runaway_cap_hit(finish_reason):
        retry_prompt_text = (
            f"{prompt_text}\n\n"
            "VINCOLO EXTRA DI SINTESI:\n"
            "- Mantieni il campo rationale breve (massimo 120 parole).\n"
            "- Evita ripetizioni e dettagli non necessari.\n"
            "- Restituisci direttamente il JSON finale.\n"
        )
        content, finish_reason = _invoke_once(retry_prompt_text, effort="low", temperature=0.0)

        if _is_runaway_cap_hit(finish_reason):
            raise RuleCheckError(
                f"Output troncato per runaway token cap ({runaway_limit}) anche dopo retry controllato."
            )

    cleaned = _strip_markdown_fences(content)
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON modello non parsabile: {e}. Estratto: {cleaned[:700]}") from e


def _rationale_alignment_score_jaccard_0_10(candidate: dict, gold: dict) -> int:
    cand_rat = _normalize_text(candidate.get("rationale", ""))
    gold_rat = _normalize_text(gold.get("rationale", ""))
    if not cand_rat or not gold_rat:
        return 0

    cand_tokens = set(cand_rat.split())
    gold_tokens = set(gold_rat.split())
    union = cand_tokens | gold_tokens
    inter = cand_tokens & gold_tokens
    jaccard = (len(inter) / len(union)) if union else 0.0
    return _clip_0_10(10.0 * jaccard)


def _call_openrouter_rationale_alignment(
    *,
    api_key: str,
    judge_model: str,
    judge_prompt_text: str,
    candidate: dict,
    gold: dict,
) -> int:
    schema = {
        "type": "object",
        "properties": {
            "alignment_score_0_10": {
                "type": "integer",
                "minimum": 0,
                "maximum": 10,
            },
            "alignment_notes": {
                "type": "string",
            },
        },
        "required": ["alignment_score_0_10", "alignment_notes"],
        "additionalProperties": False,
    }

    system_prompt = (judge_prompt_text or "").strip()
    if not system_prompt:
        raise RuleCheckError("Prompt giudice rationale vuoto.")
    user_prompt = (
        "Assegna un punteggio alignment_score_0_10 intero da 0 a 10 al rationale candidate "
        "rispetto al rationale gold.\n\n"
        "Input confronto:\n"
        f"{json.dumps({'candidate': {'outcome': candidate.get('outcome'), 'confidence': candidate.get('confidence'), 'rationale': candidate.get('rationale')}, 'gold': {'outcome': gold.get('outcome'), 'confidence': gold.get('confidence'), 'rationale': gold.get('rationale')}}, ensure_ascii=False)}"
    )

    schema_for_provider = _sanitize_json_schema_for_openrouter(schema)
    provider_cfg = _provider_for_model(judge_model)

    payload = {
        "model": judge_model,
        "reasoning": {"effort": "medium"},
        "temperature": 0.0,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        "response_format": {
            "type": "json_schema",
            "json_schema": {
                "name": "rationale_alignment",
                "strict": True,
                "schema": schema_for_provider,
            },
        },
    }
    if provider_cfg is not None:
        payload["provider"] = provider_cfg

    try:
        content = _post_openrouter(api_key=api_key, payload=payload)
    except RuleCheckError as e:
        if "compiled grammar is too large" not in str(e).lower():
            raise

        fallback_payload = {
            "model": judge_model,
            "reasoning": {"effort": "medium"},
            "temperature": 0.0,
            "messages": [
                {
                    "role": "system",
                    "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente.",
                },
                {
                    "role": "user",
                    "content": f"{user_prompt}\n\nSCHEMA JSON DA RISPETTARE:\n{json.dumps(schema, ensure_ascii=False)}",
                },
            ],
            "response_format": {"type": "json_object"},
        }
        if provider_cfg is not None:
            fallback_payload["provider"] = provider_cfg
        content = _post_openrouter(api_key=api_key, payload=fallback_payload)

    cleaned = _strip_markdown_fences(content)
    try:
        alignment_json = json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON giudice rationale non parsabile: {e}. Estratto: {cleaned[:700]}") from e

    raw_score = alignment_json.get("alignment_score_0_10")
    if not isinstance(raw_score, (int, float)):
        raise RuleCheckError("Risposta giudice rationale senza alignment_score_0_10 numerico.")
    return _clip_0_10(float(raw_score))


def _derive_patient_hash(episode_json: dict) -> str:
    patient = episode_json.get("paziente") if isinstance(episode_json, dict) else None
    if isinstance(patient, dict):
        cf = str(patient.get("codiceFiscale", "")).strip().upper()
        if cf:
            return hashlib.sha256(cf.encode("utf-8")).hexdigest()[:16]
    return "unknown_patient"


def _mode_is_gold() -> bool:
    print("\nModalità iniziale:")
    print("  1) Creazione GOLD standard")
    print("  2) Comparazione tra modelli")
    choice = input("Seleziona modalità [1/2] (default 1): ").strip() or "1"
    if choice not in {"1", "2"}:
        raise RuleCheckError("Modalità non valida.")
    return choice == "1"


def _choose_comparison_model() -> str:
    print("\nModelli disponibili per comparazione:")
    for key, model_name in COMPARISON_MODELS.items():
        print(f"  {key}) {model_name}")

    choices_hint = "/".join(COMPARISON_MODELS.keys())
    choice = input(f"Seleziona modello [{choices_hint}] (default 1): ").strip() or "1"
    if choice not in COMPARISON_MODELS:
        raise RuleCheckError("Selezione modello non valida.")
    return COMPARISON_MODELS[choice]


def _choose_reasoning_effort() -> str:
    print("\nLivelli reasoning disponibili (OpenRouter):")
    print("  1) low")
    print("  2) medium")
    print("  3) high")

    choice = input("Seleziona livello reasoning [1/2/3] (default 3): ").strip() or "3"
    if choice not in REASONING_EFFORTS:
        raise RuleCheckError("Selezione reasoning non valida.")
    return REASONING_EFFORTS[choice]


def _normalize_text(value: object) -> str:
    return re.sub(r"\s+", " ", str(value or "").strip().lower())


def _clip_0_10(value: float) -> int:
    v = round(value)
    if v < 0:
        return 0
    if v > 10:
        return 10
    return int(v)


def _outcome_alignment_score_0_10(candidate: dict, gold: dict) -> int:
    cand_outcome = _normalize_text(candidate.get("outcome"))
    gold_outcome = _normalize_text(gold.get("outcome"))
    if not cand_outcome or not gold_outcome:
        return 0
    if cand_outcome == gold_outcome:
        return 10

    similarity = OUTCOME_ALIGNMENT_TRUTH_MATRIX.get((cand_outcome, gold_outcome), 0.0)
    return _clip_0_10(10.0 * similarity)


def _conformity_score_0_10(*, inferential_alignment_0_10: int, outcome_alignment_0_10: int) -> int:
    inferential = float(_clip_0_10(inferential_alignment_0_10))
    outcome = float(_clip_0_10(outcome_alignment_0_10))
    return _clip_0_10((0.6 * inferential) + (0.4 * outcome))


def _ensure_reference_prompt_template(base_prompt: str) -> None:
    if REFERENCE_PROMPT_TEMPLATE_PATH.exists():
        return

    text = (
        f"{base_prompt.strip()}\n\n"
        "---\n"
        "INPUT EPISODIO (JSON):\n"
        "{{EPISODE_JSON}}\n\n"
        "INPUT REGOLA DA VERIFICARE (JSON):\n"
        "{{RULE_JSON}}\n\n"
        "ISTRUZIONI FINALI:\n"
        "- Restituisci SOLO JSON valido, senza markdown e senza testo extra.\n"
        "- L'output deve essere conforme allo schema check_rule_schema.\n"
        "- In supporting_documents includi almeno un documento clinico con: document_id, rationale sintetico, confidence (0..1).\n"
        "- Il rationale di ogni documento deve essere coerente con il rationale generale dell'output.\n"
    )
    REFERENCE_PROMPT_TEMPLATE_PATH.write_text(text, encoding="utf-8")


def main() -> int:
    print("=== Check batch regole STEMI con OpenRouter ===")

    api_key = os.getenv("OPENROUTER_API_KEY")
    if not api_key:
        print("Errore: variabile OPENROUTER_API_KEY non impostata.")
        return 1

    try:
        mode_gold = _mode_is_gold()
        model = os.getenv("OPENROUTER_MODEL", DEFAULT_GOLD_MODEL) if mode_gold else _choose_comparison_model()
        rationale_alignment_model = os.getenv("OPENROUTER_ALIGNMENT_MODEL", DEFAULT_RATIONALE_ALIGNMENT_MODEL)
        reasoning_effort = _choose_reasoning_effort()
    except RuleCheckError as e:
        print(f"Errore modalità/modello/reasoning: {e}")
        return 1

    if not CHECK_SCHEMA_PATH.exists():
        print(f"Errore: schema check non trovato: {CHECK_SCHEMA_PATH}")
        return 1

    if not BASE_PROMPT_PATH.exists():
        print(f"Errore: prompt base non trovato: {BASE_PROMPT_PATH}")
        return 1

    if not mode_gold and not RATIONALE_ALIGNMENT_PROMPT_PATH.exists():
        print(f"Errore: prompt giudice rationale non trovato: {RATIONALE_ALIGNMENT_PROMPT_PATH}")
        return 1

    rule_files = _load_rule_files(RULES_DIR)
    if not rule_files:
        print(f"Errore: nessuna regola trovata in {RULES_DIR}")
        return 1

    try:
        episode_selection = _choose_episode(EPISODES_DIR)
    except RuleCheckError as e:
        print(f"Errore selezione episodio: {e}")
        return 1

    try:
        check_schema = _read_json(CHECK_SCHEMA_PATH)
        validator = _load_jsonschema_validator(check_schema)
        base_prompt = BASE_PROMPT_PATH.read_text(encoding="utf-8")
        episode_json = _read_json(episode_selection.episode_input_path)
        rationale_prompt_text = ""
        if not mode_gold:
            rationale_prompt_text = RATIONALE_ALIGNMENT_PROMPT_PATH.read_text(encoding="utf-8").strip()
            if not rationale_prompt_text:
                raise RuleCheckError("Il prompt del giudice rationale e' vuoto.")
    except Exception as e:
        print(f"Errore inizializzazione: {e}")
        return 1

    _ensure_reference_prompt_template(base_prompt)

    overwrite = input("Sovrascrivere eventuali output esistenti? [s/N]: ").strip().lower() in {
        "s",
        "si",
        "sì",
        "y",
        "yes",
    }

    print(f"\nEpisodio selezionato: {episode_selection.episode_input_path}")
    print(f"Cartella output:      {episode_selection.output_dir}")
    print(f"Numero regole:        {len(rule_files)}")
    print(f"Modalità:             {'GOLD' if mode_gold else 'COMPARAZIONE'}")
    print(f"Modello:              {model}")
    print(f"Runaway token cap:    {_runaway_token_limit_for_model(model)}")
    if not mode_gold:
        print(f"Giudice rationale:    {rationale_alignment_model}")
        print(f"Prompt giudice:       {RATIONALE_ALIGNMENT_PROMPT_PATH}")
    print(f"Reasoning effort:     {reasoning_effort}")
    print("Inizio elaborazione...\n")

    ok_count = 0
    ko_count = 0

    for rule_path in rule_files:
        rule_name = rule_path.stem
        check_elapsed_sec: float | None = None

        if mode_gold:
            out_path = episode_selection.output_dir / f"GOLD_STANDARD_{rule_name}.json"
        else:
            model_safe = re.sub(r"[^a-zA-Z0-9]+", "_", model)
            out_path = episode_selection.output_dir / f"CHECK_{model_safe}_{rule_name}.json"

        if out_path.exists() and not overwrite:
            print(f"[SKIP] {rule_name} -> {out_path} (esistente)")
            continue

        try:
            rule_json = _read_json(rule_path)
            prompt_text = _build_prompt(base_prompt=base_prompt, episode=episode_json, rule=rule_json)

            check_started = perf_counter()
            try:
                result_json = _call_openrouter_check(
                    api_key=api_key,
                    model=model,
                    prompt_text=prompt_text,
                    check_schema=check_schema,
                    reasoning_effort=reasoning_effort,
                )
            finally:
                check_elapsed_sec = perf_counter() - check_started

            result_json["rule_id"] = rule_json.get("rule_id", rule_name)
            result_json.setdefault("check_id", f"CHECK-{rule_name}-{datetime.now(UTC).strftime('%Y%m%d%H%M%S')}")
            result_json.setdefault("check_timestamp", datetime.now(UTC).isoformat())
            result_json.setdefault("patient_id_hash", _derive_patient_hash(episode_json))

            errors = sorted(validator.iter_errors(result_json), key=lambda e: e.path)
            if errors:
                first = errors[0]
                loc = "/".join(str(x) for x in first.path) or "<root>"
                raise RuleCheckError(f"Output non conforme allo schema in '{loc}': {first.message}")

            _write_json(out_path, result_json)

            if mode_gold:
                print(f"[OK ] {rule_name} -> {out_path} | tempo check modello: {check_elapsed_sec:.2f}s")
            else:
                gold_path = episode_selection.output_dir / f"GOLD_STANDARD_{rule_name}.json"
                if not gold_path.exists():
                    print(
                        f"[OK ] {rule_name} -> {out_path} | conformità vs GOLD: N/D (gold mancante) "
                        f"| tempo check modello: {check_elapsed_sec:.2f}s"
                    )
                else:
                    gold_json = _read_json(gold_path)
                    rationale_mode = "inferenziale"
                    try:
                        inferential_alignment = _call_openrouter_rationale_alignment(
                            api_key=api_key,
                            judge_model=rationale_alignment_model,
                            judge_prompt_text=rationale_prompt_text,
                            candidate=result_json,
                            gold=gold_json,
                        )
                    except Exception as align_error:
                        inferential_alignment = _rationale_alignment_score_jaccard_0_10(result_json, gold_json)
                        rationale_mode = "fallback-lessicale"
                        print(
                            f"[WARN] {rule_name} -> allineamento rationale inferenziale non disponibile: {align_error}"
                        )

                    outcome_alignment = _outcome_alignment_score_0_10(result_json, gold_json)

                    conformity = _conformity_score_0_10(
                        inferential_alignment_0_10=inferential_alignment,
                        outcome_alignment_0_10=outcome_alignment,
                    )
                    print(
                        f"[OK ] {rule_name} -> {out_path} | conformità vs GOLD: {conformity}/10 "
                        f"| giudice rationale: {inferential_alignment}/10 ({rationale_mode}) "
                        f"| allineamento outcome: {outcome_alignment}/10 (pesi 60/40) "
                        f"| tempo check modello: {check_elapsed_sec:.2f}s"
                    )

            ok_count += 1

        except Exception as e:
            if check_elapsed_sec is None:
                print(f"[KO ] {rule_name} -> errore: {e}")
            else:
                print(f"[KO ] {rule_name} -> errore: {e} | tempo check modello: {check_elapsed_sec:.2f}s")
            ko_count += 1

    print("\n=== Riepilogo ===")
    print(f"OK: {ok_count}")
    print(f"KO: {ko_count}")
    print(f"Output directory: {episode_selection.output_dir}")
    print(f"Template prompt riferimento: {REFERENCE_PROMPT_TEMPLATE_PATH}")
    return 0 if ko_count == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
