# Recopilación de Requisitos - Predicción de Churn en E-commerce

## 1. Descripción del Proyecto

El objetivo es desarrollar un modelo predictivo para identificar a los clientes en riesgo de abandono (churn). Esto permitirá a los equipos de marketing y retención tomar medidas proactivas.

## 2. Diccionario de Datos (Inicial)

Basado en el archivo [ecommerce_customer_churn_dataset.csv]:

| Campo | Descripción | Tipo |
| :--- | :--- | :--- |
| `Age` | Edad del cliente | Numérico |
| `Gender` | Género del cliente | Categórico |
| `Country/City` | Ubicación geográfica | Categórico |
| `Membership_Years` | Años como miembro | Numérico |
| `Login_Frequency` | Frecuencia de inicio de sesión | Numérico |
| `Session_Duration_Avg` | Duración promedio de la sesión | Numérico |
| `Pages_Per_Session` | Páginas visitadas por sesión | Numérico |
| `Cart_Abandonment_Rate` | Tasa de abandono del carrito | Numérico (%) |
| `Wishlist_Items` | Artículos en la lista de deseos | Numérico |
| `Total_Purchases` | Total de compras de por vida | Numérico |
| `Average_Order_Value` | Valor promedio de los pedidos | Numérico ($) |
| `Days_Since_Last_Purchase` | Recencia de la última compra | Numérico |
| `Discount_Usage_Rate` | Tasa de uso de descuentos | Numérico (%) |
| `Returns_Rate` | Tasa de devolución de productos | Numérico (%) |
| `Email_Open_Rate` | Tasa de apertura de correos | Numérico (%) |
| `Customer_Service_Calls` | Total de llamadas a servicio al cliente | Numérico |
| `Product_Reviews_Written` | Reseñas de productos escritas | Numérico |
| `Social_Media_Engagement` | Puntuación de actividad en redes sociales | Numérico |
| `Mobile_App_Usage` | Frecuencia de uso de la app móvil | Numérico |
| `Payment_Diversity` | Cantidad de métodos de pago utilizados | Numérico |
| `Lifetime_Value (LTV)` | Valor total generado por el cliente | Numérico ($) |
| `Credit_Balance` | Saldo de crédito disponible | Numérico ($) |
| **`Churned`** | **Variable objetivo (1: Sí, 0: No)** | **Booleano/Binario** |

## 3. Calidad de Datos y Preguntas de Investigación

Basado en la exploración inicial de datos, se han identificado las siguientes preguntas para guiar la próxima fase del proyecto:

- **Valores Nulos e Imputación**:
  - ¿Qué características presentan el mayor porcentaje de valores nulos (ej. `Age`, `Session_Duration_Avg`, `Credit_Balance`)?
  - ¿Existe una correlación entre la falta de datos en ciertos campos y la variable objetivo (`Churned`)?
  - ¿Cuáles son las estrategias de imputación más adecuadas (media, mediana o modelado predictivo) para minimizar el sesgo?
- **Detección de Outliers (Valores Atípicos)**:
  - ¿Cuál es la validez lógica de los valores extremos, como `Age` = 200?
  - ¿Existen outliers en métricas financieras como `Average_Order_Value` o `Total_Purchases` que puedan sesgar la percepción del modelo sobre el comportamiento "normal"?
  - ¿Deberíamos aplicar recortes (clipping), escalado robusto o eliminación para los outliers identificados?
- **Desequilibrio de Clases y Representación**:
  - ¿Cómo afecta la tasa de churn del ~29% al rendimiento del modelo en la clase minoritaria?
  - ¿Deberíamos evaluar técnicas como SMOTE o aprendizaje sensible al costo para mejorar el recall (sensibilidad)?
- **Distribución de Datos y Características**:
  - ¿Cómo difieren las distribuciones de `Login_Frequency` y `Session_Duration_Avg` entre los clientes que abandonan y los usuarios activos?
  - ¿Hay características con varianza cercana a cero que deban excluirse?

## 4. Definiciones de Requerimientos (Churn)

- **Evento de Churn**: Definido como un valor de `1` en la columna `Churned`.
- **Objetivo de Negocio**: Desarrollar un sistema para identificar clientes de alto riesgo de forma proactiva.
- **Requerimientos de Evaluación**:
  - **Métrica Primaria**: **Recall** (Sensibilidad). La prioridad es capturar la máxima cantidad de posibles abandonos.
  - **Métrica Secundaria**: **Precisión** y **F1-Score**. Para asegurar que los esfuerzos de retención sean rentables.
  - **Requisito de Umbral**: El modelo debe apuntar a un **Recall > 0.7** para ser considerado viable para la intervención empresarial.

## 5. Propuestas de Procesos e Ingeniería Futura

Para continuar con el desarrollo del pipeline de datos y el modelo, se proponen los siguientes procesos:

1. **Análisis Exploratorio de Datos (EDA)**: Realizar una inmersión profunda en las preguntas planteadas en la Sección 3 para validar hipótesis.
2. **Pipeline de Preprocesamiento Robusto**:
   - Implementar una etapa de limpieza modular para el manejo de outliers.
   - Desarrollar una capa de imputación configurable para probar diferentes estrategias.
3. **Ingeniería y Selección de Características**:
   - Investigar las características originales y proponer métricas derivadas (ej. `Engagement_Score` basado en uso de app y apertura de emails).
   - Evaluar la importancia de las características para refinar el espacio de entrada.
4. **Evaluación e Iteración del Modelo**:
   - Establecer un marco de validación cruzada para asegurar que el modelo generalice bien.
   - Comparar múltiples algoritmos (Random Forest, XGBoost, etc.) utilizando las métricas definidas.
5. **Flujo de Trabajo de Ingeniería**:
   - Integrar el pipeline en un flujo de trabajo automatizado (ej. usando DVC o herramientas similares) para reproducibilidad y versionado.
   - Definir los requisitos para un modelo base (baseline) que sirva como punto de referencia para mejoras.

## 6. Requerimientos de Salida y Visualización

Para que los resultados del modelo sean accionables por el negocio, se definen los siguientes requerimientos de salida:

- **Segmentación de Clientes**:
  - Clasificar a los usuarios en tres niveles de riesgo: **Alto**, **Medio** y **Bajo**.
  - Generar perfiles descriptivos para cada segmento (ej. "Usuarios inactivos con alto LTV").
- **Dashboard Analítico**:
  - Visualización de la tasa de churn actual vs. proyectada.
  - Gráficos de importancia de variables para explicar por qué los clientes están abandonando.
  - Distribución de clientes por segmento de riesgo y valor de vida (LTV).
- **Exportabilidad e Interoperabilidad**:
  - Capacidad de exportar listas de clientes de alto riesgo en formato CSV o JSON para campañas de marketing.
