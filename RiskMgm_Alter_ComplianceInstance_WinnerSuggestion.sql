-- Add retrospective result columns to compliance_instance (idempotent).

ALTER TABLE riskm_manager_model_evaluation.compliance_instance
    ADD COLUMN IF NOT EXISTS winner text,
    ADD COLUMN IF NOT EXISTS suggestion text;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_compliance_instance_winner'
          AND conrelid = 'riskm_manager_model_evaluation.compliance_instance'::regclass
    ) THEN
        ALTER TABLE riskm_manager_model_evaluation.compliance_instance
            ADD CONSTRAINT ck_compliance_instance_winner
            CHECK (winner IS NULL OR winner IN ('GOLD', 'CHECK', 'NONE'));
    END IF;
END
$$;

COMMENT ON COLUMN riskm_manager_model_evaluation.compliance_instance.winner
    IS 'Winner della retrospettiva: GOLD | CHECK | NONE.';

COMMENT ON COLUMN riskm_manager_model_evaluation.compliance_instance.suggestion
    IS 'Suggerimenti per migliorare il prompt di check in caso di scoring basso.';
