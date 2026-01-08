/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates the tables for the 'dw_bronze' schema, which serves as 
    the Raw Data Staging area. It defines the structure for both CRM and ERP 
    source systems.

Parameters:
    None.

Usage:
    Run this script once to initialize the Bronze Layer structure. 
    WARNING: Dropping tables will delete all existing data in this layer.
===============================================================================
*/

USE dw_bronze;

-- ============================================================================
-- 1. DROP EXISTING TABLES
-- ============================================================================
-- Dropping tables to ensure a clean slate before recreation.
DROP TABLE IF EXISTS dw_bronze.crm_cust_info;
DROP TABLE IF EXISTS dw_bronze.crm_prd_info;
DROP TABLE IF EXISTS dw_bronze.crm_sales_details;
DROP TABLE IF EXISTS dw_bronze.erp_cust_az12;
DROP TABLE IF EXISTS dw_bronze.erp_loc_a101;
DROP TABLE IF EXISTS dw_bronze.erp_px_cat_gv12;

-- ============================================================================
-- 2. CREATE CRM TABLES (Source System 1)
-- ============================================================================

-- Table for Customer Master Data from CRM
CREATE TABLE dw_bronze.crm_cust_info(
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE 
);

-- Table for Product Master Data from CRM
CREATE TABLE dw_bronze.crm_prd_info(
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     DECIMAL(10, 2),
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

-- Table for Transactional Sales Data from CRM
CREATE TABLE dw_bronze.crm_sales_details(
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    DECIMAL(10, 2),
    sls_quantity INT,
    sls_price    DECIMAL(10, 2)
);

-- ============================================================================
-- 3. CREATE ERP TABLES (Source System 2)
-- ============================================================================

-- Table for Supplemental Customer Data from ERP System AZ12
CREATE TABLE dw_bronze.erp_cust_az12(
    cid   VARCHAR(50),
    bdate DATE,
    gen   VARCHAR(50)
);

-- Table for Customer Location Mapping from ERP System A101
CREATE TABLE dw_bronze.erp_loc_a101(
    cid   VARCHAR(50),
    cntry VARCHAR(50)
);

-- Table for Product Category Hierarchies from ERP System GV12
CREATE TABLE dw_bronze.erp_px_cat_gv12(
    id          VARCHAR(50),
    cat         VARCHAR(50),    
    subcat      VARCHAR(50),    
    maintenance VARCHAR(50)
);
