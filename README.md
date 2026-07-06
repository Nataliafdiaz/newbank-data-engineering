# NewBank Credit Decision Platform

### Data Engineering Repository

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.13-3776AB?logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-DDL%20%7C%20DML-orange)
![Git](https://img.shields.io/badge/Git-GitHub-F05032?logo=git&logoColor=white)

Repositorio de Ingeniería de Datos del proyecto **NewBank Credit Decision Platform**, una plataforma end-to-end para la evaluación de riesgo crediticio desarrollada sobre el dataset **Home Credit Default Risk** de Kaggle.

Este repositorio implementa un pipeline reproducible utilizando **PostgreSQL**, **SQL** y **Python**, siguiendo una arquitectura por capas (**RAW → STAGING → ANALYTICAL**) que constituye la base para las etapas de Machine Learning, APIs y visualización.

---

## Highlights

- Arquitectura de datos por capas (**RAW → STAGING → ANALYTICAL**)
- Más de **58 millones de registros** procesados en PostgreSQL 17
- Pipeline reproducible desarrollado con **Python**, **SQL** y **PostgreSQL**
- Validaciones automáticas para garantizar la calidad de los datos
- Base de datos preparada para Machine Learning, API REST y Power BI

---

## Arquitectura

```mermaid
flowchart TD

    A[Home Credit Dataset (CSV)] --> B[RAW]

    B --> C[STAGING]

    C --> D[ANALYTICAL]

    D --> E[Machine Learning]

    D --> F[Power BI]

    E --> G[FastAPI]

    G --> H[Streamlit]
```

---

## Estado del proyecto

| Sprint | Entregable | Estado |
|---------|------------|--------|
| Sprint 1 | Carga de datos en PostgreSQL (RAW) | ✅ |
| Sprint 2 | Capa STAGING y validaciones | ✅ |
| Sprint 3 | Modelo ANALYTICAL | 🚧 |
| Sprint 4 | Machine Learning | ⏳ |
| Sprint 5 | API REST | ⏳ |
| Sprint 6 | Dashboard Streamlit | ⏳ |

---

## Estructura del repositorio

```text
newbank-data-engineering/
│
├── data/
├── docs/
├── notebooks/
├── sql/
│   ├── ddl/
│   ├── dml/
│   ├── queries/
│   └── views/
├── src/
├── tests/
├── README.md
└── requirements.txt
```

---

## Decisiones técnicas

- Los archivos CSV se cargan inicialmente en una capa **RAW** utilizando columnas de tipo `TEXT`, evitando errores de importación y preservando los datos originales.
- La capa **STAGING** aplica tipado, limpieza, tratamiento de valores centinela y validaciones de calidad antes de que la información sea utilizada por otras capas.
- La arquitectura **RAW → STAGING → ANALYTICAL** garantiza trazabilidad completa desde el dato original hasta los datasets utilizados para Machine Learning y Business Intelligence.

---

## Repositorios del proyecto

| Repositorio | Descripción | Estado |
|--------------|-------------|--------|
| **newbank-data-engineering** | Ingeniería de datos y ETL | ✅ |
| **newbank-ml-models** | Modelos predictivos | ⏳ |
| **newbank-api** | API REST | ⏳ |
| **newbank-app** | Aplicación Streamlit | ⏳ |

---

## Tecnologías

- PostgreSQL 17
- Python 3.13
- SQL
- Git / GitHub

---

## Autora

**Natalia Díaz**

Data Analyst | Data Scientist | Credit Risk Analytics

GitHub: https://github.com/Nataliafdiaz
LinkedIn: https://www.linkedin.com/in/natalia-diaz-b1b80b216/