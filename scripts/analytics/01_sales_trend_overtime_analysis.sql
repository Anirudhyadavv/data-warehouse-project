/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - Analyze how sales, customers, and quantities evolve over time
    - Identify growth trends and seasonal patterns
    - Support time-based business performance evaluation

SQL Functions Used:
    - Date Functions: DATE_FORMAT(), YEAR()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- Monthly analysis of sales, customers, and quantities
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM dw_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;


-- Yearly analysis of sales, customers, and quantities
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM dw_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;
