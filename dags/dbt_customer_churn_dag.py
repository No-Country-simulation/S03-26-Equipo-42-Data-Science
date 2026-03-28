from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
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
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

def recreate_bronze_table():
    """Borra y recrea la tabla Bronze con tipos genéricos para una carga robusta"""
    hook = PostgresHook(postgres_conn_id='postgres_default')
    # Listado exacto de columnas del CSV
    columns = [
        "Age", "Gender", "Country", "City", "Membership_Years", "Login_Frequency",
        "Session_Duration_Avg", "Pages_Per_Session", "Cart_Abandonment_Rate", 
        "Wishlist_Items", "Total_Purchases", "Average_Order_Value", 
        "Days_Since_Last_Purchase", "Discount_Usage_Rate", "Returns_Rate", 
        "Email_Open_Rate", "Customer_Service_Calls", "Product_Reviews_Written", 
        "Social_Media_Engagement_Score", "Mobile_App_Usage", "Payment_Method_Diversity", 
        "Lifetime_Value", "Credit_Balance", "Churned", "Signup_Quarter"
    ]
    # Creamos todas como TEXT para que el COPY no falle por tipos decimales/enteros
    cols_sql = ", ".join([f'"{c}" TEXT' for c in columns])
    sql = f"DROP TABLE IF EXISTS public.br_ecommerce_churn; CREATE TABLE public.br_ecommerce_churn ({cols_sql});"
    hook.run(sql)

def load_csv_to_postgres():
    """Carga masiva ultra-rápida usando streaming por STDIN"""
    hook = PostgresHook(postgres_conn_id='postgres_default')
    sql = "COPY public.br_ecommerce_churn FROM STDIN WITH CSV HEADER DELIMITER ','"
    hook.copy_expert(sql, filename=CSV_FILE_PATH)

with DAG(
    'dbt_customer_churn_pipeline',
    default_args=default_args,
    description='Pipeline robusto con COPY y dbt (Medallion)',
    schedule_interval=None,
    catchup=False,
    tags=['dbt', 'churn', 'optimized'],
) as dag:

    # 1. Preparar tabla Bronze (Tipografía genérica para evitar errores de formato)
    prepare_bronze = PythonOperator(
        task_id='recreate_bronze_table',
        python_callable=recreate_bronze_table,
    )

    # 2. Carga MASIVA usando streaming
    copy_bronze = PythonOperator(
        task_id='fast_load_bronze',
        python_callable=load_csv_to_postgres,
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

    prepare_bronze >> copy_bronze >> dbt_run >> dbt_test
