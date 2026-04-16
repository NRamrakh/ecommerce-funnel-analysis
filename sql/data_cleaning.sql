-- E-Commerce Funnel Analysis
-- Step 1: Data Cleaning
-- Remove invalid prices and handle null categorical values

CREATE TABLE ecommerce_cleandata AS
SELECT
    event_time,
    event_type,
    product_id,
    category_id,
    COALESCE(category_code, 'Unknown') AS category_code,
    COALESCE(brand, 'Unknown') AS brand,
    price,
    user_id,
    user_session
FROM ecommerce_events
WHERE price > 0
AND event_type IN ('view', 'cart', 'purchase');

-- Sanity checks
SELECT MIN(price), MAX(price) FROM ecommerce_cleandata;
SELECT DISTINCT event_type FROM ecommerce_cleandata;
SELECT COUNT(*) AS total_rows FROM ecommerce_cleandata;