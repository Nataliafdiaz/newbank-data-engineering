from pathlib import Path
from datetime import datetime
import os

import psycopg2
from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
LOGS_PATH = PROJECT_ROOT / "logs"

load_dotenv(PROJECT_ROOT / ".env")


DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT")),
    "database": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}


EXPECTED_TABLES = [
    "application_test",
    "application_train",
    "bureau",
    "bureau_balance",
    "credit_card_balance",
    "homecredit_columns_description",
    "installments_payments",
    "pos_cash_balance",
    "previous_application",
    "sample_submission",
]


CANDIDATE_KEYS = {
    "application_train": "sk_id_curr",
    "application_test": "sk_id_curr",
    "bureau": "sk_id_bureau",
    "previous_application": "sk_id_prev",
    "sample_submission": "sk_id_curr",
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def get_log_file() -> Path:
    LOGS_PATH.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return LOGS_PATH / f"raw_validation_{timestamp}.txt"


def validate_tables(cursor, report: list[str]) -> None:
    cursor.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'raw'
        ORDER BY table_name;
    """)

    existing_tables = {row[0] for row in cursor.fetchall()}

    report.append("\n========== TABLE VALIDATION ==========\n")

    for table in EXPECTED_TABLES:
        if table in existing_tables:
            report.append(f"[OK] {table}")
        else:
            report.append(f"[ERROR] Missing table: {table}")


def validate_row_counts(cursor, report: list[str]) -> None:
    report.append("\n========== ROW COUNT VALIDATION ==========\n")

    for table in EXPECTED_TABLES:
        cursor.execute(f"SELECT COUNT(*) FROM raw.{table};")
        row_count = cursor.fetchone()[0]

        report.append(f"{table:<35} {row_count:>12,} rows")


def validate_candidate_keys(cursor, report: list[str]) -> None:
    report.append("\n========== CANDIDATE KEY VALIDATION ==========\n")

    for table, key_column in CANDIDATE_KEYS.items():
        cursor.execute(f"""
            SELECT
                COUNT(*) AS total_rows,
                COUNT(DISTINCT "{key_column}") AS distinct_keys,
                COUNT(*) - COUNT(DISTINCT "{key_column}") AS duplicated_keys
            FROM raw.{table};
        """)

        total_rows, distinct_keys, duplicated_keys = cursor.fetchone()
        status = "[OK]" if duplicated_keys == 0 else "[WARNING]"

        report.append(
            f"{status} {table:<30} "
            f"key={key_column:<15} "
            f"rows={total_rows:>12,} "
            f"distinct={distinct_keys:>12,} "
            f"duplicates={duplicated_keys:>12,}"
        )


def main() -> None:
    report = [
        "RAW VALIDATION REPORT",
        "=====================",
        f"Execution timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
    ]

    connection = get_connection()

    try:
        with connection:
            with connection.cursor() as cursor:
                validate_tables(cursor, report)
                validate_row_counts(cursor, report)
                validate_candidate_keys(cursor, report)

        report.append("\nSTATUS: PASSED")

        log_file = get_log_file()
        log_file.write_text("\n".join(report), encoding="utf-8")

        print(f"RAW data validation completed successfully.")
        print(f"Validation report saved to: {log_file}")

    finally:
        connection.close()


if __name__ == "__main__":
    main()