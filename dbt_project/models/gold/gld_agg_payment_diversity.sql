WITH base_data AS (
    SELECT * FROM {{ ref('gld_customer_churn_features') }}
)

SELECT
    payment_method_diversity,
    COUNT(*) AS total_customers,
    ROUND(CAST(CAST(SUM(is_churned) AS FLOAT) / NULLIF(COUNT(*), 0) AS NUMERIC), 4) AS churn_rate,
    ROUND(CAST(AVG(lifetime_value) AS NUMERIC), 2) AS avg_lifetime_value,
    ROUND(CAST(AVG(age) AS NUMERIC), 1) AS avg_age
FROM base_data
GROUP BY 1
ORDER BY 1
