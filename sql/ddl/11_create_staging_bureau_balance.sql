DROP TABLE IF EXISTS staging.bureau_balance;

CREATE TABLE staging.bureau_balance AS
SELECT
    sk_id_bureau::BIGINT AS id_bureau,
    CAST(months_balance AS NUMERIC)::INTEGER AS meses_balance,
    status::TEXT AS estado_mensual,
    NOW() AS fecha_creacion_staging
FROM raw.bureau_balance;