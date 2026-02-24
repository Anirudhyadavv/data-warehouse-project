/*
===============================================================================
Cumulative Analysis (Monthly)
===============================================================================
Purpose:
    - Track cumulative (running) total sales over time.
    - Understand long-term revenue accumulation.
    - Observe how average selling price evolves as the business grows.

Business Question:
    - How much revenue has the business generated as of each month?

Notes:
    - Gold layer is implemented as VIEWS.
    - NULL order dates are excluded by design (cleaned in Silver).
===============================================================================
*/

SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,
    ROUND(AVG(avg_price) OVER (ORDER BY order_month), 2) AS cumulative_avg_price
FROM
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM dw_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) monthly_sales
ORDER BY order_month;
