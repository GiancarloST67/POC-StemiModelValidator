#!/usr/bin/env python3
"""
Check batch regole STEMI con salvataggio su PostgreSQL (compliance_instance)
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

try:
    import psycopg2
    from psycopg2.extras import Json
except ImportError:
    print("Errore: la libreria psycopg2 non è installata. Eseguire: pip install psycopg2-binary")
    import sys
    sys.exit(1)

ROOT = Path(__file__).resolve().parent
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

DEFAULT_DB_NAME = "RiskMgm"

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", DEFAULT_DB_NAME),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "Sanbarra123")
    )

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
RUNAWAY_TOKEN_LIMITS_BY_MODEL["qwen/qwen3.5-35b-a3b"] = 10000
RUNAWAY_TOKEN_LIMITS_BY_MODEL["google/gemini-3.1-flash-lite-preview"] = 10000
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
class CaseSelection:
    case_id: int
    clinical_pathway_id: int
    identifier: str
    body: dict

@dataclass(frozen=True)
class DbRule:
    rule_id: int
    clinical_pathway_id: int
    name: str
    body: dict

def _coerce_json_object(value: object, *, context: str) -> dict:
    if isinstance(value, dict):
        return value
    if isinstance(value, str):
        try:
            parsed = json.loads(value)
        except json.JSONDecodeError as e:
            raise RuleCheckError(f"{context}: JSON non parsabile: {e}") from e
        if not isinstance(parsed, dict):
            raise RuleCheckError(f"{context}: atteso oggetto JSON.")
        return parsed
    raise RuleCheckError(f"{context}: tipo non supportato ({type(value).__name__}).")

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
        "minimum", "maximum", "exclusiveMinimum", "exclusiveMaximum",
        "multipleOf", "minLength", "maxLength", "pattern", "format",
        "minItems", "maxItems", "uniqueItems", "minProperties", "maxProperties",
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

def _extract_inference_cost_usd(body: dict, header_cost_usd: float | None) -> float | None:
    usage_raw = body.get("usage")
    usage: dict[str, object] = usage_raw if isinstance(usage_raw, dict) else {}
    direct_candidates = [
        body.get("cost"), body.get("total_cost"), body.get("cost_usd"),
        body.get("total_cost_usd"), usage.get("cost"), usage.get("total_cost"),
        usage.get("cost_usd"), usage.get("total_cost_usd"), usage.get("usd"),
        usage.get("usd_cost"), usage.get("estimated_cost"),
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
    if headers is None: return None
    getter = getattr(headers, "get", None)
    if not callable(getter): return None
    raw_retry_after = getter("Retry-After")
    if raw_retry_after is None: return None
    txt = str(raw_retry_after).strip()
    if not txt: return None
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
            if _is_retryable_openrouter_http_error(status_code=e.code, details=details) and retry_count < OPENROUTER_MAX_RETRIES:
                wait_seconds = _retry_delay_seconds(retry_index=retry_count, retry_after_seconds=_retry_after_seconds_from_headers(getattr(e, "headers", None)))
                retry_count += 1
                print(f"[WARN] OpenRouter HTTP {e.code} su {model_name}: retry {retry_count}/{OPENROUTER_MAX_RETRIES} tra {wait_seconds:.1f}s.")
                sleep(wait_seconds)
                continue
            raise RuleCheckError(f"OpenRouter HTTP {e.code}: {details}") from e
        except (error.URLError, TimeoutError) as e:
            if retry_count < OPENROUTER_MAX_RETRIES:
                wait_seconds = _retry_delay_seconds(retry_index=retry_count, retry_after_seconds=None)
                retry_count += 1
                print(f"[WARN] Errore rete OpenRouter su {model_name}: retry {retry_count}/{OPENROUTER_MAX_RETRIES} tra {wait_seconds:.1f}s.")
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

def _load_cases_for_pathway_from_db(conn, *, clinical_pathway_id: int) -> list[CaseSelection]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT case_id, clinical_pathway_id, identifier, body
            FROM riskm_manager_model_evaluation.clinical_case
            WHERE clinical_pathway_id = %s
            ORDER BY case_id
            """,
            (clinical_pathway_id,),
        )
        rows = cur.fetchall()

    selections: list[CaseSelection] = []
    for case_id_raw, pathway_id_raw, identifier_raw, body_raw in rows:
        case_id = int(case_id_raw)
        pathway_id = int(pathway_id_raw)
        identifier = str(identifier_raw)
        body = _coerce_json_object(body_raw, context=f"clinical_case.body case_id={case_id}")
        selections.append(
            CaseSelection(
                case_id=case_id,
                clinical_pathway_id=pathway_id,
                identifier=identifier,
                body=body,
            )
        )

    if not selections:
        raise RuleCheckError(f"Nessun clinical_case trovato per clinical_pathway_id={clinical_pathway_id}.")

    return selections

def _choose_case_from_db(conn, *, clinical_pathway_id: int, clinical_pathway_name: str) -> CaseSelection:
    case_rows = _load_cases_for_pathway_from_db(conn, clinical_pathway_id=clinical_pathway_id)

    options: dict[int, str] = {}
    default_id: int | None = None

    print("\nCasi disponibili da DB (case_id -> identifier):")
    for case_row in case_rows:
        options[case_row.case_id] = case_row.identifier
        marker = ""
        if default_id is None:
            default_id = case_row.case_id
            marker = " [default]"
        print(f"  {case_row.case_id:>3}) {case_row.identifier}{marker}")

    selected_case_id = _prompt_select_db_id(
        options,
        prompt=f"Seleziona case_id DB per pathway {clinical_pathway_name}",
        default_id=default_id,
    )

    for case_row in case_rows:
        if case_row.case_id == selected_case_id:
            return case_row

    raise RuleCheckError(f"Case ID DB {selected_case_id} non trovato dopo selezione.")

def _load_rules_for_pathway_from_db(conn, *, clinical_pathway_id: int) -> list[DbRule]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT rule_id, clinical_pathway_id, name, body
            FROM riskm_manager_model_evaluation.rule_definition
            WHERE clinical_pathway_id = %s
            ORDER BY rule_id
            """,
            (clinical_pathway_id,),
        )
        rows = cur.fetchall()

    db_rules: list[DbRule] = []
    for rule_id_raw, pathway_id_raw, name_raw, body_raw in rows:
        rule_id = int(rule_id_raw)
        pathway_id = int(pathway_id_raw)
        name = str(name_raw)
        body = _coerce_json_object(body_raw, context=f"rule_definition.body rule_id={rule_id}")
        db_rules.append(
            DbRule(
                rule_id=rule_id,
                clinical_pathway_id=pathway_id,
                name=name,
                body=body,
            )
        )

    if not db_rules:
        raise RuleCheckError(f"Nessuna regola trovata per clinical_pathway_id={clinical_pathway_id}.")

    return db_rules

def _load_prompt_and_schema_from_db(conn,
                                    *,
                                    inference_params_id: int,
                                    selected_pathway_id: int) -> tuple[str, dict]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT ip.clinical_pathway_id,
                   ip.prompt1,
                   ip.json_schema1,
                   cp.prompt1
            FROM riskm_manager_model_evaluation.inference_params ip
            JOIN riskm_manager_model_evaluation.clinical_pathway cp
              ON cp.clinical_pathway_id = ip.clinical_pathway_id
            WHERE ip.inference_params_id = %s
            """,
            (inference_params_id,),
        )
        row = cur.fetchone()

    if not row:
        raise RuleCheckError(f"Inference Params ID DB {inference_params_id} non trovato.")

    inference_pathway_id = int(row[0])
    inference_prompt = str(row[1] or "").strip()
    inference_schema_raw = row[2]
    pathway_prompt = str(row[3] or "").strip()

    if inference_pathway_id != selected_pathway_id:
        raise RuleCheckError(
            "Incoerenza pathway per prompt/schema: "
            f"inference_params_id={inference_params_id} appartiene a pathway {inference_pathway_id}, "
            f"atteso {selected_pathway_id}."
        )

    base_prompt = inference_prompt or pathway_prompt
    if not base_prompt:
        raise RuleCheckError(
            "Prompt base non disponibile su DB: valorizzare inference_params.prompt1 "
            "o clinical_pathway.prompt1."
        )

    check_schema = _coerce_json_object(
        inference_schema_raw,
        context=f"inference_params.json_schema1 inference_params_id={inference_params_id}",
    )

    return base_prompt, check_schema

