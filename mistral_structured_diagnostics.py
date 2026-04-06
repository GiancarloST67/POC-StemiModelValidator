#!/usr/bin/env python3
"""Diagnostic runner to find robust structured-output strategies on Mistral models."""

from __future__ import annotations

import json
import os
import time
from dataclasses import asdict, dataclass
from typing import Any
from urllib import error, request

BASE_URL = "https://oai.endpoints.kepler.ai.cloud.ovh.net"
MODELS = [
    "Mistral-Small-3.2-24B-Instruct-2506",
    "Mistral-7B-Instruct-v0.3",
]
TARGETS = [10_000, 25_000]
TIMEOUT_SEC = 600


@dataclass
class CaseResult:
    model: str
    target: int
    case: str
    endpoint: str
    success: bool
    structured_valid: bool
    finish_reason: str | None
    latency_seconds: float | None
    prompt_tokens: int | None
    completion_tokens: int | None
    total_tokens: int | None
    parsed_output: dict[str, Any] | None
    error: str | None


def _to_int(value: Any) -> int | None:
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


def _strip_md_fence(text: str) -> str:
    cleaned = text.strip()
    if cleaned.startswith("```"):
        lines = cleaned.splitlines()
        if lines and lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip() == "```":
            lines = lines[:-1]
        return "\n".join(lines).strip()
    return cleaned


def _parse_json_text(raw: Any) -> dict[str, Any] | None:
    if isinstance(raw, dict):
        return raw
    if isinstance(raw, list):
        chunks: list[str] = []
        for part in raw:
            if isinstance(part, dict):
                txt = part.get("text")
                if isinstance(txt, str):
                    chunks.append(txt)
        raw = "\n".join(chunks)
    if not isinstance(raw, str):
        return None
    cleaned = _strip_md_fence(raw)
    try:
        obj = json.loads(cleaned)
    except json.JSONDecodeError:
        return None
    return obj if isinstance(obj, dict) else None


def _validate_structured(obj: dict[str, Any] | None, target: int) -> bool:
    if not isinstance(obj, dict):
        return False
    if obj.get("status") != "ok":
        return False
    if obj.get("label") != "OVH_STRUCTURED_OUTPUT_TEST":
        return False
    return obj.get("target_bucket") == target


def _build_schema() -> dict[str, Any]:
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


def _build_prompt(*, target: int, filler_tokens: int, concise: bool) -> str:
    payload = ("a " * max(1, filler_tokens)).rstrip()
    if concise:
        return (
            "Task: output EXACTLY one JSON object and nothing else.\n"
            "Use exactly these values: "
            f"{{\"status\":\"ok\",\"target_bucket\":{target},\"label\":\"OVH_STRUCTURED_OUTPUT_TEST\"}}\n"
            "Do not add markdown fences.\n"
            "Ignore semantic meaning of payload below; it is only token load.\n\n"
            "<PAYLOAD_START>\n"
            f"{payload}\n"
            "<PAYLOAD_END>\n"
        )
    return (
        "Ignora semanticamente il blocco payload seguente: serve solo a generare carico token.\n\n"
        "<PAYLOAD_START>\n"
        f"{payload}\n"
        "<PAYLOAD_END>\n\n"
        "ORA RISPOSTA FINALE OBBLIGATORIA:\n"
        "- restituisci solo JSON valido\n"
        "- nessun testo extra\n"
        f"- target_bucket deve essere {target} (intero)\n"
        "- label deve essere OVH_STRUCTURED_OUTPUT_TEST\n"
        "- status deve essere ok\n"
    )


def _post_json(*, path: str, api_key: str, payload: dict[str, Any], timeout_sec: int) -> tuple[dict[str, Any], float]:
    url = f"{BASE_URL}{path}"
    req = request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    t0 = time.perf_counter()
    try:
        with request.urlopen(req, timeout=timeout_sec) as resp:
            body = json.loads(resp.read().decode("utf-8"))
            return body, time.perf_counter() - t0
    except error.HTTPError as e:
        details = e.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {e.code}: {details}") from e


