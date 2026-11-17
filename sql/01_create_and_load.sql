-- 01_create_and_load.sql

USE master;
GO
IF DB_ID('OlistAnalysis') IS NOT NULL
BEGIN
    ALTER DATABASE OlistAnalysis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OlistAnalysis;
END
GO
CREATE DATABASE OlistAnalysis;
GO
USE OlistAnalysis;
GO

-- 1. Tables ---------------------------------------------------------------
CREATE TABLE dbo.orders (
    order_id                       varchar(32) NOT NULL PRIMARY KEY,
    customer_id                    varchar(32) NOT NULL,
    order_status                   varchar(20),
    order_purchase_timestamp       datetime2(0),
    order_approved_at              datetime2(0),
    order_delivered_carrier_date   datetime2(0),
    order_delivered_customer_date  datetime2(0),
    order_estimated_delivery_date  datetime2(0),
    order_date                     datetime2(0),
    in_scope                       bit,
    is_excluded                    bit,
    missing_delivery_date          bit,
    delivery_days                  float,
    carrier_date_after_delivery    bit,
    extreme_delivery               bit,
    has_items                      bit,
    has_payment                    bit
);

CREATE TABLE dbo.order_items (
    order_id             varchar(32) NOT NULL,
    order_item_id        int NOT NULL,
    product_id           varchar(32) NOT NULL,
    seller_id            varchar(32) NOT NULL,
    shipping_limit_date  datetime2(0),
    price                decimal(12,2),
    freight_value        decimal(12,2),
    line_total           float,
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE dbo.payments (
    order_id              varchar(32) NOT NULL,
    payment_sequential    int NOT NULL,
    payment_type          varchar(20),
    payment_installments  int,
    payment_value         decimal(12,2),
    is_zero_payment       bit,
    invalid_installments  bit,
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE dbo.payments_by_order (
    order_id           varchar(32) NOT NULL PRIMARY KEY,
    payment_total      float,
    payment_rows       int,
    max_installments   int,
    main_payment_type  varchar(20),
    items_total        float,
    diff               float,
    payment_mismatch   bit
);

CREATE TABLE dbo.reviews (
    review_id                varchar(32) NOT NULL,
    order_id                 varchar(32) NOT NULL PRIMARY KEY,
    review_score             int,
    review_creation_date     datetime2(0),
    review_answer_timestamp  datetime2(0),
    has_comment              bit
);

CREATE TABLE dbo.products (
    product_id                   varchar(32) NOT NULL PRIMARY KEY,
    product_category_name        varchar(100),
    product_name_length          float,
    product_description_length   float,
    product_photos_qty           float,
    product_weight_g             float,
    product_length_cm            float,
    product_height_cm            float,
    product_width_cm             float,
    category                     varchar(100),
    invalid_weight               bit
);

CREATE TABLE dbo.sellers (
    seller_id               varchar(32) NOT NULL PRIMARY KEY,
    seller_zip_code_prefix  varchar(5),
    seller_city             varchar(100),
    seller_state            varchar(2)
);

CREATE TABLE dbo.customers (
    customer_id              varchar(32) NOT NULL PRIMARY KEY,
    customer_unique_id       varchar(32) NOT NULL,
    customer_zip_code_prefix varchar(5),
    customer_city            varchar(100),
    customer_state           varchar(2)
);

CREATE TABLE dbo.geolocation_zip (
    geolocation_zip_code_prefix varchar(5) NOT NULL PRIMARY KEY,
    lat    float,
    lng    float,
    city   varchar(100),
    state  varchar(2)
);

CREATE TABLE dbo.cleaning_log (
    table_name     varchar(100),
    issue          varchar(300),
    action         varchar(600),
    rows_affected  int
);
GO

-- 2. Load the CSV files -----------------------------------------------------
-- The CSV files were written by Python with \n line endings, so ROWTERMINATOR is 0x0a.
DECLARE @p nvarchar(300) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\olist_clean\';
DECLARE @opts nvarchar(300) = N'''' + N' WITH (FORMAT=''CSV'', FIRSTROW=2, FIELDQUOTE=''"'', ROWTERMINATOR=''0x0a'', CODEPAGE=''65001'', KEEPNULLS, TABLOCK);';

EXEC(N'BULK INSERT dbo.orders            FROM ''' + @p + N'orders_clean.csv'       + @opts);
EXEC(N'BULK INSERT dbo.order_items       FROM ''' + @p + N'order_items_clean.csv'  + @opts);
EXEC(N'BULK INSERT dbo.payments          FROM ''' + @p + N'payments_clean.csv'     + @opts);
EXEC(N'BULK INSERT dbo.payments_by_order FROM ''' + @p + N'payments_by_order.csv'  + @opts);
EXEC(N'BULK INSERT dbo.reviews           FROM ''' + @p + N'reviews_clean.csv'      + @opts);
EXEC(N'BULK INSERT dbo.products          FROM ''' + @p + N'products_clean.csv'     + @opts);
EXEC(N'BULK INSERT dbo.sellers           FROM ''' + @p + N'sellers_clean.csv'      + @opts);
EXEC(N'BULK INSERT dbo.customers         FROM ''' + @p + N'customers_clean.csv'    + @opts);
EXEC(N'BULK INSERT dbo.geolocation_zip   FROM ''' + @p + N'geolocation_zip.csv'    + @opts);
EXEC(N'BULK INSERT dbo.cleaning_log      FROM ''' + @p + N'cleaning_log.csv'       + @opts);
GO

SELECT 'orders' AS tbl, COUNT(*) AS n FROM dbo.orders
UNION ALL SELECT 'order_items',       COUNT(*) FROM dbo.order_items
UNION ALL SELECT 'payments',          COUNT(*) FROM dbo.payments
UNION ALL SELECT 'payments_by_order', COUNT(*) FROM dbo.payments_by_order
UNION ALL SELECT 'reviews',           COUNT(*) FROM dbo.reviews
UNION ALL SELECT 'products',          COUNT(*) FROM dbo.products
UNION ALL SELECT 'sellers',           COUNT(*) FROM dbo.sellers
UNION ALL SELECT 'customers',         COUNT(*) FROM dbo.customers
UNION ALL SELECT 'geolocation_zip',   COUNT(*) FROM dbo.geolocation_zip
UNION ALL SELECT 'cleaning_log',      COUNT(*) FROM dbo.cleaning_log;