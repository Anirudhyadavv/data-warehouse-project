/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - Consolidated product-level analytical report.
    - Designed for performance tracking and reporting use cases.

Highlights:
    - Product attributes (category, subcategory, cost)
    - Revenue-based product segmentation
    - Aggregated metrics and KPIs
===============================================================================
*/

-- =============================================================================
-- Create View: dw_gold.report_products
-- =============================================================================
DROP VIEW IF EXISTS dw_gold.report_products;

CREATE VIEW dw_gold.report_products AS

WITH product_transactions AS (
    /*---------------------------------------------------------------------------
    1) Base Query: Join fact_sales with dim_products
    ---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregation AS (
    /*---------------------------------------------------------------------------
    2) Product Aggregation: One row per product
    ---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        MAX(order_date) AS last_sale_date,
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan_months
    FROM product_transactions
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,

    last_sale_date,
    TIMESTAMPDIFF(
        MONTH,
        last_sale_date,
        CURDATE()
    ) AS recency_months,

    -- Product segmentation by revenue
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan_months,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,

    -- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END AS avg_monthly_revenue

FROM product_aggregation;
