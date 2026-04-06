#!/usr/bin/env python3
"""
Check batch regole STEMI con salvataggio su PostgreSQL (compliance_instance)
con routing router generalizzato da tabella model/router.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import socket
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from time import perf_counter, sleep
from urllib import error, parse, request

try:
    import psycopg2
    from psycopg2.extras import Json
except ImportError:
    print("Errore: la libreria psycopg2 non è installata. Eseguire: pip install psycopg2-binary")
    import sys
    sys.exit(1)

ROOT = Path(__file__).resolve().parent
RATIONALE_ALIGNMENT_PROMPT_PATH = ROOT / "SRS" / "PROMPT_RationaleAlignmentJudge.md"
RETROSPECTIVE_PROMPT_PATH = ROOT / "SRS" / "PROMPT_Retrospettiva.md"
RETROSPECTIVE_SCHEMA_PATH = ROOT / "SRS" / "retrospettiva_output.schema.json"
DEBUG_MARKDOWN_PATH = ROOT / "check_rules03_debug.md"

OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
OVHCLOUD_DEFAULT_BASE_URL = "https://oai.endpoints.kepler.ai.cloud.ovh.net"
OVHCLOUD_DEFAULT_CHAT_PATH = "/v1/chat/completions"
NEBIUS_DEFAULT_BASE_URL = "https://api.tokenfactory.nebius.com/v1"
DEFAULT_OPENROUTER_ROUTER_CODE = "OpenRouter"
DEFAULT_OVHCLOUD_ROUTER_CODE = "OVHCloud"
DEFAULT_NEBIUS_ROUTER_CODE = "NebiusTokenFactory"
DEFAULT_GOLD_MODEL = "anthropic/claude-opus-4.6"
DEFAULT_RATIONALE_ALIGNMENT_MODEL = "anthropic/claude-sonnet-4.6"
DEFAULT_RETROSPECTIVE_MODEL = "anthropic/claude-opus-4.6"
RETROSPECTIVE_TRIGGER_THRESHOLD = 7
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
ROUTER_REQUEST_TIMEOUT_SEC = _env_int("ROUTER_REQUEST_TIMEOUT_SEC", 240, minimum=30)
OVHCLOUD_REQUEST_TIMEOUT_SEC = _env_int("OVHCLOUD_REQUEST_TIMEOUT_SEC", 420, minimum=30)
DEFAULT_MAX_RUNAWAY_TOKENS = 50000

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

_OVH_PRICING_CACHE: dict[tuple[str, str], dict[str, float] | None] = {}

def _legacy_openrouter_provider_for_model(model: str) -> dict | None:
    m = (model or "").strip().lower()
    if "gpt-oss-120b" in m or "gpt-oss120b" in m:
        return {"order": ["baseten/fp4"], "allow_fallbacks": False}
    if m == "google/gemma-4-26b-a4b-it":
        return {"order": ["novita/bf16"], "allow_fallbacks": False}
    if m.startswith("google/gemini"):
        return {"order": ["google-vertex"], "allow_fallbacks": False}
    return None


def _request_timeout_seconds_for_router(router_code: str) -> int:
    router_norm = (router_code or "").strip().lower()
    if router_norm == DEFAULT_OVHCLOUD_ROUTER_CODE.lower():
        return OVHCLOUD_REQUEST_TIMEOUT_SEC
    return ROUTER_REQUEST_TIMEOUT_SEC

def _is_runaway_cap_hit(finish_reason: str | None) -> bool:
    if not finish_reason:
        return False
    fr = finish_reason.strip().lower()
    return (fr == "length") or (fr == "max_tokens") or ("length" in fr) or ("max_tokens" in fr)

class RuleCheckError(Exception):
    pass


@dataclass(frozen=True)
class ModelRoutingConfig:
    model_id: int | None
    model_code: str
    max_runaway_tokens: int
    router_code: str
    api_url: str
    api_key_env: str
    openrouter_provider: dict | None

    @property
    def is_openrouter(self) -> bool:
        return self.router_code.strip().lower() == DEFAULT_OPENROUTER_ROUTER_CODE.lower()


@dataclass(frozen=True)
class SelectedModel:
    model_id: int
    model_code: str
    routing: ModelRoutingConfig

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


@dataclass(frozen=True)
class CheckModelPostActionOptions:
    debug_gold_vs_model: bool
    suggest_prompt_improvement: bool


def _effective_runaway_token_limit(*, model: str, routing: ModelRoutingConfig | None = None) -> int | None:
    if routing is not None:
        value = int(routing.max_runaway_tokens)
        if value > 0:
            return value
    return DEFAULT_MAX_RUNAWAY_TOKENS


def _safe_string(value: object) -> str:
    if isinstance(value, str):
        return value.strip()
    return ""


def _normalize_chat_path(path: str | None) -> str:
    p = (path or "").strip()
    if not p:
        p = OVHCLOUD_DEFAULT_CHAT_PATH
    if not p.startswith("/"):
        p = "/" + p
    return p


def _build_ovh_chat_url(*, base_url: str, chat_path: str | None) -> str:
    base = base_url.strip() or OVHCLOUD_DEFAULT_BASE_URL
    return f"{base.rstrip('/')}{_normalize_chat_path(chat_path)}"


def _is_nebius_router(router_code: str) -> bool:
    router_norm = _safe_string(router_code).lower()
    return "nebius" in router_norm or "tokenfactory" in router_norm


def _default_api_key_env_for_router(router_code: str) -> str:
    router_norm = _safe_string(router_code).lower().replace("-", "_")
    if router_norm == DEFAULT_OVHCLOUD_ROUTER_CODE.lower():
        return "OVH_API_KEY"
    if _is_nebius_router(router_code):
        return "NEBIUS_API_KEY"
    return "OPENROUTER_API_KEY"


def _normalize_model_code_for_router(*, model_code: str, router_code: str) -> str:
    model_clean = _safe_string(model_code)
    if not model_clean:
        return model_clean
    if not _is_nebius_router(router_code):
        return model_clean
    if "/" in model_clean:
        return model_clean

    # Nebius TokenFactory expects provider/model naming for Qwen models.
    if model_clean.lower().startswith("qwen"):
        return f"Qwen/{model_clean}"

    return model_clean


def _normalize_router_api_url(*, api_url: str, router_code: str) -> str:
    raw_url = _safe_string(api_url)
    if not raw_url:
        return raw_url

    # Accept OpenAI-compatible base URLs (e.g. .../v1/) and normalize to chat/completions.
    raw_no_slash = raw_url.rstrip("/")
    if raw_no_slash.lower().endswith("/chat/completions"):
        return raw_no_slash

    try:
        parts = parse.urlsplit(raw_url)
    except Exception:
        return raw_url

    if not parts.scheme or not parts.netloc:
        return raw_url

    path = (parts.path or "").rstrip("/")
    path_norm = path.lower()

    if path_norm.endswith("/chat/completions"):
        new_path = path
    elif not path:
        new_path = "/v1/chat/completions"
    elif path_norm.endswith("/v1") or path_norm.endswith("/api/v1"):
        new_path = f"{path}/chat/completions"
    else:
        return raw_url

    return parse.urlunsplit((parts.scheme, parts.netloc, new_path, parts.query, parts.fragment))


def _json_object_or_none(value: object) -> dict | None:
    if isinstance(value, dict):
        return value
    if isinstance(value, str):
        txt = value.strip()
        if not txt:
            return None
        try:
            parsed = json.loads(txt)
        except json.JSONDecodeError:
            return None
        return parsed if isinstance(parsed, dict) else None
    return None


def _table_exists(conn, *, schema: str, table: str) -> bool:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = %s
              AND table_name = %s
            """,
            (schema, table),
        )
        return cur.fetchone() is not None


