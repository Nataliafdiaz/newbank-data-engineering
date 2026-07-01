# NewBank Credit Decision Platform - Data Model

## Objetivo

Construir un modelo relacional para almacenar y analizar la información utilizada por NewBank en la evaluación de solicitudes de crédito.

## Fuente de datos

Dataset: Home Credit Default Risk (Kaggle)

## Entidades principales

- `application_train`: solicitudes de crédito históricas con variable objetivo.
- `application_test`: solicitudes de crédito para predicción.
- `bureau`: historial crediticio externo del cliente.
- `bureau_balance`: estado mensual de créditos reportados en buró.
- `previous_application`: solicitudes de crédito previas.
- `POS_CASH_balance`: historial mensual de productos POS/Cash.
- `credit_card_balance`: historial mensual de tarjetas de crédito.
- `installments_payments`: historial de cuotas y pagos.

## Relaciones

- `application_train/application_test` 1:N `bureau`
- `bureau` 1:N `bureau_balance`
- `application_train/application_test` 1:N `previous_application`
- `previous_application` 1:N `POS_CASH_balance`
- `previous_application` 1:N `credit_card_balance`
- `previous_application` 1:N `installments_payments`

## Claves primarias

| Tabla | Clave primaria |
|---|---|
| `application_train` | `SK_ID_CURR` |
| `application_test` | `SK_ID_CURR` |
| `bureau` | `SK_ID_BUREAU` |
| `bureau_balance` | `SK_ID_BUREAU`, `MONTHS_BALANCE` |
| `previous_application` | `SK_ID_PREV` |
| `POS_CASH_balance` | `SK_ID_PREV`, `MONTHS_BALANCE` |
| `credit_card_balance` | `SK_ID_PREV`, `MONTHS_BALANCE` |
| `installments_payments` | `SK_ID_PREV`, `NUM_INSTALMENT_NUMBER`, `NUM_INSTALMENT_VERSION` |

## Claves foráneas

| Tabla origen | Campo | Tabla destino |
|---|---|---|
| `bureau` | `SK_ID_CURR` | `application_train/application_test` |
| `bureau_balance` | `SK_ID_BUREAU` | `bureau` |
| `previous_application` | `SK_ID_CURR` | `application_train/application_test` |
| `POS_CASH_balance` | `SK_ID_PREV` | `previous_application` |
| `credit_card_balance` | `SK_ID_PREV` | `previous_application` |
| `installments_payments` | `SK_ID_PREV` | `previous_application` |

## Decisión inicial de implementación

El primer esquema físico en PostgreSQL será `raw`.

En `raw`, las tablas conservarán la estructura original de los CSV para asegurar trazabilidad, auditoría y reproducibilidad. Las transformaciones y reglas de calidad se aplicarán posteriormente en capas `staging` y `analytical`.