def _extract_chat(body: dict[str, Any], *, target: int, mode: str) -> tuple[bool, dict[str, Any] | None, str | None, int | None, int | None, int | None]:
    usage = body.get("usage") if isinstance(body.get("usage"), dict) else {}
    prompt_tokens = _to_int(usage.get("prompt_tokens"))
    completion_tokens = _to_int(usage.get("completion_tokens"))
    total_tokens = _to_int(usage.get("total_tokens"))

    choices = body.get("choices") if isinstance(body.get("choices"), list) else []
    if not choices or not isinstance(choices[0], dict):
        return False, None, None, prompt_tokens, completion_tokens, total_tokens

    choice = choices[0]
    finish = choice.get("finish_reason")
    finish_reason = str(finish) if finish is not None else None
    msg = choice.get("message") if isinstance(choice.get("message"), dict) else {}

    parsed: dict[str, Any] | None = None
    if mode == "function":
        tool_calls = msg.get("tool_calls") if isinstance(msg.get("tool_calls"), list) else []
        if tool_calls and isinstance(tool_calls[0], dict):
            fn = tool_calls[0].get("function") if isinstance(tool_calls[0].get("function"), dict) else {}
            args = fn.get("arguments")
            parsed = _parse_json_text(args)
    else:
        parsed = _parse_json_text(msg.get("content"))

    return _validate_structured(parsed, target), parsed, finish_reason, prompt_tokens, completion_tokens, total_tokens


def _extract_responses(body: dict[str, Any], *, target: int) -> tuple[bool, dict[str, Any] | None, str | None, int | None, int | None, int | None]:
    usage = body.get("usage") if isinstance(body.get("usage"), dict) else {}
    prompt_tokens = _to_int(usage.get("input_tokens"))
    completion_tokens = _to_int(usage.get("output_tokens"))
    total_tokens = _to_int(usage.get("total_tokens"))

    status = body.get("status")
    finish_reason = str(status) if status is not None else None

    parsed: dict[str, Any] | None = None
    output = body.get("output") if isinstance(body.get("output"), list) else []
    for item in output:
        if not isinstance(item, dict):
            continue
        if item.get("type") != "message":
            continue
        content = item.get("content") if isinstance(item.get("content"), list) else []
        for part in content:
            if not isinstance(part, dict):
                continue
            if part.get("type") == "output_text" and isinstance(part.get("text"), str):
                parsed = _parse_json_text(part.get("text"))
                if parsed is not None:
                    break
        if parsed is not None:
            break

    return _validate_structured(parsed, target), parsed, finish_reason, prompt_tokens, completion_tokens, total_tokens


def _chat_payload(*, model: str, target: int, filler_tokens: int, max_tokens: int, mode: str, strict: bool | None = None, concise: bool = False) -> dict[str, Any]:
    schema = _build_schema()
    messages = [
        {
            "role": "system",
            "content": (
                "Output must be machine-readable JSON only."
                if concise
                else "Rispondi sempre e solo con JSON valido conforme allo schema o alle istruzioni."
            ),
        },
        {
            "role": "user",
            "content": _build_prompt(target=target, filler_tokens=filler_tokens, concise=concise),
        },
    ]

    payload: dict[str, Any] = {
        "model": model,
        "temperature": 0,
        "max_tokens": max_tokens,
        "messages": messages,
    }

    if mode == "json_schema":
        payload["response_format"] = {
            "type": "json_schema",
            "json_schema": {
                "name": "OVHStructuredOutput",
                "strict": bool(strict),
                "schema": schema,
            },
        }
    elif mode == "json_object":
        payload["response_format"] = {"type": "json_object"}
    elif mode == "function":
        payload["tool_choice"] = "required"
        payload["tools"] = [
            {
                "type": "function",
                "function": {
                    "name": "emit_structured_output",
                    "description": "Emit the structured output object exactly.",
                    "parameters": schema,
                },
            }
        ]

    return payload


def _responses_payload(*, model: str, target: int, filler_tokens: int, max_output_tokens: int, strict: bool) -> dict[str, Any]:
    schema = _build_schema()
    return {
        "model": model,
        "temperature": 0,
        "max_output_tokens": max_output_tokens,
        "input": [
            {
                "type": "message",
                "role": "system",
                "content": "Output machine-readable JSON only.",
            },
            {
                "type": "message",
                "role": "user",
                "content": _build_prompt(target=target, filler_tokens=filler_tokens, concise=True),
            },
        ],
        "text": {
            "format": {
                "type": "json_schema",
                "name": "OVHStructuredOutput",
                "strict": strict,
                "schema": schema,
            }
        },
    }


