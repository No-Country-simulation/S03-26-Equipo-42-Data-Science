from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Ruta del proyecto dbt dentro del contenedor
DBT_PROJECT_DIR = "/opt/airflow/dbt_project"

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'dbt_customer_churn_pipeline',
    default_args=default_args,
    description='Pipeline de transformaciones dbt para el modelo de Churn (Medallion)',
    schedule_interval=None,  # Ejecución manual por defecto
    catchup=False,
    tags=['dbt', 'churn', 'medallion'],
) as dag:

    # 1. Carga de datos crudos (Bronze)
    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt seed --profiles-dir .",
    )

    # 2. Ejecución de transformaciones (Silver & Gold)
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --profiles-dir .",
    )

    # 3. Pruebas de calidad de datos
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir .",
    )

    dbt_seed >> dbt_run >> dbt_test