def _build_prompt(base_prompt: str, episode: dict, rule: dict) -> str:
    return (
        f"{base_prompt.strip()}\n\n"
        "---\nINPUT EPISODIO (JSON):\n"
        f"{json.dumps(episode, ensure_ascii=False, indent=2)}\n\n"
        "INPUT REGOLA DA VERIFICARE (JSON):\n"
        f"{json.dumps(rule, ensure_ascii=False, indent=2)}\n\n"
        "ISTRUZIONI FINALI:\n"
        "- Restituisci SOLO JSON valido, senza markdown e senza testo extra.\n"
        "- L'output deve essere conforme allo schema check_rule_schema.\n"
        "- In supporting_documents includi almeno un documento clinico con: document_id, rationale sintetico, confidence (0..1).\n"
        "- Il rationale di ogni documento deve essere coerente con il rationale generale dell'output.\n"
    )

def _call_openrouter_check(*, api_key: str, model: str, prompt_text: str, check_schema: dict, reasoning_effort: str) -> tuple[dict, float | None]:
    system_prompt = "Sei un valutatore clinico STEMI. Ricevi episodio + regola e devi produrre esclusivamente un JSON conforme allo schema di check fornito. Nessun testo extra."
    schema_for_provider = _sanitize_json_schema_for_openrouter(check_schema)
    provider_cfg = _provider_for_model(model)
    runaway_limit = _runaway_token_limit_for_model(model)

    def _invoke_once(user_prompt_text: str, *, effort: str, temperature: float) -> tuple[str, str | None, float | None]:
        payload = {
            "model": model, "reasoning": {"effort": effort}, "temperature": temperature,
            "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt_text}],
            "response_format": {"type": "json_schema", "json_schema": {"name": "check_rule_output", "strict": True, "schema": schema_for_provider}},
        }
        if provider_cfg is not None: payload["provider"] = provider_cfg
        if runaway_limit is not None: payload["max_tokens"] = runaway_limit
        try:
            return _post_openrouter_with_meta(api_key=api_key, payload=payload)
        except RuleCheckError as e:
            if "compiled grammar is too large" not in str(e).lower(): raise
            fallback_payload = {
                "model": model, "reasoning": {"effort": effort}, "temperature": temperature,
                "messages": [
                    {"role": "system", "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente."},
                    {"role": "user", "content": (f"{user_prompt_text}\n\nSCHEMA JSON DA RISPETTARE:\n{json.dumps(check_schema, ensure_ascii=False)}")},
                ],
                "response_format": {"type": "json_object"},
            }
            if provider_cfg is not None: fallback_payload["provider"] = provider_cfg
            if runaway_limit is not None: fallback_payload["max_tokens"] = runaway_limit
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
            f"{prompt_text}\n\nVINCOLO EXTRA DI SINTESI:\n"
            "- Mantieni il campo rationale breve (massimo 120 parole).\n"
            "- Evita ripetizioni e dettagli non necessari.\n"
            "- Restituisci direttamente il JSON finale.\n"
        )
        content, finish_reason, call_cost_usd = _invoke_once(retry_prompt_text, effort="low", temperature=0.0)
        _register_cost(call_cost_usd)
        if _is_runaway_cap_hit(finish_reason):
            raise RuleCheckError(f"Output troncato per runaway token cap ({runaway_limit}) anche dopo retry controllato.")

    cleaned = _strip_markdown_fences(content)
    try:
        check_cost_usd = total_cost_usd if (call_count > 0 and all_costs_known) else None
        return json.loads(cleaned), check_cost_usd
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON modello non parsabile: {e}. Estratto: {cleaned[:700]}") from e

def _rationale_alignment_score_jaccard_0_10(candidate: dict, gold: dict) -> int:
    cand_rat = _normalize_text(candidate.get("rationale", ""))
    gold_rat = _normalize_text(gold.get("rationale", ""))
    if not cand_rat or not gold_rat: return 0
    cand_tokens, gold_tokens = set(cand_rat.split()), set(gold_rat.split())
    union = cand_tokens | gold_tokens
    inter = cand_tokens & gold_tokens
    jaccard = (len(inter) / len(union)) if union else 0.0
    return _clip_0_10(10.0 * jaccard)

def _supporting_documents_for_alignment(report: dict) -> list[dict]:
    docs = report.get("supporting_documents") if isinstance(report, dict) else None
    if not isinstance(docs, list): return []
    prepared: list[dict] = []
    for item in docs:
        if not isinstance(item, dict): continue
        prepared.append({
            "document_id": item.get("document_id"),
            "rationale": item.get("rationale"),
            "confidence": item.get("confidence"),
        })
    return prepared

def _call_openrouter_rationale_alignment(*, api_key: str, judge_model: str, judge_prompt_text: str, candidate: dict, gold: dict) -> int:
    schema = {
        "type": "object",
        "properties": {
            "alignment_score_0_10": {"type": "integer", "minimum": 0, "maximum": 10},
            "alignment_notes": {"type": "string"},
        },
        "required": ["alignment_score_0_10", "alignment_notes"],
        "additionalProperties": False,
    }
    system_prompt = (judge_prompt_text or "").strip()
    if not system_prompt: raise RuleCheckError("Prompt giudice rationale vuoto.")

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
        }
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
        "model": judge_model, "reasoning": {"effort": "medium"}, "temperature": 0.0,
        "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt}],
        "response_format": {"type": "json_schema", "json_schema": {"name": "rationale_alignment", "strict": True, "schema": schema_for_provider}},
    }
    if provider_cfg is not None: payload["provider"] = provider_cfg

    try:
        content = _post_openrouter(api_key=api_key, payload=payload)
    except RuleCheckError as e:
        if "compiled grammar is too large" not in str(e).lower(): raise
        fallback_payload = {
            "model": judge_model, "reasoning": {"effort": "medium"}, "temperature": 0.0,
            "messages": [
                {"role": "system", "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente."},
                {"role": "user", "content": f"{user_prompt}\n\nSCHEMA JSON DA RISPETTARE:\n{json.dumps(schema, ensure_ascii=False)}"},
            ],
            "response_format": {"type": "json_object"},
        }
        if provider_cfg is not None: fallback_payload["provider"] = provider_cfg
        content = _post_openrouter(api_key=api_key, payload=fallback_payload)

    cleaned = _strip_markdown_fences(content)
    try:
        alignment_json = json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON giudice rationale non parsabile: {e}. Estratto: {cleaned[:700]}") from e

    raw_score = alignment_json.get("alignment_score_0_10")
    if not isinstance(raw_score, (int, float)): raise RuleCheckError("Risposta giudice rationale senza alignment_score_0_10 numerico.")
    return _clip_0_10(float(raw_score))

