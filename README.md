# **E-commerce Churn Model: Retención y Segmentación de Riesgo**

## **Visión General y Contexto de Negocio**
Las empresas de retail digital necesitan identificar patrones de abandono de manera temprana para aumentar la retención. Este proyecto desarrolla una solución analítica integral que identifica señales de fuga y genera insights accionables, dado que retener a un cliente es hasta 5 veces más económico que adquirir uno nuevo.

## **Objetivos del Proyecto**
* **Objetivo Principal:** Predecir la probabilidad de abandono de clientes mediante Machine Learning para activar estrategias de retención tempranas.
* **Objetivos Específicos:** Identificar patrones de comportamiento transaccional, detectar señales de inactividad y perfilar segmentos de riesgo (Alto, Medio, Bajo).

## **Definición de "Churn"**
Para este proyecto, el estado de abandono (Churn) viene **predefinido como una etiqueta binaria (0 = Retenido, 1 = Fugado)** en el dataset original. Esto permite un enfoque de aprendizaje supervisado directo, sin necesidad de calcular umbrales de inactividad de forma manual.

## **Equipo y Fases de Colaboración**
* **Data Science & ML (Marco Olivares):** Limpieza de datos, Análisis Exploratorio (EDA), Ingeniería de Características, entrenamiento del modelo predictivo y segmentación de riesgo.
* **Data Engineering (Abraham Cabrera):** Automatización del pipeline de datos, ingesta en producción y despliegue del modelo para inferencia continua.
* **Data Visualization (Johanna Procopio):** Diseño del dashboard interactivo, conexión con resultados y creación de reportes visuales para el usuario final.

## **Estructura del Proyecto**
```text
├── data/
│   ├── raw/           <- Depositar aquí el archivo 'input_data.csv'
│   └── processed/     <- Resultados generados (predicciones_YYYYMMDD_HHMM.csv)
├── models/
│   ├── modelo_churn_rf.pkl
│   └── scaler_churn.pkl
├── notebooks/         <- Análisis exploratorio (EDA) y entrenamiento
├── src/               <- Scripts de producción
│   ├── preprocess.py  <- Limpieza y transformación de datos
│   ├── predict.py     <- Lógica de carga de modelo e inferencia
│   └── main.py        <- Orquestador principal del pipeline
├── README.md          <- Documentación del proyecto
└── requirements.txt   <- Librerías necesarias (pandas, scikit-learn, joblib)
```

## **Metodología Técnica y Pipeline**
* **Conjunto de Datos:** [E-commerce Customer Behavior Dataset](https://www.kaggle.com/datasets/dhairyajeetsingh/ecommerce-customer-behavior-dataset).
* **Modelos Evaluados:** Regresión Logística (Baseline), Random Forest y XGBoost.
* **Modelo Final:** Random Forest optimizado mediante GridSearchCV.
* **Métricas de Éxito:** Se priorizó el **Recall (83%)** para minimizar los falsos negativos y garantizar la detección de la mayor cantidad posible de clientes en riesgo real.

## **Dashboard Analítico e Insights**
* **Métricas Clave:** Tasa global de churn, distribución por nivel de riesgo (Alto, Medio, Bajo).
* **Recomendaciones:** Estrategias de retención dirigidas específicamente a los **2,041 clientes** identificados en el segmento de Riesgo Alto.

## **Entregables**
1. **Reporte EDA:** Visualizaciones y hallazgos clave de comportamiento.
2. **Pipeline Reproducible:** Scripts de limpieza (`src/`), modelo entrenado (`.pkl`) y escalador.
3. **Dataset Puntuado:** Datos procesados con el *score* de probabilidad de riesgo añadido.
4. **Dashboard Interactivo:** Reporte visual accionable para equipos de Marketing.

## **Reproducibilidad y Setup del pipeline tecnico**
Para replicar el entorno de trabajo y ejecutar el pipeline técnico:

1. Clonar el repositorio.
2. Crear un entorno virtual.
3. Instalar las dependencias ejecutando:

   ```bash
   pip install -r requirements.txt
   ```

## **Guía de Implementación**
El archivo `main.py` es el motor del proyecto. Pasos para generar nuevas predicciones:

### 1. Preparación de Datos
Colocar el archivo con los nuevos clientes en la carpeta `data/raw/`. 
* **Importante:** El archivo debe llamarse `input_data.csv`.

### 2. Ejecución
Abrir una terminal en la raíz del proyecto y ejecutar:

```bash
python src/main.py
```
### 3. Salida de Datos
El sistema generará un archivo en `data/processed/` con un sello de tiempo para evitar sobreescrituras y mantener un historial de auditoría.
* **Formato de nombre:** `predicciones_AÑOMESDIA_HORAMINUTO.csv`

## **Interpretación de Resultados**
El archivo generado incluye todas las columnas originales junto con una nueva métrica crítica:

* **`Probabilidad_Fuga`**: Valor decimal entre `0` y `1`.
    * **0.0 - 0.3 (Riesgo Bajo):** Cliente estable con alta probabilidad de permanencia.
    * **0.3 - 0.7 (Riesgo Medio):** Cliente en observación; muestra señales de inactividad.
    * **0.7 - 1.0 (Riesgo Alto):** Requiere acción inmediata de retención (campañas, descuentos, contacto directo).

