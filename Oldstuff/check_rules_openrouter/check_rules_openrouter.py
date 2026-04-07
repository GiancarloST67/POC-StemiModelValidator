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
from time import perf_counter, sleep
from urllib import error, request

ROOT = Path(__file__).resolve().parent


def _first_existing_path(*paths: Path) -> Path:
    for path in paths:
        if path.exists():
            return path
    return paths[0]


# Se spostato in Oldstuff, il progetto principale resta due livelli sopra.
WORKSPACE_ROOT = ROOT
if ROOT.parent.name.lower() == "oldstuff":
    WORKSPACE_ROOT = ROOT.parent.parent

LOCAL_SRS_DIR = ROOT / "SRS"
WORKSPACE_SRS_DIR = WORKSPACE_ROOT / "SRS"

STEMI_DIR = _first_existing_path(
    ROOT / "CARDIO" / "STEMI",
    WORKSPACE_ROOT / "CARDIO" / "STEMI",
)
EPISODES_DIR = STEMI_DIR / "EPISODES"
RULES_DIR = STEMI_DIR / "RULES"

CHECK_SCHEMA_PATH = _first_existing_path(
    LOCAL_SRS_DIR / "check_rule_schema.json",
    WORKSPACE_SRS_DIR / "check_rule_schema.json",
)
BASE_PROMPT_PATH = _first_existing_path(
    LOCAL_SRS_DIR / "PROMPT_CheckRegoleSTEMI_plain.md",
    WORKSPACE_SRS_DIR / "PROMPT_CheckRegoleSTEMI_plain.md",
)
REFERENCE_PROMPT_TEMPLATE_PATH = _first_existing_path(
    LOCAL_SRS_DIR / "PROMPT_CheckRegoleSTEMI_reference_template.md",
    WORKSPACE_SRS_DIR / "PROMPT_CheckRegoleSTEMI_reference_template.md",
)
RATIONALE_ALIGNMENT_PROMPT_PATH = _first_existing_path(
    LOCAL_SRS_DIR / "PROMPT_RationaleAlignmentJudge.md",
    WORKSPACE_SRS_DIR / "PROMPT_RationaleAlignmentJudge.md",
)

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
    "16": "z-ai/glm-5-turbo",
    "17": "meta-llama/llama-3.3-70b-instruct",
    "18": "mistralai/mistral-small-3.2-24b-instruct",
    "19": "qwen/qwen3.5-flash-02-23",
    "20": "qwen/qwen3.5-9b",
    "21": "qwen/qwen3.5-27b",
    "22": "qwen/qwen3.6-plus:free",
    "23": "openai/gpt-oss-safeguard-20b:nitro",
    "24": "meta-llama/llama-3.1-8b-instruct:nitro",
    "25": "z-ai/glm-4.7",
    "26": "qwen/qwen3-235b-a22b-2507",
    "27": "moonshotai/kimi-k2.5",
}

REASONING_EFFORTS = {
    "1": "low",
    "2": "medium",
    "3": "high",
}


def _env_int(name: str, default: int, *, minimum: int = 0) -> int:
    raw = (os.getenv(name) or "").strip()
    if not raw:
        return default
    try:
        value = int(raw)
    except ValueError:
        return default
    return value if value >= minimum else default


def _env_float(name: str, default: float, *, minimum: float = 0.0) -> float:
    raw = (os.getenv(name) or "").strip()
    if not raw:
        return default
    try:
        value = float(raw)
    except ValueError:
        return default
    return value if value >= minimum else default


OPENROUTER_MAX_RETRIES = _env_int("OPENROUTER_MAX_RETRIES", 3, minimum=0)
OPENROUTER_RETRY_BASE_DELAY_SEC = _env_float("OPENROUTER_RETRY_BASE_DELAY_SEC", 1.5, minimum=0.1)
OPENROUTER_RETRY_MAX_DELAY_SEC = _env_float("OPENROUTER_RETRY_MAX_DELAY_SEC", 20.0, minimum=0.1)

