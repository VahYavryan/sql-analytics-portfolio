SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM (total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 1
ORDER BY total_revenue DESC;

SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM (total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 1
ORDER BY total_revenue DESC;

SELECT
	 transaction_id,
	 order_date_date,
	 CURRENT_DATE - order_date_date AS days_since_order
FROM sales_analysis;

SELECT
	*
FROM sales_analysis
WHERE order_date_date >= CURRENT_DATE - INTERVAL '60 days';
