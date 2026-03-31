import pandas as pd

# =========================================================
# LIMPIAR DATOS
# =========================================================

def clean_data(df_raw):
    """
    Realiza la limpieza y preparación de datos crudos para el modelo de Churn.
    Replica exactamente los pasos del notebook para evitar sesgos en predicción.
    """
    df = df_raw.copy()

    # ELIMINACIÓN DE COLUMNAS SIN VALOR PREDICTIVO / RUIDO
    cols_to_drop = ['City', 'Signup_Quarter', 'Gender', 'Country', 'CustomerID']
    df = df.drop(columns=[col for col in cols_to_drop if col in df.columns])

    # ELIMINACIÓN DE DUPLICADOS
    df = df.drop_duplicates()

    # SEPARACIÓN DE COLUMNAS POR TIPO
    num_cols = df.select_dtypes(include=['float64', 'int64']).columns
    cat_cols = df.select_dtypes(include=['object']).columns

    # IMPUTACIÓN DE VALORES NULOS
    # NUMERICAS POR LA MEDIANA
    if not num_cols.empty:
        df[num_cols] = df[num_cols].fillna(df[num_cols].median())

    # CATEGORICAS POR LA MODA
    for col in cat_cols:
        if not df[col].empty:
            df[col] = df[col].fillna(df[col].mode()[0])

    return df