def run() -> int:
    api_key = (os.getenv("OVH_API_KEY") or "").strip()
    if not api_key:
        print("OVH_API_KEY missing")
        return 2

    cases = [
        {
            "name": "chat_schema_strict_512_verbose",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=512, mode="json_schema", strict=True, concise=False
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="content"),
        },
        {
            "name": "chat_schema_strict_1024_concise",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=1024, mode="json_schema", strict=True, concise=True
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="content"),
        },
        {
            "name": "chat_schema_nonstrict_1024_concise",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=1024, mode="json_schema", strict=False, concise=True
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="content"),
        },
        {
            "name": "chat_json_object_512_concise",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=512, mode="json_object", concise=True
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="content"),
        },
        {
            "name": "chat_json_object_1024_concise",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=1024, mode="json_object", concise=True
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="content"),
        },
        {
            "name": "chat_function_required_512_concise",
            "endpoint": "/v1/chat/completions",
            "payload_builder": lambda m, t, f: _chat_payload(
                model=m, target=t, filler_tokens=f, max_tokens=512, mode="function", concise=True
            ),
            "extractor": lambda body, t: _extract_chat(body, target=t, mode="function"),
        },
        {
            "name": "responses_schema_strict_1024_concise",
            "endpoint": "/v1/responses",
            "payload_builder": lambda m, t, f: _responses_payload(
                model=m, target=t, filler_tokens=f, max_output_tokens=1024, strict=True
            ),
            "extractor": lambda body, t: _extract_responses(body, target=t),
        },
        {
            "name": "responses_schema_nonstrict_1024_concise",
            "endpoint": "/v1/responses",
            "payload_builder": lambda m, t, f: _responses_payload(
                model=m, target=t, filler_tokens=f, max_output_tokens=1024, strict=False
            ),
            "extractor": lambda body, t: _extract_responses(body, target=t),
        },
    ]

    all_results: list[CaseResult] = []

    for model in MODELS:
        print(f"\n=== MODEL {model} ===")
        for target in TARGETS:
            overhead = 250
            filler = max(128, target - overhead)
            print(f"\n[TARGET {target}] filler={filler}")
            for case in cases:
                name = case["name"]
                endpoint = case["endpoint"]
                print(f"- Case: {name}")
                payload = case["payload_builder"](model, target, filler)
                t0 = time.perf_counter()
                try:
                    body, latency = _post_json(
                        path=endpoint,
                        api_key=api_key,
                        payload=payload,
                        timeout_sec=TIMEOUT_SEC,
                    )
                    valid, parsed, finish_reason, pt, ct, tt = case["extractor"](body, target)
                    if pt is not None:
                        obs_overhead = pt - filler
                        if 0 < obs_overhead < 5000:
                            overhead = int(round((0.6 * overhead) + (0.4 * obs_overhead)))
                    all_results.append(
                        CaseResult(
                            model=model,
                            target=target,
                            case=name,
                            endpoint=endpoint,
                            success=True,
                            structured_valid=valid,
                            finish_reason=finish_reason,
                            latency_seconds=latency,
                            prompt_tokens=pt,
                            completion_tokens=ct,
                            total_tokens=tt,
                            parsed_output=parsed,
                            error=None,
                        )
                    )
                    print(
                        f"  ok valid={valid} finish={finish_reason} latency={latency:.3f}s "
                        f"prompt={pt} completion={ct}"
                    )
                except Exception as e:
                    all_results.append(
                        CaseResult(
                            model=model,
                            target=target,
                            case=name,
                            endpoint=endpoint,
                            success=False,
                            structured_valid=False,
                            finish_reason=None,
                            latency_seconds=time.perf_counter() - t0,
                            prompt_tokens=None,
                            completion_tokens=None,
                            total_tokens=None,
                            parsed_output=None,
                            error=str(e),
                        )
                    )
                    print(f"  err {e}")

    out = {
        "base_url": BASE_URL,
        "models": MODELS,
        "targets": TARGETS,
        "results": [asdict(r) for r in all_results],
    }

    by_key: dict[tuple[str, int, str], list[CaseResult]] = {}
    for r in all_results:
        by_key.setdefault((r.model, r.target, r.case), []).append(r)

    print("\n=== SUMMARY (valid cases) ===")
    for r in all_results:
        if r.structured_valid:
            print(
                f"model={r.model} target={r.target} case={r.case} "
                f"finish={r.finish_reason} latency={r.latency_seconds:.3f}s"
            )

    with open("mistral_structured_diagnostics.results.json", "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
    print("Saved: mistral_structured_diagnostics.results.json")
    return 0


if __name__ == "__main__":
    raise SystemExit(run())