RUNAWAY_TOKEN_LIMITS_BY_MODEL: dict[str, int | None] = {
    model_name: None for model_name in COMPARISON_MODELS.values()
}
# Modello 1 (qwen/qwen3.5-35b-a3b): cap esplicito richiesto.
RUNAWAY_TOKEN_LIMITS_BY_MODEL["qwen/qwen3.5-35b-a3b"] = 10000
# Modello 3 (google/gemini-3.1-flash-lite-preview): cap esplicito richiesto.
RUNAWAY_TOKEN_LIMITS_BY_MODEL["google/gemini-3.1-flash-lite-preview"] = 10000
# Modello 26 (qwen/qwen3-235b-a22b-2507): cap esplicito richiesto.
RUNAWAY_TOKEN_LIMITS_BY_MODEL["qwen/qwen3-235b-a22b-2507"] = 10000
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

_RETRYABLE_OPENROUTER_STATUS_CODES = {408, 409, 425, 429, 500, 502, 503, 504}
_RETRYABLE_OPENROUTER_TEXT_MARKERS = (
    "temporarily rate-limited",
    "rate-limited",
    "rate limit",
    "too many requests",
    "please retry",
    "try again",
    "overloaded",
)


def _provider_for_model(model: str) -> dict | None:
    m = (model or "").strip().lower()
    if "gpt-oss-120b" in m or "gpt-oss120b" in m:
        return {"order": ["baseten/fp4"], "allow_fallbacks": False}
    if m == "google/gemma-4-26b-a4b-it":
        return {"order": ["novita/bf16"], "allow_fallbacks": False}
    if m.startswith("google/gemini"):
        return {"order": ["google-vertex"], "allow_fallbacks": False}
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


def _to_float(value: object) -> float | None:
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        txt = value.strip()
        if not txt:
            return None
        try:
            return float(txt)
        except ValueError:
            return None
    return None


def _normalize_check_output_for_validation(result_json: object) -> dict:
    if not isinstance(result_json, dict):
        raise RuleCheckError(f"Output modello: atteso oggetto JSON, trovato {type(result_json).__name__}.")

    docs = result_json.get("supporting_documents")
    if not isinstance(docs, list):
        return result_json

    for item in docs:
        if not isinstance(item, dict):
            continue
        doc_id = item.get("document_id")
        if isinstance(doc_id, bool) or doc_id is None or isinstance(doc_id, str):
            continue
        if isinstance(doc_id, int):
            item["document_id"] = str(doc_id)
            continue
        if isinstance(doc_id, float):
            item["document_id"] = str(int(doc_id)) if doc_id.is_integer() else str(doc_id)

    return result_json


def _extract_inference_cost_usd(body: dict, header_cost_usd: float | None) -> float | None:
    usage_raw = body.get("usage")
    usage: dict[str, object] = usage_raw if isinstance(usage_raw, dict) else {}

    direct_candidates = [
        body.get("cost"),
        body.get("total_cost"),
        body.get("cost_usd"),
        body.get("total_cost_usd"),
        usage.get("cost"),
        usage.get("total_cost"),
        usage.get("cost_usd"),
        usage.get("total_cost_usd"),
        usage.get("usd"),
        usage.get("usd_cost"),
        usage.get("estimated_cost"),
    ]
    for candidate in direct_candidates:
        val = _to_float(candidate)
        if val is not None:
            return val

    input_cost = _to_float(usage.get("input_cost"))
    output_cost = _to_float(usage.get("output_cost"))
    if input_cost is not None or output_cost is not None:
        return (input_cost or 0.0) + (output_cost or 0.0)

    return header_cost_usd


def _is_retryable_openrouter_http_error(*, status_code: int, details: str) -> bool:
    if status_code in _RETRYABLE_OPENROUTER_STATUS_CODES:
        return True

    details_norm = (details or "").strip().lower()
    return any(marker in details_norm for marker in _RETRYABLE_OPENROUTER_TEXT_MARKERS)


def _retry_after_seconds_from_headers(headers: object) -> float | None:
    if headers is None:
        return None

    getter = getattr(headers, "get", None)
    if not callable(getter):
        return None

    raw_retry_after = getter("Retry-After")
    if raw_retry_after is None:
        return None

    txt = str(raw_retry_after).strip()
    if not txt:
        return None

    try:
        seconds = float(txt)
    except ValueError:
        return None

    return seconds if seconds >= 0 else None


