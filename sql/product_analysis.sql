-- Step 4: Product Analysis
-- High-traffic, low-conversion products

SELECT
    product_id,
    MAX(brand) AS brand,
    MAX(category_code) AS category,
    COUNT(*) FILTER (WHERE event_type = 'view') AS views,
    COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchases,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
        NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
    ) AS conversion_rate,
    CASE
        WHEN ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
            NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
        ) >= 7 THEN 'High'
        WHEN ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
            NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
        ) >= 4 THEN 'Medium'
        ELSE 'Low'
    END AS performance
FROM ecommerce_cleandata
GROUP BY product_id
HAVING COUNT(*) FILTER (WHERE event_type = 'view') > 50
ORDER BY views DESC;