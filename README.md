# Propuesta de Proyecto: E-commerce Churn Model

## Visión General y Contexto de Negocio
Las empresas de retail digital necesitan identificar patrones de abandono de manera temprana para aumentar la retención. Este proyecto desarrolla una solución analítica integral que identifica señales de fuga y genera *insights* accionables para estrategias de fidelización en el sector e-commerce.

## Objetivos del Proyecto
* **Objetivo Principal:** Predecir la probabilidad de abandono de clientes mediante Machine Learning para permitir al negocio activar estrategias de retención tempranas.
* **Objetivos Específicos:** Identificar patrones de comportamiento, detectar señales tempranas de inactividad y generar recomendaciones estratégicas basadas en datos.

## Definición Propuesta de "Churn"
* **Cliente Inactivo:** Todo usuario que no haya realizado una transacción en los últimos *X* días. Umbral a definir tras evaluar la distribución de frecuencias de compra durante el Análisis Exploratorio de Datos (EDA).

## Equipo y Fases de Colaboración
* **Fase 1: Datos (Data Engineer).** Ingesta de datos crudos, limpieza inicial, tratamiento de nulos y disponibilidad en el entorno de trabajo.
* **Fase 2: Modelado (Data Scientist).** Análisis exploratorio (EDA), ingeniería de características, entrenamiento del modelo predictivo y segmentación por riesgo.
* **Fase 3: Visualización (Data Viz).** Diseño del dashboard, conexión con los resultados del modelo y creación de reportes visuales.

## Estructura del Proyecto
```text
├── data/
│   ├── raw/           # Datos originales inmutables
│   └── processed/     # Datos limpios listos para modelado
├── notebooks/         # Jupyter notebooks para EDA y experimentación
├── src/               # Scripts de Python (pipelines, entrenamiento)
├── dashboards/        # Archivos de la herramienta de BI
├── docs/              # Documentación técnica y de negocio
├── README.md          # Descripción general del proyecto
└── requirements.txt   # Dependencias para reproducibilidad
```
## Metodología Técnica y Pipeline
* **Conjunto de Datos:** E-commerce Customer Behavior Dataset (obtenido de Kaggle).
* **Modelos a evaluar:** Regresión Logística (baseline), Random Forest y XGBoost.
* **Métricas de éxito:** F1-Score y Recall (priorizando minimizar los falsos negativos para no omitir clientes en riesgo).
* **Reproducibilidad e Interpretabilidad:** Separación estricta de validación y análisis de importancia de variables para entender los factores de riesgo.

## Dashboard Analítico e Insights
* **Métricas Clave:** Tasa global de churn, precisión del modelo, distribución por nivel de riesgo (Alto, Medio, Bajo).
* **Recomendaciones:** Estrategias de retención priorizadas (descuentos dirigidos, re-engagement) basadas en los perfiles de riesgo identificados.

## Entregables
1. **Documento de Negocio:** Definición formal de churn y objetivos.
2. **Reporte EDA:** Visualizaciones y hallazgos clave del comportamiento.
3. **Pipeline Reproducible:** Código fuente, dataset procesado con score de riesgo y modelo entrenado.
4. **Dashboard Interactivo:** Reporte visual accesible para equipos no técnicos.
5. **Informe Final:** Resumen de insights y recomendaciones de acción.

## Reproducibilidad y Setup
Para replicar el entorno de trabajo y ejecutar el pipeline técnico:

1. Clonar el repositorio.
2. Crear un entorno virtual.
3. Instalar las dependencias ejecutando: `pip install -r requirements.txt`