def _derive_patient_hash(episode_json: dict) -> str:
    patient = episode_json.get("paziente") if isinstance(episode_json, dict) else None
    if isinstance(patient, dict):
        cf = str(patient.get("codiceFiscale", "")).strip().upper()
        if cf: return hashlib.sha256(cf.encode("utf-8")).hexdigest()[:16]
    return "unknown_patient"

def _mode_is_gold() -> bool:
    print("\nModalità iniziale:")
    print("  1) Creazione GOLD standard")
    print("  2) Comparazione tra modelli")
    choice = input("Seleziona modalità [1/2] (default 1): ").strip() or "1"
    if choice not in {"1", "2"}: raise RuleCheckError("Modalità non valida.")
    return choice == "1"

def _normalize_lookup_key(value: object) -> str:
    return re.sub(r"\s+", "", str(value or "").strip().upper())

def _prompt_select_db_id(options: dict[int, str], *, prompt: str, default_id: int | None = None) -> int:
    if not options:
        raise RuleCheckError("Nessuna opzione disponibile nel DB.")

    while True:
        full_prompt = prompt
        if default_id is not None and default_id in options:
            full_prompt += f" (default {default_id})"
        full_prompt += ": "
        raw = input(full_prompt).strip()

        if not raw and default_id is not None and default_id in options:
            return default_id

        if raw.isdigit():
            selected = int(raw)
            if selected in options:
                return selected

        print("Selezione non valida. Inserire un ID presente in elenco.")

def _choose_model_from_db(conn, *, mode_gold: bool) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT model_id, code
            FROM riskm_manager_model_evaluation.model
            ORDER BY model_id
            """
        )
        rows = cur.fetchall()

    if not rows:
        raise RuleCheckError("Nessun modello trovato nella tabella model.")

    if mode_gold:
        hard_gold_model = DEFAULT_GOLD_MODEL.strip().lower()
        for model_id_raw, code_raw in rows:
            code = str(code_raw).strip()
            if code.lower() == hard_gold_model:
                model_id = int(model_id_raw)
                print(
                    "\nModalita GOLD: modello fissato hard a "
                    f"{code} (model_id DB {model_id})."
                )
                return model_id, code

        raise RuleCheckError(
            "Modalita GOLD: il modello hard richiesto non esiste in tabella model: "
            f"{DEFAULT_GOLD_MODEL}. Inserirlo prima di procedere."
        )

    default_code = ""
    options: dict[int, str] = {}
    default_id: int | None = None

    print("\nModelli disponibili da DB (model_id -> code):")
    for model_id_raw, code_raw in rows:
        model_id = int(model_id_raw)
        code = str(code_raw)
        options[model_id] = code
        marker = ""
        if default_code and code.strip().lower() == default_code:
            default_id = model_id
            marker = " [default env OPENROUTER_MODEL]"
        print(f"  {model_id:>3}) {code}{marker}")

    selected_id = _prompt_select_db_id(options, prompt="Seleziona model_id DB", default_id=default_id)
    return selected_id, options[selected_id]

def _choose_clinical_pathway_from_db(conn) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT cp.clinical_pathway_id, cp.name, COUNT(cc.case_id)::int AS cases_count
            FROM riskm_manager_model_evaluation.clinical_pathway cp
            LEFT JOIN riskm_manager_model_evaluation.clinical_case cc
                ON cc.clinical_pathway_id = cp.clinical_pathway_id
            GROUP BY cp.clinical_pathway_id, cp.name
            ORDER BY cp.clinical_pathway_id
            """
        )
        pathway_rows = cur.fetchall()

    if not pathway_rows:
        raise RuleCheckError("Nessun clinical_pathway trovato nel DB.")

    options: dict[int, str] = {}
    default_id: int | None = None

    print("\nClinical pathway disponibili da DB (clinical_pathway_id -> name):")
    for pathway_id_raw, pathway_name_raw, cases_count_raw in pathway_rows:
        pathway_id = int(pathway_id_raw)
        pathway_name = str(pathway_name_raw)
        case_count = int(cases_count_raw)
        options[pathway_id] = pathway_name
        marker = ""
        if default_id is None and case_count > 0:
            default_id = pathway_id
            marker = " [default]"
        print(f"  {pathway_id:>3}) {pathway_name} | cases: {case_count}{marker}")

    selected_id = _prompt_select_db_id(
        options,
        prompt="Seleziona clinical_pathway_id DB",
        default_id=default_id,
    )
    return selected_id, options[selected_id]

def _choose_inference_params_from_db(conn, *, clinical_pathway_id: int | None = None) -> tuple[int, str]:
    with conn.cursor() as cur:
        query = (
            "SELECT ip.inference_params_id, ip.name, ip.is_active, cp.name "
            "FROM riskm_manager_model_evaluation.inference_params ip "
            "LEFT JOIN riskm_manager_model_evaluation.clinical_pathway cp "
            "ON cp.clinical_pathway_id = ip.clinical_pathway_id "
        )
        params: tuple[int, ...] | tuple[()] = ()
        if clinical_pathway_id is not None:
            query += "WHERE ip.clinical_pathway_id = %s "
            params = (clinical_pathway_id,)
        query += "ORDER BY ip.inference_params_id"
        cur.execute(
            query,
            params,
        )
        rows = cur.fetchall()

    if not rows:
        if clinical_pathway_id is None:
            raise RuleCheckError("Nessun inference_params trovato nel DB.")
        raise RuleCheckError(f"Nessun inference_params trovato per clinical_pathway_id={clinical_pathway_id}.")

    options: dict[int, str] = {}
    default_id: int | None = None

    print("\nInference params disponibili da DB (inference_params_id -> name):")
    for inference_params_id_raw, name_raw, is_active_raw, pathway_name_raw in rows:
        inference_params_id = int(inference_params_id_raw)
        name = str(name_raw)
        is_active = bool(is_active_raw)
        pathway_name = str(pathway_name_raw or "-")
        options[inference_params_id] = name
        marker = " [active]" if is_active else ""
        if default_id is None and is_active:
            default_id = inference_params_id
        print(f"  {inference_params_id:>3}) {name} | pathway: {pathway_name}{marker}")

    selected_id = _prompt_select_db_id(options, prompt="Seleziona inference_params_id DB", default_id=default_id)
    return selected_id, options[selected_id]

def _choose_inference_params_for_gold_auto(conn, *, clinical_pathway_id: int) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT inference_params_id, name, is_active
            FROM riskm_manager_model_evaluation.inference_params
            WHERE clinical_pathway_id = %s
            ORDER BY is_active DESC, inference_params_id
            """,
            (clinical_pathway_id,),
        )
        rows = cur.fetchall()

    if not rows:
        raise RuleCheckError(
            f"Nessun inference_params trovato per clinical_pathway_id={clinical_pathway_id}."
        )

    inference_params_id = int(rows[0][0])
    inference_params_name = str(rows[0][1])
    is_active = bool(rows[0][2])
    status = "active" if is_active else "not active"

    print(
        "Inference params GOLD auto: "
        f"{inference_params_id} ({inference_params_name}) [{status}]"
    )
    if len(rows) > 1:
        print(
            f"Altri inference_params disponibili sul pathway: {len(rows) - 1} "
            "(non usati in GOLD auto)."
        )

    return inference_params_id, inference_params_name

def _get_case_pathway(conn, case_id: int) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT cp.clinical_pathway_id, cp.name
            FROM riskm_manager_model_evaluation.clinical_case cc
            JOIN riskm_manager_model_evaluation.clinical_pathway cp
                ON cp.clinical_pathway_id = cc.clinical_pathway_id
            WHERE cc.case_id = %s
            """,
            (case_id,),
        )
        row = cur.fetchone()

    if not row:
        raise RuleCheckError(f"Case ID DB {case_id} non trovato o senza clinical_pathway associato.")
    return int(row[0]), str(row[1])

