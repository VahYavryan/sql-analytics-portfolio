-- TASK 1
ALTER TABLE employees
ADD CONSTRAINT uq_employees_email UNIQUE (email);

ALTER TABLE employees
ALTER COLUMN email SET NOT NULL;

ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);

ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);

-- TASK 2
-- 1․Ավելացնում ենք նոր սյուն
ALTER TABLE sales
ADD COLUMN sales_channel TEXT;
-- Ավելացրեցինք sales_channel սյունակը որպեսզի, կարողանանք
-- վերլուծել գնումները օնլայն են եղել թե Խանութից

-- 2․Ավելացնում ենք սահմանափակում
ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));
-- Ավելացրեցինք սահմանափակում որպեսզի սյուննակներում
-- հնարավոր լինի գրել միայն online and store

-- 3․Լրացնում ենք սյունակը տվյալներիով
UPDATE sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;
-- Զույգ transaction_id ունեցող գրառումների համար
-- sales_channel դաշտը լրացվեց 'online' գրառմամբ

-- TASK 3
CREATE INDEX idx_sales_product_id
ON sales (product_id);

CREATE INDEX idx_sales_customer_id
ON sales (customer_id);

CREATE INDEX idx_products_category
ON products (category);

-- TASK 4
EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;
-- Բացատրություն:
-- 1. Քանի որ query plan-ում երևում է "Seq Scan on sales",
--    ապա օգտագործվում է Sequential Scan

-- 2.PostgreSQL-ը չի օգտագործում ինդեքսը,
-- քանի որ կատարվում է ամբողջ աղյուսակի ագրեգացիա

-- 3. Planner-ը ընտրում է այս պլանը,
--    որովհետև ամբողջ աղյուսակը հերթականությամբ կարդալը
--    ավելի էժան կլինի, քան ինդեքս օգտագործելն

-- TASK 5
SELECT *
FROM sales;

SELECT
  transaction_id,
  product_id,
  total_sales
FROM sales;
-- Այս հարցման օգտագօրծումը նվազեցնում է մեր ծախսերը 
-- քանի որ արդեն անրաժեշտություն չի լինում 
-- ամբողջ տվյալների մեջ փնտրել այլ կոնկրետ հատվածներից

-- 'SELECT *' հրամանը արդյունավետ կլինի երբ չգիտենք 
-- թե որ աղյուսակներում փնտրենք մեր տվյալները կամ
-- երբ ուզում ենք տեսնել բոլոր տվյալները

-- TASK 6
 EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;

-- plan-ում կարելի է տեսնել Sort փուլ։
-- Սա նշանակում է, որ ամբողջ աղյուսակը կարդացվում է,
-- հետո կատարվում է սորտավորում։
-- Ինդեքսները կարող են չոգնել որովհետեվ սորտավորվում է

-- TASK 7
EXPLAIN
SELECT DISTINCT
  category,
  price
FROM products;

EXPLAIN 
SELECT
  category,
  price
FROM products
GROUP BY category, price;

-- 1. Պլանները սովորաբար շատ նման են։
-- 2. Օրիենտացիոն արժեքը (cost) սովորաբար գրեթե նույնն է,
-- քանի որ կատարվող գործողությունը տրամաբանորեն նույնն է
-- 3. PostgreSQL-ը կարող է օպտիմիզացնել դրանք նույն կերպ,

-- TASK 8
UPDATE products
SET price = -5
WHERE product_id = 101

-- Ծրագիրը չի թողնում բացասական գին դնել։
-- Քանի որ բիզնեսում ապրանքի գինը չի կարող բացասական լինել։


INSERT INTO customers (customer_id, email)
VALUES (999,'anna@example.com');

-- Եթե customer_id արդեն գոյություն ունի, կակտիվանա PRIMARY KEY սահմանափակումը։
-- Եթե email-ի վրա կա UNIQUE սահմանափակում,
-- կակտիվանա UNIQUE constraint-ը։

-- TASK 9
-- 1. Ամենամեծ բիզնես արժեքը տալիս են PRIMARY KEY,
-- FOREIGN KEY և CHECK սահմանափակումները,
-- քանի որ դրանք ապահովում են տվյալների ամբողջականությունն ու ճշտությունը։

-- 2. Արտադրական միջավայրում առաջնահերթություն կտայի
-- այն ինդեքսին, որը օգտագործվում է ամենահաճախ JOIN կամ WHERE

-- 3. Օպտիմիզացիայի անհրաժեշտության ազդանշաններն են՝
-- դանդաղ կատարվող հարցումներ,
-- և հաճախակի Seq Scan մեծ աղյուսակների վրա։