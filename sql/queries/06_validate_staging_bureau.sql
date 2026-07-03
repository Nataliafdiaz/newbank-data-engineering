SELECT
    'conteo_filas' AS validacion,
    (SELECT COUNT(*) FROM raw.bureau) AS total_raw,
    (SELECT COUNT(*) FROM staging.bureau) AS total_staging,
    CASE
        WHEN (SELECT COUNT(*) FROM raw.bureau) =
             (SELECT COUNT(*) FROM staging.bureau)
        THEN 'OK'
        ELSE 'ERROR: diferencia de filas'
    END AS resultado;

SELECT
    'unicidad_id_bureau' AS validacion,
    COUNT(*) AS total_filas,
    COUNT(DISTINCT id_bureau) AS ids_unicos,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT id_bureau)
        THEN 'OK'
        ELSE 'ERROR: id_bureau duplicado'
    END AS resultado
FROM staging.bureau;

SELECT
    'nulos_columnas_criticas' AS validacion,
    COUNT(*) FILTER (WHERE id_cliente IS NULL) AS nulos_id_cliente,
    COUNT(*) FILTER (WHERE id_bureau IS NULL) AS nulos_id_bureau,
    COUNT(*) FILTER (WHERE estado_credito IS NULL) AS nulos_estado_credito,
    COUNT(*) FILTER (WHERE tipo_credito IS NULL) AS nulos_tipo_credito
FROM staging.bureau;

SELECT
    estado_credito,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM staging.bureau
GROUP BY estado_credito
ORDER BY cantidad DESC;

SELECT
    tipo_credito,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM staging.bureau
GROUP BY tipo_credito
ORDER BY cantidad DESC;

SELECT
    'rangos_mora_y_montos' AS validacion,
    MIN(dias_mora) AS dias_mora_minimo,
    MAX(dias_mora) AS dias_mora_maximo,
    MAX(monto_credito_total) AS monto_credito_total_maximo,
    MAX(monto_deuda_actual) AS monto_deuda_actual_maximo,
    MAX(monto_vencido) AS monto_vencido_maximo
FROM staging.bureau;

SELECT
    'nulos_montos_relevantes' AS validacion,
    COUNT(*) FILTER (WHERE monto_credito_total IS NULL) AS nulos_monto_credito_total,
    COUNT(*) FILTER (WHERE monto_deuda_actual IS NULL) AS nulos_monto_deuda_actual,
    COUNT(*) FILTER (WHERE monto_vencido IS NULL) AS nulos_monto_vencido,
    COUNT(*) FILTER (WHERE monto_anualidad IS NULL) AS nulos_monto_anualidad
FROM staging.bureau;