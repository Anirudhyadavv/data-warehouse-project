/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Identify how individual product categories contribute to total sales.
    - Highlight high-impact categories driving overall revenue.

Data Source:
    - dw_gold.fact_sales
    - dw_gold.dim_products
===============================================================================
*/


-- ============================================================================
-- SALES CONTRIBUTION BY PRODUCT CATEGORY
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
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
