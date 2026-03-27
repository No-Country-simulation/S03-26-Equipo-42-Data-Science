from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

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
    'setup_verification',
    default_args=default_args,
    description='A simple DAG to verify the environment setup',
    schedule_interval=None,
    catchup=False,
) as dag:

    check_dbt = BashOperator(
        task_id='check_dbt_version',
        bash_command='dbt --version',
    )

    check_postgres = PostgresOperator(
        task_id='check_postgres_connection',
        postgres_conn_id='postgres_default',
        sql='SELECT 1;',
    )

    check_dbt >> check_postgres
