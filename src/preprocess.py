import pandas as pd
import joblib

# =========================================================
# LIMPIAR DATOS
# =========================================================

def limpiar_datos_produccion(df_raw):
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
    # Numéricas por la mediana
    if not num_cols.empty:
        df[num_cols] = df[num_cols].fillna(df[num_cols].median())

    # Categóricas por la moda
    for col in cat_cols:
        if not df[col].empty:
            df[col] = df[col].fillna(df[col].mode()[0])

    return df

# =========================================================
# PREDECIR NUEVOS CLIENTES
# =========================================================

def predecir_nuevos_clientes(df_limpio, path_model, path_scaler):
    """
    Carga el modelo y escalador, asegura el orden de las columnas 
    y retorna la probabilidad de fuga para cada cliente.
    """
    # Cargar herramientas (Modelo y Escalador)
    try:
        model = joblib.load(path_model)
        scaler = joblib.load(path_scaler)
    except FileNotFoundError as e:
        print(f"Error: No se encontró el archivo en la ruta especificada. {e}")
        return None

    # ALINEACIÓN DE COLUMNAS
    expected_columns = model.feature_names_in_
    
    # Reordenamos el DataFrame para que coincida exactamente con el entrenamiento
    df_aligned = df_limpio[expected_columns]

    # ESCALADO
    X_scaled = scaler.transform(df_aligned)
    
    # PREDICCIÓN DE PROBABILIDADES
    # Retornamos solo la probabilidad de la clase 1
    probs = model.predict_proba(X_scaled)[:, 1]
    
    return probs