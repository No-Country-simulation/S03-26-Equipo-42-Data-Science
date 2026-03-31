import pandas as pd
import os
from datetime import datetime
from preprocess import clean_data
from predict import predict_churn

if __name__ == "__main__":
    new_data_path = '../data/raw/input_data.csv'
    model_path = '../models/modelo_churn_rf.pkl'
    scaler_path = '../models/scaler_churn.pkl'
    export_path = '../data/processed/nuevas_predicciones.csv'

    if os.path.exists(new_data_path):
        df_new = pd.read_csv(new_data_path)
        
        # LIMPIA
        df_clean = clean_data(df_new)
        
        # PREDICE
        probability = predict_churn(df_clean, model_path, scaler_path)
        
        # GUARDA
        if probability is not None:
        
            timestamp = datetime.now().strftime("%Y%m%d_%H%M")
            filename = f"predicciones_{timestamp}.csv"
            export_path = os.path.join('../data/processed/', filename)
            df_new['Probabilidad_Fuga'] = probability
            df_new.to_csv(export_path, index=False)
            
            print(f"Éxito: Archivo guardado como {filename}")
    else:
        print(f"Error: No se encontró el archivo de datos en {new_data_path}")