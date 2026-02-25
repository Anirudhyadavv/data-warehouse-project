/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Group products and customers into meaningful segments.
    - Enable targeted insights and business decision-making.

Data Source:
    - dw_gold.dim_products
    - dw_gold.fact_sales
    - dw_gold.dim_customers
===============================================================================
*/


-- ============================================================================
-- 1. PRODUCT SEGMENTATION BY COST RANGE
-- ============================================================================
-- Business Question:
-- How are products distributed across different cost categories?

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM dw_gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- ============================================================================
-- 2. CUSTOMER SEGMENTATION BY VALUE AND TENURE
-- ============================================================================
-- Business Question:
-- Can customers be classified based on spending and relationship duration?

WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        TIMESTAMPDIFF(
            MONTH,
            MIN(f.order_date),
            MAX(f.order_date)
        ) AS lifespan_months
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
