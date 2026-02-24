/*
===============================================================================
Cumulative Customer Engagement & Sales Analysis (Monthly)
===============================================================================
Purpose:
    - Track how customer engagement and revenue accumulate over time.
    - Compare growth patterns between customers and sales.
    - Support long-term business performance analysis.

Business Questions:
    1. How does customer engagement accumulate month over month?
    2. How does revenue accumulate alongside customer engagement?

Notes:
    - Cumulative customers represent cumulative monthly participation,
      not total unique customers across all time.
===============================================================================
*/


-- ============================================================================
-- 1. CUMULATIVE SALES ANALYSIS (MONTHLY)
-- ============================================================================
-- Business Question:
-- How much revenue has the business generated in total as of each month?

SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,
    ROUND(AVG(avg_price) OVER (ORDER BY order_month), 2) AS cumulative_avg_price
FROM
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        SUM(sales_amount)                AS total_sales,
        AVG(price)                       AS avg_price
    FROM dw_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) monthly_sales
ORDER BY order_month;



-- ============================================================================
-- 2. CUMULATIVE CUSTOMER ENGAGEMENT VS SALES
-- ============================================================================
-- Business Questions:
-- 1. How does customer engagement accumulate over time?
-- 2. How does revenue accumulate alongside customer engagement?

SELECT
    order_month,
    monthly_customers,
    SUM(monthly_customers) OVER (ORDER BY order_month) AS cumulative_monthly_customers,
    monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY order_month)     AS cumulative_monthly_sales
FROM 
(
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        COUNT(DISTINCT customer_key)     AS monthly_customers,
        SUM(sales_amount)                AS monthly_sales
    FROM dw_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) customer_activity
ORDER BY order_month;
