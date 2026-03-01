/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - Consolidated customer-level analytical report.
    - Designed for downstream analytics and reporting use cases.

Highlights:
    - Customer demographics (name, age, age group)
    - Behavioral segmentation (VIP, Regular, New)
    - Aggregated metrics and KPIs
===============================================================================
*/

-- =============================================================================
-- Create View: dw_gold.report_customers
-- =============================================================================
DROP VIEW IF EXISTS dw_gold.report_customers;

CREATE VIEW dw_gold.report_customers AS        -- Join fact and customer dimension
   
WITH base_query AS (

    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) AS age
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (                  -- Customer Aggregation
    
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan_months
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age segmentation
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Customer value segmentation
    CASE
        WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,

    -- Recency in months
    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency_months,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,

    -- Average order value    
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- Average monthly spend
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END AS avg_monthly_spend

FROM customer_aggregation;
