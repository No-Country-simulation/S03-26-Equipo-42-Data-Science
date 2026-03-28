WITH silver_data AS (
    SELECT * FROM {{ ref('slv_ecommerce_churn') }}
)

SELECT
    -- Identificadores y Demografía (Pasar directamente)
    -- Asumimos que la tabla silver ya tiene un ID si existiera (aquí usamos métricas de cliente)
    age,
    gender,
    country,
    city,
    signup_quarter,

    -- Métricas de Lealtad (Capa Gold: Features Engineering)
    membership_years,
    total_purchases,
    lifetime_value,
    (lifetime_value / NULLIF(total_purchases, 0)) AS avg_order_value_derived,

    -- Indicadores de Engagement (Gold)
    login_frequency,
    avg_session_duration,
    pages_per_session,
    social_media_engagement_score,
    mobile_app_usage_score,
    payment_method_diversity,

    -- Indicadores de Riesgo de Churn (Features clave)
    cart_abandonment_rate,
    customer_service_calls,
    returns_rate,
    days_since_last_purchase,

    -- Flag de Riesgo (Ejemplo de Regla de Negocio Gold)
    CASE
        WHEN customer_service_calls > 5 AND cart_abandonment_rate > 0.70 THEN 'High Risk'
        WHEN customer_service_calls > 3 OR days_since_last_purchase > 60 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,

    -- Marketing Feature
    discount_usage_rate,
    email_open_rate,
    product_reviews_written,

    -- Variable Objetivo
    is_churned

FROM silver_data
