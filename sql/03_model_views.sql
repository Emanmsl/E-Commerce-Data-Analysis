-- 03_model_views.sql
-- Star schema views for Power BI.
USE OlistAnalysis;
GO

CREATE OR ALTER VIEW dbo.vw_dim_customer AS
SELECT c.customer_id,
       c.customer_unique_id,
       c.customer_city,
       c.customer_state,
       g.lat,
       g.lng
FROM dbo.customers c
LEFT JOIN dbo.geolocation_zip g
       ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix;
GO

CREATE OR ALTER VIEW dbo.vw_dim_product AS
SELECT product_id,
       category
FROM dbo.products;
GO

CREATE OR ALTER VIEW dbo.vw_dim_seller AS
SELECT s.seller_id,
       s.seller_city,
       s.seller_state
FROM dbo.sellers s;
GO

CREATE OR ALTER VIEW dbo.vw_fact_order_items AS
SELECT i.order_id,
       i.order_item_id,
       i.product_id,
       i.seller_id,
       CAST(o.order_date AS date) AS order_date,
       i.price,
       i.freight_value,
       CASE WHEN o.in_scope = 1 AND o.is_excluded = 0 THEN 1 ELSE 0 END AS is_valid_sale
FROM dbo.order_items i
JOIN dbo.orders o ON o.order_id = i.order_id;
GO

CREATE OR ALTER VIEW dbo.vw_fact_orders AS
SELECT o.order_id,
       o.customer_id,
       CAST(o.order_date AS date) AS order_date,
       o.order_status,
       CASE WHEN o.in_scope = 1 AND o.is_excluded = 0 THEN 1 ELSE 0 END AS is_valid_sale,
       o.delivery_days,
       CASE WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
            THEN CASE WHEN CAST(o.order_delivered_customer_date AS date) > CAST(o.order_estimated_delivery_date AS date)
                      THEN 1 ELSE 0 END
       END AS is_late,
       r.review_score,
       p.payment_total,
       p.main_payment_type,
       p.max_installments,
       ISNULL(i.items_price, 0) AS items_price,
       ISNULL(i.freight, 0)     AS freight_value,
       ISNULL(i.item_count, 0)  AS item_count
FROM dbo.orders o
LEFT JOIN dbo.reviews r           ON r.order_id = o.order_id
LEFT JOIN dbo.payments_by_order p ON p.order_id = o.order_id
LEFT JOIN (SELECT order_id,
                  SUM(price)         AS items_price,
                  SUM(freight_value) AS freight,
                  COUNT(*)           AS item_count
           FROM dbo.order_items
           GROUP BY order_id) i    ON i.order_id = o.order_id;
GO