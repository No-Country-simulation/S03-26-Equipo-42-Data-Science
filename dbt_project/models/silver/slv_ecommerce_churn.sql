WITH raw_data AS (
    SELECT * FROM {{ source('bronze', 'br_ecommerce_churn') }}
),

averages AS (
    SELECT AVG(CAST(NULLIF("Age", '') AS FLOAT)) as avg_age FROM raw_data
)

SELECT
    -- Demografía
    COALESCE(CAST(CAST(NULLIF("Age", '') AS FLOAT) AS INT), (SELECT CAST(avg_age AS INT) FROM averages)) AS age,
    COALESCE("Gender", 'Other') AS gender,
    "Country" AS country,
    "City" AS city,

    -- Comportamiento de Membresía y Navegación
    CAST(NULLIF("Membership_Years", '') AS FLOAT) AS membership_years,
    CAST(NULLIF("Login_Frequency", '') AS FLOAT)::INT AS login_frequency,
    CAST(NULLIF("Session_Duration_Avg", '') AS FLOAT) AS avg_session_duration,
    CAST(NULLIF("Pages_Per_Session", '') AS FLOAT) AS pages_per_session,

    -- Métricas de Carrito y Compras
    CAST(NULLIF("Cart_Abandonment_Rate", '') AS FLOAT) / 100 AS cart_abandonment_rate,
    CAST(NULLIF("Wishlist_Items", '') AS FLOAT)::INT AS wishlist_items,
    CAST(NULLIF("Total_Purchases", '') AS FLOAT) AS total_purchases,
    CAST(NULLIF("Average_Order_Value", '') AS FLOAT) AS avg_order_value,
    CAST(NULLIF("Days_Since_Last_Purchase", '') AS FLOAT)::INT AS days_since_last_purchase,

    -- Marketing y Servicio al Cliente
    CAST(NULLIF("Discount_Usage_Rate", '') AS FLOAT) / 100 AS discount_usage_rate,
    CAST(NULLIF("Returns_Rate", '') AS FLOAT) / 100 AS returns_rate,
    CAST(NULLIF("Email_Open_Rate", '') AS FLOAT) / 100 AS email_open_rate,
    CAST(NULLIF("Customer_Service_Calls", '') AS FLOAT)::INT AS customer_service_calls,
    CAST(NULLIF("Product_Reviews_Written", '') AS FLOAT)::INT AS product_reviews_written,

    -- Engagement Digital
    CAST(NULLIF("Social_Media_Engagement_Score", '') AS FLOAT) AS social_media_engagement_score,
    CAST(NULLIF("Mobile_App_Usage", '') AS FLOAT) AS mobile_app_usage_score,
    COALESCE(CAST(NULLIF("Payment_Method_Diversity", '') AS FLOAT)::INT, 0) AS payment_method_diversity,

    -- Valor Financiero
    CAST(NULLIF("Lifetime_Value", '') AS FLOAT) AS lifetime_value,
    CAST(NULLIF("Credit_Balance", '') AS FLOAT) AS credit_balance,

    -- Variable Objetivo y Tiempo
    CAST(NULLIF("Churned", '') AS FLOAT)::INT AS is_churned,
    "Signup_Quarter" AS signup_quarter

FROM raw_data
