DROP TABLE IF EXISTS analytics._stg_marketplace;

CREATE TABLE analytics._stg_marketplace (

	-- Order info
	order_id						text,
	order_item_id					int,
	order_unique_id					text,
	order_status					varchar(20),

	order_purchase_timestamp		timestamp,
	order_approved_at				timestamp,
	order_delivered_carrier_date	timestamp,
	order_delivered_customer_date	timestamp,
	order_estimated_delivery_date	timestamp,

	day_of_purchase					varchar(15),
	month_ofpurchase				varchar(15),
	year_of_purchase				int,
	month_year_of_purchase 			varchar(20),

	-- Customer info
	customer_id						text,
	customer_unique_id				text,
	customer_zip_code_prefix 		int,
	customer_city					varchar(100),
	customer_state					varchar(10),

	-- Seller info
	seller_id						text,
	seller_zip_code_prefix			int,
	seller_city						varchar(100),
	seller_state					varchar(10),

	-- Product info
	product_id						text,
	product_category_name			varchar(100),
	product_name_lenght				int,
	product_descripition_lenght		int,
	product_photos_qty				int,
	product_weight_g				int,
	product_length_cm				int,
	product_height_cm				int,
	product_width_cm				int,

	--Payment info
	payment_type				  varchar(20),
	payment_sequential            int,
    payment_installments          int,
    payment_value                 numeric(10,2),

    -- Pricing
    price                         numeric(10,2),
    freight_value                 numeric(10,2),

    -- Shipping
    shipping_limit_date           timestamp

	
)