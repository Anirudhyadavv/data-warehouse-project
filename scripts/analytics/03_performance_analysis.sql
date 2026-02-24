/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - Evaluate product performance over time.
    - Identify improving or declining products.
    - Support benchmarking and performance-driven decisions.

Why Performance Analysis:
    - Trend analysis shows direction.
    - Performance analysis explains whether entities are improving or worsening
      relative to previous periods.

Data Source:
    - dw_gold.fact_sales
    - dw_gold.dim_products

Entities Analyzed:
    - Products

===============================================================================
*/


-- ============================================================================
-- 1. YEAR-OVER-YEAR (YoY) PRODUCT PERFORMANCE
-- ============================================================================
-- Business Question:
-- How has each product’s sales changed compared to the previous year?

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date)  AS order_year,
        p.product_key,
        p.product_name,
        SUM(f.sales_amount) AS yearly_sales
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_key,
        p.product_name
)

SELECT
    order_year,
    product_key,
    product_name,
    yearly_sales,
    LAG(yearly_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_year
    ) AS previous_year_sales,
    yearly_sales - LAG(yearly_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_year
    ) AS yoy_sales_change,
    CASE
        WHEN yearly_sales - LAG(yearly_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_year
        ) > 0 THEN 'Increase'
        WHEN yearly_sales - LAG(yearly_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_year
        ) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_trend
FROM yearly_product_sales
ORDER BY product_name, order_year;


-- ============================================================================
-- 2. MONTH-OVER-MONTH (MoM) PRODUCT PERFORMANCE
-- ============================================================================
-- Business Question:
-- How has each product’s sales changed compared to the previous month?

WITH monthly_product_sales AS (
    SELECT
        DATE_FORMAT(f.order_date, '%Y-%m') AS order_month,
        p.product_key,
        p.product_name,
        SUM(f.sales_amount) AS monthly_sales
    FROM dw_gold.fact_sales f
    JOIN dw_gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        DATE_FORMAT(f.order_date, '%Y-%m'),
        p.product_key,
        p.product_name
)

SELECT
    order_month,
    product_key,
    product_name,
    monthly_sales,
    LAG(monthly_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_month
    ) AS previous_month_sales,
    monthly_sales - LAG(monthly_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_month
    ) AS mom_sales_change,
    CASE
        WHEN monthly_sales - LAG(monthly_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_month
        ) > 0 THEN 'Increase'
        WHEN monthly_sales - LAG(monthly_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_month
        ) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS mom_trend
FROM monthly_product_sales
ORDER BY product_name, order_month;
