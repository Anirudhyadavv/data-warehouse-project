/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - Track long-term business progress using cumulative metrics.
    - Understand how revenue and customer engagement accumulate over time.
    - Support strategic and executive-level performance analysis.

Business Questions:
    1. How much total revenue has the business generated as of each month?
    2. How has customer engagement grown cumulatively over time?

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
-- 2. CUMULATIVE CUSTOMER ENGAGEMENT ANALYSIS (MONTHLY)
-- ============================================================================
-- Business Question:
-- How has customer engagement accumulated over time?

SELECT
    order_month,
    monthly_customers,
    SUM(monthly_customers) OVER (ORDER BY order_month) AS cumulative_customers
FROM
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        COUNT(DISTINCT customer_key)     AS monthly_customers
    FROM dw_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) customer_activity
ORDER BY order_month;
