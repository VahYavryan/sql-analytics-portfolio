
 -- TASK 1
 -- Ցույց է տալիս ընդհանուր եկամուտը ըստ կատեգորիաների Նվազման կարգով
SELECT
  category,
  SUM(total_sales) AS total_revenue
  
FROM sales_analysis

	GROUP BY category
	ORDER BY total_revenue DESC;

-- TASK 2
-- Հաշվում ենք մեդիանը և միջինը
-- տվյալները շատ մոտ են իրար ինչը 
-- նշանակում է տվյալները բաշխված են հավասարաչափ
SELECT
	PERCENTILE_CONT(0.5)
	WITHIN GROUP(ORDER BY total_sales)
	AS median_total_sales,
	AVG(total_sales) AS total_sales_avg
FROM sales_analysis;


-- TASK 3
-- TRANSACTION - ՆԵՐԸ ՈՐՏԵՂ ԶԵՂՉ Է ԵՂԵԼ
SELECT
COUNT (discount) AS transaction_have_discount
FROM sales_analysis;

-- NULL նշանակում է “զեղչ չի եղել”։
SELECT
	COUNT(*) AS null_transactions_discount
FROM sales_analysis

	WHERE discount IS NULL;

-- Սա ցույց է տալիս միջին զեղչը միայն այն transaction-ների համար, որտեղ զեղչ կա։
-- AVG() ավտոմատ կերպով անտեսում է NULL-երը։
SELECT
AVG(discount) AS avg_discount
FROM sales_analysis;


-- Միջինը գրեթե չի փոխվի
SELECT
		AVG(COALESCE(discount,
		(SELECT 
		AVG(discount) FROM sales_analysis))) AS avg_discount_inputed
FROM sales_analysis;

-- Մեդիան ավելի կայուն է outlier-ների նկատմամբ։
SELECT
AVG(COALESCE(discount
, (SELECT 
	PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY (discount))
	FROM sales_analysis))) AS avg_discount_median_input
FROM sales_analysis;


-- TASK 4
-- Խմբավորում 50-ական միջակայքերով
SELECT
    FLOOR(total_sales / 50) * 50 AS revenue_range_start,
    FLOOR(total_sales / 50) * 50 + 49 AS revenue_range_end,
    COUNT(*) AS deal_count,
    SUM(total_sales) AS total_revenue
FROM sales_analysis

	GROUP BY FLOOR(total_sales / 50)
	ORDER BY revenue_range_start;

-- ամենաշատ եկամուտ բերող range-ը՝
SELECT
    FLOOR(total_sales / 50) * 50 AS revenue_range_start,
    SUM(total_sales) AS total_revenue
FROM sales_analysis

	GROUP BY FLOOR(total_sales / 50)
	ORDER BY total_revenue DESC
	LIMIT 1;

-- TASK 5
-- Դուբլիկատների ստուգում
SELECT 
    transaction_id,
    COUNT(*) AS dublicate_count
FROM sales_analysis

	GROUP BY transaction_id
	HAVING COUNT(*) > 1;

--Առաջին օրինակում sales_analysis աղյուսակի salary բաժնից
-- հանելւց աշխատողների տվյալները շատ դուբլիկատներ կան, որովհետև
-- transaction_id ները կրկնվում են ։
-- Իսկ employees ի դեպքում չկան դուբլիկատներ

SELECT 
SUM(employee_salary)
FROM sales_analysis;

SELECT
SUM (salary)
FROM employees;


-- ՆԱև մի ռիսկ կարող է հանդիսանալ NULL-երը երբ 
-- չփոխենք 0 բայց կամպանիան հաշվի որ դրանք 0 են եղել



