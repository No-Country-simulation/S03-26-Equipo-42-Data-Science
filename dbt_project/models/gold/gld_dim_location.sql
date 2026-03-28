WITH unique_locations AS (
    SELECT DISTINCT
        country,
        city
    FROM {{ ref('slv_ecommerce_churn') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY country, city) AS location_id,
    country,
    city
FROM unique_locations
