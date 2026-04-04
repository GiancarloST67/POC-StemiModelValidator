#!/usr/bin/env python3
"""
Genera una nuova regola DO o DONOT per STEMI usando OpenRouter
(Opus 4.6, reasoning high) e la salva in CARDIO/STEMI/RULES.
"""

from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path
from urllib import error, request

ROOT = Path(__file__).resolve().parent
RULES_DIR = ROOT / "CARDIO" / "STEMI" / "RULES"
DO_SCHEMA_PATH = ROOT / "SRS" / "do_rule.schema.json"
DO_NOT_SCHEMA_PATH = ROOT / "SRS" / "do_not_rule.schema.json"
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
DEFAULT_MODEL = "anthropic/claude-opus-4.6"


class RuleGenerationError(Exception):
    pass


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


def _choose_rule_kind() -> tuple[str, str, Path]:
    answer = input("Tipo regola da generare [DO/DONOT] (default DO): ").strip().lower()

    if answer in {"", "do"}:
        return "do", "STEMI-DO", DO_SCHEMA_PATH
    if answer in {"donot", "do_not", "do-not", "do not"}:
        return "do_not", "STEMI-DONOT", DO_NOT_SCHEMA_PATH

    print("Valore non riconosciuto. Uso default: DO.")
    return "do", "STEMI-DO", DO_SCHEMA_PATH


def _read_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _next_rule_id_and_file(rules_dir: Path, id_prefix: str) -> tuple[str, Path]:
    pattern = re.compile(rf"^{re.escape(id_prefix)}-(\d{{3}})\.json$")
    max_n = 0

    if rules_dir.exists():
        for p in rules_dir.iterdir():
            if not p.is_file():
                continue
            m = pattern.match(p.name)
            if m:
                max_n = max(max_n, int(m.group(1)))

    next_n = max_n + 1
    rule_id = f"{id_prefix}-{next_n:03d}"
    return rule_id, rules_dir / f"{rule_id}.json"


def _resolve_overwrite_target(rules_dir: Path, id_prefix: str) -> tuple[str, Path] | None:
    answer = input("Vuoi sovrascrivere una regola esistente? [s/N]: ").strip().lower()
    if answer not in {"s", "si", "sì", "y", "yes"}:
        return None

    rule_name = input(f"Inserisci il nome integrale della regola (es. {id_prefix}-002): ").strip()
    if not re.fullmatch(rf"{re.escape(id_prefix)}-\d{{3}}", rule_name):
        print(f"Errore: formato non valido. Usa esattamente {id_prefix}-XXX.")
        return None

    out_path = rules_dir / f"{rule_name}.json"
    if not out_path.exists():
        print(f"Errore: file non trovato: {out_path}")
        return None

    return rule_name, out_path


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
    """
    Riduce lo schema a un sottoinsieme compatibile con provider che non supportano
    alcuni vincoli JSON Schema avanzati nel response_format.
    """
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


def _post_openrouter(api_key: str, payload: dict) -> str:
    data = json.dumps(payload).encode("utf-8")
    req = request.Request(
        OPENROUTER_URL,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://local.stemi-rule-generator",
            "X-Title": "STEMI Rule Generator",
        },
    )

    try:
        with request.urlopen(req, timeout=180) as resp:
            raw = resp.read().decode("utf-8")
    except error.HTTPError as e:
        details = e.read().decode("utf-8", errors="replace")
        raise RuleGenerationError(f"OpenRouter HTTP {e.code}: {details}") from e
    except Exception as e:
        raise RuleGenerationError(f"Errore chiamata OpenRouter: {e}") from e

    try:
        body = json.loads(raw)
        content = body["choices"][0]["message"]["content"]
    except Exception as e:
        raise RuleGenerationError(f"Risposta OpenRouter non valida: {raw}") from e

    if isinstance(content, list):
        content = "\n".join(str(block.get("text", "")) for block in content if isinstance(block, dict))

    if not isinstance(content, str) or not content.strip():
        raise RuleGenerationError("La risposta del modello non contiene JSON testuale.")

    return content