def _retry_delay_seconds(*, retry_index: int, retry_after_seconds: float | None) -> float:
    if retry_after_seconds is not None:
        return min(max(0.1, retry_after_seconds), OPENROUTER_RETRY_MAX_DELAY_SEC)

    delay = OPENROUTER_RETRY_BASE_DELAY_SEC * (2**retry_index)
    return min(max(0.1, delay), OPENROUTER_RETRY_MAX_DELAY_SEC)


def _post_openrouter_with_meta(api_key: str, payload: dict) -> tuple[str, str | None, float | None]:
    data = json.dumps(payload).encode("utf-8")
    model_name = str(payload.get("model", "")).strip() or "<unknown-model>"
    retry_count = 0

    while True:
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
                header_cost_usd = _to_float(resp.headers.get("x-openrouter-cost"))
                raw = resp.read().decode("utf-8")
            break
        except error.HTTPError as e:
            details = e.read().decode("utf-8", errors="replace")
            if (
                _is_retryable_openrouter_http_error(status_code=e.code, details=details)
                and retry_count < OPENROUTER_MAX_RETRIES
            ):
                wait_seconds = _retry_delay_seconds(
                    retry_index=retry_count,
                    retry_after_seconds=_retry_after_seconds_from_headers(getattr(e, "headers", None)),
                )
                retry_count += 1
                print(
                    f"[WARN] OpenRouter HTTP {e.code} su {model_name}: retry {retry_count}/{OPENROUTER_MAX_RETRIES} "
                    f"tra {wait_seconds:.1f}s."
                )
                sleep(wait_seconds)
                continue
            raise RuleCheckError(f"OpenRouter HTTP {e.code}: {details}") from e
        except (error.URLError, TimeoutError) as e:
            if retry_count < OPENROUTER_MAX_RETRIES:
                wait_seconds = _retry_delay_seconds(retry_index=retry_count, retry_after_seconds=None)
                retry_count += 1
                print(
                    f"[WARN] Errore rete OpenRouter su {model_name}: retry {retry_count}/{OPENROUTER_MAX_RETRIES} "
                    f"tra {wait_seconds:.1f}s."
                )
                sleep(wait_seconds)
                continue
            raise RuleCheckError(f"Errore chiamata OpenRouter: {e}") from e
        except Exception as e:
            raise RuleCheckError(f"Errore chiamata OpenRouter: {e}") from e

    try:
        body = json.loads(raw)
        choice0 = body["choices"][0]
        content = choice0["message"]["content"]
        finish_reason = choice0.get("finish_reason")
        cost_usd = _extract_inference_cost_usd(body, header_cost_usd)
    except Exception as e:
        raise RuleCheckError(f"Risposta OpenRouter non valida: {raw}") from e

    if isinstance(content, list):
        content = "\n".join(str(block.get("text", "")) for block in content if isinstance(block, dict))

    if not isinstance(content, str) or not content.strip():
        raise RuleCheckError("La risposta del modello non contiene JSON testuale.")

    return content, finish_reason, cost_usd


def _post_openrouter(api_key: str, payload: dict) -> str:
    content, _, _ = _post_openrouter_with_meta(api_key=api_key, payload=payload)
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
        raise RuleCheckError(f"Nessun episodio selezionabile trovato in: {episodes_dir.name}")

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
        "- In supporting_documents includi almeno un documento clinico con: document_id (SEMPRE stringa, anche se numerico), rationale sintetico, confidence (0..1).\n"
        "- Il rationale di ogni documento deve essere coerente con il rationale generale dell'output.\n"
    )


