WITH raw_data AS (
    SELECT * FROM {{ source('bronze', 'br_ecommerce_churn') }}
)

SELECT
    -- Demografía
    CAST("Age" AS INT) AS age,
    "Gender" AS gender,
    "Country" AS country,
    "City" AS city,

    -- Comportamiento de Membresía y Navegación
    CAST("Membership_Years" AS FLOAT) AS membership_years,
    CAST("Login_Frequency" AS INT) AS login_frequency,
    CAST("Session_Duration_Avg" AS FLOAT) AS avg_session_duration,
    CAST("Pages_Per_Session" AS FLOAT) AS pages_per_session,

    -- Métricas de Carrito y Compras
    CAST("Cart_Abandonment_Rate" AS FLOAT) / 100 AS cart_abandonment_rate,
    CAST("Wishlist_Items" AS INT) AS wishlist_items,
    CAST("Total_Purchases" AS FLOAT) AS total_purchases,
    CAST("Average_Order_Value" AS FLOAT) AS avg_order_value,
    CAST("Days_Since_Last_Purchase" AS INT) AS days_since_last_purchase,

    -- Marketing y Servicio al Cliente
    CAST("Discount_Usage_Rate" AS FLOAT) / 100 AS discount_usage_rate,
    CAST("Returns_Rate" AS FLOAT) / 100 AS returns_rate,
    CAST("Email_Open_Rate" AS FLOAT) / 100 AS email_open_rate,
    CAST("Customer_Service_Calls" AS INT) AS customer_service_calls,
    CAST("Product_Reviews_Written" AS INT) AS product_reviews_written,

    -- Engagement Digital
    CAST("Social_Media_Engagement_Score" AS FLOAT) AS social_media_engagement_score,
    CAST("Mobile_App_Usage" AS FLOAT) AS mobile_app_usage_score,
    CAST("Payment_Method_Diversity" AS INT) AS payment_method_diversity,

    -- Valor Financiero
    CAST("Lifetime_Value" AS FLOAT) AS lifetime_value,
    CAST("Credit_Balance" AS FLOAT) AS credit_balance,

    -- Variable Objetivo y Tiempo
    CAST("Churned" AS INT) AS is_churned,
    "Signup_Quarter" AS signup_quarter

FROM raw_data
