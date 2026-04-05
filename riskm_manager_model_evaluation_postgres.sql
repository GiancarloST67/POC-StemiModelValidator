BEGIN;

CREATE SCHEMA IF NOT EXISTS riskm_manager_model_evaluation;
SET search_path TO riskm_manager_model_evaluation, public;

/*
Entity: Model
*/
CREATE TABLE IF NOT EXISTS model (
    model_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    max_runaway_tokens INTEGER,
    providers JSONB,
    CONSTRAINT ck_model_max_runaway_tokens
        CHECK (max_runaway_tokens IS NULL OR max_runaway_tokens > 0)
);

/*
Seed data: models from check_rules_openrouter.py
- DEFAULT_GOLD_MODEL
- DEFAULT_RATIONALE_ALIGNMENT_MODEL
- COMPARISON_MODELS
- runaway caps from RUNAWAY_TOKEN_LIMITS_BY_MODEL
- providers from _provider_for_model
*/
INSERT INTO model (code, max_runaway_tokens, providers)
VALUES
    ('anthropic/claude-opus-4.6', NULL, NULL),
    ('anthropic/claude-sonnet-4.6', NULL, NULL),
    ('qwen/qwen3.5-35b-a3b', 10000, NULL),
    ('google/gemini-3-flash-preview', NULL, '{"order":["google-vertex"],"allow_fallbacks":false}'::jsonb),
    ('google/gemini-3.1-flash-lite-preview', 10000, '{"order":["google-vertex"],"allow_fallbacks":false}'::jsonb),
    ('google/gemini-3.1-pro-preview', NULL, '{"order":["google-vertex"],"allow_fallbacks":false}'::jsonb),
    ('openai/gpt-oss-120b', NULL, '{"order":["baseten/fp4"],"allow_fallbacks":false}'::jsonb),
    ('openai/gpt-5.4', NULL, NULL),
    ('anthropic/claude-haiku-4.5', NULL, NULL),
    ('anthropic/claude-sonnet-4.5', NULL, NULL),
    ('deepseek/deepseek-v3.2', NULL, NULL),
    ('z-ai/glm-5', NULL, NULL),
    ('mistralai/mistral-small-2603', NULL, NULL),
    ('x-ai/grok-4.1-fast', NULL, NULL),
    ('google/gemma-4-26b-a4b-it', NULL, '{"order":["novita/bf16"],"allow_fallbacks":false}'::jsonb),
    ('google/gemma-4-31b-it', NULL, NULL),
    ('openai/gpt-5.4-pro', NULL, NULL),
    ('z-ai/glm-5-turbo', NULL, NULL),
    ('meta-llama/llama-3.3-70b-instruct', NULL, NULL),
    ('mistralai/mistral-small-3.2-24b-instruct', NULL, NULL),
    ('qwen/qwen3.5-flash-02-23', NULL, NULL),
    ('qwen/qwen3.5-9b', NULL, NULL),
    ('qwen/qwen3.5-27b', NULL, NULL),
    ('qwen/qwen3.6-plus:free', NULL, NULL),
    ('openai/gpt-oss-safeguard-20b:nitro', NULL, NULL),
    ('meta-llama/llama-3.1-8b-instruct:nitro', NULL, NULL),
    ('z-ai/glm-4.7', NULL, NULL),
    ('qwen/qwen3-235b-a22b-2507', 10000, NULL),
    ('moonshotai/kimi-k2.5', NULL, NULL)
ON CONFLICT (code) DO UPDATE
SET
    max_runaway_tokens = EXCLUDED.max_runaway_tokens,
    providers = EXCLUDED.providers;

/*
Entity: ClinicalPathway
*/
CREATE TABLE IF NOT EXISTS clinical_pathway (
    clinical_pathway_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    prompt1 TEXT
);

