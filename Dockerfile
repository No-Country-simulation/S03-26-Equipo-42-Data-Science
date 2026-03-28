FROM apache/airflow:2.7.1-python3.9

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         build-essential \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow
RUN pip install --no-cache-dir \
    dbt-postgres \
    apache-airflow-providers-postgres \
    jupyterlab \
    pandas \
    matplotlib \
    seaborn \
    sqlalchemy \
    psycopg2-binary