def _get_inference_params_pathway(conn, inference_params_id: int) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT cp.clinical_pathway_id, cp.name
            FROM riskm_manager_model_evaluation.inference_params ip
            JOIN riskm_manager_model_evaluation.clinical_pathway cp
                ON cp.clinical_pathway_id = ip.clinical_pathway_id
            WHERE ip.inference_params_id = %s
            """,
            (inference_params_id,),
        )
        row = cur.fetchone()

    if not row:
        raise RuleCheckError(
            f"Inference Params ID DB {inference_params_id} non trovato o senza clinical_pathway associato."
        )
    return int(row[0]), str(row[1])

def _assert_case_inference_pathway_compatibility(*,
                                                 case_id: int,
                                                 case_pathway_id: int,
                                                 case_pathway_name: str,
                                                 inference_params_id: int,
                                                 inference_pathway_id: int,
                                                 inference_pathway_name: str) -> None:
    if case_pathway_id == inference_pathway_id:
        return
    raise RuleCheckError(
        "Incoerenza selezioni DB: "
        f"case_id={case_id} (pathway {case_pathway_id}: {case_pathway_name}) "
        f"e inference_params_id={inference_params_id} "
        f"(pathway {inference_pathway_id}: {inference_pathway_name}) non appartengono allo stesso clinical_pathway."
    )

def _load_rule_pathway_map(conn) -> dict[int, tuple[int, str]]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT rd.rule_id, cp.clinical_pathway_id, cp.name
            FROM riskm_manager_model_evaluation.rule_definition rd
            JOIN riskm_manager_model_evaluation.clinical_pathway cp
                ON cp.clinical_pathway_id = rd.clinical_pathway_id
            ORDER BY rd.rule_id
            """
        )
        rows = cur.fetchall()

    mapping: dict[int, tuple[int, str]] = {}
    for rule_id_raw, pathway_id_raw, pathway_name_raw in rows:
        mapping[int(rule_id_raw)] = (int(pathway_id_raw), str(pathway_name_raw))

    if not mapping:
        raise RuleCheckError("Nessuna regola con clinical_pathway trovata nel DB.")
    return mapping

def _assert_rule_pathway_compatibility(*,
                                       rule_id: int,
                                       rule_label: str,
                                       selected_pathway_id: int,
                                       selected_pathway_name: str,
                                       rule_pathway_map: dict[int, tuple[int, str]]) -> None:
    rule_pathway = rule_pathway_map.get(rule_id)
    if rule_pathway is None:
        raise RuleCheckError(f"rule_id DB {rule_id} non trovato nella mappatura regole/pathway.")

    rule_pathway_id, rule_pathway_name = rule_pathway
    if rule_pathway_id == selected_pathway_id:
        return

    raise RuleCheckError(
        "Incoerenza rule/pathway: "
        f"regola {rule_label} (rule_id={rule_id}, pathway {rule_pathway_id}: {rule_pathway_name}) "
        f"non compatibile con pathway selezionato ({selected_pathway_id}: {selected_pathway_name})."
    )

def _load_compliance_type_map(conn) -> dict[str, int]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT compliance_type_id, name
            FROM riskm_manager_model_evaluation.compliance_type
            ORDER BY compliance_type_id
            """
        )
        rows = cur.fetchall()

    if not rows:
        raise RuleCheckError("Nessun compliance_type trovato nel DB.")

    mapping: dict[str, int] = {}
    for compliance_type_id_raw, name_raw in rows:
        key = _normalize_text(name_raw)
        if not key:
            continue
        compliance_type_id = int(compliance_type_id_raw)
        existing = mapping.get(key)
        if existing is not None and existing != compliance_type_id:
            raise RuleCheckError(
                f"Mappatura compliance_type ambigua per '{name_raw}': {existing} e {compliance_type_id}."
            )
        mapping[key] = compliance_type_id

    if not mapping:
        raise RuleCheckError("Impossibile costruire la mappatura outcome -> compliance_type_id.")

    return mapping

def _load_rule_definition_rows(conn) -> list[tuple[int, str, str]]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT rule_id, name, COALESCE(body ->> 'rule_id', '') AS body_rule_id
            FROM riskm_manager_model_evaluation.rule_definition
            ORDER BY rule_id
            """
        )
        rows = cur.fetchall()

    prepared = [(int(rule_id), str(name), str(body_rule_id)) for rule_id, name, body_rule_id in rows]
    if not prepared:
        raise RuleCheckError("Nessuna regola trovata nella tabella rule_definition.")
    return prepared

def _build_rule_id_lookup(rule_rows: list[tuple[int, str, str]]) -> dict[str, int]:
    lookup: dict[str, int] = {}
    for rule_id, rule_name, body_rule_id in rule_rows:
        for candidate in (rule_name, body_rule_id):
            key = _normalize_lookup_key(candidate)
            if not key:
                continue
            existing = lookup.get(key)
            if existing is not None and existing != rule_id:
                raise RuleCheckError(
                    f"Lookup regole ambiguo nel DB per chiave '{candidate}': {existing} e {rule_id}."
                )
            lookup[key] = rule_id
    return lookup

def _choose_rule_id_from_db(rule_label: str, rule_rows: list[tuple[int, str, str]]) -> int:
    options: dict[int, str] = {}
    print(f"\nRegole DB disponibili per {rule_label}:")
    for rule_id, rule_name, body_rule_id in rule_rows:
        display_code = body_rule_id or rule_name
        display = f"{display_code} | name={rule_name}"
        options[rule_id] = display
        print(f"  {rule_id:>3}) {display}")

    return _prompt_select_db_id(options, prompt=f"Seleziona rule_id DB per {rule_label}")

def _resolve_rule_id_from_db(*,
                             rule_json: dict,
                             rule_name: str,
                             rule_lookup: dict[str, int],
                             rule_rows: list[tuple[int, str, str]]) -> int:
    keys: list[str] = []
    for candidate in (rule_json.get("rule_id"), rule_json.get("name"), rule_name):
        key = _normalize_lookup_key(candidate)
        if key and key not in keys:
            keys.append(key)

    matches = sorted({rule_lookup[key] for key in keys if key in rule_lookup})
    if len(matches) == 1:
        return matches[0]

    rule_label = str(rule_json.get("rule_id") or rule_name)
    if not matches:
        print(f"[WARN] Nessun match automatico rule_id DB per '{rule_label}'.")
    else:
        print(f"[WARN] Match automatico ambiguo rule_id DB per '{rule_label}': {matches}.")
    return _choose_rule_id_from_db(rule_label=rule_label, rule_rows=rule_rows)

def _compliance_type_id_from_result(result_json: dict, compliance_type_map: dict[str, int]) -> int:
    outcome_key = _normalize_text(result_json.get("outcome"))
    if not outcome_key:
        raise RuleCheckError("Output senza campo 'outcome': impossibile determinare compliance_type_id.")

    compliance_type_id = compliance_type_map.get(outcome_key)
    if compliance_type_id is None:
        available = ", ".join(sorted(compliance_type_map.keys()))
        raise RuleCheckError(
            f"Outcome '{result_json.get('outcome')}' non presente in compliance_type DB. Valori disponibili: {available}."
        )
    return compliance_type_id

