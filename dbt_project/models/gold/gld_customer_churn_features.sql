WITH silver_data AS (
    SELECT * FROM {{ ref('slv_ecommerce_churn') }}
),

dim_location AS (
    SELECT * FROM {{ ref('gld_dim_location') }}
),

dim_gender AS (
    SELECT * FROM {{ ref('gld_dim_gender') }}
)

SELECT
    -- Identidad y Demografía (Normalizada)
    sd.customer_id,
    sd.age,
    dg.gender_id,
    dl.location_id,
    sd.signup_quarter,

    -- Métricas de Lealtad (Capa Gold: Features Engineering)
    ROUND(CAST(sd.membership_years AS NUMERIC), 3) AS membership_years,
    ROUND(CAST(sd.total_purchases AS NUMERIC), 3) AS total_purchases,
    ROUND(CAST(sd.lifetime_value AS NUMERIC), 3) AS lifetime_value,
    ROUND(CAST((sd.lifetime_value / NULLIF(sd.total_purchases, 0)) AS NUMERIC), 3) AS avg_order_value_derived,

    -- Indicadores de Engagement (Gold)
    sd.login_frequency,
    ROUND(CAST(sd.avg_session_duration AS NUMERIC), 3) AS avg_session_duration,
    ROUND(CAST(sd.pages_per_session AS NUMERIC), 3) AS pages_per_session,
    ROUND(CAST(sd.social_media_engagement_score AS NUMERIC), 3) AS social_media_engagement_score,
    ROUND(CAST(sd.mobile_app_usage_score AS NUMERIC), 3) AS mobile_app_usage_score,
    sd.payment_method_diversity,

    -- Indicadores de Riesgo de Churn (Features clave)
    ROUND(CAST(sd.cart_abandonment_rate AS NUMERIC), 3) AS cart_abandonment_rate,
    sd.customer_service_calls,
    ROUND(CAST(sd.returns_rate AS NUMERIC), 3) AS returns_rate,
    sd.days_since_last_purchase,

    -- Flag de Riesgo (Ejemplo de Regla de Negocio Gold)
    CASE
        WHEN sd.customer_service_calls > 5 AND sd.cart_abandonment_rate > 0.70 THEN 'High Risk'
        WHEN sd.customer_service_calls > 3 OR sd.days_since_last_purchase > 60 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,

    -- Marketing Feature
    ROUND(CAST(sd.discount_usage_rate AS NUMERIC), 3) AS discount_usage_rate,
    ROUND(CAST(sd.email_open_rate AS NUMERIC), 3) AS email_open_rate,
    sd.product_reviews_written,

    -- Variable Objetivo
    sd.is_churned

FROM silver_data sd
JOIN dim_location dl ON sd.city = dl.city AND sd.country = dl.country
JOIN dim_gender dg ON sd.gender = dg.gender
