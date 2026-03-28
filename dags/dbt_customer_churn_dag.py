from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

# Configuración de rutas
DBT_PROJECT_DIR = "/opt/airflow/dbt_project"
CSV_FILE_PATH = f"{DBT_PROJECT_DIR}/seeds/br_ecommerce_churn.csv"

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
    description='Pipeline optimizado con COPY y dbt (Medallion)',
    schedule_interval=None,
    catchup=False,
    tags=['dbt', 'churn', 'optimized'],
) as dag:

    # 1. Limpiar tabla Bronze (Ingestión rápida)
    truncate_bronze = PostgresOperator(
        task_id='truncate_bronze',
        postgres_conn_id='postgres_default',
        sql="TRUNCATE TABLE public.br_ecommerce_churn;",
    )

    # 2. Carga MASIVA usando comando COPY (Velocidad extrema)
    copy_bronze = PostgresOperator(
        task_id='fast_load_bronze',
        postgres_conn_id='postgres_default',
        sql=f"COPY public.br_ecommerce_churn FROM '{CSV_FILE_PATH}' DELIMITER ',' CSV HEADER;",
    )

    # 3. Transformaciones dbt (Silver & Gold)
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --profiles-dir .",
    )

    # 4. Pruebas de Calidad
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir .",
    )

    truncate_bronze >> copy_bronze >> dbt_run >> dbt_test
