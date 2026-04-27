-- ==============================
-- SALES ANALYTICS QUERIES
-- ==============================

-- 1. Total Revenue
SELECT SUM(sales) AS total_revenue
FROM sales;


-- 2. Top 10 Products by Revenue
SELECT p.product_name, SUM(s.sales) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- 3. Top 10 Customers by Spending
SELECT c.customer_name, SUM(s.sales) AS total_spent
FROM sales s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Sales by Category
SELECT p.category, SUM(s.sales) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 5. Sales by Region
SELECT region, SUM(sales) AS revenue
FROM sales_raw
GROUP BY region
ORDER BY revenue DESC;


-- 6. Monthly Sales Trend
SELECT DATE_TRUNC('month', order_date) AS month,
SUM(sales) AS revenue
FROM sales_raw
GROUP BY month
ORDER BY month;


-- 7. Orders Count per Customer
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;


-- 8. Average Order Value
SELECT AVG(sales) AS avg_order_value
FROM sales;


-- 9. Top 5 Cities by Revenue
SELECT city, SUM(sales) AS revenue
FROM sales_raw
GROUP BY city
ORDER BY revenue DESC
LIMIT 5;


-- 10. Customer Ranking (Window Function)
SELECT c.customer_name,
SUM(s.sales) AS total_spent,
RANK() OVER (ORDER BY SUM(s.sales) DESC) AS rank
FROM sales s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name;

