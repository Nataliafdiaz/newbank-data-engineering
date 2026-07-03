DROP TABLE IF EXISTS staging.bureau;

CREATE TABLE staging.bureau (
    id_cliente INTEGER NOT NULL,
    id_bureau INTEGER PRIMARY KEY,

    estado_credito TEXT,
    moneda_credito TEXT,

    dias_credito INTEGER,
    dias_mora INTEGER,
    dias_fin_credito_estimado INTEGER,
    dias_fin_credito_real INTEGER,

    monto_maximo_mora NUMERIC(14,2),
    cantidad_prorrogas INTEGER,
    monto_credito_total NUMERIC(14,2),
    monto_deuda_actual NUMERIC(14,2),
    monto_limite_credito NUMERIC(14,2),
    monto_vencido NUMERIC(14,2),

    tipo_credito TEXT,
    dias_actualizacion_credito INTEGER,
    monto_anualidad NUMERIC(14,2),

    fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO staging.bureau (
    id_cliente,
    id_bureau,
    estado_credito,
    moneda_credito,
    dias_credito,
    dias_mora,
    dias_fin_credito_estimado,
    dias_fin_credito_real,
    monto_maximo_mora,
    cantidad_prorrogas,
    monto_credito_total,
    monto_deuda_actual,
    monto_limite_credito,
    monto_vencido,
    tipo_credito,
    dias_actualizacion_credito,
    monto_anualidad
)
SELECT
    sk_id_curr::INTEGER AS id_cliente,
    sk_id_bureau::INTEGER AS id_bureau,

    credit_active::TEXT AS estado_credito,
    credit_currency::TEXT AS moneda_credito,

    CAST(days_credit AS NUMERIC)::INTEGER AS dias_credito,
    CAST(credit_day_overdue AS NUMERIC)::INTEGER AS dias_mora,
    CAST(days_credit_enddate AS NUMERIC)::INTEGER AS dias_fin_credito_estimado,
    CAST(days_enddate_fact AS NUMERIC)::INTEGER AS dias_fin_credito_real,

    amt_credit_max_overdue::NUMERIC(14,2) AS monto_maximo_mora,
    CAST(cnt_credit_prolong AS NUMERIC)::INTEGER AS cantidad_prorrogas,
    amt_credit_sum::NUMERIC(14,2) AS monto_credito_total,
    amt_credit_sum_debt::NUMERIC(14,2) AS monto_deuda_actual,
    amt_credit_sum_limit::NUMERIC(14,2) AS monto_limite_credito,
    amt_credit_sum_overdue::NUMERIC(14,2) AS monto_vencido,

    credit_type::TEXT AS tipo_credito,
    CAST(days_credit_update AS NUMERIC)::INTEGER AS dias_actualizacion_credito,
    amt_annuity::NUMERIC(14,2) AS monto_anualidad

FROM raw.bureau;