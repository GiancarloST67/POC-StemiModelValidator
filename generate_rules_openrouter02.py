#!/usr/bin/env python3
"""
Genera una regola DO o DONOT su PostgreSQL (tabella rule_definition)
usando OpenRouter e gli schema JSON locali.
"""

from __future__ import annotations

import json
import os
import re
from pathlib import Path
from urllib import error, request

try:
    import psycopg2
    from psycopg2.extras import Json
except ImportError:
    print("Errore: la libreria psycopg2 non e installata. Eseguire: pip install psycopg2-binary")
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parent
DO_SCHEMA_PATH = ROOT / "SRS" / "do_rule.schema.json"
DO_NOT_SCHEMA_PATH = ROOT / "SRS" / "do_not_rule.schema.json"

OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
DEFAULT_MODEL = "anthropic/claude-opus-4.6"
DEFAULT_DB_NAME = "RiskMgm"


class RuleGenerationError(Exception):
    pass


def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", DEFAULT_DB_NAME),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "Sanbarra123"),
    )


def _db_target_info() -> str:
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")
    name = os.getenv("DB_NAME", DEFAULT_DB_NAME)
    user = os.getenv("DB_USER", "postgres")
    return f"{host}:{port}/{name} (user={user})"


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


def _is_yes(answer: str) -> bool:
    return answer.strip().lower() in {"s", "si", "y", "yes"}


def _read_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _choose_rule_kind() -> tuple[str, str, Path]:
    answer = input("Tipo regola da generare [DO/DONOT] (default DO): ").strip().lower()

    if answer in {"", "do"}:
        return "do", "DO", DO_SCHEMA_PATH
    if answer in {"donot", "do_not", "do-not", "do not"}:
        return "do_not", "DONOT", DO_NOT_SCHEMA_PATH

    print("Valore non riconosciuto. Uso default: DO.")
    return "do", "DO", DO_SCHEMA_PATH


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


