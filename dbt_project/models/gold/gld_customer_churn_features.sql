WITH silver_data AS (
    SELECT * FROM {{ ref('slv_ecommerce_churn') }}
)

SELECT
    -- Identificadores y Demografía
    age,
    gender,
    country,
    city,
    signup_quarter,

    -- Métricas de Lealtad (Capa Gold: Features Engineering)
    ROUND(CAST(membership_years AS NUMERIC), 3) AS membership_years,
    ROUND(CAST(total_purchases AS NUMERIC), 3) AS total_purchases,
    ROUND(CAST(lifetime_value AS NUMERIC), 3) AS lifetime_value,
    ROUND(CAST((lifetime_value / NULLIF(total_purchases, 0)) AS NUMERIC), 3) AS avg_order_value_derived,

    -- Indicadores de Engagement (Gold)
    login_frequency,
    ROUND(CAST(avg_session_duration AS NUMERIC), 3) AS avg_session_duration,
    ROUND(CAST(pages_per_session AS NUMERIC), 3) AS pages_per_session,
    ROUND(CAST(social_media_engagement_score AS NUMERIC), 3) AS social_media_engagement_score,
    ROUND(CAST(mobile_app_usage_score AS NUMERIC), 3) AS mobile_app_usage_score,
    payment_method_diversity,

    -- Indicadores de Riesgo de Churn (Features clave)
    ROUND(CAST(cart_abandonment_rate AS NUMERIC), 3) AS cart_abandonment_rate,
    customer_service_calls,
    ROUND(CAST(returns_rate AS NUMERIC), 3) AS returns_rate,
    days_since_last_purchase,

    -- Flag de Riesgo (Ejemplo de Regla de Negocio Gold)
    CASE
        WHEN customer_service_calls > 5 AND cart_abandonment_rate > 0.70 THEN 'High Risk'
        WHEN customer_service_calls > 3 OR days_since_last_purchase > 60 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,

    -- Marketing Feature
    ROUND(CAST(discount_usage_rate AS NUMERIC), 3) AS discount_usage_rate,
    ROUND(CAST(email_open_rate AS NUMERIC), 3) AS email_open_rate,
    product_reviews_written,

    -- Variable Objetivo
    is_churned

FROM silver_data
