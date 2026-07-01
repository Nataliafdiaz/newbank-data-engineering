from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"
OUTPUT_PATH = PROJECT_ROOT / "sql" / "ddl" / "02_create_tables.sql"


def normalize_table_name(file_path: Path) -> str:
    return file_path.stem.lower()


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


def main() -> None:
    csv_files = sorted(RAW_DATA_PATH.glob("*.csv"))

    ddl_blocks = [
        "-- ============================================================",
        "-- NewBank Credit Decision Platform",
        "-- Physical Data Model",
        "-- File: 02_create_tables.sql",
        "-- Description: Creates raw tables for the Home Credit dataset.",
        "-- Generated automatically from data/raw CSV headers.",
        "-- ============================================================",
        "",
    ]

    for file_path in csv_files:
        ddl_blocks.append(generate_create_table(file_path))

    OUTPUT_PATH.write_text("\n".join(ddl_blocks), encoding="utf-8")

    print(f"DDL generated successfully: {OUTPUT_PATH}")
    print(f"Tables generated: {len(csv_files)}")


if __name__ == "__main__":
    main()