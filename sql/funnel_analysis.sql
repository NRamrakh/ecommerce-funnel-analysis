-- Step 2: Funnel Analysis
-- User-level and session-level conversion rates

-- User-level funnel
SELECT
    users_viewed,
    users_carted,
    users_purchased,
    ROUND(100.0 * users_carted / NULLIF(users_viewed, 0), 2) 
        AS user_cart_rate,
    ROUND(100.0 * users_purchased / NULLIF(users_viewed, 0), 2) 
        AS user_purchase_rate
FROM (
    SELECT
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view') 
            AS users_viewed,
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'cart') 
            AS users_carted,
        COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase') 
            AS users_purchased
    FROM ecommerce_cleandata
) u;

-- Session-level funnel using CTE
WITH session_flags AS (
    SELECT
        user_session,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS carted,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM ecommerce_cleandata
    GROUP BY user_session
)
SELECT
    COUNT(*) AS total_sessions,
    COUNT(*) FILTER (WHERE viewed = 1) AS sessions_with_view,
    COUNT(*) FILTER (WHERE carted = 1) AS sessions_with_cart,
    COUNT(*) FILTER (WHERE purchased = 1) AS sessions_with_purchase,
    ROUND(100.0 * COUNT(*) FILTER (WHERE carted = 1) 
        / NULLIF(COUNT(*) FILTER (WHERE viewed = 1), 0), 2) 
        AS session_cart_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE purchased = 1) 
        / NULLIF(COUNT(*) FILTER (WHERE viewed = 1), 0), 2) 
        AS session_purchase_rate
FROM session_flags;

-- Event-level funnel for dashboard
SELECT 'View' AS stage, COUNT(*) AS count
FROM ecommerce_cleandata WHERE event_type = 'view'
UNION ALL
SELECT 'Cart', COUNT(*)
FROM ecommerce_cleandata WHERE event_type = 'cart'
UNION ALL
SELECT 'Purchase', COUNT(*)
FROM ecommerce_cleandata WHERE event_type = 'purchase';