def _call_openrouter(
    api_key: str,
    model: str,
    rule_text: str,
    target_rule_id: str,
    rule_type: str,
    schema: dict,
) -> dict:
    system_prompt = (
        "Sei un assistente esperto di linee guida cliniche STEMI. "
        "Genera SOLO un JSON valido, senza testo extra, in italiano, "
        "conformemente allo schema JSON fornito via response_format."
    )

    user_prompt = (
        f"Crea una regola di tipo {rule_type.upper()} per il clinical pathway STEMI partendo da questo testo libero:\n"
        f"\"{rule_text}\"\n\n"
        "Vincoli obbligatori:\n"
        f"- rule_id deve essere esattamente '{target_rule_id}'\n"
        f"- rule_type deve essere '{rule_type}'\n"
        "- usa terminologia clinica italiana\n"
        "- compila tutti i campi richiesti in modo coerente e plausibile\n"
        "- non aggiungere proprietà non previste\n"
    )

    schema_for_provider = _sanitize_json_schema_for_openrouter(schema)
    provider_cfg = _provider_for_model(model)

    payload_strict_schema = {
        "model": model,
        "reasoning": {"effort": "high"},
        "temperature": 0.2,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        "response_format": {
            "type": "json_schema",
            "json_schema": {
                "name": "do_rule",
                "strict": True,
                "schema": schema_for_provider,
            },
        },
    }
    if provider_cfg is not None:
        payload_strict_schema["provider"] = provider_cfg

    try:
        content = _post_openrouter(api_key=api_key, payload=payload_strict_schema)
    except RuleGenerationError as e:
        msg = str(e)
        if "compiled grammar is too large" not in msg.lower():
            raise

        # Fallback per provider con limiti sul grammar compiler: disabilita
        # json_schema strict e passa lo schema come istruzione testuale.
        fallback_system_prompt = (
            system_prompt
            + " Segui rigorosamente lo schema seguente e restituisci solo JSON valido."
            + " Non usare markdown."
        )
        fallback_user_prompt = (
            user_prompt
            + "\n\nSchema JSON da rispettare integralmente:\n"
            + json.dumps(schema, ensure_ascii=False)
        )

        payload_fallback = {
            "model": model,
            "reasoning": {"effort": "high"},
            "temperature": 0.2,
            "messages": [
                {"role": "system", "content": fallback_system_prompt},
                {"role": "user", "content": fallback_user_prompt},
            ],
            "response_format": {"type": "json_object"},
        }
        if provider_cfg is not None:
            payload_fallback["provider"] = provider_cfg
        content = _post_openrouter(api_key=api_key, payload=payload_fallback)

    cleaned = _strip_markdown_fences(content)

    try:
        return json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleGenerationError(f"JSON prodotto non parsabile: {e}\nContenuto: {cleaned[:1000]}") from e


def main() -> int:
    print("=== Generatore regola STEMI (DO/DONOT) con OpenRouter ===")

    api_key = os.getenv("OPENROUTER_API_KEY")
    if not api_key:
        print("Errore: variabile OPENROUTER_API_KEY non impostata.")
        return 1

    model = os.getenv("OPENROUTER_MODEL", DEFAULT_MODEL)

    rule_type, id_prefix, schema_path = _choose_rule_kind()

    if not schema_path.exists():
        print(f"Errore: schema non trovato: {schema_path}")
        return 1

    RULES_DIR.mkdir(parents=True, exist_ok=True)

    overwrite_target = _resolve_overwrite_target(RULES_DIR, id_prefix)
    if overwrite_target is None:
        next_rule_id, out_path = _next_rule_id_and_file(RULES_DIR, id_prefix)
        print(f"Prossimo identificativo disponibile: {next_rule_id}")
    else:
        next_rule_id, out_path = overwrite_target
        print(f"Sovrascrittura attiva su: {out_path}")

    rule_text = input("Inserisci la regola in linguaggio libero: ").strip()
    if not rule_text:
        print("Errore: input vuoto.")
        return 1

    schema = _read_json(schema_path)

    try:
        rule_json = _call_openrouter(
            api_key=api_key,
            model=model,
            rule_text=rule_text,
            target_rule_id=next_rule_id,
            rule_type=rule_type,
            schema=schema,
        )
    except RuleGenerationError as e:
        print(f"Errore generazione: {e}")
        return 1

    # Enforce nomenclatura coerente sia nel file che dentro al JSON
    rule_json["rule_id"] = next_rule_id
    rule_json["rule_type"] = rule_type

    with out_path.open("w", encoding="utf-8") as f:
        json.dump(rule_json, f, ensure_ascii=False, indent=2)
        f.write("\n")

    print(f"Regola creata: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())