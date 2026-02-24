/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - Analyze how sales, customers, and quantities evolve over time
    - Identify growth trends and potential seasonality
    - Support time-based business performance evaluation

Grain:
    - Monthly and Yearly

SQL Functions Used:
    - DATE_FORMAT(), YEAR()
    - SUM(), COUNT()
===============================================================================
*/


-- ============================================================================
-- 1. MONTHLY CHANGE OVER TIME ANALYSIS
-- ============================================================================
-- Business Question:
-- How do sales, customer activity, and quantities change month by month?

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    SUM(sales_amount)                AS total_sales,
    COUNT(DISTINCT customer_key)     AS total_customers,
    SUM(quantity)                    AS total_quantity
FROM dw_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;


-- ============================================================================
-- 2. YEARLY CHANGE OVER TIME ANALYSIS
-- ============================================================================
-- Business Question:
-- How does overall business performance evolve year by  year?

SELECT
    YEAR(order_date)                 AS order_year,
    SUM(sales_amount)                AS total_sales,
    COUNT(DISTINCT customer_key)     AS total_customers,
    SUM(quantity)                    AS total_quantity
FROM dw_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;
