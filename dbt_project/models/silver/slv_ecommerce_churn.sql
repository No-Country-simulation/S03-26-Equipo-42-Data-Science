WITH raw_data AS (
    SELECT * FROM {{ source('bronze', 'br_ecommerce_churn') }}
)

SELECT
    -- Demografía
    COALESCE(CAST(CAST(NULLIF("Age", '') AS FLOAT) AS INT), 0) AS age,
    COALESCE("Gender", 'Other') AS gender,
    "Country" AS country,
    "City" AS city,

    -- Comportamiento de Membresía y Navegación
    COALESCE(CAST(NULLIF("Membership_Years", '') AS FLOAT), 0) AS membership_years,
    COALESCE(CAST(NULLIF("Login_Frequency", '') AS FLOAT)::INT, 0) AS login_frequency,
    COALESCE(CAST(NULLIF("Session_Duration_Avg", '') AS FLOAT), 0) AS avg_session_duration,
    COALESCE(CAST(NULLIF("Pages_Per_Session", '') AS FLOAT), 0) AS pages_per_session,

    -- Métricas de Carrito y Compras
    COALESCE(CAST(NULLIF("Cart_Abandonment_Rate", '') AS FLOAT) / 100, 0) AS cart_abandonment_rate,
    COALESCE(CAST(NULLIF("Wishlist_Items", '') AS FLOAT)::INT, 0) AS wishlist_items,
    COALESCE(CAST(NULLIF("Total_Purchases", '') AS FLOAT), 0) AS total_purchases,
    COALESCE(CAST(NULLIF("Average_Order_Value", '') AS FLOAT), 0) AS avg_order_value,
    COALESCE(CAST(NULLIF("Days_Since_Last_Purchase", '') AS FLOAT)::INT, 0) AS days_since_last_purchase,

    -- Marketing y Servicio al Cliente
    COALESCE(CAST(NULLIF("Discount_Usage_Rate", '') AS FLOAT) / 100, 0) AS discount_usage_rate,
    COALESCE(CAST(NULLIF("Returns_Rate", '') AS FLOAT) / 100, 0) AS returns_rate,
    COALESCE(CAST(NULLIF("Email_Open_Rate", '') AS FLOAT) / 100, 0) AS email_open_rate,
    COALESCE(CAST(NULLIF("Customer_Service_Calls", '') AS FLOAT)::INT, 0) AS customer_service_calls,
    COALESCE(CAST(NULLIF("Product_Reviews_Written", '') AS FLOAT)::INT, 0) AS product_reviews_written,

    -- Engagement Digital
    COALESCE(CAST(NULLIF("Social_Media_Engagement_Score", '') AS FLOAT), 0) AS social_media_engagement_score,
    COALESCE(CAST(NULLIF("Mobile_App_Usage", '') AS FLOAT), 0) AS mobile_app_usage_score,
    COALESCE(CAST(NULLIF("Payment_Method_Diversity", '') AS FLOAT)::INT, 0) AS payment_method_diversity,

    -- Valor Financiero
    COALESCE(CAST(NULLIF("Lifetime_Value", '') AS FLOAT), 0) AS lifetime_value,
    COALESCE(CAST(NULLIF("Credit_Balance", '') AS FLOAT), 0) AS credit_balance,

    -- Variable Objetivo y Tiempo
    COALESCE(CAST(NULLIF("Churned", '') AS FLOAT)::INT, 0) AS is_churned,
    "Signup_Quarter" AS signup_quarter

FROM raw_data
