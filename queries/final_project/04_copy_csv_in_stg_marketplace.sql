COPY analytics._stg_marketplace (
    order_id, order_item_id, customer_id, customer_unique_id, customer_zip_code_prefix, 
    customer_city, customer_state, product_id, product_category_name, product_name_lenght, 
    product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, 
    product_height_cm, product_width_cm, seller_id, seller_city, seller_state, 
    seller_zip_code_prefix, payment_type, payment_sequential, payment_installments, 
    price, freight_value, payment_value, shipping_limit_date, order_purchase_timestamp, 
    order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, 
    order_estimated_delivery_date, day_of_purchase, month_of_purchase, year_of_purchase, 
    "month/year_of_purchase", order_status, order_unique_id
)
FROM '/docker-entrypoint-initdb.d/Data/marketplace_project/marketplace_clean.csv'
DELIMITER ','
CSV HEADER
NULL '';