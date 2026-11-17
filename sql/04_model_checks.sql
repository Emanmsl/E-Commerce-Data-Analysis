USE OlistAnalysis;

-- Row counts (expected: 112650, 99441, 99441, 32951, 3095)
SELECT 'fact_order_items' AS vw, COUNT(*) AS n FROM dbo.vw_fact_order_items
UNION ALL SELECT 'fact_orders',  COUNT(*) FROM dbo.vw_fact_orders
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dbo.vw_dim_customer
UNION ALL SELECT 'dim_product',  COUNT(*) FROM dbo.vw_dim_product
UNION ALL SELECT 'dim_seller',   COUNT(*) FROM dbo.vw_dim_seller;

-- Revenue from the views (expected: 13449530 / 97905)
SELECT ROUND(SUM(price), 0) AS revenue, COUNT(DISTINCT order_id) AS orders
FROM dbo.vw_fact_order_items WHERE is_valid_sale = 1;

-- Joining the facts to the dimensions must not add or lose rows (expected: 112650)
SELECT COUNT(*) AS joined_rows
FROM dbo.vw_fact_order_items f
JOIN dbo.vw_fact_orders   o ON o.order_id   = f.order_id
JOIN dbo.vw_dim_customer  c ON c.customer_id = o.customer_id
JOIN dbo.vw_dim_product   p ON p.product_id = f.product_id
JOIN dbo.vw_dim_seller    s ON s.seller_id  = f.seller_id;

-- First look at the business: top 5 categories by revenue, and the late-delivery rate
SELECT TOP 5 p.category, ROUND(SUM(f.price), 0) AS revenue
FROM dbo.vw_fact_order_items f
JOIN dbo.vw_dim_product p ON p.product_id = f.product_id
WHERE f.is_valid_sale = 1
GROUP BY p.category
ORDER BY revenue DESC;

SELECT ROUND(100.0 * AVG(CAST(is_late AS float)), 1) AS late_delivery_pct
FROM dbo.vw_fact_orders
WHERE is_valid_sale = 1 AND is_late IS NOT NULL;