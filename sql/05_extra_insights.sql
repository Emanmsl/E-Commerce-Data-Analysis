USE OlistAnalysis;

-- unique customers with more than one valid order
WITH cust AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS orders
    FROM dbo.vw_fact_orders o
    JOIN dbo.vw_dim_customer c ON c.customer_id = o.customer_id
    WHERE o.is_valid_sale = 1
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS customers,
       SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
       ROUND(100.0 * SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS repeat_pct
FROM cust;

-- Freight cost as a share of item price by customer state (states with 500+ orders)
SELECT c.customer_state,
       COUNT(*) AS orders,
       ROUND(100.0 * SUM(o.freight_value) / SUM(o.items_price), 1) AS freight_pct_of_price,
       ROUND(AVG(o.delivery_days), 1) AS avg_delivery_days
FROM dbo.vw_fact_orders o
JOIN dbo.vw_dim_customer c ON c.customer_id = o.customer_id
WHERE o.is_valid_sale = 1 AND o.item_count > 0
GROUP BY c.customer_state
HAVING COUNT(*) > 500
ORDER BY freight_pct_of_price DESC;

-- Payment type: share of orders, average order value, average installments
SELECT main_payment_type,
       COUNT(*) AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_orders,
       ROUND(AVG(items_price), 2) AS avg_order_value,
       ROUND(AVG(CAST(max_installments AS float)), 1) AS avg_installments
FROM dbo.vw_fact_orders
WHERE is_valid_sale = 1 AND main_payment_type IS NOT NULL
GROUP BY main_payment_type
ORDER BY orders DESC;