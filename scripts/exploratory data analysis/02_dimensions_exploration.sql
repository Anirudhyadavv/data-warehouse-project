/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Explore key dimension attributes and hierarchies
    - Understand distinct values and cardinality
    - Identify potential data quality issues in dimensions

SQL Functions Used:
    - DISTINCT
    - COUNT
    - ORDER BY
===============================================================================
*/

-- List of unique countries from which customers originate
SELECT DISTINCT 
    country
FROM dw_gold.dim_customers
ORDER BY country;


-- Cardinality check for customer country
SELECT 
    COUNT(DISTINCT country) AS distinct_countries
FROM dw_gold.dim_customers;


-- Product hierarchy: Category → Subcategory → Product
SELECT DISTINCT 
    category,
    subcategory,
    product_name
FROM dw_gold.dim_products
ORDER BY category, subcategory, product_name;
