-- Try Yourself
SELECT
	*
FROM analytics.customers

-- View

-- CREATE OR REPLACE VIEW analytics.v_product_price AS
-- SELECT
-- 	product_id,
-- 	category,
-- 	product_name,
-- 	price,
	
-- 	CASE
-- 		WHEN price < 10 THEN 'Low Price'
-- 		WHEN price BETWEEN 10 AND 14.76 THEN 'Medium Price'
-- 		ELSE 'High Price'
-- 	END AS prices_category
-- FROM analytics.products

SELECT
	*
FROM analytics.v_product_price


-- UDF
-- DROP FUNCTION analytics.fn_total_revenue
-- CREATE OR REPLACE FUNCTION analytics.fn_total_revenue()
-- RETURNS TABLE(
-- 	product_id NUMERIC,
-- 	product_name TEXT,
-- 	prices_category TEXT,
-- 	pro_total_revenue NUMERIC,
-- 	total_revenue_lvl TEXT
-- )
-- LANGUAGE sql
-- AS $$
-- 	SELECT
-- 		v.product_id,
-- 		v.product_name,
-- 		v.prices_category,
-- 		SUM(v.price * oi.quantity) AS pro_total_revenue,
		
-- 		CASE 
-- 			WHEN COALESCE(SUM(v.price * oi.quantity), 0) < 300 THEN 'Low Revenue'
-- 			WHEN COALESCE(SUM(v.price * oi.quantity), 0) BETWEEN 300 AND 600 THEN 'Medium Revenue'
-- 			ELSE 'High Revenue'
-- 		END AS total_revenue_lvl
		
-- 	FROM analytics.v_product_price v
-- 	LEFT JOIN analytics.order_items oi ON (v.product_id = oi.product_id)
-- 	GROUP BY v.product_id, v.product_name, v.prices_category;
-- $$;

SELECT
	*
FROM analytics.fn_total_revenue()
ORDER BY pro_total_revenue ASC

-- CREATE TABLE analytics.product_revenue_report (
-- 	product_id NUMERIC,
-- 	product_name TEXT,
-- 	prices_category TEXT,
-- 	pro_total_revenue NUMERIC,
-- 	total_revenue_lvl TEXT
-- );

-- Stored Procedure
CREATE OR REPLACE PROCEDURE analytics.sp_update_product_revenue()
LANGUAGE plpgsql
AS $$
BEGIN
 -- Cleare old data
 DELETE FROM analytics.product_revenue_report;

 -- Insert fresh data from UDF
--  INSERT INTO analytics.product_revenue_report
--  (
-- 		product_id,
--         product_name,
--         prices_category,
--         pro_total_revenue,
--         total_revenue_lvl
--  )
--  SELECT
--  	*
--  FROM analytics.fn_total_revenue();

--  END;
--  $$;



-- CALL analytics.sp_update_product_revenue();

SELECT
	*
FROM analytics.product_revenue_report;