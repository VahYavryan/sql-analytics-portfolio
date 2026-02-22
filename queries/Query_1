CREATE TABLE IF NOT EXISTS sales_analysis AS
SELECT
    s.transaction_id,

    o.order_date,
    DATE(o.order_date) AS order_date_date,
    o.year,
    o.quarter,
    o.month,

    c.customer_name,
    c.city,
    c.zip_code,

    p.product_name,
    p.category,
    p.price,

    e.first_name  AS employee_first_name,
    e.last_name   AS employee_last_name,
    e.salary      AS employee_salary,

    s.quantity,
    s.discount,
    s.total_sales

FROM sales AS s
JOIN orders AS o
    ON s.order_id = o.order_id
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_id;

CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);

CREATE transaction_id,
    ,order_date_date
    ,product_name
    ,total_sales
FROM sales_analysis
WHERE total_sales > 1000
;

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Electronics';

SELECT
    transaction_id,
    order_date_date,
    year,
    product_name,
    total_sales
FROM sales_analysis
WHERE year = 2023
  AND total_sales > 10000;

SELECT transaction_id,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
AND category = 'Electronics';

SELECT
    transaction_id,
    order_date_date,
    city,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
   OR city = 'Smithside';

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Toys'
   OR category = 'Books';

SELECT
    transaction_id,
    order_date_date,
    total_sales
FROM sales_analysis
WHERE total_sales BETWEEN 50000 AND 150000;

SELECT
    transaction_id,
    year,
    total_sales
FROM sales_analysis
WHERE year BETWEEN 2022 AND 2024;

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city IN ('East Amanda', 'Smithside', 'Lake Thomas');

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category IN ('Electronics', 'Books');

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city NOT IN ('East Lori', 'Anthonymouth');

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category NOT IN ('Toys', 'Books');

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city LIKE '%North%';

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE category LIKE 'B%ks'

SELECT
    product_name,
    order_date_date,
    COUNT(*) AS occurrence_count
FROM sales_analysis
GROUP BY product_name, order_date_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

SELECT
    customer_name,
    order_date_date,
    COUNT(*) AS transaction_count
FROM sales_analysis
GROUP BY customer_name, order_date_date
HAVING COUNT(*) > 1
ORDER BY transaction_count DESC;

SELECT
  AVG(total_sales) as customer_total
FROM sales_analysis
;
SELECT 
      customer_name,
CASE 
  WHEN AVG(total_sales) >= 150 THEN 'High Value'
  WHEN AVG(total_sales) >= 100 THEN 'Medium Value'
  WHEN AVG(total_sales) >= 30 THEN 'Low Value'
      ELSE 'Warning'
      END AS customer_total
FROM sales_analysis
  GROUP BY customer_name