def _choose_reasoning_effort() -> str:
    print("\nLivelli reasoning disponibili (OpenRouter):")
    print("  1) low")
    print("  2) medium")
    print("  3) high")
    choice = input("Seleziona livello reasoning [1/2/3] (default 3): ").strip() or "3"
    if choice not in REASONING_EFFORTS: raise RuleCheckError("Selezione reasoning non valida.")
    return REASONING_EFFORTS[choice]

def _normalize_text(value: object) -> str:
    return re.sub(r"\s+", " ", str(value or "").strip().lower())

def _clip_0_10(value: float) -> int:
    v = round(value)
    if v < 0: return 0
    if v > 10: return 10
    return int(v)

def _format_conformity_score_colored(score_0_10: int) -> str:
    score = _clip_0_10(score_0_10)
    plain = f"{score}/10"
    if os.getenv("NO_COLOR"): return plain
    if score <= 3: color = "\x1b[31m"
    elif score <= 5: color = "\x1b[38;5;208m"
    elif score <= 7: color = "\x1b[33m"
    else: color = "\x1b[32m"
    reset = "\x1b[0m"
    return f"{color}{plain}{reset}"

def _format_inference_cost_usd(cost_usd: float | None) -> str:
    if not isinstance(cost_usd, (int, float)): return "N/D"
    if cost_usd < 0: return "N/D"
    return f"${float(cost_usd):.6f}"

def _format_rule_name_for_status(rule_name: str) -> str:
    label = re.sub(r"[-_]+", " ", str(rule_name or "").strip()).upper()
    label = label.replace("DONOT", "DO NOT")
    label = re.sub(r"\s+", " ", label).strip()
    return label or str(rule_name)

def _db_target_info() -> str:
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")
    name = os.getenv("DB_NAME", DEFAULT_DB_NAME)
    user = os.getenv("DB_USER", "postgres")
    return f"{host}:{port}/{name} (user={user})"

def _format_run_datetime_for_ui(value: object) -> str:
    if not isinstance(value, datetime):
        return "-"
    try:
        local_value = value.astimezone()
    except Exception:
        local_value = value
    return local_value.strftime("%d/%m/%y %H.%M.%S")

def _ensure_run_instance_schema(conn) -> None:
    with conn.cursor() as cur:
        cur.execute("SELECT to_regclass('riskm_manager_model_evaluation.run_instance')")
        run_table = cur.fetchone()

        cur.execute(
            """
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'riskm_manager_model_evaluation'
              AND table_name = 'compliance_instance'
              AND column_name = 'run_instance_id'
            """
        )
        run_fk_column = cur.fetchone()

    if not run_table or not run_table[0]:
        raise RuleCheckError(
            "Tabella DB mancante: riskm_manager_model_evaluation.run_instance. "
            "Applicare prima la migrazione DDL del run."
        )
    if not run_fk_column:
        raise RuleCheckError(
            "Colonna DB mancante: riskm_manager_model_evaluation.compliance_instance.run_instance_id. "
            "Applicare prima la migrazione DDL del run."
        )

def _load_existing_runs(conn) -> list[tuple[int, object]]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT run_instance_id, run_datetime
            FROM riskm_manager_model_evaluation.run_instance
            ORDER BY run_instance_id
            """
        )
        rows = cur.fetchall()
    return [(int(run_id_raw), run_datetime_raw) for run_id_raw, run_datetime_raw in rows]

def _choose_or_create_run_instance(conn) -> tuple[int, object, bool]:
    _ensure_run_instance_schema(conn)
    existing_runs = _load_existing_runs(conn)

    print("\nRun disponibili da DB (run_instance_id -> data):")
    if existing_runs:
        for run_id, run_datetime in existing_runs:
            print(f"  {run_id:>4}) {_format_run_datetime_for_ui(run_datetime)}")
    else:
        print("  (nessun run esistente)")

    run_map = {run_id: run_datetime for run_id, run_datetime in existing_runs}

    while True:
        raw = input("Seleziona run_instance_id esistente oppure N per New: ").strip()
        if raw.lower() == "n":
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO riskm_manager_model_evaluation.run_instance
                    DEFAULT VALUES
                    RETURNING run_instance_id, run_datetime
                    """
                )
                row = cur.fetchone()
            conn.commit()
            if not row:
                raise RuleCheckError("Creazione Run New fallita: nessun record restituito dal DB.")
            run_id = int(row[0])
            run_datetime = row[1]
            print(f"Creato Run {run_id} del {_format_run_datetime_for_ui(run_datetime)}")
            return run_id, run_datetime, True

        if raw.isdigit():
            selected_id = int(raw)
            if selected_id in run_map:
                return selected_id, run_map[selected_id], False

        print("Selezione non valida. Inserire un run_instance_id presente in elenco oppure N.")

def _choose_overwrite_or_skip_for_run(*, run_instance_id: int, run_datetime: object, is_new_run: bool) -> str:
    if is_new_run:
        run_label = "Run New"
    else:
        run_label = f"Run {run_instance_id} del {_format_run_datetime_for_ui(run_datetime)}"

    prompt = (
        f"Sul {run_label} vuoi sovrascrivere i record oppure skippare i test gia effettuati "
        "(Overwrite/Skip) [O/S] (default S): "
    )
    while True:
        choice = input(prompt).strip().upper()
        if not choice:
            return "S"
        if choice in {"O", "S"}:
            return choice
        print("Selezione non valida. Inserire O (Overwrite) oppure S (Skip), oppure Invio per default S.")

def _count_existing_tests_for_run(conn,
                                  *,
                                  run_instance_id: int,
                                  model_id: int,
                                  inference_params_id: int,
                                  case_id: int,
                                  rule_id: int) -> int:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT COUNT(*)
            FROM riskm_manager_model_evaluation.compliance_instance
            WHERE run_instance_id = %s
              AND model_id = %s
              AND inference_params_id = %s
              AND case_id = %s
              AND rule_id = %s
            """,
            (run_instance_id, model_id, inference_params_id, case_id, rule_id),
        )
        row = cur.fetchone()
    return int(row[0]) if row else 0

def _ensure_gold_outcome_schema(conn) -> None:
    with conn.cursor() as cur:
        cur.execute("SELECT to_regclass('riskm_manager_model_evaluation.gold_outcome')")
        row = cur.fetchone()
    if not row or not row[0]:
        raise RuleCheckError(
            "Tabella DB mancante: riskm_manager_model_evaluation.gold_outcome. "
            "Applicare prima la migrazione DDL/import GOLD."
        )

def _load_gold_outcome_from_db(conn, *, case_id: int, rule_id: int) -> dict | None:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT body
            FROM riskm_manager_model_evaluation.gold_outcome
            WHERE case_id = %s
              AND rule_id = %s
            """,
            (case_id, rule_id),
        )
        row = cur.fetchone()

    if not row:
        return None

    body = row[0]
    if isinstance(body, dict):
        return body

    if isinstance(body, str):
        try:
            parsed = json.loads(body)
        except json.JSONDecodeError as e:
            raise RuleCheckError(
                f"Body GOLD non parsabile per case_id={case_id}, rule_id={rule_id}: {e}"
            ) from e
        if not isinstance(parsed, dict):
            raise RuleCheckError(
                f"Body GOLD non oggetto JSON per case_id={case_id}, rule_id={rule_id}."
            )
        return parsed

    raise RuleCheckError(
        f"Tipo body GOLD non supportato per case_id={case_id}, rule_id={rule_id}: {type(body).__name__}"
    )

