# E-commerce Churn Model: Retención y Segmentación de Riesgo

## Visión General y Contexto de Negocio
Las empresas de retail digital necesitan identificar patrones de abandono de manera temprana para aumentar la retención. Este proyecto desarrolla una solución analítica integral que identifica señales de fuga y genera insights accionables, dado que retener a un cliente es hasta 5 veces más económico que adquirir uno nuevo.

## Objetivos del Proyecto
* **Objetivo Principal:** Predecir la probabilidad de abandono de clientes mediante Machine Learning para activar estrategias de retención tempranas.
* **Objetivos Específicos:** Identificar patrones de comportamiento transaccional, detectar señales de inactividad y perfilar segmentos de riesgo (Alto, Medio, Bajo).

## Definición de "Churn"
Para este proyecto, el estado de abandono (Churn) viene **predefinido como una etiqueta binaria (0 = Retenido, 1 = Fugado)** en el dataset original. Esto permite un enfoque de aprendizaje supervisado directo, sin necesidad de calcular umbrales de inactividad de forma manual.

## Equipo y Fases de Colaboración
* **Data Science & ML (Marco Olivares):** Limpieza de datos, Análisis Exploratorio (EDA), Ingeniería de Características, entrenamiento del modelo predictivo y segmentación de riesgo.
* **Data Engineering (Abraham Cabrera):** Automatización del pipeline de datos, ingesta en producción y despliegue del modelo para inferencia continua.
* **Data Visualization (Johanna Procopio):** Diseño del dashboard interactivo, conexión con resultados y creación de reportes visuales para el usuario final.

## Estructura del Proyecto
```text
├── dashboards/        # Archivos de la herramienta de BI
├── data/
│   ├── processed/     # Datos limpios y con predicciones para el dashboard
│   └── raw/           # Datos originales inmutables (ecommerce_customer_data)
├── docs/              # Documentación técnica y de negocio
├── models/            # Artefactos exportados (modelo_churn_rf.pkl, scaler_churn.pkl)
├── notebooks/         # Notebook principal (EDA, Limpieza y Modelado)
├── src/               # Scripts de Python (preprocess.py, predict.py)
├── .gitignore         # Archivos ignorados por el control de versiones
├── README.md          # Descripción general del proyecto
└── requirements.txt   # Dependencias para reproducibilidad
```

## Metodología Técnica y Pipeline
* **Conjunto de Datos:** E-commerce Customer Behavior Dataset.
* **Modelos Evaluados:** Regresión Logística (Baseline), Random Forest y XGBoost.
* **Modelo Final:** Random Forest optimizado mediante GridSearchCV.
* **Métricas de Éxito:** Se priorizó el **Recall (83%)** para minimizar los falsos negativos y garantizar la detección de la mayor cantidad posible de clientes en riesgo real.

## Dashboard Analítico e Insights
* **Métricas Clave:** Tasa global de churn, distribución por nivel de riesgo (Alto, Medio, Bajo).
* **Recomendaciones:** Estrategias de retención dirigidas específicamente a los **2,041 clientes** identificados en el segmento de Riesgo Alto.

## Entregables
1. **Reporte EDA:** Visualizaciones y hallazgos clave de comportamiento.
2. **Pipeline Reproducible:** Scripts de limpieza (`src/`), modelo entrenado (`.pkl`) y escalador.
3. **Dataset Puntuado:** Datos procesados con el *score* de probabilidad de riesgo añadido.
4. **Dashboard Interactivo:** Reporte visual accionable para equipos de Marketing.

## Reproducibilidad y Setup
Para replicar el entorno de trabajo y ejecutar el pipeline técnico:

1. Clonar el repositorio.
2. Crear un entorno virtual.
3. Instalar las dependencias ejecutando: 
   ```bash
   pip install -r requirements.txt