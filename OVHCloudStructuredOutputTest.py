#!/usr/bin/env python3
"""
Structured output load test for OVHCloud OpenAI-compatible endpoint.

Runs inference calls at target prompt loads of 10k, 25k, 75k and 100k tokens,
captures latency and transaction cost, and validates that the model response
respects a JSON schema.

Required environment variable:
- OVH_API_KEY
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import asdict, dataclass
from time import perf_counter
from urllib import error, request

DEFAULT_BASE_URL = "https://oai.endpoints.kepler.ai.cloud.ovh.net"
DEFAULT_MODEL = "gpt-oss-20b"
DEFAULT_TARGETS = [10_000, 25_000, 75_000, 100_000]


@dataclass
class PricingInfo:
    prompt_per_token_usd: float | None
    completion_per_token_usd: float | None
    request_per_call_usd: float | None
    currency_unit: str | None
    raw_pricing: dict


@dataclass
class LoadTestResult:
    target_prompt_tokens: int
    filler_tokens_used: int
    observed_prompt_tokens: int | None
    observed_completion_tokens: int | None
    observed_total_tokens: int | None
    latency_seconds: float | None
    finish_reason: str | None
    structured_output_valid: bool
    structured_output: dict | None
    request_id: str | None
    cost_usd: float | None
    cost_source: str
    error: str | None


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


def _strip_markdown_fences(text: str) -> str:
    cleaned = text.strip()
    if cleaned.startswith("```"):
        lines = cleaned.splitlines()
        if lines and lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip() == "```":
            lines = lines[:-1]
        return "\n".join(lines).strip()
    return cleaned


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


def _parse_pricing_token_rate(raw_value: object) -> float | None:
    if raw_value is None:
        return None

    if isinstance(raw_value, (int, float)):
        val = float(raw_value)
        return val if val >= 0 else None

    if not isinstance(raw_value, str):
        return None

    text = raw_value.strip().lower().replace(",", ".")
    if not text:
        return None

    try:
        val = float(text)
        return val if val >= 0 else None
    except ValueError:
        pass

    # Handles strings like "0.15/1m", "$0.30 / 1k tokens", "2e-7/1M".
    m = re.search(r"([0-9]*\.?[0-9]+(?:e[+-]?\d+)?)\s*(?:usd|\$)?\s*/\s*1\s*([kmb]?)", text)
    if not m:
        return None

    value = float(m.group(1))
    unit = m.group(2)
    scale = 1.0
    if unit == "k":
        scale = 1_000.0
    elif unit == "m":
        scale = 1_000_000.0
    elif unit == "b":
        scale = 1_000_000_000.0

    if scale <= 0:
        return None
    return value / scale


def _http_json(*, url: str, api_key: str, method: str, payload: dict | None, timeout_sec: int) -> tuple[dict, object]:
    req_data = None
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    if payload is not None:
        req_data = json.dumps(payload).encode("utf-8")

    req = request.Request(url, data=req_data, method=method, headers=headers)

    try:
        with request.urlopen(req, timeout=timeout_sec) as resp:
            raw = resp.read().decode("utf-8")
            body = json.loads(raw)
            return body, resp.headers
    except error.HTTPError as e:
        details = e.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {e.code} on {url}: {details}") from e
    except error.URLError as e:
        raise RuntimeError(f"Network error on {url}: {e}") from e
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Non-JSON response from {url}: {e}") from e


def _fetch_model_pricing(*, base_url: str, api_key: str, model: str, timeout_sec: int) -> PricingInfo | None:
    url = f"{base_url.rstrip('/')}/v1/models"
    body, _ = _http_json(url=url, api_key=api_key, method="GET", payload=None, timeout_sec=timeout_sec)

    data = body.get("data") if isinstance(body, dict) else None
    if not isinstance(data, list):
        return None

    target = None
    for item in data:
        if not isinstance(item, dict):
            continue
        if str(item.get("id", "")).strip() == model:
            target = item
            break

    if not isinstance(target, dict):
        return None

    pricing_raw = target.get("pricing")
    if not isinstance(pricing_raw, dict):
        return None

    return PricingInfo(
        prompt_per_token_usd=_parse_pricing_token_rate(pricing_raw.get("prompt")),
        completion_per_token_usd=_parse_pricing_token_rate(pricing_raw.get("completion")),
        request_per_call_usd=_parse_pricing_token_rate(pricing_raw.get("request")),
        currency_unit=(str(pricing_raw.get("currency_unit")).strip() or None),
        raw_pricing=pricing_raw,
    )


def _estimate_cost_from_pricing(
    *,
    pricing: PricingInfo,
    prompt_tokens: int | None,
    completion_tokens: int | None,
) -> float | None:
    if prompt_tokens is None and completion_tokens is None:
        return None

    total = 0.0
    has_any_component = False

    if prompt_tokens is not None and pricing.prompt_per_token_usd is not None:
        total += prompt_tokens * pricing.prompt_per_token_usd
        has_any_component = True

    if completion_tokens is not None and pricing.completion_per_token_usd is not None:
        total += completion_tokens * pricing.completion_per_token_usd
        has_any_component = True

    if pricing.request_per_call_usd is not None:
        total += pricing.request_per_call_usd
        has_any_component = True

    return total if has_any_component else None


def _build_structured_schema() -> dict:
    return {
        "type": "object",
        "properties": {
            "status": {"type": "string"},
            "target_bucket": {"type": "integer"},
            "label": {"type": "string"},
        },
        "required": ["status", "target_bucket", "label"],
        "additionalProperties": False,
    }


def _build_user_prompt(*, target_prompt_tokens: int, filler_tokens: int) -> str:
    # Keep the load block first, then repeat strict output instructions at the end
    # so they remain close to the generation point even with very large contexts.
    load_block = ("a " * max(1, filler_tokens)).rstrip()
    return (
        "Ignora semanticamente il blocco payload seguente: serve solo a generare carico token.\n\n"
        "<PAYLOAD_START>\n"
        f"{load_block}\n"
        "<PAYLOAD_END>\n\n"
        "ORA RISPOSTA FINALE OBBLIGATORIA:\n"
        "- restituisci solo JSON valido\n"
        "- nessun testo extra\n"
        f"- target_bucket deve essere {target_prompt_tokens} (intero)\n"
        "- label deve essere OVH_STRUCTURED_OUTPUT_TEST\n"
        "- status deve essere ok\n"
    )


def _parse_structured_output(content: object) -> tuple[bool, dict | None]:
    parsed_obj: dict | None = None

    if isinstance(content, dict):
        parsed_obj = content
    elif isinstance(content, list):
        joined = "\n".join(str(part.get("text", "")) for part in content if isinstance(part, dict))
        joined = _strip_markdown_fences(joined)
        try:
            candidate = json.loads(joined)
            if isinstance(candidate, dict):
                parsed_obj = candidate
        except json.JSONDecodeError:
            parsed_obj = None
    elif isinstance(content, str):
        cleaned = _strip_markdown_fences(content)
        try:
            candidate = json.loads(cleaned)
            if isinstance(candidate, dict):
                parsed_obj = candidate
        except json.JSONDecodeError:
            parsed_obj = None

    if not isinstance(parsed_obj, dict):
        return False, None

    if not isinstance(parsed_obj.get("status"), str):
        return False, parsed_obj
    if not isinstance(parsed_obj.get("target_bucket"), int):
        return False, parsed_obj
    if not isinstance(parsed_obj.get("label"), str):
        return False, parsed_obj

    return True, parsed_obj


def _send_structured_call(
    *,
    base_url: str,
    api_key: str,
    model: str,
    target_prompt_tokens: int,
    filler_tokens: int,
    max_output_tokens: int,
    timeout_sec: int,
) -> tuple[dict, object, float]:
    schema = _build_structured_schema()
    payload = {
        "model": model,
        "temperature": 0,
        "max_tokens": max_output_tokens,
        "messages": [
            {
                "role": "system",
                "content": (
                    "Rispondi sempre e solo con JSON valido conforme allo schema fornito in response_format."
                ),
            },
            {
                "role": "user",
                "content": _build_user_prompt(
                    target_prompt_tokens=target_prompt_tokens,
                    filler_tokens=filler_tokens,
                ),
            },
        ],
        "response_format": {
            "type": "json_schema",
            "json_schema": {
                "name": "OVHStructuredOutput",
                "strict": True,
                "schema": schema,
            },
        },
    }

    url = f"{base_url.rstrip('/')}/v1/chat/completions"
    t0 = perf_counter()
    body, headers = _http_json(url=url, api_key=api_key, method="POST", payload=payload, timeout_sec=timeout_sec)
    elapsed = perf_counter() - t0
    return body, headers, elapsed


def _parse_targets(raw: str) -> list[int]:
    values: list[int] = []
    for part in raw.split(","):
        token = part.strip().lower().replace("_", "")
        if not token:
            continue
        multiplier = 1
        if token.endswith("k"):
            multiplier = 1_000
            token = token[:-1]
        n = int(token)
        if n <= 0:
            raise ValueError("target tokens must be > 0")
        values.append(n * multiplier)
    if not values:
        raise ValueError("empty targets")
    return values


def run(args: argparse.Namespace) -> int:
    api_key = (os.getenv("OVH_API_KEY") or "").strip()
    if not api_key:
        print("Errore: variabile ambiente OVH_API_KEY non impostata.")
        return 2

    try:
        targets = _parse_targets(args.targets)
    except ValueError as e:
        print(f"Errore parsing --targets: {e}")
        return 2

    print("OVH structured output load test")
    print(f"Base URL: {args.base_url}")
    print(f"Model: {args.model}")
    print(f"Targets: {targets}")

    pricing = None
    try:
        pricing = _fetch_model_pricing(
            base_url=args.base_url,
            api_key=api_key,
            model=args.model,
            timeout_sec=args.timeout_sec,
        )
    except Exception as e:
        print(f"[WARN] Impossibile leggere pricing da /v1/models: {e}")

    if pricing is not None:
        print(
            "Pricing fallback loaded: "
            f"prompt_per_token={pricing.prompt_per_token_usd}, "
            f"completion_per_token={pricing.completion_per_token_usd}, "
            f"request_per_call={pricing.request_per_call_usd}, "
            f"currency={pricing.currency_unit}"
        )
    else:
        print("Pricing fallback non disponibile: usero solo costo diretto dalla risposta, se presente.")

    results: list[LoadTestResult] = []
    estimated_overhead_tokens = 250

    for target in targets:
        filler_tokens = max(128, target - estimated_overhead_tokens)
        print(f"\n[RUN] target={target} filler_tokens={filler_tokens}")

        try:
            body, headers, elapsed = _send_structured_call(
                base_url=args.base_url,
                api_key=api_key,
                model=args.model,
                target_prompt_tokens=target,
                filler_tokens=filler_tokens,
                max_output_tokens=args.max_output_tokens,
                timeout_sec=args.timeout_sec,
            )

            usage_raw = body.get("usage") if isinstance(body, dict) else None
            usage = usage_raw if isinstance(usage_raw, dict) else {}

            prompt_tokens = _to_int(usage.get("prompt_tokens"))
            completion_tokens = _to_int(usage.get("completion_tokens"))
            total_tokens = _to_int(usage.get("total_tokens"))

            if prompt_tokens is not None:
                observed_overhead = prompt_tokens - filler_tokens
                if 0 < observed_overhead < 5000:
                    estimated_overhead_tokens = int(round((0.6 * estimated_overhead_tokens) + (0.4 * observed_overhead)))

            choice0 = None
            choices = body.get("choices") if isinstance(body, dict) else None
            if isinstance(choices, list) and choices:
                choice0 = choices[0]
            if not isinstance(choice0, dict):
                raise RuntimeError("Response missing choices[0]")

            message = choice0.get("message")
            if not isinstance(message, dict):
                raise RuntimeError("Response missing choices[0].message")

            structured_valid, structured_obj = _parse_structured_output(message.get("content"))
            finish_reason = str(choice0.get("finish_reason")) if choice0.get("finish_reason") is not None else None

            header_cost_usd = _to_float(getattr(headers, "get", lambda *_: None)("x-openrouter-cost"))
            direct_cost = _extract_inference_cost_usd(body, header_cost_usd)

            cost_usd = direct_cost
            cost_source = "direct"
            if cost_usd is None and pricing is not None:
                estimated = _estimate_cost_from_pricing(
                    pricing=pricing,
                    prompt_tokens=prompt_tokens,
                    completion_tokens=completion_tokens,
                )
                if estimated is not None:
                    cost_usd = estimated
                    cost_source = "estimated_from_models_pricing"
                else:
                    cost_source = "unavailable"
            elif cost_usd is None:
                cost_source = "unavailable"

            request_id = None
            if isinstance(body, dict):
                request_id = str(body.get("id")) if body.get("id") is not None else None

            result = LoadTestResult(
                target_prompt_tokens=target,
                filler_tokens_used=filler_tokens,
                observed_prompt_tokens=prompt_tokens,
                observed_completion_tokens=completion_tokens,
                observed_total_tokens=total_tokens,
                latency_seconds=elapsed,
                finish_reason=finish_reason,
                structured_output_valid=structured_valid,
                structured_output=structured_obj,
                request_id=request_id,
                cost_usd=cost_usd,
                cost_source=cost_source,
                error=None,
            )
            results.append(result)

            print(
                "[OK] "
                f"target={target} "
                f"prompt={prompt_tokens} "
                f"completion={completion_tokens} "
                f"latency={elapsed:.3f}s "
                f"cost={cost_usd} ({cost_source}) "
                f"structured_valid={structured_valid}"
            )

        except Exception as e:
            print(f"[ERR] target={target}: {e}")
            results.append(
                LoadTestResult(
                    target_prompt_tokens=target,
                    filler_tokens_used=filler_tokens,
                    observed_prompt_tokens=None,
                    observed_completion_tokens=None,
                    observed_total_tokens=None,
                    latency_seconds=None,
                    finish_reason=None,
                    structured_output_valid=False,
                    structured_output=None,
                    request_id=None,
                    cost_usd=None,
                    cost_source="unavailable",
                    error=str(e),
                )
            )

    total_known_cost = sum((r.cost_usd or 0.0) for r in results)
    known_cost_count = sum(1 for r in results if r.cost_usd is not None)
    valid_count = sum(1 for r in results if r.structured_output_valid)

    summary = {
        "base_url": args.base_url,
        "model": args.model,
        "targets": targets,
        "pricing": asdict(pricing) if pricing is not None else None,
        "results": [asdict(r) for r in results],
        "aggregate": {
            "structured_output_valid_count": valid_count,
            "total_runs": len(results),
            "known_cost_count": known_cost_count,
            "total_known_cost_usd": total_known_cost,
        },
    }

    print("\n=== AGGREGATE ===")
    print(json.dumps(summary["aggregate"], ensure_ascii=False, indent=2))

    if args.output_json:
        with open(args.output_json, "w", encoding="utf-8") as f:
            json.dump(summary, f, ensure_ascii=False, indent=2)
        print(f"Dettaglio salvato in: {args.output_json}")
    else:
        print(json.dumps(summary, ensure_ascii=False, indent=2))

    return 0


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="OVHCloud structured output load test (OpenAI-compatible API)."
    )
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL, help="API base URL.")
    parser.add_argument("--model", default=DEFAULT_MODEL, help="Model ID.")
    parser.add_argument(
        "--targets",
        default=",".join(str(x) for x in DEFAULT_TARGETS),
        help="Comma-separated target prompt token loads (e.g. 10000,25000,75000,100000 or 10k,25k,75k,100k).",
    )
    parser.add_argument("--max-output-tokens", type=int, default=512, help="max_tokens for output JSON.")
    parser.add_argument("--timeout-sec", type=int, default=900, help="Request timeout in seconds.")
    parser.add_argument(
        "--output-json",
        default="OVHCloudStructuredOutputTest.results.json",
        help="Output file path for detailed JSON results. Use empty string to print full JSON on stdout.",
    )
    return parser


def main() -> int:
    parser = build_arg_parser()
    args = parser.parse_args()
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
