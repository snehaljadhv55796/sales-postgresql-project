-- Create clean tables
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_name FROM sales_raw;

CREATE TABLE products AS
SELECT product_id, MIN(product_name)
FROM sales_raw
GROUP BY product_id;