/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Understand how different business dimensions contribute to total sales.
    - Identify high-impact categories and regions driving overall revenue.

Data Source:
    - dw_gold.fact_sales
    - dw_gold.dim_products
    - dw_gold.dim_customers
===============================================================================
*/


-- ============================================================================
-- 1. SALES CONTRIBUTION BY PRODUCT CATEGORY
-- ============================================================================
-- Business Question:
-- Which product categories contribute the most to overall sales?

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND(
        (total_sales / SUM(total_sales) OVER ()) * 100,
        2
    ) AS overall_contribution_percentage
FROM category_sales
ORDER BY total_sales DESC;


-- ============================================================================
-- 2. SALES CONTRIBUTION BY CUSTOMER COUNTRY
-- ============================================================================
-- Business Question:
-- Which countries contribute the most to overall sales?

WITH country_sales AS (
    SELECT
        c.country,
        SUM(f.sales_amount) AS total_sales
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_customers c
        USING (customer_key)
    GROUP BY c.country
)

SELECT
    country,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND(
        (total_sales / SUM(total_sales) OVER ()) * 100,
        2
    ) AS overall_contribution_percentage
FROM country_sales
ORDER BY total_sales DESC;