def _call_openrouter_check(
    *, api_key: str, model: str, prompt_text: str, check_schema: dict, reasoning_effort: str
) -> tuple[dict, float | None]:
    system_prompt = (
        "Sei un valutatore clinico STEMI. "
        "Ricevi episodio + regola e devi produrre esclusivamente un JSON conforme "
        "allo schema di check fornito. Nessun testo extra."
    )

    schema_for_provider = _sanitize_json_schema_for_openrouter(check_schema)
    provider_cfg = _provider_for_model(model)
    runaway_limit = _runaway_token_limit_for_model(model)

    def _invoke_once(
        user_prompt_text: str,
        *,
        effort: str,
        temperature: float,
    ) -> tuple[str, str | None, float | None]:
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

    call_count = 0
    all_costs_known = True
    total_cost_usd = 0.0

    def _register_cost(cost_usd: float | None) -> None:
        nonlocal call_count, all_costs_known, total_cost_usd
        call_count += 1
        if cost_usd is None:
            all_costs_known = False
            return
        total_cost_usd += max(0.0, float(cost_usd))

    content, finish_reason, call_cost_usd = _invoke_once(prompt_text, effort=reasoning_effort, temperature=0.1)
    _register_cost(call_cost_usd)

    if runaway_limit is not None and _is_runaway_cap_hit(finish_reason):
        retry_prompt_text = (
            f"{prompt_text}\n\n"
            "VINCOLO EXTRA DI SINTESI:\n"
            "- Mantieni il campo rationale breve (massimo 120 parole).\n"
            "- Evita ripetizioni e dettagli non necessari.\n"
            "- Restituisci direttamente il JSON finale.\n"
        )
        content, finish_reason, call_cost_usd = _invoke_once(retry_prompt_text, effort="low", temperature=0.0)
        _register_cost(call_cost_usd)

        if _is_runaway_cap_hit(finish_reason):
            raise RuleCheckError(
                f"Output troncato per runaway token cap ({runaway_limit}) anche dopo retry controllato."
            )

    cleaned = _strip_markdown_fences(content)
    try:
        normalized = _normalize_check_output_for_validation(json.loads(cleaned))
        check_cost_usd = total_cost_usd if (call_count > 0 and all_costs_known) else None
        return normalized, check_cost_usd
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


