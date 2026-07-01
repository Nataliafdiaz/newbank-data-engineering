# Inventario del Dataset

Este documento fue generado automáticamente desde el notebook:

`notebooks/01_eda_exploratorio/01_dataset_inventory.ipynb`

## Fuente de datos

Dataset: Home Credit Default Risk (Kaggle)

## Inventario de archivos

| file_name                          | entity_type                  |     rows |   columns |   size_mb | primary_key                                               | foreign_keys           | candidate_keys           |
|:-----------------------------------|:-----------------------------|---------:|----------:|----------:|:----------------------------------------------------------|:-----------------------|:-------------------------|
| application_test.csv               | Main application - test      |    48744 |       121 |     25.34 | SK_ID_CURR                                                | -                      | SK_ID_CURR               |
| application_train.csv              | Main application - train     |   307511 |       122 |    158.44 | SK_ID_CURR                                                | -                      | SK_ID_CURR               |
| bureau.csv                         | Credit bureau history        |  1716428 |        17 |    162.14 | SK_ID_BUREAU                                              | SK_ID_CURR             | SK_ID_CURR, SK_ID_BUREAU |
| bureau_balance.csv                 | Credit bureau monthly status | 27299925 |         3 |    358.19 | SK_ID_BUREAU, MONTHS_BALANCE                              | SK_ID_BUREAU           | SK_ID_BUREAU             |
| credit_card_balance.csv            | Credit card monthly balance  |  3840312 |        23 |    404.91 | SK_ID_PREV, MONTHS_BALANCE                                | SK_ID_PREV, SK_ID_CURR | SK_ID_PREV, SK_ID_CURR   |
| HomeCredit_columns_description.csv | Data dictionary              |      219 |         5 |      0.04 | -                                                         | -                      | -                        |
| installments_payments.csv          | Installment payments history | 13605401 |         8 |    689.62 | SK_ID_PREV, NUM_INSTALMENT_NUMBER, NUM_INSTALMENT_VERSION | SK_ID_PREV, SK_ID_CURR | SK_ID_PREV, SK_ID_CURR   |
| POS_CASH_balance.csv               | POS cash monthly balance     | 10001358 |         8 |    374.51 | SK_ID_PREV, MONTHS_BALANCE                                | SK_ID_PREV, SK_ID_CURR | SK_ID_PREV, SK_ID_CURR   |
| previous_application.csv           | Previous credit applications |  1670214 |        37 |    386.21 | SK_ID_PREV                                                | SK_ID_CURR             | SK_ID_PREV, SK_ID_CURR   |
| sample_submission.csv              | Kaggle submission template   |    48744 |         2 |      0.51 | SK_ID_CURR                                                | SK_ID_CURR             | SK_ID_CURR               |

## Observaciones iniciales

- application_train.csv es la tabla principal.
- application_test.csv contiene los datos para predicción.
- bureau contiene el historial crediticio externo.
- previous_application contiene solicitudes anteriores.
- credit_card_balance, POS_CASH_balance e installments_payments contienen información histórica de créditos.
- Las claves SK_ID_CURR, SK_ID_PREV y SK_ID_BUREAU serán la base del modelo relacional.
