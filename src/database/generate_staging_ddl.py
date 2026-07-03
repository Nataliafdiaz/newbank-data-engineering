from pathlib import Path


RUTA_BASE = Path(__file__).resolve().parents[2]
RUTA_DDL = RUTA_BASE / "sql" / "ddl"


TABLAS_STAGING = {
    "previous_application": "07_create_staging_previous_application.sql",
    "pos_cash_balance": "08_create_staging_pos_cash_balance.sql",
    "installments_payments": "09_create_staging_installments_payments.sql",
    "credit_card_balance": "10_create_staging_credit_card_balance.sql",
    "bureau_balance": "11_create_staging_bureau_balance.sql",
    "application_test": "12_create_staging_application_test.sql",
}


def generar_script_basico(nombre_tabla_raw: str, nombre_archivo: str) -> None:
    ruta_salida = RUTA_DDL / nombre_archivo

    contenido = f"""-- =============================================================
-- ARCHIVO: {nombre_archivo}
-- OBJETIVO: Crear tabla staging.{nombre_tabla_raw}
-- ORIGEN: raw.{nombre_tabla_raw}
-- NOTA: Script base generado automáticamente. Revisar tipos antes de ejecutar.
-- =============================================================

DROP TABLE IF EXISTS staging.{nombre_tabla_raw};

CREATE TABLE staging.{nombre_tabla_raw} AS
SELECT
    *
FROM raw.{nombre_tabla_raw};

ALTER TABLE staging.{nombre_tabla_raw}
ADD COLUMN fecha_creacion_staging TIMESTAMP NOT NULL DEFAULT NOW();
"""

    ruta_salida.write_text(contenido, encoding="utf-8")
    print(f"Generado: {ruta_salida}")


def main() -> None:
    RUTA_DDL.mkdir(parents=True, exist_ok=True)

    for tabla, archivo in TABLAS_STAGING.items():
        generar_script_basico(tabla, archivo)

    print("Scripts base de staging generados correctamente.")


if __name__ == "__main__":
    main()