def _load_existing_gold_pairs_for_pathway(conn, *, clinical_pathway_id: int) -> set[tuple[int, int]]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT go.case_id, go.rule_id
            FROM riskm_manager_model_evaluation.gold_outcome go
            JOIN riskm_manager_model_evaluation.clinical_case cc
              ON cc.case_id = go.case_id
            JOIN riskm_manager_model_evaluation.rule_definition rd
              ON rd.rule_id = go.rule_id
            WHERE cc.clinical_pathway_id = %s
              AND rd.clinical_pathway_id = %s
            """,
            (clinical_pathway_id, clinical_pathway_id),
        )
        rows = cur.fetchall()

    pairs: set[tuple[int, int]] = set()
    for case_id_raw, rule_id_raw in rows:
        pairs.add((int(case_id_raw), int(rule_id_raw)))
    return pairs

def _insert_gold_outcome_if_missing(conn, *, case_id: int, rule_id: int, body: dict) -> tuple[bool, int | None]:
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO riskm_manager_model_evaluation.gold_outcome (rule_id, case_id, body)
            VALUES (%s, %s, %s)
            ON CONFLICT (rule_id, case_id) DO NOTHING
            RETURNING gold_outcome_id
            """,
            (rule_id, case_id, Json(body)),
        )
        row = cur.fetchone()

    if not row:
        return False, None
    return True, int(row[0])

def _outcome_alignment_score_0_10(candidate: dict, gold: dict) -> int:
    cand_outcome = _normalize_text(candidate.get("outcome"))
    gold_outcome = _normalize_text(gold.get("outcome"))
    if not cand_outcome or not gold_outcome: return 0
    if cand_outcome == gold_outcome: return 10
    similarity = OUTCOME_ALIGNMENT_TRUTH_MATRIX.get((cand_outcome, gold_outcome), 0.0)
    return _clip_0_10(10.0 * similarity)

def _conformity_score_0_10(*, inferential_alignment_0_10: int, outcome_alignment_0_10: int) -> int:
    inferential = float(_clip_0_10(inferential_alignment_0_10))
    outcome = float(_clip_0_10(outcome_alignment_0_10))
    return _clip_0_10((0.6 * inferential) + (0.4 * outcome))

def _run_gold_outcome_backfill(conn, *, api_key: str, model_id: int, model: str) -> int:
    _ensure_gold_outcome_schema(conn)

    selected_pathway_id, selected_pathway_name = _choose_clinical_pathway_from_db(conn)
    inference_params_id, inference_params_name = _choose_inference_params_for_gold_auto(
        conn,
        clinical_pathway_id=selected_pathway_id,
    )
    base_prompt, check_schema = _load_prompt_and_schema_from_db(
        conn,
        inference_params_id=inference_params_id,
        selected_pathway_id=selected_pathway_id,
    )

    case_rows = _load_cases_for_pathway_from_db(conn, clinical_pathway_id=selected_pathway_id)
    db_rules = _load_rules_for_pathway_from_db(conn, clinical_pathway_id=selected_pathway_id)
    validator = _load_jsonschema_validator(check_schema)

    existing_pairs = _load_existing_gold_pairs_for_pathway(conn, clinical_pathway_id=selected_pathway_id)
    total_pairs = len(case_rows) * len(db_rules)
    pre_existing_pairs = 0
    for case_row in case_rows:
        for db_rule in db_rules:
            if (case_row.case_id, db_rule.rule_id) in existing_pairs:
                pre_existing_pairs += 1

    print("\n=== GOLD Backfill Automatico ===")
    print(f"Modalita:             GOLD")
    print(f"Model ID DB:          {model_id}")
    print(f"Modello:              {model}")
    print(f"Clinical pathway DB:  {selected_pathway_id} ({selected_pathway_name})")
    print(f"Inference params DB:  {inference_params_id} ({inference_params_name}) [auto]")
    print(f"DB target:            {_db_target_info()}")
    print("DB table target:      riskm_manager_model_evaluation.gold_outcome")
    print("Prompt base:          DB (inference_params.prompt1/clinical_pathway.prompt1)")
    print("Schema check:         DB (inference_params.json_schema1)")
    provider_cfg = _provider_for_model(model)
    provider_display = "NULL" if provider_cfg is None else json.dumps(provider_cfg, ensure_ascii=False)
    print(f"Provider:             {provider_display}")
    print(f"Runaway token cap:    {_runaway_token_limit_for_model(model)}")
    print(f"Retry OpenRouter:     {OPENROUTER_MAX_RETRIES} (base {OPENROUTER_RETRY_BASE_DELAY_SEC:.1f}s, max {OPENROUTER_RETRY_MAX_DELAY_SEC:.1f}s)")
    print(f"Combinazioni case x rule: {total_pairs}")
    print(f"Gia presenti in GOLD:      {pre_existing_pairs}")
    print(f"Da generare:               {max(0, total_pairs - pre_existing_pairs)}")
    print("Inizio elaborazione GOLD mancanti...\n")

    reasoning_effort = "high"
    created_count = 0
    skipped_existing_count = 0
    ko_count = 0

    for case_row in case_rows:
        case_id = case_row.case_id
        episode_json = case_row.body
        for db_rule in db_rules:
            db_rule_id = db_rule.rule_id
            if (case_id, db_rule_id) in existing_pairs:
                skipped_existing_count += 1
                continue

            rule_json = db_rule.body
            rule_name = str(rule_json.get("rule_id") or db_rule.name)
            rule_label = _format_rule_name_for_status(rule_name)
            check_elapsed_sec: float | None = None
            check_cost_usd: float | None = None

            try:
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
                result_json.setdefault("check_id", f"GOLD-{case_id}-{rule_name}-{datetime.now(UTC).strftime('%Y%m%d%H%M%S')}")
                result_json.setdefault("check_timestamp", datetime.now(UTC).isoformat())
                result_json.setdefault("patient_id_hash", _derive_patient_hash(episode_json))

                errors = sorted(validator.iter_errors(result_json), key=lambda e: e.path)
                if errors:
                    first = errors[0]
                    loc = "/".join(str(x) for x in first.path) or "<root>"
                    raise RuleCheckError(f"Output non conforme allo schema in '{loc}': {first.message}")

                created, gold_outcome_id = _insert_gold_outcome_if_missing(
                    conn,
                    case_id=case_id,
                    rule_id=db_rule_id,
                    body=result_json,
                )
                conn.commit()

                if created:
                    existing_pairs.add((case_id, db_rule_id))
                    created_count += 1
                    print(
                        f"[OK ] case_id={case_id} | {rule_label} "
                        f"| tempo: {check_elapsed_sec:.2f}s "
                        f"| costo: {_format_inference_cost_usd(check_cost_usd)} "
                        f"| gold_outcome_id: {gold_outcome_id}"
                    )
                else:
                    existing_pairs.add((case_id, db_rule_id))
                    skipped_existing_count += 1

            except Exception as e:
                conn.rollback()
                if check_elapsed_sec is None:
                    print(
                        f"[KO ] case_id={case_id} | {rule_label} "
                        f"-> errore: {e} | costo: {_format_inference_cost_usd(check_cost_usd)}"
                    )
                else:
                    print(
                        f"[KO ] case_id={case_id} | {rule_label} "
                        f"-> errore: {e} | tempo check: {check_elapsed_sec:.2f}s "
                        f"| costo: {_format_inference_cost_usd(check_cost_usd)}"
                    )
                ko_count += 1

    print("\n=== Riepilogo GOLD Backfill ===")
    print(f"Creati:                {created_count}")
    print(f"Gia presenti (skip):   {skipped_existing_count}")
    print(f"KO:                    {ko_count}")
    print("Salvataggio effettuato su Database (riskm_manager_model_evaluation.gold_outcome).")

    return 0 if ko_count == 0 else 2

