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
