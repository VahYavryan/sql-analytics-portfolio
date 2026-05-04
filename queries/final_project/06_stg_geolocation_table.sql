CREATE TABLE analytics._stg_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

COPY analytics._stg_geolocation 
FROM '/docker-entrypoint-initdb.d/Data/olist_geolocation_dataset.csv' 
DELIMITER ',' CSV HEADER;