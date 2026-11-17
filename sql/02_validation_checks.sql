USE OlistAnalysis;

-- 1. Headline numbers (expected: 13449530 / 97905)
SELECT ROUND(SUM(i.price), 0)     AS revenue,
       COUNT(DISTINCT i.order_id) AS orders
FROM dbo.order_items i
JOIN dbo.orders o ON o.order_id = i.order_id
WHERE o.in_scope = 1 AND o.is_excluded = 0;

-- 2. Average order value (expected: 137.37)
SELECT ROUND(AVG(t.order_revenue), 2) AS avg_order_value
FROM (SELECT i.order_id, SUM(i.price) AS order_revenue
      FROM dbo.order_items i
      JOIN dbo.orders o ON o.order_id = i.order_id
      WHERE o.in_scope = 1 AND o.is_excluded = 0
      GROUP BY i.order_id) t;

-- 3. Jan-Aug comparison (expected: 2017 = 3080851 / 22562 orders, 2018 = 7341037 / 53530 orders)
SELECT YEAR(o.order_date)             AS yr,
       ROUND(SUM(i.price), 0)         AS revenue,
       COUNT(DISTINCT i.order_id)     AS orders
FROM dbo.order_items i
JOIN dbo.orders o ON o.order_id = i.order_id
WHERE o.in_scope = 1 AND o.is_excluded = 0 AND MONTH(o.order_date) <= 8
GROUP BY YEAR(o.order_date)
ORDER BY yr;

-- 4. ZIP codes kept their leading zeros, and the flags loaded as 1/0
SELECT TOP 3 customer_zip_code_prefix FROM dbo.customers WHERE customer_zip_code_prefix LIKE '0%';
SELECT in_scope, is_excluded, COUNT(*) AS n FROM dbo.orders GROUP BY in_scope, is_excluded;