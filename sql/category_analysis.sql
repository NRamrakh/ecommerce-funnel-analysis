-- Step 3: Category Analysis
-- Conversion rates by product category

SELECT
    category_code,
    COUNT(*) FILTER (WHERE event_type = 'view') AS views,
    COUNT(*) FILTER (WHERE event_type = 'cart') AS carts,
    COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchases,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE event_type = 'cart') /
        NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
    ) AS cart_rate,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
        NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
    ) AS purchase_rate
FROM ecommerce_cleandata
WHERE category_code IS NOT NULL
GROUP BY category_code
HAVING COUNT(*) FILTER (WHERE event_type = 'view') > 100
ORDER BY purchase_rate DESC;