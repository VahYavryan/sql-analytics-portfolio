-- Customers
CREATE TABLE core.dem_customers(
	customer_id TEXT PRIMARY KEY,
	customer_unique_id TEXT,
	customer_zip_code_prefix INT,
	customer_city TEXT,
	customer_state TEXT
);

INSERT INTO core.dem_customers
SELECT DISTINCT (customer_id)
	customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM analytics._stg_marketplace;


-- Products
CREATE TABLE core.dim_products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_lenght NUMERIC,
    product_description_lenght NUMERIC,
    product_photos_qty NUMERIC,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

INSERT INTO core.dim_products
SELECT DISTINCT ON (product_id)
    product_id, product_category_name, product_name_lenght, product_description_lenght, 
    product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
FROM analytics._stg_marketplace;


-- Sellers
CREATE TABLE core.dim_sellers (
    seller_id TEXT PRIMARY KEY,
    seller_city TEXT,
    seller_state TEXT,
    seller_zip_code_prefix INT
);

INSERT INTO core.dim_sellers
SELECT DISTINCT ON (seller_id)
    seller_id, seller_city, seller_state, seller_zip_code_prefix
FROM analytics._stg_marketplace;


-- Fact Table Orders
CREATE TABLE core.fact_orders (
    order_unique_id TEXT,
    order_id TEXT,
    order_item_id INT,
    customer_id TEXT REFERENCES core.dim_customers(customer_id),
    product_id TEXT REFERENCES core.dim_products(product_id),
    seller_id TEXT REFERENCES core.dim_sellers(seller_id),
    payment_type TEXT,
    price NUMERIC,
    freight_value NUMERIC,
    payment_value NUMERIC,
    order_purchase_timestamp TIMESTAMP,
    order_status TEXT,
    PRIMARY KEY (order_unique_id, order_item_id) -- Համակցված բանալի
);


SELECT order_unique_id, order_item_id, COUNT(*)
FROM analytics._stg_marketplace
GROUP BY order_unique_id, order_item_id
HAVING COUNT(*) > 1;

INSERT INTO core.fact_orders (
    order_unique_id, order_id, order_item_id, customer_id, product_id, 
    seller_id, payment_type, price, freight_value, payment_value, 
    order_purchase_timestamp, order_status
)
SELECT DISTINCT ON (order_unique_id, order_item_id) 
    order_unique_id, order_id, order_item_id, customer_id, product_id, 
    seller_id, payment_type, price, freight_value, payment_value, 
    order_purchase_timestamp, order_status
FROM analytics._stg_marketplace
ORDER BY order_unique_id, order_item_id, order_purchase_timestamp DESC; 


