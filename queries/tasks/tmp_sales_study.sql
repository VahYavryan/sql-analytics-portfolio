CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 'online'),
        (2,  'A', DATE '2024-01-02', 120, 'store'),
        (3,  'A', DATE '2024-01-03', 90,  'online'),
        (4,  'A', DATE '2024-01-04', 130, 'store'),

        
        (5,  'B', DATE '2024-01-01', 180, 'store'),
        (6,  'B', DATE '2024-01-02', 200, 'online'),
        (7,  'B', DATE '2024-01-03', 220, 'online'),
        (8,  'B', DATE '2024-01-04', 200, 'store'),

        
        (9,  'C', DATE '2024-01-01', 150, 'online'),
        (10, 'C', DATE '2024-01-02', 150, 'online'),
        (11, 'C', DATE '2024-01-03', 170, 'online'),

        
        (12, 'D', DATE '2024-01-01', 90,  'store'),
        (13, 'D', DATE '2024-01-02', 110, 'store'),

        
        (14, 'E', DATE '2024-01-01', 140, 'store'),
        (15, 'E', DATE '2024-01-02', 160, 'online'),
        (16, 'E', DATE '2024-01-03', 155, 'store')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    channel
);

-- Հաշվել՝ յուրաքանչյուր հաճախորդի միջին գնումների գումարը
SELECT
    sale_id,
    customer_id,
    sale_date,
    amount,
AVG(amount) OVER(PARTITION BY customer_id) AS avg_customer_amount
FROM tmp_sales;


-- Ընդհանուր ծախսը հաճախորդի համար
SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
SUM(amount) OVER(PARTITION BY customer_id) AS total_customer_spend
FROM tmp_sales;

-- Գործարքների քանակը մեկ հաճախորդի համար
SELECT
		sale_id,
		customer_id,
	COUNT(*) OVER(
	PARTITION BY customer_id
	) AS transaction_count
FROM tmp_sales;

-- Մաքսիմում և մինիմում արժեքները յորաքանչյուր խմբի համար
SELECT
sale_id,
customer_id,
sale_date,
amount,
MIN(amount) OVER(PARTITION BY customer_id) AS min_amount,
MAX(amount) OVER(PARTITION BY customer_id) AS max_amount
FROM tmp_sales;


-- Վիճակագրական (Statistical) ֆունկցիաներ
-- Median (միջին կետ)
SELECT
customer_id,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_amount
FROM tmp_sales
GROUP BY customer_id;


-- Այս գործարքը իր խմբում որտեղ է
SELECT
sale_id,
customer_id,
amount,
PERCENT_RANK() OVER(
PARTITION BY customer_id
ORDER BY sale) AS percent_rank
FROM tmp_sales;


-- Քանի՞ տոկոս գործարք կա ինձանից փոքր կամ հավասար
SELECT
sale_id,
customer_id,
amount,
CUME_DIST() OVER(
PARTITION BY customer_id
ORDER BY amount
) AS cumulative_distribution
FROM tmp_sales;


-- Այս գործարքը ո՞ր խմբում է (top, middle, bottom)
SELECT
sale_id,
customer_id,
amount,
NTILE(4) OVER(
PARTITION BY customer_id
ORDER BY amount
)
FROM tmp_sales;



-- Previous Transaction Amount (LAG)
SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
LAG(amount) OVER(
PARTITION BY customer_id
ORDER BY sale_date 
) AS previos_amount
FROM tmp_sales;


-- Next Transaction Amount (LEAD)
SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
LEAD(amount) OVER(
PARTITION BY customer_id
ORDER  BY sale_date
) AS next_amount
FROM tmp_sales;


-- Change Since Previous Transaction
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
		amount
	 - LAG(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	) AS amount_change
FROM tmp_sales;


-- First Transaction Amount per Customer
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
	FIRST_VALUE(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	) AS first_value
FROM tmp_sales;


--  Last Transaction Amount per Customer
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
	LAST_VALUE(amount) OVER(
	PARTITION BY sale_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS last_amount
FROM tmp_sales;


-- Sequential Ordering (ROW_NUMBER)
SELECT
		sale_id,
		customer_id,
		amount,
	ROW_NUMBER() OVER(
	PARTITION BY customer_id
	ORDER BY amount
	) 
FROM tmp_sales;


-- Dense Ranking by Amount (DENSE_RANK)
SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
DENSE_RANK() OVER(
PARTITION BY customer_id
ORDER BY amount DESC
)
FROM tmp_sales;


-- Ranking by Amount with Gaps (RANK)
SELECT
	sale_id,
	customer_id,
	amount,
RANK() OVER(
PARTITION BY  customer_id
ORDER BY amount DESC
)
FROM tmp_sales;


-- Comparison
SELECT
	sale_id,
	customer_id,
	amount,

ROW_NUMBER() OVER(
PARTITION BY customer_id
ORDER BY amount DESC
) AS row_number_amount,

DENSE_RANK() OVER(
PARTITION BY customer_id
ORDER BY amount DESC
) AS dense_rank_amount,

RANK() OVER(
PARTITION BY customer_id
ORDER BY amount DESC
) AS rank_amount

FROM tmp_sales
ORDER BY customer_id,amount DESC, sale_id;


-- Channel-ներ յուրաքանչյուր հաճախորդի համար (կուտակային)
SELECT
	sale_id,
	customer_id,
	sale_date,
	channel,
	STRING_AGG(channel, '>') OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	) AS channels_used_so_far
FROM tmp_sales;

-- Լրիվ channel պատմություն յուրաքանչյուր տողի համար
SELECT
		sale_id,
		customer_id,
		sale_date,
		channel,
	STRING_AGG(channel, '>') OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	)
FROM tmp_sales;


-- Channel pattern (GROUP BY)
SELECT	
	customer_id,
	STRING_AGG(channel, '>' ORDER BY channel) AS channel_pattern
FROM tmp_sales
GROUP BY customer_id;


-- Channel pattern (DISTINCT)
SELECT
customer_id,
STRING_AGG(channel, '>' ORDER BY channel) AS channel_pattern,
STRING_AGG(DISTINCT channel, '>' ORDER BY channel) AS dist_channel_pattern
FROM tmp_sales
GROUP BY customer_id



-- Pattern-ների խմբավորում
WITH customer_channels AS(
SELECT
	customer_id,
	STRING_AGG(DISTINCT channel, '>' ORDER BY channel) AS dist_channel_pattern
FROM tmp_sales
GROUP BY customer_id
)
SELECT
	dist_channel_pattern,
	COUNT(*) AS customer_count
FROM customer_channels
GROUP BY dist_channel_pattern



-- Running Total (Explicit Frame)
SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
	SUM(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total
	FROM tmp_sales;


--  Full-Partition Aggregate (Stable Value)
SELECT
	sale_id,
	customer_id,
	amount,
	AVG(amount) OVER(
	PARTITION BY customer_id
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS full_partition_avg
FROM tmp_sales;


-- Moving Window (Last 2 Transactions)
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
	AVG(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
) AS moving_avg_2
FROM tmp_sales;


-- Forward-Looking Average
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
	AVG(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
) AS forward_avg_2
FROM tmp_sales;


--  Centered Moving Average (Previous + Current + Next)
SELECT
		sale_id,
		customer_id,
		sale_date,
		amount,
	AVG(amount) OVER(
	PARTITION BY customer_id
	ORDER BY sale_date
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS centered_avg_3
FROM tmp_sales;