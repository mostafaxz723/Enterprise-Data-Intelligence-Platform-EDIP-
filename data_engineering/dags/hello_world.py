from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator

with DAG("hello_world", start_date=datetime(2026, 1, 1), schedule=None, catchup=False, tags=["test"]) as dag:
    PythonOperator(task_id="say_hi", python_callable=lambda: print("Airflow works!"))
