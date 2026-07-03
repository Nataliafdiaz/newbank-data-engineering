DROP TABLE IF EXISTS staging.solicitudes_credito;

CREATE TABLE staging.solicitudes_credito (
    id_solicitud INTEGER PRIMARY KEY,
    incumplio_pago SMALLINT NOT NULL CHECK (incumplio_pago IN (0, 1)),

    tipo_contrato TEXT,
    genero TEXT,
    tiene_auto BOOLEAN,
    tiene_propiedad BOOLEAN,

    cantidad_hijos INTEGER,
    ingreso_total NUMERIC(14,2),
    monto_credito NUMERIC(14,2),
    monto_anualidad NUMERIC(14,2),
    precio_bien NUMERIC(14,2),

    tipo_ingreso TEXT,
    nivel_educativo TEXT,
    estado_civil TEXT,
    tipo_vivienda TEXT,
    ocupacion TEXT,

    dias_nacimiento INTEGER,
    edad_anios NUMERIC(5,2),

    dias_empleado INTEGER,
    antiguedad_laboral_anios NUMERIC(6,2),

    cantidad_miembros_familia NUMERIC(6,2),
    rating_region_cliente SMALLINT,

    score_externo_1 NUMERIC(10,6),
    score_externo_2 NUMERIC(10,6),
    score_externo_3 NUMERIC(10,6),

    ratio_credito_ingreso NUMERIC(14,6),
    ratio_anualidad_ingreso NUMERIC(14,6),

    fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO staging.solicitudes_credito (
    id_solicitud,
    incumplio_pago,
    tipo_contrato,
    genero,
    tiene_auto,
    tiene_propiedad,
    cantidad_hijos,
    ingreso_total,
    monto_credito,
    monto_anualidad,
    precio_bien,
    tipo_ingreso,
    nivel_educativo,
    estado_civil,
    tipo_vivienda,
    ocupacion,
    dias_nacimiento,
    edad_anios,
    dias_empleado,
    antiguedad_laboral_anios,
    cantidad_miembros_familia,
    rating_region_cliente,
    score_externo_1,
    score_externo_2,
    score_externo_3,
    ratio_credito_ingreso,
    ratio_anualidad_ingreso
)
SELECT
    sk_id_curr::INTEGER AS id_solicitud,
    target::SMALLINT AS incumplio_pago,

    name_contract_type::TEXT AS tipo_contrato,
    code_gender::TEXT AS genero,

    CASE
        WHEN flag_own_car = 'Y' THEN TRUE
        WHEN flag_own_car = 'N' THEN FALSE
        ELSE NULL
    END AS tiene_auto,

    CASE
        WHEN flag_own_realty = 'Y' THEN TRUE
        WHEN flag_own_realty = 'N' THEN FALSE
        ELSE NULL
    END AS tiene_propiedad,

    cnt_children::INTEGER AS cantidad_hijos,
    amt_income_total::NUMERIC(14,2) AS ingreso_total,
    amt_credit::NUMERIC(14,2) AS monto_credito,
    amt_annuity::NUMERIC(14,2) AS monto_anualidad,
    amt_goods_price::NUMERIC(14,2) AS precio_bien,

    name_income_type::TEXT AS tipo_ingreso,
    name_education_type::TEXT AS nivel_educativo,
    name_family_status::TEXT AS estado_civil,
    name_housing_type::TEXT AS tipo_vivienda,
    occupation_type::TEXT AS ocupacion,

    days_birth::INTEGER AS dias_nacimiento,
    ROUND(ABS(days_birth::NUMERIC) / 365.25, 2) AS edad_anios,

    CASE
        WHEN days_employed::INTEGER = 365243 THEN NULL
        ELSE days_employed::INTEGER
    END AS dias_empleado,

    CASE
        WHEN days_employed::INTEGER = 365243 THEN NULL
        ELSE ROUND(ABS(days_employed::NUMERIC) / 365.25, 2)
    END AS antiguedad_laboral_anios,

    cnt_fam_members::NUMERIC(6,2) AS cantidad_miembros_familia,
    region_rating_client::SMALLINT AS rating_region_cliente,

    ext_source_1::NUMERIC(10,6) AS score_externo_1,
    ext_source_2::NUMERIC(10,6) AS score_externo_2,
    ext_source_3::NUMERIC(10,6) AS score_externo_3,

    ROUND(amt_credit::NUMERIC / NULLIF(amt_income_total::NUMERIC, 0), 6) AS ratio_credito_ingreso,
    ROUND(amt_annuity::NUMERIC / NULLIF(amt_income_total::NUMERIC, 0), 6) AS ratio_anualidad_ingreso

FROM raw.application_train;