def _ensure_reference_prompt_template(base_prompt: str) -> None:
    _ = base_prompt
    return

def save_to_db(conn, run_instance_id: int, model_id: int, case_id: int, rule_id: int, inference_params_id: int,
               compliance_type_map: dict[str, int], result_json: dict,
               overwrite_existing_in_run: bool,
               check_elapsed_sec: float | None, check_cost_usd: float | None,
               quality_score_total=None, quality_score_rationale=None, quality_score_classification=None):
    compliance_type_id = _compliance_type_id_from_result(result_json, compliance_type_map)

    confidence = result_json.get("confidence")

    with conn.cursor() as cursor:
        overwritten_rows = 0
        if overwrite_existing_in_run:
            # Delete child rows first to avoid FK violation when compliance_supporting_document
            # has ON DELETE RESTRICT on compliance_instance_id.
            cursor.execute(
                """
                DELETE FROM riskm_manager_model_evaluation.compliance_supporting_document
                WHERE compliance_instance_id IN (
                    SELECT compliance_instance_id
                    FROM riskm_manager_model_evaluation.compliance_instance
                    WHERE run_instance_id = %s
                      AND model_id = %s
                      AND inference_params_id = %s
                      AND case_id = %s
                      AND rule_id = %s
                )
                """,
                (run_instance_id, model_id, inference_params_id, case_id, rule_id),
            )
            cursor.execute(
                """
                DELETE FROM riskm_manager_model_evaluation.compliance_instance
                WHERE run_instance_id = %s
                  AND model_id = %s
                  AND inference_params_id = %s
                  AND case_id = %s
                  AND rule_id = %s
                """,
                (run_instance_id, model_id, inference_params_id, case_id, rule_id),
            )
            overwritten_rows = max(0, cursor.rowcount)

        query = """
            INSERT INTO riskm_manager_model_evaluation.compliance_instance (
                compliance_type_id, run_instance_id, model_id, inference_params_id, case_id, rule_id,
                body, confidence, quality_score_total, quality_score_rationale, quality_score_classification,
                computing_time_ms, cost_in_dollar
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
            ) RETURNING compliance_instance_id;
        """
        computing_time_ms = int(check_elapsed_sec * 1000) if check_elapsed_sec else None
        
        cursor.execute(query, (
            compliance_type_id,
            run_instance_id,
            model_id,
            inference_params_id,
            case_id,
            rule_id,
            Json(result_json),
            confidence,
            quality_score_total,
            quality_score_rationale,
            quality_score_classification,
            computing_time_ms,
            check_cost_usd
        ))
        
        instance_id = cursor.fetchone()[0]
        
        # Supporting documents insert (optional, per DDL)
        documents = result_json.get("supporting_documents", [])
        if isinstance(documents, list) and documents:
            ensure_document_query = """
                INSERT INTO riskm_manager_model_evaluation.document (
                    document_id, case_id, document_date, body
                ) OVERRIDING SYSTEM VALUE VALUES (%s, %s, CURRENT_DATE, %s)
                ON CONFLICT (document_id) DO NOTHING
            """
            doc_query = """
                INSERT INTO riskm_manager_model_evaluation.compliance_supporting_document (
                    compliance_instance_id, document_id, rationale, confidence
                ) VALUES (%s, %s, %s, %s)
                ON CONFLICT (compliance_instance_id, document_id) DO NOTHING
            """
            for doc in documents:
                if not isinstance(doc, dict):
                    continue
                doc_id = doc.get("document_id")
                
                if doc_id is not None:
                    try:
                        doc_id_int = int(str(doc_id).split('-')[-1]) if isinstance(doc_id, str) else int(doc_id)
                        if doc_id_int <= 0:
                            continue

                        cursor.execute(
                            ensure_document_query,
                            (
                                doc_id_int,
                                case_id,
                                Json({"source": "auto-placeholder", "original_document_id": doc_id}),
                            ),
                        )

                        cursor.execute(doc_query, (
                            instance_id,
                            doc_id_int,
                            doc.get("rationale"),
                            doc.get("confidence")
                        ))
                    except (TypeError, ValueError):
                        pass
        conn.commit()

        with conn.cursor() as verify_cursor:
            verify_cursor.execute(
                "SELECT 1 FROM riskm_manager_model_evaluation.compliance_instance WHERE compliance_instance_id = %s",
                (instance_id,),
            )
            if not verify_cursor.fetchone():
                raise RuleCheckError(
                    f"Salvataggio DB non confermato per compliance_instance_id={instance_id}."
                )

            return instance_id, overwritten_rows

def update_quality_scores_in_db(conn, compliance_instance_id: int,
                                quality_score_total: float | None,
                                quality_score_rationale: float | None,
                                quality_score_classification: float | None) -> None:
    with conn.cursor() as cursor:
        cursor.execute(
            """
            UPDATE riskm_manager_model_evaluation.compliance_instance
            SET quality_score_total = %s,
                quality_score_rationale = %s,
                quality_score_classification = %s
            WHERE compliance_instance_id = %s
            """,
            (
                quality_score_total,
                quality_score_rationale,
                quality_score_classification,
                compliance_instance_id,
            ),
        )
    conn.commit()
    

