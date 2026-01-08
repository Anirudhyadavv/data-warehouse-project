/*
===============================================================================
Data Loading Script: Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script performs the bulk loading of raw data into the 'dw_bronze' schema.
    It clears existing data using TRUNCATE and ingests fresh data from CSV files
    originating from two main source systems: CRM and ERP.

Key Actions:
    - Truncates existing bronze tables to prevent data duplication.
    - Uses 'LOAD DATA LOCAL INFILE' for high-performance bulk ingestion.
    - Handles Windows-style line endings (\r\n) and skips header rows.

WARNING:
    Ensure 'local_infile' is enabled on both the MySQL server and client 
    before execution.
===============================================================================
*/

USE dw_bronze;

-- ============================================================================
-- 1. CRM Tables (Source System: CRM)
-- ============================================================================

-- Loading crm_cust_info (Customer Master Data)
-- Source: cust_info.csv
TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE "Local date source path"
INTO TABLE dw_bronze.crm_cust_info
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Loading crm_prd_info (Product Master Data)
-- Source: prd_info.csv
TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE "Local date source path"
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Loading crm_sales_details (Transactional Sales Records)
-- Source: sales_details.csv
TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE "Local date source path"
INTO TABLE dw_bronze.crm_sales_details
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ============================================================================
-- 2. ERP Tables (Source System: ERP)
-- ============================================================================

-- Loading erp_cust_az12 (Supplemental Customer Information)
-- Source: CUST_AZ12.csv
TRUNCATE TABLE erp_cust_az12;
LOAD DATA LOCAL INFILE "Local date source path"
INTO TABLE dw_bronze.erp_cust_az12
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Loading erp_loc_a101 (Customer Geographic Mapping)
-- Source: LOC_A101.csv
TRUNCATE TABLE erp_loc_a101;
LOAD DATA LOCAL INFILE "Local date source path"
INTO TABLE dw_bronze.erp_loc_a101
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Loading erp_px_cat_gv12 (Product Category Hierarchy)
-- Source: PX_CAT_G1V2.csv
TRUNCATE TABLE erp_px_cat_gv12;
LOAD DATA LOCAL INFILE "Local date source path"
INTO TABLE dw_bronze.erp_px_cat_gv12
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
