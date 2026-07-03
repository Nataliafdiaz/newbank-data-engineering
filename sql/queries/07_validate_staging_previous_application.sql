-- ============================================================
-- Validación 1: Conteo de registros
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM raw.previous_application) AS total_raw,
    (SELECT COUNT(*) FROM staging.previous_application) AS total_staging,
    CASE
        WHEN (SELECT COUNT(*) FROM raw.previous_application) =
             (SELECT COUNT(*) FROM staging.previous_application)
        THEN 'OK'
        ELSE 'ERROR'
    END AS resultado;

-- ============================================================
-- Validación 2: Clave primaria
-- ============================================================

SELECT
    COUNT(*) AS total_filas,
    COUNT(DISTINCT id_solicitud_previa) AS ids_unicos,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT id_solicitud_previa)
        THEN 'OK'
        ELSE 'ERROR'
    END AS resultado
FROM staging.previous_application;

-- ============================================================
-- Validación 3: IDs obligatorios
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE id_cliente IS NULL) AS clientes_nulos,
    COUNT(*) FILTER (WHERE id_solicitud_previa IS NULL) AS solicitudes_nulas
FROM staging.previous_application;

-- ============================================================
-- Validación 4: Estados del contrato
-- ============================================================

SELECT
    estado_contrato,
    COUNT(*) AS cantidad
FROM staging.previous_application
GROUP BY estado_contrato
ORDER BY cantidad DESC;

-- ============================================================
-- Validación 5: Rangos monetarios
-- ============================================================

SELECT
    MIN(monto_credito) AS minimo_credito,
    MAX(monto_credito) AS maximo_credito,
    MIN(monto_solicitado) AS minimo_solicitado,
    MAX(monto_solicitado) AS maximo_solicitado
FROM staging.previous_application;