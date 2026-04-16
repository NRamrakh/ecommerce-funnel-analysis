-- Step 6: Brand Analysis
-- Impact of brand trust on conversion rates

SELECT
    COALESCE(brand, 'Unknown') AS brand,
    COUNT(*) FILTER (WHERE event_type = 'view') AS views,
    COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchases,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
        NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
    ) AS conversion_rate
FROM ecommerce_cleandata
GROUP BY COALESCE(brand, 'Unknown')
HAVING COUNT(*) FILTER (WHERE event_type = 'view') > 100
ORDER BY conversion_rate DESC;