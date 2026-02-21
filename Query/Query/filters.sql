-- TASK 1
SELECT
	transaction_id,
	year,
	city,
	category,
	discount,
	total_sales,
	
CASE
	WHEN discount <= 0.10
	THEN 'Low Discount'

	WHEN discount BETWEEN 0.10 AND 0.30
	THEN 'Medium Discount'

	WHEN discount >= 0.30
	THEN 'High Discount'

		ELSE 'Normal'
		END AS bussines_segmentation
		
	FROM sales_analysis
	WHERE year = 2023

-- TASK 2
-- Հաշվում է 2023-ի ընդհանուր վաճառքը ըստ category
-- Հաշվում է միջին discount-ը
-- Դասակարգում է category-ները ըստ ընդհանուր վաճառքի

SELECT 
	category,
	SUM (total_sales) AS total_sales_amount,
	AVG (discount) AS discount_avg,

CASE 
	WHEN SUM(total_sales) >= 70000
	THEN 'Strong Performer'

	WHEN SUM(total_sales) BETWEEN 55000 AND 70000
	THEN 'Average Performer'
	

	WHEN SUM(total_sales) <= 55000
	THEN 'Underperformer'

	ELSE 'Standart'
	END
	
FROM sales_analysis
WHERE year = 2023
GROUP BY category;

-- TASK 3

SELECT
	city,
	COUNT(*) AS total_transactions,

	CASE
		WHEN COUNT(*) >= 4  THEN 'High Activity'
		WHEN COUNT(*) BETWEEN 2 AND 3 THEN 'Medium Activity'
		ELSE 'Low Activity'
	END AS activity_level

FROM sales_analysis
WHERE year = 2023

GROUP BY city

ORDER BY total_transactions DESC;


-- TASK 4
SELECT 
	category,
	AVG(discount) AS avg_discount,
	COUNT (*) AS total_transactions,
	SUM(total_sales) AS total_sales,

CASE 
	WHEN AVG(discount) > 0.25 
	THEN 'Discount-Heavy'
	
	WHEN AVG(discount) BETWEEN 0.24 AND 0.25
	THEN 'Moderate Discount'

	ELSE 'Low or No Discount'
	
	END AS discount_behavior

	
FROM sales_analysis
WHERE year = 2023

GROUP BY category

HAVING COUNT (*) >= 100

ORDER BY avg_discount DESC;






