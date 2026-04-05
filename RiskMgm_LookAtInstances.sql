-- ============================================================
-- RISK MGM - DEBUG/REPORT DECODIFICATO
-- ============================================================

-- 0) Contesto sessione
SELECT
    current_database() AS current_db,
    current_user AS current_user,
    current_schema() AS current_schema,
    now() AS server_time;

-- Se vuoi, puoi forzare lo schema:
SET search_path TO riskm_manager_model_evaluation, public;

-- 1) Compliance instance "decodificata" con lookup
WITH doc_stats AS (
    SELECT
        csd.compliance_instance_id,
        COUNT(*)::int AS supporting_docs_count,
        AVG(csd.confidence)::numeric(5,4) AS supporting_docs_avg_confidence,
        STRING_AGG(csd.document_id::text, ', ' ORDER BY csd.document_id) AS supporting_doc_ids
    FROM compliance_supporting_document csd
    GROUP BY csd.compliance_instance_id
)
SELECT
    ci.compliance_instance_id,
    ci.run_instance_id,
    ri.run_datetime,
    ci.run_date,

    ci.compliance_type_id,
    ct.name AS compliance_type_name,

    ci.model_id,
    m.code AS model_code,

    ci.inference_params_id,
    ip.name AS inference_params_name,
    ip.is_active AS inference_params_active,

    ci.case_id,
    cc.identifier AS case_identifier,

    ci.rule_id,
    COALESCE(rd.body ->> 'rule_id', rd.name) AS rule_code,
    rd.name AS rule_name,

    COALESCE(cp_rule.name, cp_case.name, cp_inf.name) AS clinical_pathway_name,

    ci.confidence,
    ci.quality_score_total,
    ci.quality_score_rationale,
    ci.quality_score_classification,
    ci.computing_time_ms,
    ci.cost_in_dollar,

    ci.body AS compliance_body,
    ci.body ->> 'outcome' AS outcome,
    ci.body ->> 'check_id' AS check_id,
    ci.body ->> 'check_timestamp' AS check_timestamp,

    COALESCE(ds.supporting_docs_count, 0) AS supporting_docs_count,
    ds.supporting_docs_avg_confidence,
    ds.supporting_doc_ids

FROM compliance_instance ci
LEFT JOIN run_instance ri
    ON ri.run_instance_id = ci.run_instance_id
LEFT JOIN compliance_type ct
       ON ct.compliance_type_id = ci.compliance_type_id
LEFT JOIN model m
       ON m.model_id = ci.model_id
LEFT JOIN inference_params ip
       ON ip.inference_params_id = ci.inference_params_id
LEFT JOIN clinical_case cc
       ON cc.case_id = ci.case_id
LEFT JOIN rule_definition rd
       ON rd.rule_id = ci.rule_id
LEFT JOIN clinical_pathway cp_rule
       ON cp_rule.clinical_pathway_id = rd.clinical_pathway_id
LEFT JOIN clinical_pathway cp_case
       ON cp_case.clinical_pathway_id = cc.clinical_pathway_id
LEFT JOIN clinical_pathway cp_inf
       ON cp_inf.clinical_pathway_id = ip.clinical_pathway_id
LEFT JOIN doc_stats ds
       ON ds.compliance_instance_id = ci.compliance_instance_id

ORDER BY ci.compliance_instance_id DESC
LIMIT 200;

-- 2) Tutte le lookup in un'unica vista (ID + codice + nome)
SELECT *
FROM (
    -- compliance_type non ha colonna "code": uso name come codice descrittivo
    SELECT
        'compliance_type'::text AS lookup_table,
        compliance_type_id::text AS lookup_id,
        name AS lookup_code,
        name AS lookup_name
    FROM compliance_type

    UNION ALL

    SELECT
        'model'::text AS lookup_table,
        model_id::text AS lookup_id,
        code AS lookup_code,
        code AS lookup_name
    FROM model

    UNION ALL

    SELECT
        'clinical_pathway'::text AS lookup_table,
        clinical_pathway_id::text AS lookup_id,
        name AS lookup_code,
        name AS lookup_name
    FROM clinical_pathway

    UNION ALL

    SELECT
        'inference_params'::text AS lookup_table,
        inference_params_id::text AS lookup_id,
        name AS lookup_code,
        name AS lookup_name
    FROM inference_params

    UNION ALL

    SELECT
        'clinical_case'::text AS lookup_table,
        case_id::text AS lookup_id,
        identifier AS lookup_code,
        identifier AS lookup_name
    FROM clinical_case

    UNION ALL

    SELECT
        'rule_definition'::text AS lookup_table,
        rule_id::text AS lookup_id,
        COALESCE(body ->> 'rule_id', name) AS lookup_code,
        name AS lookup_name
    FROM rule_definition

    UNION ALL

    SELECT
        'run_instance'::text AS lookup_table,
        run_instance_id::text AS lookup_id,
        to_char(run_datetime, 'YYYY-MM-DD HH24:MI:SSOF') AS lookup_code,
        to_char(run_datetime, 'DD/MM/YY HH24:MI:SS') AS lookup_name
    FROM run_instance
) t
ORDER BY t.lookup_table, t.lookup_id::bigint;