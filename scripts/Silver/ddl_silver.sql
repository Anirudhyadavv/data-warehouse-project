/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates the tables for the 'dw_silver' schema.
    The Silver layer is responsible for data cleansing, standardization, 
    and enrichment. 

Key Actions:
    - Defines schemas for cleaned CRM and ERP data.
    - Adds metadata columns (dwh_create_date) for auditability.
    - Sets the stage for deduplication and data type casting.

Layer: Silver (Cleaned/Standardized)
===============================================================================
*/

-- ============================================================================
-- 1. DROP EXISTING TABLES
-- ============================================================================
-- Ensures a clean slate before recreation.
DROP TABLE IF EXISTS dw_silver.crm_cust_info;
DROP TABLE IF EXISTS dw_silver.crm_prd_info;
DROP TABLE IF EXISTS dw_silver.crm_sales_details;
DROP TABLE IF EXISTS dw_silver.erp_cust_az12;
DROP TABLE IF EXISTS dw_silver.erp_loc_a101;
DROP TABLE IF EXISTS dw_silver.erp_px_cat_gv12;

-- ============================================================================
-- 2. CREATE CRM TABLES (Cleaned Source 1)
-- ============================================================================

-- Cleaned Customer Info from CRM
CREATE TABLE dw_silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);

-- Cleaned Product Info from CRM
CREATE TABLE dw_silver.crm_prd_info (
    prd_id             INT,
    cat_id             VARCHAR(50),
    prd_key            VARCHAR(50),
    prd_nm             VARCHAR(50),
    prd_cost           DECIMAL(10, 2),
    prd_line           VARCHAR(50),
    prd_start_dt       DATE,
    prd_end_dt         DATE,
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);

-- Cleaned Sales Details from CRM
CREATE TABLE dw_silver.crm_sales_details (
    sls_ord_num        VARCHAR(50),
    sls_prd_key        VARCHAR(50),
    sls_cust_id        INT,
    sls_order_dt       DATE,
    sls_ship_dt        DATE,
    sls_due_dt         DATE,
    sls_sales          DECIMAL(10, 2),
    sls_quantity       INT,
    sls_price          DECIMAL(10, 2),
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);

-- ============================================================================
-- 3. CREATE ERP TABLES (Cleaned Source 2)
-- ============================================================================

-- Cleaned Supplemental Customer Data
CREATE TABLE dw_silver.erp_cust_az12 (
    cid                VARCHAR(50),
    bdate              DATE,
    gen                VARCHAR(50),
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);

-- Cleaned Geographic Mapping
CREATE TABLE dw_silver.erp_loc_a101 (
    cid                VARCHAR(50),
    cntry              VARCHAR(50),
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);

-- Cleaned Product Category Hierarchy
CREATE TABLE dw_silver.erp_px_cat_gv12 (
    id                 VARCHAR(50),
    cat                VARCHAR(50),    
    subcat             VARCHAR(50),    
    maintenance        VARCHAR(50),
    dwh_create_date    DATETIME DEFAULT CURRENT_TIMESTAMP -- Audit Column
);
