 --create table sales_raw
CREATE TABLE sales_raw (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales NUMERIC(10,2)
);

--select
SELECT * FROM sales_raw;


--CREATE TABLE customers AS
CREATE TABLE customers AS 
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM sales_raw;

--select
select *from customers;

--CREATE TABLE products AS
CREATE TABLE products AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM sales_raw;

--select
select * from products;

--CREATE TABLE locations AS
CREATE TABLE locations AS
SELECT DISTINCT
    country,
    city,
    state,
    postal_code,
    region
FROM sales_raw;

--select
select * from locations;

--CREATE TABLE orders AS
CREATE TABLE orders AS
SELECT DISTINCT
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id
FROM sales_raw;

--select
select * from orders;

--CREATE TABLE sales AS
CREATE TABLE sales AS
SELECT
    row_id,
    order_id,
    product_id,
    sales,
    city
FROM sales_raw;

--select
select * from sales;

--add primary key
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

--check duplicates
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--add foreign key
ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

--add primary key
ALTER TABLE orders
ADD PRIMARY KEY (order_id);


--add foreign key
ALTER TABLE sales
ADD FOREIGN KEY (order_id) 
REFERENCES orders(order_id);


--Recreate products table properly
--DROP TABLE products;

--Create clean products table


CREATE TABLE products AS
SELECT 
    product_id,
    MIN(product_name) AS product_name,
    MIN(category) AS category,
    MIN(sub_category) AS sub_category
FROM sales_raw
GROUP BY product_id;


CREATE TABLE products AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM sales_raw;

--select
SELECT * FROM products

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


--Total Revenue
SELECT SUM(sales) AS total_revenue FROM sales;

--Top 10 Products
SELECT p.product_name, SUM(s.sales) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

--Top Customers
SELECT c.customer_name, SUM(s.sales) AS total_spent
FROM sales s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

--Sales by Region
SELECT region, SUM(sales) AS revenue
FROM sales_raw
GROUP BY region
ORDER BY revenue DESC;

--Monthly Trend
SELECT DATE_TRUNC('month', order_date) AS month,
       SUM(sales) AS revenue
FROM sales_raw
GROUP BY month
ORDER BY month;

--CREATE VIEW
CREATE VIEW sales_dashboard AS
SELECT 
    region,
    category,
    SUM(sales) AS revenue
FROM sales_raw
GROUP BY region, category;

SELECT * FROM sales_dashboard;

--INDEXING
CREATE INDEX idx_order_id ON sales(order_id);
CREATE INDEX idx_product_id ON sales(product_id);

--See indexes using SQL
SELECT indexname, tablename, indexdef
FROM pg_indexes
WHERE tablename = 'sales';


--See specific index
SELECT * FROM pg_indexes
WHERE indexname = 'idx_order_id';


--Using PostgreSQL system catalog
SELECT *
FROM pg_class
WHERE relname LIKE 'idx%';


--Check if index is used
EXPLAIN ANALYZE
SELECT * FROM sales WHERE order_id = 'CA-2016-152156';


--Window Function (Ranking)
SELECT customer_name,
       SUM(sales) AS total,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
FROM sales_raw
GROUP BY customer_name;

--CTE
WITH high_sales AS (
    SELECT * FROM sales_raw WHERE sales > 1000
)
SELECT COUNT(*) FROM high_sales;

--CLEAN DATA
DELETE FROM sales_raw
WHERE sales IS NULL;