def _supporting_documents_for_alignment(report: dict) -> list[dict]:
    docs = report.get("supporting_documents") if isinstance(report, dict) else None
    if not isinstance(docs, list):
        return []

    prepared: list[dict] = []
    for item in docs:
        if not isinstance(item, dict):
            continue
        prepared.append(
            {
                "document_id": item.get("document_id"),
                "rationale": item.get("rationale"),
                "confidence": item.get("confidence"),
            }
        )
    return prepared


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

    compare_payload = {
        "candidate": {
            "outcome": candidate.get("outcome"),
            "confidence": candidate.get("confidence"),
            "rationale": candidate.get("rationale"),
            "supporting_documents": _supporting_documents_for_alignment(candidate),
        },
        "gold": {
            "outcome": gold.get("outcome"),
            "confidence": gold.get("confidence"),
            "rationale": gold.get("rationale"),
            "supporting_documents": _supporting_documents_for_alignment(gold),
        },
    }

    user_prompt = (
        "Assegna un punteggio alignment_score_0_10 intero da 0 a 10 al report candidate rispetto al report gold.\n"
        "Valuta congiuntamente:\n"
        "- allineamento del rationale generale;\n"
        "- allineamento dei supporting_documents (document_id, rationale per documento, confidence per documento);\n"
        "- coerenza tra rationale generale e razionali per-documento all'interno dello stesso report.\n\n"
        "Input confronto:\n"
        f"{json.dumps(compare_payload, ensure_ascii=False)}"
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


def _format_conformity_score_colored(score_0_10: int) -> str:
    score = _clip_0_10(score_0_10)
    plain = f"{score}/10"

    # Allow users to disable terminal colors when needed.
    if os.getenv("NO_COLOR"):
        return plain

    if score <= 3:
        color = "\x1b[31m"  # red
    elif score <= 5:
        color = "\x1b[38;5;208m"  # orange
    elif score <= 7:
        color = "\x1b[33m"  # yellow
    else:
        color = "\x1b[32m"  # green

    reset = "\x1b[0m"
    return f"{color}{plain}{reset}"


def _format_inference_cost_usd(cost_usd: float | None) -> str:
    if not isinstance(cost_usd, (int, float)):
        return "N/D"
    if cost_usd < 0:
        return "N/D"
    return f"${float(cost_usd):.6f}"


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
        "- In supporting_documents includi almeno un documento clinico con: document_id (SEMPRE stringa, anche se numerico), rationale sintetico, confidence (0..1).\n"
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
        print(f"Errore: schema check non trovato: {CHECK_SCHEMA_PATH.name}")
        return 1

    if not BASE_PROMPT_PATH.exists():
        print(f"Errore: prompt base non trovato: {BASE_PROMPT_PATH.name}")
        return 1

    if not mode_gold and not RATIONALE_ALIGNMENT_PROMPT_PATH.exists():
        print(f"Errore: prompt giudice rationale non trovato: {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
        return 1

    rule_files = _load_rule_files(RULES_DIR)
    if not rule_files:
        print(f"Errore: nessuna regola trovata in {RULES_DIR.name}")
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

    print(f"\nEpisodio selezionato: {episode_selection.episode_input_path.name}")
    print(f"Cartella output:      {episode_selection.output_dir.name}")
    print(f"Numero regole:        {len(rule_files)}")
    print(f"Modalità:             {'GOLD' if mode_gold else 'COMPARAZIONE'}")
    print(f"Modello:              {model}")
    provider_cfg = _provider_for_model(model)
    provider_display = "NULL" if provider_cfg is None else json.dumps(provider_cfg, ensure_ascii=False)
    print(f"Provider:             {provider_display}")
    print(f"Runaway token cap:    {_runaway_token_limit_for_model(model)}")
    print(
        f"Retry OpenRouter:     {OPENROUTER_MAX_RETRIES} "
        f"(base {OPENROUTER_RETRY_BASE_DELAY_SEC:.1f}s, max {OPENROUTER_RETRY_MAX_DELAY_SEC:.1f}s)"
    )
    if not mode_gold:
        print(f"Giudice rationale:    {rationale_alignment_model}")
        print(f"Prompt giudice:       {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
    print(f"Reasoning effort:     {reasoning_effort}")
    print("Inizio elaborazione...\n")

    ok_count = 0
    ko_count = 0

    for rule_path in rule_files:
        rule_name = rule_path.stem
        check_elapsed_sec: float | None = None
        check_cost_usd: float | None = None

        if mode_gold:
            out_path = episode_selection.output_dir / f"GOLD_STANDARD_{rule_name}.json"
        else:
            model_safe = re.sub(r"[^a-zA-Z0-9]+", "_", model)
            out_path = episode_selection.output_dir / f"CHECK_{model_safe}_{rule_name}.json"

        if out_path.exists() and not overwrite:
            print(f"[SKIP] {rule_name} -> {out_path.name} (esistente)")
            continue

        try:
            rule_json = _read_json(rule_path)
            prompt_text = _build_prompt(base_prompt=base_prompt, episode=episode_json, rule=rule_json)

            check_started = perf_counter()
            try:
                result_json, check_cost_usd = _call_openrouter_check(
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
                print(
                    f"[OK ] {rule_name} -> {out_path.name} | tempo check modello: {check_elapsed_sec:.2f}s "
                    f"| costo inferenza modello: {_format_inference_cost_usd(check_cost_usd)}"
                )
            else:
                gold_path = episode_selection.output_dir / f"GOLD_STANDARD_{rule_name}.json"
                if not gold_path.exists():
                    print(
                        f"[OK ] {rule_name} -> {out_path.name} | conformità vs GOLD: N/D (gold mancante) "
                        f"| tempo check modello: {check_elapsed_sec:.2f}s "
                        f"| costo inferenza modello: {_format_inference_cost_usd(check_cost_usd)}"
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
                    conformity_colored = _format_conformity_score_colored(conformity)
                    print(
                        f"[OK ] {rule_name} -> {out_path.name} | conformità vs GOLD: {conformity_colored} "
                        f"| giudice rationale: {inferential_alignment}/10 ({rationale_mode}) "
                        f"| allineamento outcome: {outcome_alignment}/10 (pesi 60/40) "
                        f"| tempo check modello: {check_elapsed_sec:.2f}s "
                        f"| costo inferenza modello: {_format_inference_cost_usd(check_cost_usd)}"
                    )

            ok_count += 1

        except Exception as e:
            if check_elapsed_sec is None:
                print(
                    f"[KO ] {rule_name} -> errore: {e} "
                    f"| costo inferenza modello: {_format_inference_cost_usd(check_cost_usd)}"
                )
            else:
                print(
                    f"[KO ] {rule_name} -> errore: {e} | tempo check modello: {check_elapsed_sec:.2f}s "
                    f"| costo inferenza modello: {_format_inference_cost_usd(check_cost_usd)}"
                )
            ko_count += 1

    print("\n=== Riepilogo ===")
    print(f"OK: {ok_count}")
    print(f"KO: {ko_count}")
    print(f"Output directory: {episode_selection.output_dir.name}")
    print(f"Template prompt riferimento: {REFERENCE_PROMPT_TEMPLATE_PATH.name}")
    return 0 if ko_count == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
