-- TASK 1
--Ընդհանուր եկամուտը ըստ տարիների
SELECT
	DATE_TRUNC('year', order_date_date) AS year,
	SUM(total_sales) AS total_revenue_year
FROM sales_analysis
		GROUP BY DATE_TRUNC('year', order_date_date)
		ORDER BY year;

-- Ընդհանուր եկամուտը ըստ Եռամսյակների
SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue_quarter
FROM sales_analysis 
		GROUP BY DATE_TRUNC('quarter', order_date_date)
		ORDER BY quarter;

-- Ընդհանուր եկամուտը ըստ ամիսների
SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue_month
FROM sales_analysis
		GROUP BY DATE_TRUNC('month', order_date_date)
		ORDER BY month;


-- TASK 2
-- Ամսական ագրեգացիան ցույց է տալիս բարձր տատանումներ։
-- Տեսանելի են սուր աճեր և անկումներ տարբեր ամիսներում։
SELECT
	DATE_TRUNC('month',order_date_date) AS month,
	SUM(total_sales) AS total_revenue_month
FROM sales_analysis
GROUP BY 1
ORDER BY 1;

-- Եռամսյակային ագրեգացիան հարթեցնում է ամսական տատանումները։
SELECT
	DATE_TRUNC('quarter',order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue_quarter
FROM sales_analysis
GROUP BY 1
ORDER BY 1;

-- Տարեկան ագրեգացիան ցույց է տալիս ընդհանուր պատկերը։
SELECT
	DATE_TRUNC('year',order_date_date) AS year,
	SUM(total_sales) AS total_revenue_year
FROM sales_analysis
GROUP BY 1
ORDER BY 1;


-- TASK 3
-- Ամենաշատ եկամուտ բերած ամիսը
SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue_month
FROM sales_analysis
		GROUP BY DATE_TRUNC('month', order_date_date)
		ORDER BY total_revenue_month DESC
		LIMIT 1;

-- Ամենաթույլ եկամուտ ունեցող ժամանակահատվածը
SELECT 
*
FROM (
SELECT
        DATE_TRUNC('quarter', order_date_date) AS quarter,
        SUM(total_sales) AS total_revenue
    FROM sales_analysis
    GROUP BY 1) 
	ORDER BY total_revenue ASC
LIMIT 1;

-- TASK 4
-- Քանի օր է անցել վերջին գնումից
SELECT
transaction_id,
MAX(order_date_date) AS last_transaction,
CURRENT_DATE - MAX(order_date_date) AS last_order,
AGE(CURRENT_DATE, MAX(order_date_date))
FROM sales_analysis
GROUP BY transaction_id
ORDER BY CURRENT_DATE - MAX(order_date_date) DESC;



-- Ամսական տվյալներում նկատվում են ավելի մեծ տատանումներ և սուր աճեր կամ անկումներ,
-- մինչդեռ եռամսյակային և տարեկան մակարդակներում այդ տատանումները
-- հարթվում են և ավելի պարզ երևում է ընդհանուր միտումը։

-- ավելի լայն մակարդակը (եռամսյակային կամ տարեկան)
-- օգնում է հասկանալ երկարաժամկետ աճը կամ անկումը։

-- Որոշ եզրակացություններ կարող են փոխվել aggregation-ից կախված
-- Օրինակ՝ մեկ թույլ ամիսը կարող է թվալ լուրջ խնդիր ամսական վերլուծության մեջ,
-- բայց եռամսյակային մակարդակում այդ ազդեցությունը կարող է նվազել։


