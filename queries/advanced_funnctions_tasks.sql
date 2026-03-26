CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 2, 'Yerevan', 'online',  'Electronics'),
        (2,  'A', DATE '2024-01-02', 120, 1, 'Yerevan', 'store',   'Clothing'),
        (3,  'A', DATE '2024-01-03', 90,  3, 'Gyumri',  'online',  'Groceries'),
        (4,  'A', DATE '2024-01-04', 130, 2, 'Gyumri',  'store',   'Home'),

        (5,  'B', DATE '2024-01-01', 180, 4, 'Yerevan', 'store',   'Electronics'),
        (6,  'B', DATE '2024-01-02', 200, 2, 'Vanadzor','online',  'Clothing'),
        (7,  'B', DATE '2024-01-03', 220, 5, 'Vanadzor','online',  'Groceries'),
        (8,  'B', DATE '2024-01-04', 200, 3, 'Yerevan', 'store',   'Home'),

        (9,  'C', DATE '2024-01-01', 150, 2, 'Gyumri',  'online',  'Electronics'),
        (10, 'C', DATE '2024-01-02', 150, 1, 'Gyumri',  'online',  'Clothing'),
        (11, 'C', DATE '2024-01-03', 170, 3, 'Yerevan', 'online',  'Groceries'),

        (12, 'D', DATE '2024-01-01', 90,  1, 'Vanadzor','store',   'Clothing'),
        (13, 'D', DATE '2024-01-02', 110, 2, 'Vanadzor','store',   'Electronics'),

        (14, 'E', DATE '2024-01-01', 140, 2, 'Yerevan', 'store',   'Home'),
        (15, 'E', DATE '2024-01-02', 160, 3, 'Gyumri',  'online',  'Groceries'),
        (16, 'E', DATE '2024-01-03', 155, 2, 'Yerevan', 'store',   'Electronics')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    quantity,
    city,
    channel,
    category
);

-- Պարզ Aggregate Window Functions
SELECT DISTINCT
	customer_id,
	AVG(amount) OVER(
	PARTITION BY customer_id
	) AS customers_avg
FROM tmp_sales
ORDER BY customer_id ASC;


-- Վիճակագրական Window Functions
SELECT 
	customer_id,
	(amount * quantity) AS order_rev,
	PERCENT_RANK() OVER(
	PARTITION BY customer_id
	ORDER BY (amount * quantity)
	) AS order_rev_rank
FROM tmp_sales


-- Այլ Տողից Արժեք Վերցնող Ֆունկցիաներ
SELECT
	customer_id,
	sale_date,
	amount,
	amount
	- LAG(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	) AS amount_change
FROM tmp_sales


-- Ranking Ֆունկցիաներ
SELECT
	city,
	customer_id,
	total_spend,
	DENSE_RANK() OVER(
	PARTITION BY city
	ORDER BY total_spend DESC
	)
FROM (SELECT
	city,
	customer_id,
	SUM(amount) AS total_spend
FROM tmp_sales
GROUP BY city, customer_id
) t;


-- String Aggregation Window Functions
SELECT

    customer_id,
    STRING_AGG(category, '> ' ORDER BY category) AS category_pattern
    
FROM tmp_sales
GROUP BY customer_id


WITH patterns AS (
	SELECT
		customer_id,
		STRING_AGG(channel, ' > ' ORDER BY sale_date) AS pattern
	FROM tmp_sales
	GROUP BY customer_id
)
SELECT
	pattern,
	COUNT(*) AS customer_count
FROM patterns
GROUP BY pattern


