WITH unique_genders AS (
    SELECT DISTINCT gender
    FROM {{ ref('slv_ecommerce_churn') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY gender) AS gender_id,
    gender
FROM unique_genders
