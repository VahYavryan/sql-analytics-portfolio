CREATE OR REPLACE FUNCTION analytics.fn_nationality_customers(
    p_nationality TEXT
)
RETURNS TABLE (
    number_of_customers INT
)
LANGUAGE sql
AS $$
    SELECT
        COUNT(*) AS number_of_customers
    FROM analytics.customers cust
    LEFT JOIN analytics.cities cit ON cust.city_id = cit.city_id
    LEFT JOIN analytics.regions reg ON cit.region_id = reg.region_id
    LEFT JOIN analytics.countries cou ON reg.country_id = cou.country_id
    WHERE 
        CASE
            WHEN cou.country_name = 'Armenia' THEN 'Hay'
            WHEN cou.country_name = 'Georgia' THEN 'Vraci'
            ELSE 'Other'
        END = p_nationality
$$;


SELECT * FROM analytics.fn_nationality_customers('Hay');
