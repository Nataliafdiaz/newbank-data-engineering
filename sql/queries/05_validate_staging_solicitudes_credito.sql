-- =============================================================
-- ARCHIVO: 05_validate_staging_solicitudes_credito.sql
-- SCHEMA:  staging
-- TABLA:   solicitudes_credito
-- ORIGEN:  raw.application_train
-- OBJETIVO: Validar integridad, tipado y calidad de la capa staging
-- AUTOR:   Natalia
-- FECHA:   2026-07-02
-- =============================================================

SELECT
    'conteo_filas' AS validacion,
    (SELECT COUNT(*) FROM raw.application_train)       AS total_raw,
    (SELECT COUNT(*) FROM staging.solicitudes_credito) AS total_staging,
    CASE
        WHEN (SELECT COUNT(*) FROM raw.application_train) =
             (SELECT COUNT(*) FROM staging.solicitudes_credito)
        THEN 'OK'
        ELSE 'ERROR: diferencia de filas'
    END AS resultado;

SELECT
    'unicidad_pk' AS validacion,
    COUNT(*) AS total_filas,
    COUNT(DISTINCT id_solicitud) AS ids_unicos,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT id_solicitud)
        THEN 'OK'
        ELSE 'ERROR: hay id_solicitud duplicados'
    END AS resultado
FROM staging.solicitudes_credito;

SELECT
    'variable_objetivo' AS validacion,
    incumplio_pago,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM staging.solicitudes_credito
GROUP BY incumplio_pago
ORDER BY incumplio_pago;

SELECT
    'nulos_columnas_criticas' AS validacion,
    COUNT(*) FILTER (WHERE ingreso_total IS NULL) AS nulos_ingreso_total,
    COUNT(*) FILTER (WHERE monto_credito IS NULL) AS nulos_monto_credito,
    COUNT(*) FILTER (WHERE monto_anualidad IS NULL) AS nulos_monto_anualidad,
    COUNT(*) FILTER (WHERE precio_bien IS NULL) AS nulos_precio_bien,
    COUNT(*) FILTER (WHERE score_externo_2 IS NULL) AS nulos_score_ext_2
FROM staging.solicitudes_credito;

SELECT
    'rangos_variables_temporales' AS validacion,
    MIN(edad_anios) AS edad_minima,
    MAX(edad_anios) AS edad_maxima,
    ROUND(AVG(edad_anios), 2) AS edad_promedio,
    MIN(antiguedad_laboral_anios) AS antiguedad_minima,
    MAX(antiguedad_laboral_anios) AS antiguedad_maxima,
    ROUND(AVG(antiguedad_laboral_anios), 2) AS antiguedad_promedio
FROM staging.solicitudes_credito;

SELECT
    'centinela_dias_empleado' AS validacion,
    COUNT(*) FILTER (WHERE dias_empleado = 365243) AS filas_con_centinela,
    COUNT(*) FILTER (WHERE dias_empleado IS NULL) AS filas_nulas,
    CASE
        WHEN COUNT(*) FILTER (WHERE dias_empleado = 365243) = 0
        THEN 'OK: centinela correctamente convertido a NULL'
        ELSE 'ERROR: quedan filas con valor centinela 365243'
    END AS resultado
FROM staging.solicitudes_credito;

SELECT
    'flags_booleanos' AS validacion,
    COUNT(*) FILTER (WHERE tiene_auto IS NULL) AS nulos_tiene_auto,
    COUNT(*) FILTER (WHERE tiene_propiedad IS NULL) AS nulos_tiene_propiedad,
    CASE
        WHEN COUNT(*) FILTER (WHERE tiene_auto IS NULL) = 0
         AND COUNT(*) FILTER (WHERE tiene_propiedad IS NULL) = 0
        THEN 'OK'
        ELSE 'ADVERTENCIA: existen NULLs en flags booleanos'
    END AS resultado
FROM staging.solicitudes_credito;

SELECT
    'ratios_financieros' AS validacion,
    COUNT(*) FILTER (WHERE ratio_credito_ingreso < 0) AS ratios_credito_negativos,
    COUNT(*) FILTER (WHERE ratio_anualidad_ingreso < 0) AS ratios_anualidad_negativos,
    COUNT(*) FILTER (WHERE ratio_credito_ingreso IS NULL) AS nulos_ratio_credito,
    COUNT(*) FILTER (WHERE ratio_anualidad_ingreso IS NULL) AS nulos_ratio_anualidad,
    COUNT(*) FILTER (WHERE ratio_credito_ingreso > 20) AS ratios_credito_mayor_20,
    MAX(ratio_credito_ingreso) AS ratio_credito_maximo,
    MAX(ratio_anualidad_ingreso) AS ratio_anualidad_maximo
FROM staging.solicitudes_credito;