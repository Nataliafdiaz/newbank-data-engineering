DROP TABLE IF EXISTS staging.previous_application;

CREATE TABLE staging.previous_application (
    id_solicitud_previa INTEGER PRIMARY KEY,
    id_cliente INTEGER NOT NULL,

    tipo_contrato TEXT,
    monto_anualidad NUMERIC(14,2),
    monto_solicitado NUMERIC(14,2),
    monto_credito NUMERIC(14,2),
    monto_anticipo NUMERIC(14,2),
    precio_bien NUMERIC(14,2),

    dia_semana_solicitud TEXT,
    hora_solicitud SMALLINT,
    ultima_solicitud_por_contrato BOOLEAN,
    ultima_solicitud_del_dia SMALLINT,

    tasa_anticipo NUMERIC(12,6),
    tasa_interes_primaria NUMERIC(12,6),
    tasa_interes_privilegiada NUMERIC(12,6),

    proposito_prestamo TEXT,
    estado_contrato TEXT,
    dias_decision INTEGER,

    tipo_pago TEXT,
    motivo_rechazo TEXT,
    tipo_acompanante TEXT,
    tipo_cliente TEXT,
    categoria_bien TEXT,
    portfolio TEXT,
    tipo_producto TEXT,
    canal_venta TEXT,
    area_vendedor INTEGER,
    industria_vendedor TEXT,
    cantidad_cuotas INTEGER,
    grupo_rendimiento TEXT,
    combinacion_producto TEXT,

    dias_primer_desembolso INTEGER,
    dias_primer_vencimiento INTEGER,
    dias_ultimo_vencimiento_version INTEGER,
    dias_ultimo_vencimiento INTEGER,
    dias_finalizacion INTEGER,

    seguro_solicitado SMALLINT,

    fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO staging.previous_application (
    id_solicitud_previa,
    id_cliente,
    tipo_contrato,
    monto_anualidad,
    monto_solicitado,
    monto_credito,
    monto_anticipo,
    precio_bien,
    dia_semana_solicitud,
    hora_solicitud,
    ultima_solicitud_por_contrato,
    ultima_solicitud_del_dia,
    tasa_anticipo,
    tasa_interes_primaria,
    tasa_interes_privilegiada,
    proposito_prestamo,
    estado_contrato,
    dias_decision,
    tipo_pago,
    motivo_rechazo,
    tipo_acompanante,
    tipo_cliente,
    categoria_bien,
    portfolio,
    tipo_producto,
    canal_venta,
    area_vendedor,
    industria_vendedor,
    cantidad_cuotas,
    grupo_rendimiento,
    combinacion_producto,
    dias_primer_desembolso,
    dias_primer_vencimiento,
    dias_ultimo_vencimiento_version,
    dias_ultimo_vencimiento,
    dias_finalizacion,
    seguro_solicitado
)
SELECT
    sk_id_prev::INTEGER,
    sk_id_curr::INTEGER,

    name_contract_type::TEXT,
    amt_annuity::NUMERIC(14,2),
    amt_application::NUMERIC(14,2),
    amt_credit::NUMERIC(14,2),
    amt_down_payment::NUMERIC(14,2),
    amt_goods_price::NUMERIC(14,2),

    weekday_appr_process_start::TEXT,
    CAST(hour_appr_process_start AS NUMERIC)::SMALLINT,

    CASE
        WHEN flag_last_appl_per_contract = 'Y' THEN TRUE
        WHEN flag_last_appl_per_contract = 'N' THEN FALSE
        ELSE NULL
    END,

    CAST(nflag_last_appl_in_day AS NUMERIC)::SMALLINT,

    rate_down_payment::NUMERIC(12,6),
    rate_interest_primary::NUMERIC(12,6),
    rate_interest_privileged::NUMERIC(12,6),

    name_cash_loan_purpose::TEXT,
    name_contract_status::TEXT,
    CAST(days_decision AS NUMERIC)::INTEGER,

    name_payment_type::TEXT,
    code_reject_reason::TEXT,
    name_type_suite::TEXT,
    name_client_type::TEXT,
    name_goods_category::TEXT,
    name_portfolio::TEXT,
    name_product_type::TEXT,
    channel_type::TEXT,
    CAST(sellerplace_area AS NUMERIC)::INTEGER,
    name_seller_industry::TEXT,
    CAST(cnt_payment AS NUMERIC)::INTEGER,
    name_yield_group::TEXT,
    product_combination::TEXT,

    CASE
        WHEN CAST(days_first_drawing AS NUMERIC)::INTEGER = 365243 THEN NULL
        ELSE CAST(days_first_drawing AS NUMERIC)::INTEGER
    END,

    CASE
        WHEN CAST(days_first_due AS NUMERIC)::INTEGER = 365243 THEN NULL
        ELSE CAST(days_first_due AS NUMERIC)::INTEGER
    END,

    CASE
        WHEN CAST(days_last_due_1st_version AS NUMERIC)::INTEGER = 365243 THEN NULL
        ELSE CAST(days_last_due_1st_version AS NUMERIC)::INTEGER
    END,

    CASE
        WHEN CAST(days_last_due AS NUMERIC)::INTEGER = 365243 THEN NULL
        ELSE CAST(days_last_due AS NUMERIC)::INTEGER
    END,

    CASE
        WHEN CAST(days_termination AS NUMERIC)::INTEGER = 365243 THEN NULL
        ELSE CAST(days_termination AS NUMERIC)::INTEGER
    END,

    CAST(nflag_insured_on_approval AS NUMERIC)::SMALLINT

FROM raw.previous_application;