DROP TABLE IF EXISTS staging.pos_cash_balance;

CREATE TABLE staging.pos_cash_balance (
    id_solicitud_previa INTEGER,
    id_cliente INTEGER,
    mes_balance INTEGER,
    cuotas_restantes INTEGER,
    cuotas_futuras INTEGER,
    estado_contrato TEXT,
    dias_atraso_pago INTEGER,
    dias_atraso_pago_definitivo INTEGER,
    fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO staging.pos_cash_balance (
    id_solicitud_previa,
    id_cliente,
    mes_balance,
    cuotas_restantes,
    cuotas_futuras,
    estado_contrato,
    dias_atraso_pago,
    dias_atraso_pago_definitivo
)
SELECT
    sk_id_prev::INTEGER,
    sk_id_curr::INTEGER,
    CAST(months_balance AS NUMERIC)::INTEGER,
    ROUND(cnt_instalment::NUMERIC)::INTEGER,
    ROUND(cnt_instalment_future::NUMERIC)::INTEGER,
    name_contract_status::TEXT,
    ROUND(sk_dpd::NUMERIC)::INTEGER,
    ROUND(sk_dpd_def::NUMERIC)::INTEGER
FROM raw.pos_cash_balance;