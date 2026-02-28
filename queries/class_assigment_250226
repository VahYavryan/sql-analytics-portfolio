SELECT
raw_phone,
LENGTH(raw_phone) AS phone_length,
POSITION  ('-' IN raw_phone) AS position_1,
POSITION ('(' IN raw_phone) AS position_2
FROM customers_raw_text;


SELECT
category_raw
FROM customers_raw_text
GROUP BY category_raw
ORDER BY COUNT(*) DESC;