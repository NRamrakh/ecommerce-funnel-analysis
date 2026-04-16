-- Step 5: Price Band Analysis
-- Does lower price mean higher conversion?

SELECT *
FROM (
    SELECT
        CASE
            WHEN price < 20 THEN 'Under 20'
            WHEN price >= 20 AND price < 50 THEN '20-49'
            WHEN price >= 50 AND price < 100 THEN '50-99'
            WHEN price >= 100 AND price < 200 THEN '100-199'
            ELSE '200+'
        END AS price_band,
        COUNT(*) FILTER (WHERE event_type = 'view') AS views,
        COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchases,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_type = 'purchase') /
            NULLIF(COUNT(*) FILTER (WHERE event_type = 'view'), 0), 2
        ) AS conversion_rate
    FROM ecommerce_cleandata
    GROUP BY price_band
) t
ORDER BY
    CASE price_band
        WHEN 'Under 20' THEN 1
        WHEN '20-49' THEN 2
        WHEN '50-99' THEN 3
        WHEN '100-199' THEN 4
        ELSE 5
    END;