def main() -> int:
    print("=== Check batch regole STEMI con OpenRouter (DB Save) ===")

    api_key = os.getenv("OPENROUTER_API_KEY")
    if not api_key:
        print("Errore: variabile OPENROUTER_API_KEY non impostata.")
        return 1

    try:
        conn = get_db_connection()
    except Exception as e:
        print(f"Errore connessione DB: {e}")
        return 1

    try:
        mode_gold = _mode_is_gold()
        model_id, model = _choose_model_from_db(conn, mode_gold=mode_gold)
    except RuleCheckError as e:
        print(f"Errore modalità/modello: {e}")
        conn.close()
        return 1

    if mode_gold:
        try:
            return _run_gold_outcome_backfill(
                conn,
                api_key=api_key,
                model_id=model_id,
                model=model,
            )
        finally:
            conn.close()

    try:
        rationale_alignment_model = os.getenv("OPENROUTER_ALIGNMENT_MODEL", DEFAULT_RATIONALE_ALIGNMENT_MODEL)
        reasoning_effort = _choose_reasoning_effort()
        run_instance_id, run_datetime, is_new_run = _choose_or_create_run_instance(conn)
        overwrite_or_skip = _choose_overwrite_or_skip_for_run(
            run_instance_id=run_instance_id,
            run_datetime=run_datetime,
            is_new_run=is_new_run,
        )
    except RuleCheckError as e:
        print(f"Errore setup comparazione: {e}")
        conn.close()
        return 1

    if not mode_gold and not RATIONALE_ALIGNMENT_PROMPT_PATH.exists():
        print(f"Errore: prompt giudice rationale non trovato: {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
        conn.close()
        return 1

    try:
        selected_pathway_id, selected_pathway_name = _choose_clinical_pathway_from_db(conn)
        case_selection = _choose_case_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
            clinical_pathway_name=selected_pathway_name,
        )
        case_id = case_selection.case_id
        case_identifier = case_selection.identifier
        inference_params_id, inference_params_name = _choose_inference_params_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
        )
        base_prompt, check_schema = _load_prompt_and_schema_from_db(
            conn,
            inference_params_id=inference_params_id,
            selected_pathway_id=selected_pathway_id,
        )
        db_rules = _load_rules_for_pathway_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
        )
        case_pathway_id, case_pathway_name = _get_case_pathway(conn, case_id)
        inference_pathway_id, inference_pathway_name = _get_inference_params_pathway(conn, inference_params_id)
        _assert_case_inference_pathway_compatibility(
            case_id=case_id,
            case_pathway_id=case_pathway_id,
            case_pathway_name=case_pathway_name,
            inference_params_id=inference_params_id,
            inference_pathway_id=inference_pathway_id,
            inference_pathway_name=inference_pathway_name,
        )
        compliance_type_map = _load_compliance_type_map(conn)
        if not mode_gold:
            _ensure_gold_outcome_schema(conn)

        validator = _load_jsonschema_validator(check_schema)
        episode_json = case_selection.body
        rationale_prompt_text = ""
        if not mode_gold:
            rationale_prompt_text = RATIONALE_ALIGNMENT_PROMPT_PATH.read_text(encoding="utf-8").strip()
            if not rationale_prompt_text:
                raise RuleCheckError("Il prompt del giudice rationale e' vuoto.")
    except Exception as e:
        print(f"Errore inizializzazione: {e}")
        conn.close()
        return 1

    print(f"\nCaso selezionato:     {case_identifier} (da DB)")
    print(f"Numero regole:        {len(db_rules)}")
    print(f"Modalità:             {'GOLD' if mode_gold else 'COMPARAZIONE'}")
    print(f"Model ID DB:          {model_id}")
    print(f"Modello:              {model}")
    print(f"Clinical pathway DB:  {selected_pathway_id} ({selected_pathway_name})")
    print(f"Case ID DB:           {case_id} ({case_identifier})")
    print(f"Inference params DB:  {inference_params_id} ({inference_params_name})")
    print(f"Run DB:               {run_instance_id} ({_format_run_datetime_for_ui(run_datetime)})")
    print(f"Gestione già eseguiti:{' Overwrite' if overwrite_or_skip == 'O' else ' Skip'}")
    print(f"DB target:            {_db_target_info()}")
    print("DB table target:      riskm_manager_model_evaluation.compliance_instance")
    print("Prompt base:          DB (inference_params.prompt1/clinical_pathway.prompt1)")
    print("Schema check:         DB (inference_params.json_schema1)")
    provider_cfg = _provider_for_model(model)
    provider_display = "NULL" if provider_cfg is None else json.dumps(provider_cfg, ensure_ascii=False)
    print(f"Provider:             {provider_display}")
    print(f"Runaway token cap:    {_runaway_token_limit_for_model(model)}")
    print(f"Retry OpenRouter:     {OPENROUTER_MAX_RETRIES} (base {OPENROUTER_RETRY_BASE_DELAY_SEC:.1f}s, max {OPENROUTER_RETRY_MAX_DELAY_SEC:.1f}s)")
    if not mode_gold:
        print(f"Giudice rationale:    {rationale_alignment_model}")
        print(f"Prompt giudice:       {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
        print("Riferimento GOLD:     riskm_manager_model_evaluation.gold_outcome (case_id, rule_id)")
    print(f"Reasoning effort:     {reasoning_effort}")
    print("Inizio elaborazione...\n")

    ok_count = 0
    ko_count = 0

    for db_rule in db_rules:
        rule_json = db_rule.body
        db_rule_id = db_rule.rule_id
        rule_name = str(rule_json.get("rule_id") or db_rule.name)
        rule_label = _format_rule_name_for_status(rule_name)
        line_open = False
        
        check_elapsed_sec: float | None = None
        check_cost_usd: float | None = None

        try:
            existing_tests_in_run = _count_existing_tests_for_run(
                conn,
                run_instance_id=run_instance_id,
                model_id=model_id,
                inference_params_id=inference_params_id,
                case_id=case_id,
                rule_id=db_rule_id,
            )
            if overwrite_or_skip == "S" and existing_tests_in_run > 0:
                print(
                    f"[SKIP] {rule_label} -> test gia presente nel Run {run_instance_id} "
                    f"({_format_run_datetime_for_ui(run_datetime)}), record trovati: {existing_tests_in_run}"
                )
                continue

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

            # DB Saving Preparation
            quality_score_total = None
            quality_score_rationale = None
            quality_score_classification = None

            instance_id, overwritten_rows = save_to_db(
                conn,
                run_instance_id,
                model_id,
                case_id,
                db_rule_id,
                inference_params_id,
                compliance_type_map,
                result_json,
                overwrite_existing_in_run=(overwrite_or_skip == "O"),
                check_elapsed_sec=check_elapsed_sec,
                check_cost_usd=check_cost_usd,
            )
            overwrite_info = f" | sovrascritti: {overwritten_rows}" if overwrite_or_skip == "O" else ""
            print(
                f"[OK ] {rule_label} | tempo: {check_elapsed_sec:.2f}s "
                f"| costo: {_format_inference_cost_usd(check_cost_usd)} "
                f"| compliance_instance_id: {instance_id}{overwrite_info}",
                end="",
                flush=True,
            )
            line_open = True

            gold_json = _load_gold_outcome_from_db(
                conn,
                case_id=case_id,
                rule_id=db_rule_id,
            )
            if gold_json is None:
                print(" | conformità vs GOLD: N/D (gold mancante su DB)")
                line_open = False
            else:
                rationale_mode = "inferenziale"
                try:
                    inferential_alignment = _call_openrouter_rationale_alignment(
                        api_key=api_key,
                        judge_model=rationale_alignment_model,
                        judge_prompt_text=rationale_prompt_text,
                        candidate=result_json,
                        gold=gold_json,
                    )
                except Exception:
                    inferential_alignment = _rationale_alignment_score_jaccard_0_10(result_json, gold_json)
                    rationale_mode = "fallback-lessicale"

                outcome_alignment = _outcome_alignment_score_0_10(result_json, gold_json)

                conformity = _conformity_score_0_10(
                    inferential_alignment_0_10=inferential_alignment,
                    outcome_alignment_0_10=outcome_alignment,
                )
                conformity_colored = _format_conformity_score_colored(conformity)

                quality_score_total = float(conformity)
                quality_score_rationale = float(inferential_alignment)
                quality_score_classification = float(outcome_alignment)

                update_quality_scores_in_db(
                    conn,
                    instance_id,
                    quality_score_total,
                    quality_score_rationale,
                    quality_score_classification,
                )

                print(
                    f" | conformità vs GOLD: {conformity_colored} "
                    f"| giudice rationale: {inferential_alignment}/10 ({rationale_mode}) "
                    f"| allineamento outcome: {outcome_alignment}/10"
                )
                line_open = False

            ok_count += 1

        except Exception as e:
            conn.rollback()
            if line_open:
                print(f" | errore: {e}")
            elif check_elapsed_sec is None:
                print(f"[KO ] {rule_label} -> errore: {e} | costo: {_format_inference_cost_usd(check_cost_usd)}")
            else:
                print(f"[KO ] {rule_label} -> errore: {e} | tempo check: {check_elapsed_sec:.2f}s | costo: {_format_inference_cost_usd(check_cost_usd)}")
            ko_count += 1

    print("\n=== Riepilogo ===")
    print(f"OK: {ok_count}")
    print(f"KO: {ko_count}")
    print(f"Salvataggio effettuato su Database (riskm_manager_model_evaluation.compliance_instance).")
    
    if conn:
        conn.close()
        
    return 0 if ko_count == 0 else 2

if __name__ == "__main__":
    raise SystemExit(main())
