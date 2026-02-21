/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - Calculate core business metrics such as sales, quantity, orders, and customers
    - Get a high-level view of overall business performance
===============================================================================
*/

-- Total Sales
SELECT SUM(sales_amount) AS total_sales
FROM dw_gold.fact_sales;


-- Total Quantity Sold
SELECT SUM(quantity) AS total_sold_quantity
FROM dw_gold.fact_sales;


-- Average Selling Price
SELECT ROUND(AVG(price), 2) AS average_price
FROM dw_gold.fact_sales;


-- Total Number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM dw_gold.fact_sales;


-- Total Number of Products
SELECT COUNT(DISTINCT product_name) AS total_products
FROM dw_gold.dim_products;


-- Total Number of Customers
SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM dw_gold.dim_customers;


-- Total Number of Customers Who Placed an Order
SELECT COUNT(DISTINCT customer_key) AS active_customers
FROM dw_gold.fact_sales;


-- Consolidated Business Metrics Report
SELECT 'Total Sales'      AS measure_name, SUM(sales_amount)           AS measure_value FROM dw_gold.fact_sales
UNION ALL
SELECT 'Total Quantity',        SUM(quantity)                            FROM dw_gold.fact_sales
UNION ALL
SELECT 'Average Price',         ROUND(AVG(price), 2)                    FROM dw_gold.fact_sales
UNION ALL
SELECT 'Total Orders',          COUNT(DISTINCT order_number)             FROM dw_gold.fact_sales
UNION ALL
SELECT 'Total Products',        COUNT(DISTINCT product_name)             FROM dw_gold.dim_products
UNION ALL
SELECT 'Total Customers',       COUNT(DISTINCT customer_key)             FROM dw_gold.dim_customers
UNION ALL
SELECT 'Active Customers',      COUNT(DISTINCT customer_key)             FROM dw_gold.fact_sales;
