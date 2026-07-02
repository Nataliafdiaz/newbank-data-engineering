from pathlib import Path

import psycopg2
from dotenv import load_dotenv
import os


PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"
load_dotenv(PROJECT_ROOT / ".env")

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT")),
    "database": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def normalize_table_name(file_path: Path) -> str:
    return file_path.stem.lower()
def truncate_table(cursor, table_name: str) -> None:
    query = f'TRUNCATE TABLE raw."{table_name}";'
    cursor.execute(query)


def copy_csv_to_table(cursor, file_path: Path, table_name: str) -> None:
    query = f"""
        COPY raw."{table_name}"
        FROM STDIN
        WITH (
            FORMAT CSV,
            HEADER TRUE,
            ENCODING 'LATIN1'
        );
    """

    with file_path.open("r", encoding="latin1") as csv_file:
        cursor.copy_expert(query, csv_file)
def load_dataset(cursor, file_path: Path) -> None:
    table_name = normalize_table_name(file_path)

    print(f"Loading {file_path.name} into raw.{table_name}...")

    truncate_table(cursor, table_name)
    copy_csv_to_table(cursor, file_path, table_name)

    print(f"Loaded {file_path.name} successfully.")


def main() -> None:
    csv_files = sorted(RAW_DATA_PATH.glob("*.csv"))

    if not csv_files:
        raise FileNotFoundError(f"No CSV files found in {RAW_DATA_PATH}")

    print("Starting raw data load...")
    print(f"CSV files detected: {len(csv_files)}")

    connection = get_connection()

    try:
        with connection:
            with connection.cursor() as cursor:
                for file_path in csv_files:
                    load_dataset(cursor, file_path)

        print("Raw data load completed successfully.")

    finally:
        connection.close()


if __name__ == "__main__":
    main()