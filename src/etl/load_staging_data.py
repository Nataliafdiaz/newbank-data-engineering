from pathlib import Path
import psycopg2
from src.config.settings import DB_CONFIG


RUTA_BASE = Path(__file__).resolve().parents[2]
RUTA_SQL_DDL = RUTA_BASE / "sql" / "ddl"


def ejecutar_script_sql(ruta_script: Path) -> None:
    """Ejecuta un archivo SQL completo en PostgreSQL."""
    print(f"Ejecutando script: {ruta_script.name}")

    with open(ruta_script, "r", encoding="utf-8") as archivo:
        sql = archivo.read()

    with psycopg2.connect(**DB_CONFIG) as conexion:
        with conexion.cursor() as cursor:
            cursor.execute(sql)

    print(f"Script finalizado: {ruta_script.name}")


def cargar_staging() -> None:
    """Ejecuta los scripts necesarios para construir la capa staging."""
    scripts_staging = [
        RUTA_SQL_DDL / "05_create_staging_solicitudes_credito.sql",
    ]

    for script in scripts_staging:
        if not script.exists():
            raise FileNotFoundError(f"No existe el script SQL: {script}")

        ejecutar_script_sql(script)

    print("Carga de staging finalizada correctamente.")


if __name__ == "__main__":
    cargar_staging()