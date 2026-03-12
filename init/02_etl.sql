-- COPY must read files inside the container; we mounted ./public_schema to /docker-entrypoint-initdb.d/public_schema
\echo 'Loading employees...'
COPY employees(employee_id,first_name,last_name,email,salary)
FROM '/docker-entrypoint-initdb.d/public_schema/employees.csv'
WITH (FORMAT csv, HEADER true);

\echo 'Loading customers...'
COPY customers(customer_id,customer_name,address,city,zip_code)
FROM '/docker-entrypoint-initdb.d/public_schema/customers.csv'
WITH (FORMAT csv, HEADER true);

\echo 'Loading products...'
COPY products(product_id,product_name,price,description,category)
FROM '/docker-entrypoint-initdb.d/public_schema/products.csv'
WITH (FORMAT csv, HEADER true);

\echo 'Loading orders...'
COPY orders(order_id,order_date,year,quarter,month)
FROM '/docker-entrypoint-initdb.d/public_schema/orders.csv'
WITH (FORMAT csv, HEADER true);

\echo 'Loading sales...'
COPY sales(transaction_id,order_id,product_id,customer_id,employee_id,total_sales,quantity,discount)
FROM '/docker-entrypoint-initdb.d/public_schema/sales.csv'
WITH (FORMAT csv, HEADER true);