def _post_openrouter(api_key: str, payload: dict) -> str:
    data = json.dumps(payload).encode("utf-8")
    req = request.Request(
        OPENROUTER_URL,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://local.rule-generator-db",
            "X-Title": "Rule Generator DB",
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
    target_rule_name: str,
    rule_type: str,
    schema: dict,
    clinical_pathway_id: int,
    clinical_pathway_name: str,
) -> dict:
    system_prompt = (
        "Sei un assistente esperto di linee guida cliniche. "
        "Genera SOLO un JSON valido, senza testo extra, in italiano, "
        "conformemente allo schema JSON fornito via response_format."
    )

    user_prompt = (
        f"Crea una regola di tipo {rule_type.upper()} per il clinical pathway "
        f"'{clinical_pathway_name}' (clinical_pathway_id={clinical_pathway_id}) "
        f"partendo da questo testo libero:\n"
        f"\"{rule_text}\"\n\n"
        "Vincoli obbligatori:\n"
        f"- rule_id deve essere esattamente '{target_rule_name}'\n"
        f"- rule_type deve essere '{rule_type}'\n"
        "- usa terminologia clinica italiana\n"
        "- compila tutti i campi richiesti in modo coerente e plausibile\n"
        "- non aggiungere proprieta non previste\n"
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
                "name": "rule_definition",
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


def _prompt_select_db_id(options: dict[int, str], *, prompt: str, default_id: int | None = None) -> int:
    if not options:
        raise RuleGenerationError("Nessuna opzione disponibile nel DB.")

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


def _choose_clinical_pathway_from_db(conn) -> tuple[int, str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT cp.clinical_pathway_id, cp.name, COUNT(rd.rule_id)::int AS rules_count
            FROM riskm_manager_model_evaluation.clinical_pathway cp
            LEFT JOIN riskm_manager_model_evaluation.rule_definition rd
                ON rd.clinical_pathway_id = cp.clinical_pathway_id
            GROUP BY cp.clinical_pathway_id, cp.name
            ORDER BY cp.clinical_pathway_id
            """
        )
        rows = cur.fetchall()

    if not rows:
        raise RuleGenerationError("Nessun clinical_pathway trovato nel DB.")

    options: dict[int, str] = {}
    default_id: int | None = None

    print("\nClinical pathway disponibili da DB (clinical_pathway_id -> name):")
    for pathway_id_raw, pathway_name_raw, rules_count_raw in rows:
        pathway_id = int(pathway_id_raw)
        pathway_name = str(pathway_name_raw)
        rules_count = int(rules_count_raw)
        options[pathway_id] = pathway_name

        marker = ""
        if default_id is None and rules_count > 0:
            default_id = pathway_id
            marker = " [default]"

        print(f"  {pathway_id:>3}) {pathway_name} | rules: {rules_count}{marker}")

    selected_id = _prompt_select_db_id(
        options,
        prompt="Seleziona clinical_pathway_id DB",
        default_id=default_id,
    )
    return selected_id, options[selected_id]


def _load_rule_names_for_pathway(conn, *, clinical_pathway_id: int) -> list[str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT name
            FROM riskm_manager_model_evaluation.rule_definition
            WHERE clinical_pathway_id = %s
            ORDER BY rule_id
            """,
            (clinical_pathway_id,),
        )
        rows = cur.fetchall()

    return [str(name_raw) for (name_raw,) in rows]


def _lookup_rule_id_by_name(conn, *, clinical_pathway_id: int, rule_name: str) -> int | None:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT rule_id
            FROM riskm_manager_model_evaluation.rule_definition
            WHERE clinical_pathway_id = %s
              AND UPPER(name) = UPPER(%s)
            """,
            (clinical_pathway_id, rule_name),
        )
        row = cur.fetchone()

    if not row:
        return None
    return int(row[0])


def _extract_prefix_and_number(rule_name: str, kind_token: str) -> tuple[str, int] | None:
    m = re.fullmatch(rf"([A-Z0-9][A-Z0-9_-]*)-{kind_token}-(\d{{3}})", rule_name.strip().upper())
    if not m:
        return None
    return m.group(1), int(m.group(2))


def _fallback_prefix_from_pathway_name(pathway_name: str) -> str:
    tokens = [t for t in re.split(r"[^A-Za-z0-9]+", pathway_name.upper()) if t]
    if not tokens:
        return "RULE"
    return tokens[-1]


def _next_available_name(prefix: str, kind_token: str, start_number: int, existing_names_upper: set[str]) -> str:
    n = max(1, start_number)
    while True:
        candidate = f"{prefix}-{kind_token}-{n:03d}"
        if candidate not in existing_names_upper:
            return candidate
        n += 1


def _infer_rule_name(
    *,
    existing_names: list[str],
    kind_token: str,
    clinical_pathway_name: str,
) -> tuple[str, str]:
    existing_upper = [name.strip().upper() for name in existing_names if str(name).strip()]
    existing_set = set(existing_upper)

    current_kind: dict[str, list[int]] = {}
    for name in existing_upper:
        parsed = _extract_prefix_and_number(name, kind_token)
        if not parsed:
            continue
        prefix, number = parsed
        current_kind.setdefault(prefix, []).append(number)

    if current_kind:
        ranked = sorted(
            current_kind.items(),
            key=lambda item: (len(item[1]), max(item[1]), item[0]),
            reverse=True,
        )
        best_prefix, numbers = ranked[0]
        suggested = _next_available_name(
            prefix=best_prefix,
            kind_token=kind_token,
            start_number=max(numbers) + 1,
            existing_names_upper=existing_set,
        )
        reason = f"pattern trovato nelle regole {kind_token} del pathway (prefisso {best_prefix})"
        return suggested, reason

    other_kind = "DONOT" if kind_token == "DO" else "DO"
    other_prefix_counts: dict[str, int] = {}
    for name in existing_upper:
        parsed = _extract_prefix_and_number(name, other_kind)
        if not parsed:
            continue
        prefix, _ = parsed
        other_prefix_counts[prefix] = other_prefix_counts.get(prefix, 0) + 1

    if other_prefix_counts:
        best_prefix = sorted(
            other_prefix_counts.items(),
            key=lambda item: (item[1], item[0]),
            reverse=True,
        )[0][0]
        suggested = _next_available_name(
            prefix=best_prefix,
            kind_token=kind_token,
            start_number=1,
            existing_names_upper=existing_set,
        )
        reason = f"prefisso inferito dalle regole {other_kind} del pathway (prefisso {best_prefix})"
        return suggested, reason

    generic_prefix_counts: dict[str, int] = {}
    generic_pattern = re.compile(r"([A-Z0-9][A-Z0-9_-]*)-(DO|DONOT)-(\d{3})")
    for name in existing_upper:
        m = generic_pattern.fullmatch(name)
        if not m:
            continue
        prefix = m.group(1)
        generic_prefix_counts[prefix] = generic_prefix_counts.get(prefix, 0) + 1

    if generic_prefix_counts:
        best_prefix = sorted(
            generic_prefix_counts.items(),
            key=lambda item: (item[1], item[0]),
            reverse=True,
        )[0][0]
        suggested = _next_available_name(
            prefix=best_prefix,
            kind_token=kind_token,
            start_number=1,
            existing_names_upper=existing_set,
        )
        reason = f"prefisso inferito dalle altre regole del pathway (prefisso {best_prefix})"
        return suggested, reason

    fallback_prefix = _fallback_prefix_from_pathway_name(clinical_pathway_name)
    suggested = _next_available_name(
        prefix=fallback_prefix,
        kind_token=kind_token,
        start_number=1,
        existing_names_upper=existing_set,
    )
    reason = f"fallback dal nome clinical pathway ({clinical_pathway_name} -> {fallback_prefix})"
    return suggested, reason


def _is_valid_rule_name_for_kind(rule_name: str, kind_token: str) -> bool:
    return bool(re.fullmatch(rf"[A-Z0-9][A-Z0-9_-]*-{kind_token}-\d{{3}}", rule_name.strip().upper()))


def _resolve_target_rule_name(
    conn,
    *,
    clinical_pathway_id: int,
    clinical_pathway_name: str,
    kind_token: str,
) -> tuple[str, int | None]:
    existing_names = _load_rule_names_for_pathway(conn, clinical_pathway_id=clinical_pathway_id)
    suggested_name, reason = _infer_rule_name(
        existing_names=existing_names,
        kind_token=kind_token,
        clinical_pathway_name=clinical_pathway_name,
    )

    print(f"\nInferenza naming: {reason}")
    print(f"Nome regola suggerito: {suggested_name}")

    existing_set_upper = {name.strip().upper() for name in existing_names if str(name).strip()}

    while True:
        raw = input(f"Nome regola da creare (default {suggested_name}): ").strip().upper()
        chosen_name = raw or suggested_name

        if not _is_valid_rule_name_for_kind(chosen_name, kind_token):
            print(
                "Formato nome non valido. "
                f"Usa il formato PREFIX-{kind_token}-NNN (esempio: {suggested_name})."
            )
            continue

        existing_rule_id = _lookup_rule_id_by_name(
            conn,
            clinical_pathway_id=clinical_pathway_id,
            rule_name=chosen_name,
        )

        if existing_rule_id is None:
            return chosen_name, None

        print(f"La regola {chosen_name} esiste gia in DB (rule_id={existing_rule_id}).")
        if _is_yes(input("Vuoi sovrascriverla? [s/N]: ")):
            return chosen_name, existing_rule_id

        if not raw:
            parsed = _extract_prefix_and_number(chosen_name, kind_token)
            if parsed:
                prefix, number = parsed
                suggested_name = _next_available_name(
                    prefix=prefix,
                    kind_token=kind_token,
                    start_number=number + 1,
                    existing_names_upper=existing_set_upper,
                )
                print(f"Nuovo suggerimento disponibile: {suggested_name}")
                continue

        print("Inserisci un nome diverso.")


def _insert_rule_definition(
    conn,
    *,
    clinical_pathway_id: int,
    rule_name: str,
    rule_body: dict,
) -> int:
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO riskm_manager_model_evaluation.rule_definition
                (clinical_pathway_id, name, body)
            VALUES
                (%s, %s, %s)
            RETURNING rule_id
            """,
            (clinical_pathway_id, rule_name, Json(rule_body)),
        )
        row = cur.fetchone()

    if not row:
        raise RuleGenerationError("Insert su rule_definition non ha restituito rule_id.")

    return int(row[0])


