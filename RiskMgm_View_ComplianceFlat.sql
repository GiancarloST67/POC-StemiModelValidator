-- ============================================================
-- VIEW: v_compliance_instance_flat
-- Compliance instance denormalizzata con tutte le lookup risolte
-- Schema: riskm_manager_model_evaluation
-- ============================================================

CREATE OR REPLACE VIEW riskm_manager_model_evaluation.v_compliance_instance_flat AS
WITH doc_stats AS (
    SELECT
        csd.compliance_instance_id,
        COUNT(*)::int                                                        AS supporting_docs_count,
        AVG(csd.confidence)::numeric(5,4)                                   AS supporting_docs_avg_confidence,
        STRING_AGG(csd.document_id::text, ', ' ORDER BY csd.document_id)    AS supporting_doc_ids
    FROM riskm_manager_model_evaluation.compliance_supporting_document csd
    GROUP BY csd.compliance_instance_id
)
SELECT
    -- ── chiavi primarie / run ──────────────────────────────────────────────
    ci.compliance_instance_id,
    ci.run_instance_id,
    ri.run_datetime,
    ci.run_date,

    -- ── compliance_type ───────────────────────────────────────────────────
    ci.compliance_type_id,
    ct.name                                         AS compliance_type_name,

    -- ── model ─────────────────────────────────────────────────────────────
    ci.model_id,
    m.code                                          AS model_code,

    -- ── inference_params ──────────────────────────────────────────────────
    ci.inference_params_id,
    ip.name                                         AS inference_params_name,
    ip.is_active                                    AS inference_params_active,
    ip.clinical_pathway_id                          AS inference_params_clinical_pathway_id,
    cp_inf.name                                     AS inference_params_clinical_pathway_name,

    -- ── clinical_case ─────────────────────────────────────────────────────
    ci.case_id,
    cc.identifier                                   AS case_identifier,
    cc.clinical_pathway_id                          AS case_clinical_pathway_id,
    cp_case.name                                    AS case_clinical_pathway_name,

    -- ── rule_definition ───────────────────────────────────────────────────
    ci.rule_id,
    COALESCE(rd.body ->> 'rule_id', rd.name)        AS rule_code,
    rd.name                                         AS rule_name,
    rd.clinical_pathway_id                          AS rule_clinical_pathway_id,
    cp_rule.name                                    AS rule_clinical_pathway_name,

    -- ── clinical_pathway "prevalente" (rule > case > inference_params) ────
    COALESCE(cp_rule.name, cp_case.name, cp_inf.name) AS clinical_pathway_name,

    -- ── metriche compliance ───────────────────────────────────────────────
    ci.confidence,
    ci.quality_score_total,
    ci.quality_score_rationale,
    ci.quality_score_classification,
    ci.computing_time_ms,
    ci.cost_in_dollar,

    -- ── campi JSON estratti dal body ──────────────────────────────────────
    ci.body                                         AS compliance_body,
    ci.body ->> 'outcome'                           AS outcome,
    ci.body ->> 'check_id'                          AS check_id,
    ci.body ->> 'check_timestamp'                   AS check_timestamp,

    -- ── documenti di supporto (aggregati) ────────────────────────────────
    COALESCE(ds.supporting_docs_count, 0)           AS supporting_docs_count,
    ds.supporting_docs_avg_confidence,
    ds.supporting_doc_ids

FROM riskm_manager_model_evaluation.compliance_instance ci

LEFT JOIN riskm_manager_model_evaluation.run_instance ri
       ON ri.run_instance_id = ci.run_instance_id

LEFT JOIN riskm_manager_model_evaluation.compliance_type ct
       ON ct.compliance_type_id = ci.compliance_type_id

LEFT JOIN riskm_manager_model_evaluation.model m
       ON m.model_id = ci.model_id

LEFT JOIN riskm_manager_model_evaluation.inference_params ip
       ON ip.inference_params_id = ci.inference_params_id

LEFT JOIN riskm_manager_model_evaluation.clinical_pathway cp_inf
       ON cp_inf.clinical_pathway_id = ip.clinical_pathway_id

LEFT JOIN riskm_manager_model_evaluation.clinical_case cc
       ON cc.case_id = ci.case_id

LEFT JOIN riskm_manager_model_evaluation.clinical_pathway cp_case
       ON cp_case.clinical_pathway_id = cc.clinical_pathway_id

LEFT JOIN riskm_manager_model_evaluation.rule_definition rd
       ON rd.rule_id = ci.rule_id

LEFT JOIN riskm_manager_model_evaluation.clinical_pathway cp_rule
       ON cp_rule.clinical_pathway_id = rd.clinical_pathway_id

LEFT JOIN doc_stats ds
       ON ds.compliance_instance_id = ci.compliance_instance_id;

-- ── utilizzo tipico ───────────────────────────────────────────────────────
-- SELECT * FROM riskm_manager_model_evaluation.v_compliance_instance_flat
-- ORDER BY compliance_instance_id DESC
-- LIMIT 200;
