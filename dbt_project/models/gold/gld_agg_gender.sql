WITH base_data AS (
    SELECT * FROM {{ ref('gld_customer_churn_features') }}
),

dim_gender AS (
    SELECT * FROM {{ ref('gld_dim_gender') }}
)

SELECT
    dg.gender_id,
    dg.gender,
    COUNT(*) AS total_customers,
    ROUND(CAST(CAST(SUM(bd.is_churned) AS FLOAT) / NULLIF(COUNT(*), 0) AS NUMERIC), 4) AS churn_rate,
    ROUND(CAST(AVG(bd.lifetime_value) AS NUMERIC), 2) AS avg_lifetime_value,
    ROUND(CAST(AVG(bd.age) AS NUMERIC), 1) AS avg_age
FROM base_data bd
JOIN dim_gender dg ON bd.gender_id = dg.gender_id
GROUP BY 1, 2
ORDER BY 1