/*
Entity: InferenceParams
Relation: many InferenceParams -> one ClinicalPathway
*/
CREATE TABLE IF NOT EXISTS inference_params (
    inference_params_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clinical_pathway_id BIGINT NOT NULL
        REFERENCES clinical_pathway (clinical_pathway_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    name TEXT NOT NULL,
    prompt1 TEXT,
    json_schema1 JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_inference_params_name_per_pathway
        UNIQUE (clinical_pathway_id, name)
);

/*
Entity: ComplianceType
*/
CREATE TABLE IF NOT EXISTS compliance_type (
    compliance_type_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

/*
Seed data: compliance outcomes from check_rule_schema.json (outcome enum).
*/
INSERT INTO compliance_type (name)
VALUES
    ('compliant'),
    ('non_compliant'),
    ('justified_deviation'),
    ('not_applicable'),
    ('not_evaluable'),
    ('probable_non_compliance')
ON CONFLICT (name) DO NOTHING;

/*
Entity: Case
PostgreSQL-safe name used: clinical_case
Relation: many Case -> one ClinicalPathway
*/
CREATE TABLE IF NOT EXISTS clinical_case (
    case_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clinical_pathway_id BIGINT NOT NULL
        REFERENCES clinical_pathway (clinical_pathway_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    identifier TEXT NOT NULL,
    body JSONB NOT NULL,
    CONSTRAINT uq_case_identifier_per_pathway
        UNIQUE (clinical_pathway_id, identifier)
);

/*
Entity: Rule
PostgreSQL-safe name used: rule_definition
Relation: many Rule -> one ClinicalPathway
*/
CREATE TABLE IF NOT EXISTS rule_definition (
    rule_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clinical_pathway_id BIGINT NOT NULL
        REFERENCES clinical_pathway (clinical_pathway_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    name TEXT NOT NULL,
    body JSONB NOT NULL,
    CONSTRAINT uq_rule_name_per_pathway
        UNIQUE (clinical_pathway_id, name)
);

/*
Entity: Document
Relation: many Document -> one Case
*/
CREATE TABLE IF NOT EXISTS document (
    document_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id BIGINT NOT NULL
        REFERENCES clinical_case (case_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    document_date DATE,
    body JSONB NOT NULL
);

/*
Entity: ComplianceInstance
Relations:
- many ComplianceInstance -> one Model
- many ComplianceInstance -> one InferenceParams
- many ComplianceInstance -> one ComplianceType
- many ComplianceInstance -> one Case
- many ComplianceInstance -> one Rule
*/
CREATE TABLE IF NOT EXISTS compliance_instance (
    compliance_instance_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    compliance_type_id SMALLINT NOT NULL
        REFERENCES compliance_type (compliance_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    model_id BIGINT NOT NULL
        REFERENCES model (model_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    inference_params_id BIGINT NOT NULL
        REFERENCES inference_params (inference_params_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    case_id BIGINT NOT NULL
        REFERENCES clinical_case (case_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    rule_id BIGINT NOT NULL
        REFERENCES rule_definition (rule_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    body JSONB NOT NULL,
    confidence NUMERIC(5,4),
    quality_score_total NUMERIC(4,2),
    quality_score_rationale NUMERIC(4,2),
    quality_score_classification NUMERIC(4,2),
    computing_time_ms INTEGER,
    cost_in_dollar NUMERIC(12,6),
    run_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_compliance_instance_confidence
        CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    CONSTRAINT ck_compliance_instance_qs_total
        CHECK (quality_score_total IS NULL OR (quality_score_total >= 0 AND quality_score_total <= 10)),
    CONSTRAINT ck_compliance_instance_qs_rationale
        CHECK (quality_score_rationale IS NULL OR (quality_score_rationale >= 0 AND quality_score_rationale <= 10)),
    CONSTRAINT ck_compliance_instance_qs_classification
        CHECK (quality_score_classification IS NULL OR (quality_score_classification >= 0 AND quality_score_classification <= 10)),
    CONSTRAINT ck_compliance_instance_computing_time_ms
        CHECK (computing_time_ms IS NULL OR computing_time_ms >= 0),
    CONSTRAINT ck_compliance_instance_cost
        CHECK (cost_in_dollar IS NULL OR cost_in_dollar >= 0)
);

/*
Entity: ComplianceSupportingDocument
Bridge relation between ComplianceInstance and Document
*/
CREATE TABLE IF NOT EXISTS compliance_supporting_document (
    compliance_instance_id BIGINT NOT NULL
        REFERENCES compliance_instance (compliance_instance_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    document_id BIGINT NOT NULL
        REFERENCES document (document_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    rationale TEXT,
    confidence NUMERIC(5,4),
    CONSTRAINT pk_compliance_supporting_document
        PRIMARY KEY (compliance_instance_id, document_id),
    CONSTRAINT ck_compliance_supporting_document_confidence
        CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1))
);

CREATE INDEX IF NOT EXISTS ix_inference_params_pathway
    ON inference_params (clinical_pathway_id);

CREATE INDEX IF NOT EXISTS ix_clinical_case_pathway
    ON clinical_case (clinical_pathway_id);

CREATE INDEX IF NOT EXISTS ix_rule_definition_pathway
    ON rule_definition (clinical_pathway_id);

CREATE INDEX IF NOT EXISTS ix_document_case
    ON document (case_id);

CREATE INDEX IF NOT EXISTS ix_compliance_instance_model
    ON compliance_instance (model_id);

CREATE INDEX IF NOT EXISTS ix_compliance_instance_inference_params
    ON compliance_instance (inference_params_id);

CREATE INDEX IF NOT EXISTS ix_compliance_instance_case
    ON compliance_instance (case_id);

CREATE INDEX IF NOT EXISTS ix_compliance_instance_rule
    ON compliance_instance (rule_id);

CREATE INDEX IF NOT EXISTS ix_compliance_instance_run_date
    ON compliance_instance (run_date);

CREATE INDEX IF NOT EXISTS ix_compliance_supporting_document_document
    ON compliance_supporting_document (document_id);

COMMIT;
