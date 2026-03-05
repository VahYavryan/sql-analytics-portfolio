

CREATE TABLE analytics.normal_customers(
customer_id SERIAL PRIMARY KEY,
customer_name TEXT NOT NULL,
customer_email TEXT NOT NULL UNIQUE,
customer_age INT NOT NULL
);

CREATE TABLE analytics.normal_location(
location_id SERIAL PRIMARY KEY,
country TEXT NOT NULL,
region TEXT NOT NULL,
city TEXT NOT NULL,
city_lat DECIMAL(9,6),
city_lot DECIMAL(9,6)
)

CREATE TABLE analytics.normal_products(
product_id SERIAL PRIMARY KEY,
product_name TEXT NOT NULL,
product_category TEXT NOT NULL,
unit_price DECIMAL (10,2)
);

CREATE TABLE analytics.normal_sales(
sale_id INT PRIMARY KEY,
sale_date DATE NOT NULL,
 customer_id INT REFERENCES analytics.normal_customers(customer_id),
    location_id INT REFERENCES analytics.normal_location(location_id),
    product_id INT REFERENCES analytics.normal_products(product_id),
    quantity INT NOT NULL,
    payment_method TEXT,
    order_status TEXT
);

SELECT
*
FROM analytics.normal_sales



