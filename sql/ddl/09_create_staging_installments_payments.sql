DROP TABLE IF EXISTS staging.installments_payments;

CREATE TABLE staging.installments_payments (
    id_solicitud_previa INTEGER,
    id_cliente INTEGER,

    version_plan_cuotas INTEGER,
    numero_cuota INTEGER,

    dias_vencimiento INTEGER,
    dias_pago INTEGER,

    monto_cuota NUMERIC(14,2),
    monto_pagado NUMERIC(14,2),

    fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO staging.installments_payments (
    id_solicitud_previa,
    id_cliente,
    version_plan_cuotas,
    numero_cuota,
    dias_vencimiento,
    dias_pago,
    monto_cuota,
    monto_pagado
)
SELECT
    sk_id_prev::INTEGER,
    sk_id_curr::INTEGER,

    ROUND(num_instalment_version::NUMERIC)::INTEGER,
    ROUND(num_instalment_number::NUMERIC)::INTEGER,

    ROUND(days_instalment::NUMERIC)::INTEGER,
    ROUND(days_entry_payment::NUMERIC)::INTEGER,

    amt_instalment::NUMERIC(14,2),
    amt_payment::NUMERIC(14,2)
FROM raw.installments_payments;