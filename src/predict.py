import joblib

# =========================================================
# PREDECIR PROBABILIDAD DE FUGA 
# =========================================================

def predict_churn(df_clean, path_model, path_scaler):
    """
    Carga el modelo y escalador, asegura el orden de las columnas 
    y retorna la probabilidad de fuga para cada cliente.
    """
    # CARGAR MODELO Y ESCALADOR
    try:
        model = joblib.load(path_model)
        scaler = joblib.load(path_scaler)
    except FileNotFoundError as e:
        print(f"Error: No se encontró el archivo en la ruta especificada. {e}")
        return None

    # ALINEACIÓN DE COLUMNAS
    expected_columns = model.feature_names_in_
    
    # REORDENANDO
    df_aligned = df_clean[expected_columns]

    # ESCALADO
    X_scaled = scaler.transform(df_aligned)
    
    # PREDICCIÓN DE PROBABILIDADES DE LA CLASE 1
    probs = model.predict_proba(X_scaled)[:, 1]
    
    return probs