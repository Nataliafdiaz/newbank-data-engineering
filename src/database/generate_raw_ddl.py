from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"
DDL_OUTPUT_DIR = PROJECT_ROOT / "sql" / "ddl"

OUTPUT_FILES = {
    "schema": DDL_OUTPUT_DIR / "01_create_schema.sql",
    "tables": DDL_OUTPUT_DIR / "02_create_tables.sql",
    "constraints": DDL_OUTPUT_DIR / "03_constraints.sql",
    "indexes": DDL_OUTPUT_DIR / "04_index.sql",
}


def normalize_table_name(file_path: Path) -> str:
    return file_path.stem.lower()


def build_header(file_name: str, description: str) -> str:
    return f"""-- ==========================================================
-- NewBank Credit Decision Platform
-- Modelo Físico de Datos
-- Archivo: {file_name}
-- Descripción: {description}
-- Generado automáticamente mediante generate_raw_ddl.py.
-- ==========================================================
"""


def generate_schema() -> str:
    return f"""{build_header(
        "01_create_schema.sql",
        "Crea los schemas principales de la base de datos."
    )}
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytical;
"""


def generate_create_table(file_path: Path) -> str:
    table_name = normalize_table_name(file_path)
    df = pd.read_csv(file_path, nrows=5, encoding="latin1")

    columns = [
        f'    "{column.lower()}" TEXT'
        for column in df.columns
    ]

    columns_sql = ",\n".join(columns)

    return f"""-- Table: raw.{table_name}
CREATE TABLE IF NOT EXISTS raw.{table_name} (
{columns_sql}
);
"""


def generate_tables(csv_files: list[Path]) -> str:
    ddl_blocks = [
        build_header(
            "02_create_tables.sql",
            "Crea las tablas de la capa raw a partir de los encabezados CSV."
        ),
        "-- ==========================================================",
        "-- DECISIÓN DE DISEÑO - CAPA RAW",
        "-- ==========================================================",
        "-- Todas las columnas se crean intencionalmente con tipo TEXT.",
        "-- La capa raw almacena los archivos CSV exactamente como fueron recibidos.",
        "-- La conversión de tipos y reglas de negocio se aplicarán en staging.",
        "-- ==========================================================",
        "",
    ]

    for file_path in csv_files:
        ddl_blocks.append(generate_create_table(file_path))

    return "\n".join(ddl_blocks)


def generate_constraints() -> str:
    return f"""{build_header(
        "03_constraints.sql",
        "Documenta la estrategia de constraints para la capa raw."
    )}
-- ==========================================================
-- DECISIÓN DE DISEÑO - CONSTRAINTS EN RAW
-- ==========================================================
-- No se aplican PRIMARY KEY ni FOREIGN KEY en esta etapa.
--
-- Motivo:
-- La capa raw debe aceptar los datos exactamente como llegan desde Kaggle.
-- Antes de aplicar constraints físicas, se validará unicidad,
-- duplicados e integridad referencial durante el proceso de calidad de datos.
--
-- Las constraints se definirán posteriormente sobre staging o analytical,
-- cuando existan datos tipados, limpios y validados.
-- ==========================================================
"""


def generate_indexes() -> str:
    return f"""{build_header(
        "04_index.sql",
        "Documenta la estrategia inicial de índices para la capa raw."
    )}
-- ==========================================================
-- DECISIÓN DE DISEÑO - ÍNDICES EN RAW
-- ==========================================================
-- No se crean índices en la capa raw antes de la carga inicial.
--
-- Motivo:
-- Los índices pueden ralentizar la ingesta masiva de datos.
-- Se definirán después de cargar y validar la información, en función de:
--   1. claves de unión frecuentes;
--   2. columnas usadas en filtros;
--   3. necesidades de consultas analíticas;
--   4. rendimiento observado en PostgreSQL.
-- ==========================================================
"""


def write_sql_file(output_path: Path, content: str) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(content, encoding="utf-8")


def main() -> None:
    csv_files = sorted(RAW_DATA_PATH.glob("*.csv"))

    write_sql_file(OUTPUT_FILES["schema"], generate_schema())
    write_sql_file(OUTPUT_FILES["tables"], generate_tables(csv_files))
    write_sql_file(OUTPUT_FILES["constraints"], generate_constraints())
    write_sql_file(OUTPUT_FILES["indexes"], generate_indexes())

    print("DDL files generated successfully.")
    print(f"Output directory: {DDL_OUTPUT_DIR}")
    print(f"CSV files detected: {len(csv_files)}")
    print("Files generated:")
    for output_file in OUTPUT_FILES.values():
        print(f"- {output_file.name}")


if __name__ == "__main__":
    main()