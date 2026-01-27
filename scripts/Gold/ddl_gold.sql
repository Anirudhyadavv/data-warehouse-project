/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- ============================================================================
-- 1. DROP EXISTING VIEWS
-- ============================================================================
-- Note: Using the standard SQL 'DROP VIEW IF EXISTS' syntax.
DROP VIEW IF EXISTS dw_gold.fact_sales;
DROP VIEW IF EXISTS dw_gold.dim_customers;
DROP VIEW IF EXISTS dw_gold.dim_products;


-- ============================================================================
-- 2. CREATE DIMENSION: gold.dim_customers
-- ============================================================================
CREATE VIEW dw_gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY cu.cst_id) AS customer_key, -- Surrogate Key
    cu.cst_id AS customer_id, 
    cu.cst_key AS customer_number, 
    cu.cst_firstname AS first_name, 
    cu.cst_lastname AS last_name, 
    el.cntry AS country,
    cu.cst_marital_status AS marital_status, 
    CASE 
        WHEN cu.cst_gndr != 'n/a' THEN cu.cst_gndr
        ELSE COALESCE(eu.gen, 'n/a')
    END AS gender,
    eu.bdate AS birth_date,
    cu.cst_create_date AS create_date
FROM dw_silver.crm_cust_info AS cu
LEFT JOIN dw_silver.erp_cust_az12 eu
    ON cu.cst_key = eu.cid
LEFT JOIN dw_silver.erp_loc_a101 el
    ON cu.cst_key = el.cid;


-- ============================================================================
-- 3. CREATE DIMENSION: gold.dim_products
-- ============================================================================
CREATE VIEW dw_gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key, -- Surrogate Key
    cp.prd_id AS product_id, 
    cp.prd_key AS product_number, 
    cp.prd_nm AS product_name, 
    cp.cat_id AS category_id, 
    ep.cat AS category,
    ep.subcat AS subcategory,
    ep.maintenance,
    cp.prd_cost AS cost, 
    cp.prd_line AS product_line, 
    cp.prd_start_dt AS start_date
FROM dw_silver.crm_prd_info cp
LEFT JOIN dw_silver.erp_px_cat_gv12 ep
    ON cp.cat_id = ep.id;


-- ============================================================================
-- 4. CREATE FACT: gold.fact_sales
-- ============================================================================
CREATE VIEW dw_gold.fact_sales AS
SELECT 
    cs.sls_ord_num AS order_number, 
    sp.product_key, -- Surrogate key from dimension
    sc.customer_key, -- Surrogate key from dimension
    cs.sls_order_dt AS order_date, 
    cs.sls_ship_dt AS shipping_date, 
    cs.sls_due_dt AS due_date, 
    cs.sls_sales AS sales_amount, 
    cs.sls_quantity AS quantity, 
    cs.sls_price AS price
FROM dw_silver.crm_sales_details AS cs
LEFT JOIN dw_gold.dim_products AS sp
    ON cs.sls_prd_key = sp.product_number
LEFT JOIN dw_gold.dim_customers AS sc
    ON cs.sls_cust_id = sc.customer_id;
