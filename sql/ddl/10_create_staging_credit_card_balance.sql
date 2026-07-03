DROP TABLE IF EXISTS staging.credit_card_balance;

CREATE TABLE staging.credit_card_balance AS
SELECT
    sk_id_prev::BIGINT AS id_solicitud_previa,
    sk_id_curr::BIGINT AS id_cliente,
    CAST(months_balance AS NUMERIC)::INTEGER AS meses_balance,

    amt_balance::NUMERIC(14,2) AS saldo_actual,
    amt_credit_limit_actual::NUMERIC(14,2) AS limite_credito,
    amt_drawings_atm_current::NUMERIC(14,2) AS extraccion_atm,
    amt_drawings_current::NUMERIC(14,2) AS extracciones_total,
    amt_drawings_other_current::NUMERIC(14,2) AS otras_extracciones,
    amt_drawings_pos_current::NUMERIC(14,2) AS compras_pos,

    amt_inst_min_regularity::NUMERIC(14,2) AS pago_minimo,
    amt_payment_current::NUMERIC(14,2) AS pago_actual,
    amt_payment_total_current::NUMERIC(14,2) AS pago_total_actual,

    amt_receivable_principal::NUMERIC(14,2) AS capital_pendiente,
    amt_recivable::NUMERIC(14,2) AS monto_pendiente,
    amt_total_receivable::NUMERIC(14,2) AS deuda_total,

    ROUND(cnt_drawings_atm_current::NUMERIC)::INTEGER AS cant_extracciones_atm,
    ROUND(cnt_drawings_current::NUMERIC)::INTEGER AS cant_extracciones_total,
    ROUND(cnt_drawings_other_current::NUMERIC)::INTEGER AS cant_otras_extracciones,
    ROUND(cnt_drawings_pos_current::NUMERIC)::INTEGER AS cant_compras_pos,
    ROUND(cnt_instalment_mature_cum::NUMERIC)::INTEGER AS cuotas_vencidas,

    name_contract_status::TEXT AS estado_contrato,

    ROUND(sk_dpd::NUMERIC)::INTEGER AS dias_mora,
    ROUND(sk_dpd_def::NUMERIC)::INTEGER AS dias_mora_definidos,

    NOW() AS fecha_creacion_staging
FROM raw.credit_card_balance;