def _update_rule_definition(
    conn,
    *,
    existing_rule_id: int,
    clinical_pathway_id: int,
    rule_name: str,
    rule_body: dict,
) -> int:
    with conn.cursor() as cur:
        cur.execute(
            """
            UPDATE riskm_manager_model_evaluation.rule_definition
            SET body = %s
            WHERE rule_id = %s
              AND clinical_pathway_id = %s
              AND name = %s
            RETURNING rule_id
            """,
            (Json(rule_body), existing_rule_id, clinical_pathway_id, rule_name),
        )
        row = cur.fetchone()

    if not row:
        raise RuleGenerationError(
            f"Update fallito: nessuna riga aggiornata per rule_id={existing_rule_id}, "
            f"clinical_pathway_id={clinical_pathway_id}, name={rule_name}."
        )

    return int(row[0])


def main() -> int:
    print("=== Generatore regola su rule_definition con OpenRouter ===")

    api_key = os.getenv("OPENROUTER_API_KEY")
    if not api_key:
        print("Errore: variabile OPENROUTER_API_KEY non impostata.")
        return 1

    model = os.getenv("OPENROUTER_MODEL", DEFAULT_MODEL)
    rule_type, kind_token, schema_path = _choose_rule_kind()

    if not schema_path.exists():
        print(f"Errore: schema non trovato: {schema_path}")
        return 1

    schema = _read_json(schema_path)

    try:
        conn = get_db_connection()
    except Exception as e:
        print(f"Errore connessione DB: {e}")
        return 1

    try:
        clinical_pathway_id, clinical_pathway_name = _choose_clinical_pathway_from_db(conn)
        target_rule_name, overwrite_rule_id = _resolve_target_rule_name(
            conn,
            clinical_pathway_id=clinical_pathway_id,
            clinical_pathway_name=clinical_pathway_name,
            kind_token=kind_token,
        )

        print(f"\nDB target:           {_db_target_info()}")
        print("Tabella target:      riskm_manager_model_evaluation.rule_definition")
        print(f"Clinical pathway:    {clinical_pathway_id} ({clinical_pathway_name})")
        print(f"Regola target name:  {target_rule_name}")
        print(f"Azione DB:           {'UPDATE (overwrite)' if overwrite_rule_id is not None else 'INSERT'}")

        rule_text = input("Inserisci la regola in linguaggio libero: ").strip()
        if not rule_text:
            raise RuleGenerationError("Input regola vuoto.")

        rule_json = _call_openrouter(
            api_key=api_key,
            model=model,
            rule_text=rule_text,
            target_rule_name=target_rule_name,
            rule_type=rule_type,
            schema=schema,
            clinical_pathway_id=clinical_pathway_id,
            clinical_pathway_name=clinical_pathway_name,
        )

        rule_json["rule_id"] = target_rule_name
        rule_json["rule_type"] = rule_type

        if overwrite_rule_id is None:
            db_rule_id = _insert_rule_definition(
                conn,
                clinical_pathway_id=clinical_pathway_id,
                rule_name=target_rule_name,
                rule_body=rule_json,
            )
        else:
            db_rule_id = _update_rule_definition(
                conn,
                existing_rule_id=overwrite_rule_id,
                clinical_pathway_id=clinical_pathway_id,
                rule_name=target_rule_name,
                rule_body=rule_json,
            )

        conn.commit()

        print("\nOperazione completata con successo.")
        print(f"rule_definition.rule_id DB: {db_rule_id}")
        print(f"rule_definition.name:       {target_rule_name}")
        return 0

    except RuleGenerationError as e:
        conn.rollback()
        print(f"Errore generazione: {e}")
        return 1
    except Exception as e:
        conn.rollback()
        print(f"Errore imprevisto: {e}")
        return 1
    finally:
        conn.close()


if __name__ == "__main__":
    raise SystemExit(main())
