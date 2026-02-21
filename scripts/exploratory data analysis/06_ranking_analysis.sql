/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK()
    - Clauses: GROUP BY, ORDER BY, LIMIT
===============================================================================
*/


-- Which 5 products Generating the Highest Revenue?
SELECT  p.subcategory,
        SUM(f.sales_amount) AS revenue
FROM dw_gold.dim_products p
JOIN dw_gold.fact_sales f
USING (product_key)
GROUP BY p.subcategory
ORDER BY revenue DESC
LIMIT 5;


-- Worst performing products in terms of revenue
SELECT subcategory, total_revenue
FROM (
    SELECT 
        p.subcategory,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS rnk
    FROM dw_gold.dim_products p
    JOIN dw_gold.fact_sales f
        USING (product_key)
    GROUP BY p.subcategory
) t
WHERE rnk <= 5;


-- Top 10 customers by total revenue (window function)
SELECT 
    customer_key,
    first_name,
    last_name,
    total_revenue
FROM (
    SELECT 
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rnk
    FROM dw_gold.dim_customers c
    JOIN dw_gold.fact_sales f
        ON c.customer_key = f.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
) t
WHERE rnk <= 10;


-- 3 customers with the fewest orders (including zero orders)
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM dw_gold.dim_customers c
LEFT JOIN dw_gold.fact_sales f
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders ASC
LIMIT 3;
