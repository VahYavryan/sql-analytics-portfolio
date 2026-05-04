CREATE TABLE core.dim_geolocation AS
SELECT DISTINCT ON (geolocation_zip_code_prefix)
    geolocation_zip_code_prefix AS zip_code_prefix,
    AVG(geolocation_lat) OVER(PARTITION BY geolocation_zip_code_prefix) AS latitude,
    AVG(geolocation_lng) OVER(PARTITION BY geolocation_zip_code_prefix) AS longitude,
    geolocation_city AS city,
    geolocation_state AS state
FROM analytics._stg_geolocation
ORDER BY geolocation_zip_code_prefix, geolocation_city; 

ALTER TABLE core.dim_geolocation ADD PRIMARY KEY (zip_code_prefix);