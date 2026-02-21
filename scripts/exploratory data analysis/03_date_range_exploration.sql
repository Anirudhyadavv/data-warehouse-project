/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Identify the earliest and latest dates in the dataset
    - Understand how much historical data is available
    - Review customer age range based on birth dates

SQL Functions Used:
    - MIN()
    - MAX()
    - TIMESTAMPDIFF()
===============================================================================
*/

-- Order date range and total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS total_months
FROM dw_gold.fact_sales;


-- Youngest and oldest customers (based on birth date)
SELECT
    MIN(birth_date) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birth_date), CURRENT_DATE()) AS oldest_age,
    MAX(birth_date) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MAX(birth_date), CURRENT_DATE()) AS youngest_age
FROM dw_gold.dim_customers
WHERE birth_date IS NOT NULL;


-- Check for future or invalid birth dates
SELECT COUNT(*) AS invalid_birth_dates
FROM dw_gold.dim_customers
WHERE birth_date > CURRENT_DATE();