def _column_exists(conn, *, schema: str, table: str, column: str) -> bool:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = %s
              AND table_name = %s
              AND column_name = %s
            """,
            (schema, table, column),
        )
        return cur.fetchone() is not None


def _model_routing_from_db(conn, *, model_code: str) -> ModelRoutingConfig:
    model_code_clean = str(model_code or "").strip()
    if not model_code_clean:
        raise RuleCheckError("Modello vuoto: impossibile risolvere routing router.")

    schema = "riskm_manager_model_evaluation"
    has_model_router_col = _column_exists(conn, schema=schema, table="model", column="router_code")
    has_model_max_runaway_tokens_col = _column_exists(conn, schema=schema, table="model", column="max_runaway_tokens")
    has_router_table = _table_exists(conn, schema=schema, table="router")

    if has_model_router_col and has_router_table:
        max_runaway_select = "m.max_runaway_tokens" if has_model_max_runaway_tokens_col else "NULL::integer AS max_runaway_tokens"
        query = """
            SELECT m.model_id, m.code, m.providers, {max_runaway_select}, m.router_code, r.api_url, r.key_env_variable
            FROM riskm_manager_model_evaluation.model m
            LEFT JOIN riskm_manager_model_evaluation.router r
                ON r.code = m.router_code
            WHERE UPPER(m.code) = UPPER(%s)
            LIMIT 1
        """.format(max_runaway_select=max_runaway_select)
    elif has_model_router_col:
        max_runaway_select = "m.max_runaway_tokens" if has_model_max_runaway_tokens_col else "NULL::integer AS max_runaway_tokens"
        query = """
            SELECT m.model_id, m.code, m.providers, {max_runaway_select}, m.router_code, NULL::text AS api_url, NULL::text AS key_env_variable
            FROM riskm_manager_model_evaluation.model m
            WHERE UPPER(m.code) = UPPER(%s)
            LIMIT 1
        """.format(max_runaway_select=max_runaway_select)
    else:
        max_runaway_select = "m.max_runaway_tokens" if has_model_max_runaway_tokens_col else "NULL::integer AS max_runaway_tokens"
        query = """
            SELECT m.model_id, m.code, m.providers, {max_runaway_select}, NULL::text AS router_code, NULL::text AS api_url, NULL::text AS key_env_variable
            FROM riskm_manager_model_evaluation.model m
            WHERE UPPER(m.code) = UPPER(%s)
            LIMIT 1
        """.format(max_runaway_select=max_runaway_select)

    with conn.cursor() as cur:
        cur.execute(query, (model_code_clean,))
        row = cur.fetchone()

    if not row:
        return ModelRoutingConfig(
            model_id=None,
            model_code=model_code_clean,
            max_runaway_tokens=DEFAULT_MAX_RUNAWAY_TOKENS,
            router_code=DEFAULT_OPENROUTER_ROUTER_CODE,
            api_url=OPENROUTER_URL,
            api_key_env="OPENROUTER_API_KEY",
            openrouter_provider=_legacy_openrouter_provider_for_model(model_code_clean),
        )

    model_id = int(row[0])
    resolved_model_code = str(row[1]).strip()
    providers = _json_object_or_none(row[2])
    max_runaway_tokens_raw = row[3]
    max_runaway_tokens = _to_int(max_runaway_tokens_raw)
    if max_runaway_tokens is None or max_runaway_tokens <= 0:
        max_runaway_tokens = DEFAULT_MAX_RUNAWAY_TOKENS
    router_code = _safe_string(row[4])
    api_url = _safe_string(row[5])
    api_key_env = _safe_string(row[6])

    openrouter_provider = _legacy_openrouter_provider_for_model(resolved_model_code)
    if isinstance(providers, dict):
        if "order" in providers or "allow_fallbacks" in providers:
            openrouter_provider = providers
        provider_from_json = providers.get("openrouter_provider")
        if isinstance(provider_from_json, dict):
            openrouter_provider = provider_from_json

    # Backward compatibility: infer router from legacy providers.endpoint if router table/column not populated yet.
    if isinstance(providers, dict):
        endpoint_cfg_raw = providers.get("endpoint")
        endpoint_cfg = endpoint_cfg_raw if isinstance(endpoint_cfg_raw, dict) else {}
        endpoint_type_raw = endpoint_cfg_raw if isinstance(endpoint_cfg_raw, str) else endpoint_cfg.get("type")
        endpoint_type_norm = _safe_string(endpoint_type_raw).lower().replace("-", "_")
        model_override = _safe_string(endpoint_cfg.get("model_override")) or _safe_string(
            providers.get("model_override")
        )

        if endpoint_type_norm in {"ovh", "ovh_openai", "ovhcloud"}:
            if not router_code:
                router_code = DEFAULT_OVHCLOUD_ROUTER_CODE
            if not api_url:
                explicit_url = _safe_string(endpoint_cfg.get("url")) or _safe_string(providers.get("url"))
                base_url = (
                    _safe_string(endpoint_cfg.get("base_url"))
                    or _safe_string(providers.get("base_url"))
                    or OVHCLOUD_DEFAULT_BASE_URL
                )
                chat_path = _safe_string(endpoint_cfg.get("chat_completions_path")) or _safe_string(
                    providers.get("chat_completions_path")
                )
                api_url = explicit_url or _build_ovh_chat_url(base_url=base_url, chat_path=chat_path)
            if not api_key_env:
                api_key_env = (
                    _safe_string(endpoint_cfg.get("api_key_env"))
                    or _safe_string(providers.get("api_key_env"))
                    or "OVH_API_KEY"
                )
            openrouter_provider = None

        elif endpoint_type_norm in {"nebius", "tokenfactory", "nebius_tokenfactory", "nebius_openai"}:
            if not router_code:
                router_code = DEFAULT_NEBIUS_ROUTER_CODE
            if not api_url:
                api_url = (
                    _safe_string(endpoint_cfg.get("url"))
                    or _safe_string(providers.get("url"))
                    or _safe_string(endpoint_cfg.get("base_url"))
                    or _safe_string(providers.get("base_url"))
                    or NEBIUS_DEFAULT_BASE_URL
                )
            if not api_key_env:
                api_key_env = (
                    _safe_string(endpoint_cfg.get("api_key_env"))
                    or _safe_string(providers.get("api_key_env"))
                    or "NEBIUS_API_KEY"
                )
            if model_override:
                resolved_model_code = model_override
            openrouter_provider = None

        elif endpoint_type_norm in {"openrouter", "open_router"}:
            if not router_code:
                router_code = DEFAULT_OPENROUTER_ROUTER_CODE
            if not api_url:
                api_url = (
                    _safe_string(endpoint_cfg.get("url"))
                    or _safe_string(providers.get("url"))
                    or OPENROUTER_URL
                )
            if not api_key_env:
                api_key_env = (
                    _safe_string(endpoint_cfg.get("api_key_env"))
                    or _safe_string(providers.get("api_key_env"))
                    or "OPENROUTER_API_KEY"
                )

    if not router_code:
        router_code = DEFAULT_OPENROUTER_ROUTER_CODE

    if not api_url:
        router_norm = router_code.strip().lower()
        if router_norm == DEFAULT_OVHCLOUD_ROUTER_CODE.lower():
            api_url = _build_ovh_chat_url(base_url=OVHCLOUD_DEFAULT_BASE_URL, chat_path=OVHCLOUD_DEFAULT_CHAT_PATH)
        elif _is_nebius_router(router_code):
            api_url = NEBIUS_DEFAULT_BASE_URL
        else:
            api_url = OPENROUTER_URL

    if not api_key_env:
        api_key_env = _default_api_key_env_for_router(router_code)

    resolved_model_code = _normalize_model_code_for_router(model_code=resolved_model_code, router_code=router_code)
    api_url = _normalize_router_api_url(api_url=api_url, router_code=router_code)

    if router_code.strip().lower() != DEFAULT_OPENROUTER_ROUTER_CODE.lower():
        openrouter_provider = None

    return ModelRoutingConfig(
        model_id=model_id,
        model_code=resolved_model_code,
        max_runaway_tokens=max_runaway_tokens,
        router_code=router_code,
        api_url=api_url,
        api_key_env=api_key_env,
        openrouter_provider=openrouter_provider,
    )

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


def _to_int(value: object) -> int | None:
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    if isinstance(value, str):
        txt = value.strip()
        if not txt:
            return None
        try:
            return int(float(txt))
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


def _usage_tokens_from_body(body: dict) -> tuple[int | None, int | None]:
    usage_raw = body.get("usage")
    usage = usage_raw if isinstance(usage_raw, dict) else {}
    prompt_tokens = _to_int(usage.get("prompt_tokens")) or _to_int(usage.get("input_tokens"))
    completion_tokens = _to_int(usage.get("completion_tokens")) or _to_int(usage.get("output_tokens"))
    return prompt_tokens, completion_tokens


def _ovh_base_url_from_chat_api_url(api_url: str) -> str:
    url = (api_url or "").strip().rstrip("/")
    low = url.lower()
    markers = (
        "/v1/chat/completions",
        "/chat/completions",
        "/v1/completions",
        "/completions",
    )
    for marker in markers:
        if low.endswith(marker):
            return url[: -len(marker)]
    if low.endswith("/v1"):
        return url[:-3]
    return url


def _fetch_ovh_pricing(*, base_url: str, api_key: str, model: str) -> dict[str, float] | None:
    cache_key = (base_url, model)
    if cache_key in _OVH_PRICING_CACHE:
        return _OVH_PRICING_CACHE[cache_key]

    models_base = f"{base_url.rstrip('/')}/v1/models"

    def _fetch_models_data(*, verbose: bool) -> list[dict] | None:
        models_url = f"{models_base}?verbose=true" if verbose else models_base
        req = request.Request(
            models_url,
            data=None,
            method="GET",
            headers={
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json",
            },
        )
        try:
            with request.urlopen(req, timeout=60) as resp:
                raw = resp.read().decode("utf-8")
            body = json.loads(raw)
        except Exception:
            return None

        data = body.get("data") if isinstance(body, dict) else None
        if not isinstance(data, list):
            return None
        return [item for item in data if isinstance(item, dict)]

    data = _fetch_models_data(verbose=True) or _fetch_models_data(verbose=False)
    if not isinstance(data, list):
        _OVH_PRICING_CACHE[cache_key] = None
        return None

    model_norm = model.strip().lower()
    found: dict | None = None
    for item in data:
        item_id = str(item.get("id") or "").strip().lower()
        if item_id == model_norm:
            found = item
            break

    if not isinstance(found, dict):
        _OVH_PRICING_CACHE[cache_key] = None
        return None

    pricing_raw = found.get("pricing")
    pricing = pricing_raw if isinstance(pricing_raw, dict) else {}
    prompt_rate = _to_float(pricing.get("prompt"))
    completion_rate = _to_float(pricing.get("completion"))
    request_rate = _to_float(pricing.get("request"))

    if prompt_rate is None and completion_rate is None and request_rate is None:
        _OVH_PRICING_CACHE[cache_key] = None
        return None

    resolved = {
        "prompt": float(prompt_rate or 0.0),
        "completion": float(completion_rate or 0.0),
        "request": float(request_rate or 0.0),
    }
    _OVH_PRICING_CACHE[cache_key] = resolved
    return resolved


def _estimate_ovh_cost_usd(*, body: dict, api_url: str, api_key: str, model: str) -> float | None:
    prompt_tokens, completion_tokens = _usage_tokens_from_body(body)
    if prompt_tokens is None and completion_tokens is None:
        return None

    base_url = _ovh_base_url_from_chat_api_url(api_url)
    pricing = _fetch_ovh_pricing(base_url=base_url, api_key=api_key, model=model)
    if not isinstance(pricing, dict):
        return None

    estimated = (
        float(prompt_tokens or 0) * float(pricing.get("prompt", 0.0))
        + float(completion_tokens or 0) * float(pricing.get("completion", 0.0))
        + float(pricing.get("request", 0.0))
    )
    return max(0.0, estimated)

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

def _post_router_with_meta(*,
                           api_key: str,
                           payload: dict,
                           api_url: str,
                           router_code: str) -> tuple[str, str | None, float | None]:
    data = json.dumps(payload).encode("utf-8")
    model_name = str(payload.get("model", "")).strip() or "<unknown-model>"
    router_label = _safe_string(router_code) or DEFAULT_OPENROUTER_ROUTER_CODE
    is_openrouter = router_label.lower() == DEFAULT_OPENROUTER_ROUTER_CODE.lower()
    resolved_api_url = _normalize_router_api_url(api_url=api_url, router_code=router_label)
    request_timeout_sec = _request_timeout_seconds_for_router(router_label)
    retry_count = 0
    while True:
        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        }
        if is_openrouter:
            headers["HTTP-Referer"] = "https://local.stemi-rule-checker"
            headers["X-Title"] = "STEMI Rule Checker"

        req = request.Request(
            resolved_api_url,
            data=data,
            method="POST",
            headers=headers,
        )
        try:
            with request.urlopen(req, timeout=request_timeout_sec) as resp:
                header_cost_usd = _to_float(resp.headers.get("x-openrouter-cost")) if is_openrouter else None
                raw = resp.read().decode("utf-8")
            break
        except error.HTTPError as e:
            details = e.read().decode("utf-8", errors="replace")
            if _is_retryable_openrouter_http_error(status_code=e.code, details=details) and retry_count < OPENROUTER_MAX_RETRIES:
                wait_seconds = _retry_delay_seconds(retry_index=retry_count, retry_after_seconds=_retry_after_seconds_from_headers(getattr(e, "headers", None)))
                retry_count += 1
                print(
                    f"[WARN] {router_label} HTTP {e.code} su {model_name}: "
                    f"retry {retry_count}/{OPENROUTER_MAX_RETRIES} tra {wait_seconds:.1f}s."
                )
                sleep(wait_seconds)
                continue
            raise RuleCheckError(f"{router_label} HTTP {e.code}: {details}") from e
        except (error.URLError, TimeoutError, socket.timeout) as e:
            reason_raw = getattr(e, "reason", None)
            reason_txt = str(reason_raw if reason_raw is not None else e)
            timeout_like = isinstance(e, (TimeoutError, socket.timeout)) or ("timed out" in reason_txt.lower())
            if retry_count < OPENROUTER_MAX_RETRIES:
                wait_seconds = _retry_delay_seconds(retry_index=retry_count, retry_after_seconds=None)
                retry_count += 1
                if timeout_like:
                    print(
                        f"[WARN] Timeout {router_label} su {model_name} dopo {request_timeout_sec}s: "
                        f"retry {retry_count}/{OPENROUTER_MAX_RETRIES} tra {wait_seconds:.1f}s."
                    )
                else:
                    print(
                        f"[WARN] Errore rete {router_label} su {model_name}: "
                        f"retry {retry_count}/{OPENROUTER_MAX_RETRIES} tra {wait_seconds:.1f}s."
                    )
                sleep(wait_seconds)
                continue
            if timeout_like:
                raise RuleCheckError(
                    f"Timeout {router_label} dopo {request_timeout_sec}s su {model_name}: {reason_txt}"
                ) from e
            raise RuleCheckError(f"Errore chiamata {router_label}: {reason_txt}") from e
        except Exception as e:
            raise RuleCheckError(f"Errore chiamata {router_label}: {e}") from e

    try:
        body = json.loads(raw)
        choice0 = body["choices"][0]
        message = choice0.get("message") if isinstance(choice0, dict) else {}
        if not isinstance(message, dict):
            message = {}
        content = message.get("content")
        finish_reason = choice0.get("finish_reason")
        cost_usd = _extract_inference_cost_usd(body, header_cost_usd)
        if cost_usd is None and not is_openrouter:
            cost_usd = _estimate_ovh_cost_usd(
                body=body,
                api_url=resolved_api_url,
                api_key=api_key,
                model=model_name,
            )
    except Exception as e:
        raise RuleCheckError(f"Risposta {router_label} non valida: {raw}") from e

    if isinstance(content, list):
        content = "\n".join(
            str(block.get("text") or block.get("content") or "")
            for block in content
            if isinstance(block, dict)
        )

    if isinstance(content, dict):
        content = json.dumps(content, ensure_ascii=False)

    if not isinstance(content, str) or not content.strip():
        reasoning_content = _safe_string(message.get("reasoning_content"))
        if reasoning_content and _is_runaway_cap_hit(finish_reason):
            # The model exhausted max_tokens while still in internal reasoning stream.
            # Return a tiny placeholder so caller can trigger controlled retry on finish_reason=length.
            content = "{}"
        else:
            raise RuleCheckError("La risposta del modello non contiene JSON testuale.")

    return content, finish_reason, cost_usd


def _post_router(*, api_key: str, payload: dict, api_url: str, router_code: str) -> str:
    content, _, _ = _post_router_with_meta(
        api_key=api_key,
        payload=payload,
        api_url=api_url,
        router_code=router_code,
    )
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

def _choose_cases_from_db(conn, *, clinical_pathway_id: int, clinical_pathway_name: str) -> list[CaseSelection]:
    case_rows = _load_cases_for_pathway_from_db(conn, clinical_pathway_id=clinical_pathway_id)

    options: dict[int, str] = {}
    default_ids: list[int] = []

    print("\nCasi disponibili da DB (case_id -> identifier):")
    for case_row in case_rows:
        options[case_row.case_id] = case_row.identifier
        marker = ""
        if not default_ids:
            default_ids = [case_row.case_id]
            marker = " [default]"
        print(f"  {case_row.case_id:>3}) {case_row.identifier}{marker}")

    selected_case_ids = _prompt_select_multiple_db_ids(
        options,
        prompt=f"Seleziona uno o più case_id DB per pathway {clinical_pathway_name}",
        default_ids=default_ids,
        allow_all=True,
    )

    selected_ids = set(selected_case_ids)
    selected_cases = [case_row for case_row in case_rows if case_row.case_id in selected_ids]
    if not selected_cases:
        raise RuleCheckError("Nessun clinical_case selezionato.")
    return selected_cases

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
                                    selected_pathway_id: int) -> tuple[str, dict, str]:
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

    return base_prompt, check_schema, inference_prompt


def _load_retrospettiva_prompt_and_schema() -> tuple[str, dict]:
    if not RETROSPECTIVE_PROMPT_PATH.exists():
        raise RuleCheckError(f"Prompt retrospettiva non trovato: {RETROSPECTIVE_PROMPT_PATH}")
    if not RETROSPECTIVE_SCHEMA_PATH.exists():
        raise RuleCheckError(f"Schema retrospettiva non trovato: {RETROSPECTIVE_SCHEMA_PATH}")

    prompt_text = RETROSPECTIVE_PROMPT_PATH.read_text(encoding="utf-8").strip()
    if not prompt_text:
        raise RuleCheckError("Prompt retrospettiva vuoto.")

    try:
        schema_raw = json.loads(RETROSPECTIVE_SCHEMA_PATH.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"Schema retrospettiva non parsabile: {e}") from e

    schema = _coerce_json_object(
        schema_raw,
        context=f"retrospettiva schema ({RETROSPECTIVE_SCHEMA_PATH.name})",
    )
    return prompt_text, schema

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
        "- In supporting_documents includi almeno un documento clinico con: document_id (SEMPRE stringa, anche se numerico), rationale sintetico, confidence (0..1).\n"
        "- Il rationale di ogni documento deve essere coerente con il rationale generale dell'output.\n"
        "- Non confondere MAI l'orario di insorgenza dei sintomi con il First Medical Contact (FMC).\n"
        "- Se compare testo tipo 'dolore insorto alle ...', quello NON e' FMC.\n"
        "- Per i vincoli temporali basati su FMC usa solo evidenze di contatto sanitario (es. verbale 118, ECG pre-ospedaliero, triage).\n"
        "- Se il timestamp FMC e' ambiguo/non determinabile con certezza, preferisci 'not_evaluable' con confidence prudente.\n"
    )

def _call_router_check(*,
                       api_key: str,
                       routing: ModelRoutingConfig,
                       prompt_text: str,
                       check_schema: dict,
                       reasoning_effort: str) -> tuple[dict, float | None]:
    system_prompt = "Sei un valutatore clinico STEMI. Ricevi episodio + regola e devi produrre esclusivamente un JSON conforme allo schema di check fornito. Nessun testo extra."
    model = _normalize_model_code_for_router(model_code=routing.model_code, router_code=routing.router_code)
    schema_for_provider = _sanitize_json_schema_for_openrouter(check_schema) if routing.is_openrouter else check_schema
    provider_cfg = routing.openrouter_provider if routing.is_openrouter else None
    runaway_limit = _effective_runaway_token_limit(model=model, routing=routing)

    def _invoke_once(user_prompt_text: str, *, effort: str, temperature: float) -> tuple[str, str | None, float | None]:
        if routing.is_openrouter:
            payload = {
                "model": model, "temperature": temperature,
                "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt_text}],
                "response_format": {
                    "type": "json_schema",
                    "json_schema": {"name": "check_rule_output", "strict": True, "schema": schema_for_provider},
                },
            }
        else:
            user_prompt_with_schema = (
                f"{user_prompt_text}\n\n"
                "SCHEMA JSON DA RISPETTARE (OBBLIGATORIO):\n"
                f"{json.dumps(check_schema, ensure_ascii=False)}\n\n"
                "VINCOLO FINALE: restituisci direttamente il JSON finale, senza testo extra."
            )
            payload = {
                "model": model, "temperature": temperature,
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt_with_schema},
                ],
                "response_format": {"type": "json_object"},
            }
        if routing.is_openrouter:
            payload["reasoning"] = {"effort": effort}
        if provider_cfg is not None: payload["provider"] = provider_cfg
        if runaway_limit is not None: payload["max_tokens"] = runaway_limit
        try:
            return _post_router_with_meta(
                api_key=api_key,
                payload=payload,
                api_url=routing.api_url,
                router_code=routing.router_code,
            )
        except RuleCheckError as e:
            if "compiled grammar is too large" not in str(e).lower(): raise
            print(
                f"[WARN] {routing.router_code} schema troppo grande per {model}: "
                "fallback a response_format=json_object."
            )
            fallback_payload = {
                "model": model, "temperature": temperature,
                "messages": [
                    {"role": "system", "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente."},
                    {"role": "user", "content": (f"{user_prompt_text}\n\nSCHEMA JSON DA RISPETTARE:\n{json.dumps(check_schema, ensure_ascii=False)}")},
                ],
                "response_format": {"type": "json_object"},
            }
            if routing.is_openrouter:
                fallback_payload["reasoning"] = {"effort": effort}
            if provider_cfg is not None: fallback_payload["provider"] = provider_cfg
            if runaway_limit is not None: fallback_payload["max_tokens"] = runaway_limit
            return _post_router_with_meta(
                api_key=api_key,
                payload=fallback_payload,
                api_url=routing.api_url,
                router_code=routing.router_code,
            )

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

    initial_temperature = 0.1 if routing.is_openrouter else 0.0
    content, finish_reason, call_cost_usd = _invoke_once(prompt_text, effort=reasoning_effort, temperature=initial_temperature)
    _register_cost(call_cost_usd)

    if _is_runaway_cap_hit(finish_reason):
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
        normalized = _normalize_check_output_for_validation(json.loads(cleaned))
        check_cost_usd = total_cost_usd if (call_count > 0 and all_costs_known) else None
        return normalized, check_cost_usd
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

def _call_router_rationale_alignment(*,
                                     api_key: str,
                                     routing: ModelRoutingConfig,
                                     judge_prompt_text: str,
                                     candidate: dict,
                                     gold: dict) -> int:
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

    judge_model = _normalize_model_code_for_router(model_code=routing.model_code, router_code=routing.router_code)
    schema_for_provider = _sanitize_json_schema_for_openrouter(schema) if routing.is_openrouter else schema
    provider_cfg = routing.openrouter_provider if routing.is_openrouter else None
    payload = {
        "model": judge_model, "temperature": 0.0,
        "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt}],
        "response_format": {"type": "json_schema", "json_schema": {"name": "rationale_alignment", "strict": True, "schema": schema_for_provider}},
    }
    if routing.is_openrouter:
        payload["reasoning"] = {"effort": "medium"}
    if provider_cfg is not None: payload["provider"] = provider_cfg

    try:
        content = _post_router(
            api_key=api_key,
            payload=payload,
            api_url=routing.api_url,
            router_code=routing.router_code,
        )
    except RuleCheckError as e:
        if "compiled grammar is too large" not in str(e).lower(): raise
        print(
            f"[WARN] {routing.router_code} schema giudice troppo grande per {judge_model}: "
            "fallback a response_format=json_object."
        )
        fallback_payload = {
            "model": judge_model, "temperature": 0.0,
            "messages": [
                {"role": "system", "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente."},
                {"role": "user", "content": f"{user_prompt}\n\nSCHEMA JSON DA RISPETTARE:\n{json.dumps(schema, ensure_ascii=False)}"},
            ],
            "response_format": {"type": "json_object"},
        }
        if routing.is_openrouter:
            fallback_payload["reasoning"] = {"effort": "medium"}
        if provider_cfg is not None: fallback_payload["provider"] = provider_cfg
        content = _post_router(
            api_key=api_key,
            payload=fallback_payload,
            api_url=routing.api_url,
            router_code=routing.router_code,
        )

    cleaned = _strip_markdown_fences(content)
    try:
        alignment_json = json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON giudice rationale non parsabile: {e}. Estratto: {cleaned[:700]}") from e

    raw_score = alignment_json.get("alignment_score_0_10")
    if not isinstance(raw_score, (int, float)): raise RuleCheckError("Risposta giudice rationale senza alignment_score_0_10 numerico.")
    return _clip_0_10(float(raw_score))


def _normalize_retrospettiva_winner(value: object) -> str:
    winner = str(value or "").strip().upper()
    if winner not in {"GOLD", "CHECK", "NONE"}:
        raise RuleCheckError(f"Winner retrospettiva non valido: {value}")
    return winner


def _retrospettiva_suggestion_text(value: object) -> str:
    if isinstance(value, str):
        return value.strip()
    if isinstance(value, list):
        lines: list[str] = []
        for item in value:
            txt = str(item or "").strip()
            if txt:
                lines.append(txt)
        return "\n".join(lines).strip()
    return ""


def _call_router_retrospettiva(*,
                               api_key: str,
                               routing: ModelRoutingConfig,
                               retrospective_prompt_text: str,
                               retrospective_schema: dict,
                               retrospective_payload: dict) -> tuple[str, str]:
    system_prompt = (retrospective_prompt_text or "").strip()
    if not system_prompt:
        raise RuleCheckError("Prompt retrospettiva vuoto.")

    retrospective_model = _normalize_model_code_for_router(
        model_code=routing.model_code,
        router_code=routing.router_code,
    )
    schema_for_provider = (
        _sanitize_json_schema_for_openrouter(retrospective_schema)
        if routing.is_openrouter
        else retrospective_schema
    )
    provider_cfg = routing.openrouter_provider if routing.is_openrouter else None
    runaway_limit = _effective_runaway_token_limit(model=retrospective_model, routing=routing)

    user_prompt = (
        "Esegui una retrospettiva del check clinico e proponi miglioramenti al prompt di verifica.\n"
        "Restituisci solo JSON conforme allo schema richiesto.\n\n"
        "INPUT RETROSPETTIVA:\n"
        f"{json.dumps(retrospective_payload, ensure_ascii=False)}"
    )

    payload = {
        "model": retrospective_model,
        "temperature": 0.0,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        "response_format": {
            "type": "json_schema",
            "json_schema": {
                "name": "retrospettiva_output",
                "strict": True,
                "schema": schema_for_provider,
            },
        },
    }
    if routing.is_openrouter:
        payload["reasoning"] = {"effort": "high"}
    if provider_cfg is not None:
        payload["provider"] = provider_cfg
    if runaway_limit is not None:
        payload["max_tokens"] = runaway_limit

    try:
        content = _post_router(
            api_key=api_key,
            payload=payload,
            api_url=routing.api_url,
            router_code=routing.router_code,
        )
    except RuleCheckError as e:
        if "compiled grammar is too large" not in str(e).lower():
            raise
        print(
            f"[WARN] {routing.router_code} schema retrospettiva troppo grande per {retrospective_model}: "
            "fallback a response_format=json_object."
        )
        fallback_payload = {
            "model": retrospective_model,
            "temperature": 0.0,
            "messages": [
                {
                    "role": "system",
                    "content": system_prompt + " Segui rigorosamente lo schema JSON allegato nel prompt utente.",
                },
                {
                    "role": "user",
                    "content": (
                        f"{user_prompt}\n\n"
                        "SCHEMA JSON DA RISPETTARE:\n"
                        f"{json.dumps(retrospective_schema, ensure_ascii=False)}"
                    ),
                },
            ],
            "response_format": {"type": "json_object"},
        }
        if routing.is_openrouter:
            fallback_payload["reasoning"] = {"effort": "high"}
        if provider_cfg is not None:
            fallback_payload["provider"] = provider_cfg
        if runaway_limit is not None:
            fallback_payload["max_tokens"] = runaway_limit
        content = _post_router(
            api_key=api_key,
            payload=fallback_payload,
            api_url=routing.api_url,
            router_code=routing.router_code,
        )

    cleaned = _strip_markdown_fences(content)
    try:
        retrospective_json = json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise RuleCheckError(f"JSON retrospettiva non parsabile: {e}. Estratto: {cleaned[:700]}") from e

    if not isinstance(retrospective_json, dict):
        raise RuleCheckError("Output retrospettiva non valido: atteso oggetto JSON.")

    winner = _normalize_retrospettiva_winner(retrospective_json.get("winner"))
    suggestion = _retrospettiva_suggestion_text(retrospective_json.get("suggestion"))
    if not suggestion:
        suggestion = _retrospettiva_suggestion_text(retrospective_json.get("suggestions"))
    if not suggestion:
        raise RuleCheckError("Output retrospettiva senza campo suggestion valorizzato.")

    return winner, suggestion

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

def _parse_db_id_selection(raw: str, options: dict[int, str]) -> list[int] | None:
    tokens = [token.strip() for token in raw.split(",") if token.strip()]
    if not tokens:
        return []

    selected: set[int] = set()
    for token in tokens:
        if "-" in token:
            bounds = [part.strip() for part in token.split("-", 1)]
            if len(bounds) != 2 or not bounds[0].isdigit() or not bounds[1].isdigit():
                return None
            start, end = int(bounds[0]), int(bounds[1])
            if start > end:
                start, end = end, start
            for value in range(start, end + 1):
                if value not in options:
                    return None
                selected.add(value)
            continue

        if not token.isdigit():
            return None
        value = int(token)
        if value not in options:
            return None
        selected.add(value)

    return sorted(selected)

def _prompt_select_multiple_db_ids(options: dict[int, str], *, prompt: str,
                                   default_ids: list[int] | None = None,
                                   allow_all: bool = True) -> list[int]:
    if not options:
        raise RuleCheckError("Nessuna opzione disponibile nel DB.")

    default_ids_clean = sorted({item for item in (default_ids or []) if item in options})
    all_ids_sorted = sorted(options.keys())

    while True:
        full_prompt = prompt
        if allow_all:
            full_prompt += " [A=all]"
        if default_ids_clean:
            full_prompt += f" (default {','.join(str(item) for item in default_ids_clean)})"
        full_prompt += ": "

        raw = input(full_prompt).strip()
        if not raw:
            if default_ids_clean:
                return default_ids_clean
            print("Selezione non valida. Inserire almeno un ID.")
            continue

        if allow_all and raw.upper() in {"A", "ALL", "*"}:
            return all_ids_sorted

        parsed = _parse_db_id_selection(raw, options)
        if parsed:
            return parsed

        print("Selezione non valida. Usa ID singoli/multipli (es. 1,3,7 o 2-5).")

def _choose_models_from_db(conn, *, mode_gold: bool) -> list[SelectedModel]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT model_id, code
            FROM riskm_manager_model_evaluation.model
            ORDER BY LOWER(code), model_id
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
                routing = _model_routing_from_db(conn, model_code=code)
                print(
                    "\nModalita GOLD: modello fissato hard a "
                    f"{code} (model_id DB {model_id})."
                )
                return [
                    SelectedModel(
                        model_id=model_id,
                        model_code=code,
                        routing=routing,
                    )
                ]

        raise RuleCheckError(
            "Modalita GOLD: il modello hard richiesto non esiste in tabella model: "
            f"{DEFAULT_GOLD_MODEL}. Inserirlo prima di procedere."
        )

    default_code = (os.getenv("OPENROUTER_MODEL") or "").strip().lower()
    options: dict[int, str] = {}
    routing_by_model_id: dict[int, ModelRoutingConfig] = {}
    default_ids: list[int] = []

    print("\nModelli disponibili da DB (model_id -> code -> router):")
    for model_id_raw, code_raw in rows:
        model_id = int(model_id_raw)
        code = str(code_raw).strip()
        routing = _model_routing_from_db(conn, model_code=code)
        options[model_id] = code
        routing_by_model_id[model_id] = routing
        marker = ""
        if default_code and code.lower() == default_code:
            default_ids = [model_id]
            marker = " [default env OPENROUTER_MODEL]"
        print(f"  {model_id:>3}) {code} | router: {routing.router_code}{marker}")

    selected_ids = _prompt_select_multiple_db_ids(
        options,
        prompt="Seleziona uno o più model_id DB (es. 2,5,9 o 2-4)",
        default_ids=default_ids,
        allow_all=True,
    )
    selected_models = [
        SelectedModel(
            model_id=model_id,
            model_code=options[model_id],
            routing=routing_by_model_id[model_id],
        )
        for model_id in selected_ids
    ]
    selected_models.sort(key=lambda item: (item.model_code.lower(), item.model_id))
    return selected_models

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


def _choose_check_model_post_actions() -> CheckModelPostActionOptions:
    print("\nUltima domanda del flusso Check model:")
    print("  1) Nessuna azione extra")
    print("  2) Debug, comparazione GOLD versus modello")
    print("  3) Suggest Prompt Improvement")
    print("  4) Debug + Suggest Prompt Improvement")

    while True:
        choice = input("Seleziona opzione [1/2/3/4] (default 1): ").strip() or "1"
        if choice == "1":
            return CheckModelPostActionOptions(debug_gold_vs_model=False, suggest_prompt_improvement=False)
        if choice == "2":
            return CheckModelPostActionOptions(debug_gold_vs_model=True, suggest_prompt_improvement=False)
        if choice == "3":
            return CheckModelPostActionOptions(debug_gold_vs_model=False, suggest_prompt_improvement=True)
        if choice == "4":
            return CheckModelPostActionOptions(debug_gold_vs_model=True, suggest_prompt_improvement=True)
        print("Selezione non valida. Inserire 1, 2, 3 o 4.")


def _next_debug_entry_index(debug_path: Path) -> int:
    if not debug_path.exists():
        return 1
    try:
        content = debug_path.read_text(encoding="utf-8")
    except Exception:
        return 1
    matches = re.findall(r"^## Debug Entry (\d+)\\b", content, flags=re.MULTILINE)
    if not matches:
        return 1
    return max(int(match) for match in matches) + 1


def _ensure_debug_markdown_file(debug_path: Path) -> int:
    next_index = _next_debug_entry_index(debug_path)
    if debug_path.exists() and debug_path.stat().st_size > 0:
        return next_index

    created_at = datetime.now(UTC).isoformat()
    header = (
        "# check_rules03 debug log\n\n"
        f"Creato UTC: {created_at}\n\n"
        "Log append-only con confronto progressivo tra output modello e GOLD.\n\n"
    )
    debug_path.write_text(header, encoding="utf-8")
    return next_index


def _append_debug_gold_vs_model_markdown(*,
                                         debug_path: Path,
                                         entry_index: int,
                                         run_instance_id: int,
                                         inference_params_id: int,
                                         rule_id: int,
                                         rule_name: str,
                                         case_id: int,
                                         case_identifier: str,
                                         model_id: int,
                                         model_code: str,
                                         router_code: str,
                                         compliance_instance_id: int,
                                         candidate_json: dict,
                                         gold_json: dict | None,
                                         check_elapsed_sec: float | None,
                                         check_cost_usd: float | None,
                                         rationale_alignment: int | None,
                                         outcome_alignment: int | None,
                                         conformity: int | None,
                                         rationale_mode: str | None) -> None:
    timestamp_utc = datetime.now(UTC).isoformat()
    candidate_outcome = candidate_json.get("outcome") if isinstance(candidate_json, dict) else None
    gold_outcome = gold_json.get("outcome") if isinstance(gold_json, dict) else None

    rationale_alignment_txt = "N/D" if rationale_alignment is None else f"{rationale_alignment}/10"
    outcome_alignment_txt = "N/D" if outcome_alignment is None else f"{outcome_alignment}/10"
    conformity_txt = "N/D" if conformity is None else f"{conformity}/10"
    rationale_mode_txt = rationale_mode or "N/D"
    check_time_txt = "N/D" if check_elapsed_sec is None else f"{check_elapsed_sec:.2f}s"
    cost_txt = _format_inference_cost_usd(check_cost_usd)

    candidate_pretty = json.dumps(candidate_json, ensure_ascii=False, indent=2)
    if isinstance(gold_json, dict):
        gold_pretty = json.dumps(gold_json, ensure_ascii=False, indent=2)
    else:
        gold_pretty = "null"

    entry = (
        f"## Debug Entry {entry_index}\n\n"
        f"- timestamp_utc: {timestamp_utc}\n"
        f"- run_instance_id: {run_instance_id}\n"
        f"- inference_params_id: {inference_params_id}\n"
        f"- compliance_instance_id: {compliance_instance_id}\n"
        f"- rule_id: {rule_id}\n"
        f"- rule_name: {rule_name}\n"
        f"- case_id: {case_id}\n"
        f"- case_identifier: {case_identifier}\n"
        f"- model_id: {model_id}\n"
        f"- model_code: {model_code}\n"
        f"- router_code: {router_code}\n"
        f"- outcome_modello: {candidate_outcome}\n"
        f"- outcome_gold: {gold_outcome}\n"
        f"- conformity_vs_gold: {conformity_txt}\n"
        f"- rationale_alignment: {rationale_alignment_txt} ({rationale_mode_txt})\n"
        f"- outcome_alignment: {outcome_alignment_txt}\n"
        f"- check_time: {check_time_txt}\n"
        f"- estimated_cost: {cost_txt}\n\n"
        "### JSON modello\n\n"
        "```json\n"
        f"{candidate_pretty}\n"
        "```\n\n"
        "### JSON gold\n\n"
        "```json\n"
        f"{gold_pretty}\n"
        "```\n\n"
    )

    with debug_path.open("a", encoding="utf-8") as f:
        f.write(entry)

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


def _ensure_compliance_instance_retro_columns(conn) -> None:
    missing: list[str] = []
    for column_name in ("winner", "suggestion"):
        if not _column_exists(
            conn,
            schema="riskm_manager_model_evaluation",
            table="compliance_instance",
            column=column_name,
        ):
            missing.append(column_name)

    if missing:
        missing_csv = ", ".join(missing)
        raise RuleCheckError(
            "Colonne DB mancanti in riskm_manager_model_evaluation.compliance_instance: "
            f"{missing_csv}. Applicare prima il DDL di alter table per winner/suggestion."
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

def _run_gold_outcome_backfill(conn, *, selected_model: SelectedModel) -> int:
    _ensure_gold_outcome_schema(conn)

    model_id = selected_model.model_id
    model = selected_model.model_code
    routing = selected_model.routing
    api_key = (os.getenv(routing.api_key_env) or "").strip()
    if not api_key:
        raise RuleCheckError(
            f"Variabile ambiente {routing.api_key_env} non impostata "
            f"(router {routing.router_code}, modello {model})."
        )

    selected_pathway_id, selected_pathway_name = _choose_clinical_pathway_from_db(conn)
    inference_params_id, inference_params_name = _choose_inference_params_for_gold_auto(
        conn,
        clinical_pathway_id=selected_pathway_id,
    )
    base_prompt, check_schema, _ = _load_prompt_and_schema_from_db(
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
    provider_cfg = routing.openrouter_provider if routing.is_openrouter else None
    provider_display = "NULL" if provider_cfg is None else json.dumps(provider_cfg, ensure_ascii=False)
    print(f"Router:               {routing.router_code}")
    print(f"Router API URL:       {routing.api_url}")
    print(f"Router key env:       {routing.api_key_env}")
    print(f"Provider OpenRouter:  {provider_display}")
    print(f"Runaway token cap:    {_effective_runaway_token_limit(model=model, routing=routing)}")
    print(
        f"Retry Router API:     {OPENROUTER_MAX_RETRIES} "
        f"(base {OPENROUTER_RETRY_BASE_DELAY_SEC:.1f}s, max {OPENROUTER_RETRY_MAX_DELAY_SEC:.1f}s)"
    )
    print(f"Request timeout:      {_request_timeout_seconds_for_router(routing.router_code)}s")
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
                    result_json, check_cost_usd = _call_router_check(
                        api_key=api_key,
                        routing=routing,
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


def update_retrospettiva_result_in_db(conn,
                                      compliance_instance_id: int,
                                      winner: str,
                                      suggestion: str) -> None:
    winner_norm = _normalize_retrospettiva_winner(winner)
    suggestion_text = str(suggestion or "").strip()
    if not suggestion_text:
        raise RuleCheckError("Suggestion retrospettiva vuota: update DB annullato.")

    with conn.cursor() as cursor:
        cursor.execute(
            """
            UPDATE riskm_manager_model_evaluation.compliance_instance
            SET winner = %s,
                suggestion = %s
            WHERE compliance_instance_id = %s
            """,
            (winner_norm, suggestion_text, compliance_instance_id),
        )
        if cursor.rowcount != 1:
            raise RuleCheckError(
                f"Update retrospettiva non riuscito per compliance_instance_id={compliance_instance_id}."
            )

    conn.commit()
    

def main() -> int:
    print("=== Check batch regole STEMI con routing router da DB (DB Save) ===")

    try:
        conn = get_db_connection()
    except Exception as e:
        print(f"Errore connessione DB: {e}")
        return 1

    try:
        mode_gold = _mode_is_gold()
        selected_models = _choose_models_from_db(conn, mode_gold=mode_gold)
    except RuleCheckError as e:
        print(f"Errore modalità/modello: {e}")
        conn.close()
        return 1

    if mode_gold:
        selected_model = selected_models[0]
        try:
            return _run_gold_outcome_backfill(
                conn,
                selected_model=selected_model,
            )
        finally:
            conn.close()

    model_api_keys: dict[int, str] = {}
    rationale_alignment_routing: ModelRoutingConfig | None = None
    rationale_alignment_api_key: str = ""
    debug_gold_vs_model = False
    suggest_prompt_improvement = False
    debug_entry_index = 1
    debug_entries_written = 0
    retrospective_prompt_text = ""
    retrospective_schema: dict = {}
    retrospective_model = DEFAULT_RETROSPECTIVE_MODEL
    retrospective_routing: ModelRoutingConfig | None = None
    retrospective_api_key: str = ""
    selected_inference_prompt = ""

    try:
        rationale_alignment_model = os.getenv("OPENROUTER_ALIGNMENT_MODEL", DEFAULT_RATIONALE_ALIGNMENT_MODEL)
        rationale_alignment_routing = _model_routing_from_db(conn, model_code=rationale_alignment_model)
        rationale_alignment_api_key = (os.getenv(rationale_alignment_routing.api_key_env) or "").strip()
        if not rationale_alignment_api_key:
            raise RuleCheckError(
                f"Variabile ambiente {rationale_alignment_routing.api_key_env} non impostata "
                f"per giudice rationale {rationale_alignment_routing.model_code} "
                f"(router {rationale_alignment_routing.router_code})."
            )

        for selected_model in selected_models:
            api_key = (os.getenv(selected_model.routing.api_key_env) or "").strip()
            if not api_key:
                raise RuleCheckError(
                    f"Variabile ambiente {selected_model.routing.api_key_env} non impostata "
                    f"per modello {selected_model.model_code} "
                    f"(router {selected_model.routing.router_code})."
                )
            model_api_keys[selected_model.model_id] = api_key

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

    if rationale_alignment_routing is None:
        print("Errore setup comparazione: routing del giudice rationale non risolto.")
        conn.close()
        return 1

    if not mode_gold and not RATIONALE_ALIGNMENT_PROMPT_PATH.exists():
        print(f"Errore: prompt giudice rationale non trovato: {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
        conn.close()
        return 1

    try:
        selected_pathway_id, selected_pathway_name = _choose_clinical_pathway_from_db(conn)
        case_selections = _choose_cases_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
            clinical_pathway_name=selected_pathway_name,
        )
        inference_params_id, inference_params_name = _choose_inference_params_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
        )
        base_prompt, check_schema, selected_inference_prompt = _load_prompt_and_schema_from_db(
            conn,
            inference_params_id=inference_params_id,
            selected_pathway_id=selected_pathway_id,
        )
        db_rules = _load_rules_for_pathway_from_db(
            conn,
            clinical_pathway_id=selected_pathway_id,
        )
        inference_pathway_id, inference_pathway_name = _get_inference_params_pathway(conn, inference_params_id)
        for case_selection in case_selections:
            case_pathway_id, case_pathway_name = _get_case_pathway(conn, case_selection.case_id)
            _assert_case_inference_pathway_compatibility(
                case_id=case_selection.case_id,
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
        rationale_prompt_text = ""
        if not mode_gold:
            rationale_prompt_text = RATIONALE_ALIGNMENT_PROMPT_PATH.read_text(encoding="utf-8").strip()
            if not rationale_prompt_text:
                raise RuleCheckError("Il prompt del giudice rationale e' vuoto.")
    except Exception as e:
        print(f"Errore inizializzazione: {e}")
        conn.close()
        return 1

    # Ultima domanda del ramo "check model": opzioni debug e suggest improvement.
    try:
        post_actions = _choose_check_model_post_actions()
        debug_gold_vs_model = post_actions.debug_gold_vs_model
        suggest_prompt_improvement = post_actions.suggest_prompt_improvement

        if debug_gold_vs_model:
            debug_entry_index = _ensure_debug_markdown_file(DEBUG_MARKDOWN_PATH)

        if suggest_prompt_improvement:
            _ensure_compliance_instance_retro_columns(conn)
            if not selected_inference_prompt:
                raise RuleCheckError(
                    "Suggest Prompt Improvement richiede inference_params.prompt1 valorizzato "
                    "(senza fallback su clinical_pathway.prompt1)."
                )
            retrospective_prompt_text, retrospective_schema = _load_retrospettiva_prompt_and_schema()
            retrospective_model = DEFAULT_RETROSPECTIVE_MODEL
            retrospective_routing = _model_routing_from_db(conn, model_code=retrospective_model)
            retrospective_api_key = (os.getenv(retrospective_routing.api_key_env) or "").strip()
            if not retrospective_api_key:
                raise RuleCheckError(
                    f"Variabile ambiente {retrospective_routing.api_key_env} non impostata "
                    f"per retrospettiva {retrospective_routing.model_code} "
                    f"(router {retrospective_routing.router_code})."
                )
    except Exception as e:
        print(f"Errore setup post-actions: {e}")
        conn.close()
        return 1

    total_combinations = len(db_rules) * len(case_selections) * len(selected_models)

    print(f"\nCasi selezionati:     {len(case_selections)}")
    for case_selection in case_selections:
        print(f"  {case_selection.case_id:>3}) {case_selection.identifier}")
    print(f"Numero regole:        {len(db_rules)}")
    print(f"Modalità:             {'GOLD' if mode_gold else 'COMPARAZIONE'}")
    print(f"Modelli selezionati:  {len(selected_models)} (ordine alfabetico)")
    for selected_model in selected_models:
        selected_provider_cfg = selected_model.routing.openrouter_provider if selected_model.routing.is_openrouter else None
        selected_provider_display = "NULL" if selected_provider_cfg is None else json.dumps(selected_provider_cfg, ensure_ascii=False)
        print(
            f"  {selected_model.model_id:>3}) {selected_model.model_code} "
            f"| router: {selected_model.routing.router_code} "
            f"| api_url: {selected_model.routing.api_url} "
            f"| key_env: {selected_model.routing.api_key_env} "
            f"| provider_openrouter: {selected_provider_display} "
            f"| runaway token cap: {_effective_runaway_token_limit(model=selected_model.model_code, routing=selected_model.routing)} "
            f"| timeout: {_request_timeout_seconds_for_router(selected_model.routing.router_code)}s"
        )
    print(f"Clinical pathway DB:  {selected_pathway_id} ({selected_pathway_name})")
    print(f"Inference params DB:  {inference_params_id} ({inference_params_name})")
    print(f"Run DB:               {run_instance_id} ({_format_run_datetime_for_ui(run_datetime)})")
    print(f"Gestione già eseguiti:{' Overwrite' if overwrite_or_skip == 'O' else ' Skip'}")
    print(f"DB target:            {_db_target_info()}")
    print("DB table target:      riskm_manager_model_evaluation.compliance_instance")
    print("Prompt base:          DB (inference_params.prompt1/clinical_pathway.prompt1)")
    print("Schema check:         DB (inference_params.json_schema1)")
    print(f"Combinazioni totali:  {total_combinations} (regole x case x modelli)")
    print(
        f"Retry Router API:     {OPENROUTER_MAX_RETRIES} "
        f"(base {OPENROUTER_RETRY_BASE_DELAY_SEC:.1f}s, max {OPENROUTER_RETRY_MAX_DELAY_SEC:.1f}s)"
    )
    print(
        f"Timeout default:      {ROUTER_REQUEST_TIMEOUT_SEC}s "
        f"| OVHCloud: {OVHCLOUD_REQUEST_TIMEOUT_SEC}s"
    )
    if not mode_gold:
        print(
            f"Giudice rationale:    {rationale_alignment_model} "
            f"(router: {rationale_alignment_routing.router_code}, key_env: {rationale_alignment_routing.api_key_env})"
        )
        print(f"Prompt giudice:       {RATIONALE_ALIGNMENT_PROMPT_PATH.name}")
        print("Riferimento GOLD:     riskm_manager_model_evaluation.gold_outcome (case_id, rule_id)")
        print(f"Debug gold vs model:  {'SI' if debug_gold_vs_model else 'NO'}")
        if debug_gold_vs_model:
            print(
                f"Debug markdown:       {DEBUG_MARKDOWN_PATH.name} "
                f"(append progressivo da entry {debug_entry_index})"
            )
        print(f"Suggest improvement:  {'SI' if suggest_prompt_improvement else 'NO'}")
        if suggest_prompt_improvement and retrospective_routing is not None:
            print(
                f"Retrospettiva model:  {retrospective_model} "
                f"(router: {retrospective_routing.router_code}, key_env: {retrospective_routing.api_key_env})"
            )
            print(
                "Prompt check retro:   check_prompt=inference_params.prompt1 "
                "(singolo, no fallback)"
            )
            print(f"Lunghezza check_prompt: {len(selected_inference_prompt)} chars")
            print(f"Prompt retrospettiva: {RETROSPECTIVE_PROMPT_PATH.name}")
            print(f"Schema retrospettiva: {RETROSPECTIVE_SCHEMA_PATH.name}")
            print(f"Trigger retrospettiva: conformita' < {RETROSPECTIVE_TRIGGER_THRESHOLD}")
    print(f"Reasoning effort:     {reasoning_effort}")
    print("Inizio elaborazione...\n")

    ok_count = 0
    ko_count = 0
    skip_count = 0
    retrospective_invoked_count = 0
    retrospective_saved_count = 0
    retrospective_ko_count = 0

    for db_rule in db_rules:
        rule_json = db_rule.body
        db_rule_id = db_rule.rule_id
        rule_name = str(rule_json.get("rule_id") or db_rule.name)
        rule_label = _format_rule_name_for_status(rule_name)
        for case_selection in case_selections:
            case_id = case_selection.case_id
            case_identifier = case_selection.identifier
            episode_json = case_selection.body

            for selected_model in selected_models:
                model_id = selected_model.model_id
                model = selected_model.model_code
                routing = selected_model.routing
                model_api_key = model_api_keys[model_id]
                line_open = False
                check_elapsed_sec: float | None = None
                check_cost_usd: float | None = None
                execution_label = (
                    f"{rule_label} | case_id={case_id} ({case_identifier}) "
                    f"| model_id={model_id} ({model}) | router={routing.router_code}"
                )

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
                            f"[SKIP] {execution_label} -> test gia presente nel Run {run_instance_id} "
                            f"({_format_run_datetime_for_ui(run_datetime)}), record trovati: {existing_tests_in_run}"
                        )
                        skip_count += 1
                        continue

                    prompt_text = _build_prompt(base_prompt=base_prompt, episode=episode_json, rule=rule_json)

                    check_started = perf_counter()
                    try:
                        result_json, check_cost_usd = _call_router_check(
                            api_key=model_api_key,
                            routing=routing,
                            prompt_text=prompt_text,
                            check_schema=check_schema,
                            reasoning_effort=reasoning_effort,
                        )
                    finally:
                        check_elapsed_sec = perf_counter() - check_started

                    result_json["rule_id"] = rule_json.get("rule_id", rule_name)
                    result_json.setdefault(
                        "check_id",
                        f"CHECK-{case_id}-{model_id}-{rule_name}-{datetime.now(UTC).strftime('%Y%m%d%H%M%S')}"
                    )
                    result_json.setdefault("check_timestamp", datetime.now(UTC).isoformat())
                    result_json.setdefault("patient_id_hash", _derive_patient_hash(episode_json))

                    errors = sorted(validator.iter_errors(result_json), key=lambda e: e.path)
                    if errors:
                        first = errors[0]
                        loc = "/".join(str(x) for x in first.path) or "<root>"
                        raise RuleCheckError(f"Output non conforme allo schema in '{loc}': {first.message}")

                    quality_score_total = None
                    quality_score_rationale = None
                    quality_score_classification = None
                    inferential_alignment: int | None = None
                    outcome_alignment: int | None = None
                    conformity: int | None = None
                    rationale_mode: str | None = None
                    retrospective_winner: str | None = None
                    retrospective_suggestion: str | None = None

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
                        f"[OK ] {execution_label} | tempo: {check_elapsed_sec:.2f}s "
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
                            inferential_alignment = _call_router_rationale_alignment(
                                api_key=rationale_alignment_api_key,
                                routing=rationale_alignment_routing,
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

                        if suggest_prompt_improvement and conformity < RETROSPECTIVE_TRIGGER_THRESHOLD:
                            retrospective_invoked_count += 1
                            if retrospective_routing is None:
                                raise RuleCheckError("Routing retrospettiva non risolto.")

                            retrospective_payload = {
                                "check_prompt": selected_inference_prompt,
                                "clinical_case": episode_json,
                                "rule": rule_json,
                                "gold_output": gold_json,
                                "check_output": result_json,
                                "scoring": {
                                    "conformity_0_10": conformity,
                                    "rationale_alignment_0_10": inferential_alignment,
                                    "outcome_alignment_0_10": outcome_alignment,
                                    "threshold": RETROSPECTIVE_TRIGGER_THRESHOLD,
                                },
                            }

                            try:
                                retrospective_winner, retrospective_suggestion = _call_router_retrospettiva(
                                    api_key=retrospective_api_key,
                                    routing=retrospective_routing,
                                    retrospective_prompt_text=retrospective_prompt_text,
                                    retrospective_schema=retrospective_schema,
                                    retrospective_payload=retrospective_payload,
                                )
                                update_retrospettiva_result_in_db(
                                    conn,
                                    instance_id,
                                    winner=retrospective_winner,
                                    suggestion=retrospective_suggestion,
                                )
                                retrospective_saved_count += 1
                                print(
                                    f"[RETRO] {execution_label} | trigger: conformita' {conformity}/10 < {RETROSPECTIVE_TRIGGER_THRESHOLD} "
                                    f"| check_prompt: inference_params.prompt1 "
                                    f"| winner: {retrospective_winner} | suggestion salvata"
                                )
                            except Exception as retrospective_error:
                                try:
                                    conn.rollback()
                                except Exception:
                                    pass
                                retrospective_ko_count += 1
                                print(
                                    f"[WARN] Retrospettiva non completata su {execution_label}: "
                                    f"{retrospective_error}"
                                )

                    if debug_gold_vs_model:
                        try:
                            _append_debug_gold_vs_model_markdown(
                                debug_path=DEBUG_MARKDOWN_PATH,
                                entry_index=debug_entry_index,
                                run_instance_id=run_instance_id,
                                inference_params_id=inference_params_id,
                                rule_id=db_rule_id,
                                rule_name=rule_name,
                                case_id=case_id,
                                case_identifier=case_identifier,
                                model_id=model_id,
                                model_code=model,
                                router_code=routing.router_code,
                                compliance_instance_id=instance_id,
                                candidate_json=result_json,
                                gold_json=gold_json,
                                check_elapsed_sec=check_elapsed_sec,
                                check_cost_usd=check_cost_usd,
                                rationale_alignment=inferential_alignment,
                                outcome_alignment=outcome_alignment,
                                conformity=conformity,
                                rationale_mode=rationale_mode,
                            )
                            debug_entry_index += 1
                            debug_entries_written += 1
                        except Exception as debug_error:
                            print(f"[WARN] Debug markdown append fallito su {execution_label}: {debug_error}")

                    ok_count += 1

                except Exception as e:
                    conn.rollback()
                    if line_open:
                        print(f" | errore: {e}")
                    elif check_elapsed_sec is None:
                        print(f"[KO ] {execution_label} -> errore: {e} | costo: {_format_inference_cost_usd(check_cost_usd)}")
                    else:
                        print(
                            f"[KO ] {execution_label} -> errore: {e} "
                            f"| tempo check: {check_elapsed_sec:.2f}s "
                            f"| costo: {_format_inference_cost_usd(check_cost_usd)}"
                        )
                    ko_count += 1

    print("\n=== Riepilogo ===")
    print(f"OK: {ok_count}")
    print(f"KO: {ko_count}")
    print(f"SKIP: {skip_count}")
    if suggest_prompt_improvement:
        print(f"RETRO trigger: {retrospective_invoked_count}")
        print(f"RETRO salvate: {retrospective_saved_count}")
        print(f"RETRO KO: {retrospective_ko_count}")
    if debug_gold_vs_model:
        print(
            f"DEBUG markdown append: {debug_entries_written} "
            f"entry su {DEBUG_MARKDOWN_PATH.name}"
        )
    print(f"Salvataggio effettuato su Database (riskm_manager_model_evaluation.compliance_instance).")
    
    if conn:
        conn.close()
        
    return 0 if ko_count == 0 else 2

if __name__ == "__main__":
    raise SystemExit(main())
