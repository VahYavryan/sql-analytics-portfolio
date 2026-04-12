-- TASK 1
--Քանի տարբեր հեռախոսներ և կատեգորիաներ կան
SELECT
	COUNT(raw_phone) AS all_phones,
	COUNT(category_raw) AS all_category,
	COUNT(DISTINCT raw_phone) AS unique_phones,
	COUNT(DISTINCT category_raw) AS unique_category
FROM transactions_text_demo;

-- Որ կատեգորիաից քանի անգամ է կրկնվում
SELECT
	category_raw,
	COUNT(*) AS records
FROM transactions_text_demo
	GROUP BY category_raw
	ORDER BY records DESC;

-- Որ համարից քանի անգամ է կրկնվում և նրանց երկարությունները
SELECT
	LENGTH(raw_phone) AS phone_length,
	COUNT(*) AS records
FROM transactions_text_demo
GROUP BY LENGTH(raw_phone)
ORDER BY phone_length;

-- Ինչպես է այդ «կեղտոտ» տեքստը փչացնում GROUP BY-ը
-- GROUP BY - Ը տարբեր ձև է կարդում այդ տվյալները
-- Արդյունքում կարող են լինել շատ դուբլիկատներ


-- TASK 2
SELECT

	SUBSTRING(
		REGEXP_REPLACE(TRIM(raw_phone), '[^0-9]', '', 'g')
	FROM LENGTH(
		REGEXP_REPLACE(TRIM(raw_phone), '[^0-9]', '', 'g')) - 7 FOR 8)
	AS phone_core

FROM transactions_text_demo;


-- Մաքրված կատեգորիա
SELECT
INITCAP(REGEXP_REPLACE(TRIM(category_raw), '[()]', '', 'g'))
FROM transactions_text_demo;

-- revenue per transaction
SELECT
price,
quantity,
price * quantity AS total_revenue
FROM transactions_text_demo;

-- TASK 3
-- Ընդհանուր եկամուտը ըստ կեղտոտ կատեգորիաների
SELECT
category_raw AS dirty_category,
SUM(price * quantity) AS total_revenue
FROM transactions_text_demo
GROUP BY category_raw;

-- Ըստ մաքուր կատեգորիաների
SELECT
INITCAP(REGEXP_REPLACE(TRIM(category_raw), '[()]', '', 'g')) AS clean_category,
SUM(price * quantity) AS total_revenue
FROM transactions_text_demo
GROUP BY category_raw;

-- Clean Phone VS Dirty Phone
SELECT
	COUNT(DISTINCT raw_phone) AS unique_phone,
	COUNT(DISTINCT(SUBSTRING(
	REGEXP_REPLACE(TRIM(raw_phone), '[^0-9]', '', 'g')
	FROM LENGTH(REGEXP_REPLACE(TRIM(raw_phone), '[^0-9]', '', 'g')) - 7 FOR 8))) AS clean_phone
FROM transactions_text_demo;

-- TASK 4
-- KPI - ները մաքրվեցին որովհետեվ
-- մի հաճախորդը կարող էր մի քանի անգամ գրանցված լիներ 
-- տարբեր ֆորմատներով

-- Ավելի շատ ազդեց հաճախորդի հեռախոսահամանրների պրոցեսը
-- քանի որ մի հաճախորդը մի համարով լիքը անգամներ էր գրանցված

-- Ինչ ենթադրություն արեցի
-- Որ վերջին 8 թվերը բավարար են հաճախորդին նույնականացնելու համար
-- Նաև իրական օրինակի վրա տեսա թե ինչքան խափուսիկ կարող են լինել տվյալները
-- մինչև դրանց մաքրումը և դուպլիկատների հեռացումը
-- Որ price և quantity արժեքները ճիշտ են և մաքրման կարիք չունեն

-- Ինչը կարող է արտադրությանը լուռ կոտրել
-- Եթե NULL արժեքներ լինեն, որոնք հաշվարկների վրա ազդեն
-- Եթե նոր ֆորմատով համարներ գրանցվեն օրինակ այլ երկրի կոդով
-- եթե price - ը գա նոր տեքստային ձևաչափով





