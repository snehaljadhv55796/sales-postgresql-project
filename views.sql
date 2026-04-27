CREATE VIEW sales_dashboard AS
SELECT region, SUM(sales) AS revenue
FROM sales_raw
GROUP BY region;

SELECT * FROM sales_dashboard;