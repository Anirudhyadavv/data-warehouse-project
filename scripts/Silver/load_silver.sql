/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze → Silver)
===============================================================================
Purpose:
    This procedure serves as the authoritative transformation layer of the
    Data Warehouse, converting raw Bronze-stage data into a cleaned,
    standardized, and validated Silver layer.

    It enforces data quality and business rules so downstream analytical and
    Gold-layer models can operate on trusted, consistent datasets.

Business Logic & Transformations:
    - Data Cleansing: Removes leading and trailing whitespace to prevent key
      mismatches and join failures in downstream models.
    - Standardization: Normalizes inconsistent source attributes (e.g. 'M',
      'Male', 'MALE') into canonical values to ensure consistent reporting.
    - Data Integrity: Applies corrective rules for invalid or missing sales
      values, ensuring accurate revenue and quantity calculations.
    - Observability: Captures execution duration and row counts to provide
      operational visibility and basic load validation.

Operational Notes:
    - The procedure performs a full refresh of Silver tables and is idempotent.
    - A unified execution summary is returned for monitoring and audit checks.

Usage:
    CALL dw_silver.load_silver();
===============================================================================
*/

DELIMITER $$

CREATE PROCEDURE dw_silver.load_silver()
BEGIN
    -- Declare variables for tracking load status and counts
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE row_count_c_cust INT;
    DECLARE row_count_c_prd INT;
    DECLARE row_count_c_sales INT;
    DECLARE row_count_e_cust INT;
    DECLARE row_count_e_loc INT;
    DECLARE row_count_e_cat INT;

    SET start_time = NOW();

    -- ============================================================================
    -- 1. CRM Tables Transformation
    -- ============================================================================
    
    -- Transforming crm_cust_info
    TRUNCATE TABLE dw_silver.crm_cust_info;
    INSERT INTO dw_silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
    SELECT cst_id, TRIM(cst_key), TRIM(cst_firstname), TRIM(cst_lastname), UPPER(TRIM(cst_marital_status)),
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) IN ('F', 'FEMALE') THEN 'Female'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM dw_bronze.crm_cust_info;
    SET row_count_c_cust = ROW_COUNT();

    -- Transforming crm_prd_info
    TRUNCATE TABLE dw_silver.crm_prd_info;
    INSERT INTO dw_silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SELECT prd_id, REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'), prd_key, TRIM(prd_nm), COALESCE(prd_cost, 0), UPPER(TRIM(prd_line)), prd_start_dt, prd_end_dt
    FROM dw_bronze.crm_prd_info;
    SET row_count_c_prd = ROW_COUNT();

    -- Transforming crm_sales_details
    TRUNCATE TABLE dw_silver.crm_sales_details;
    INSERT INTO dw_silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
    SELECT sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt,
        CASE WHEN sls_sales <= 0 OR sls_sales IS NULL THEN sls_quantity * sls_price ELSE sls_sales END,
        ABS(sls_quantity), sls_price
    FROM dw_bronze.crm_sales_details;
    SET row_count_c_sales = ROW_COUNT();

    -- ============================================================================
    -- 2. ERP Tables Transformation
    -- ============================================================================
    
    -- Transforming erp_cust_az12
    TRUNCATE TABLE dw_silver.erp_cust_az12;
    INSERT INTO dw_silver.erp_cust_az12 (cid, bdate, gen)
    SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) ELSE cid END, bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM dw_bronze.erp_cust_az12;
    SET row_count_e_cust = ROW_COUNT();

    -- Transforming erp_loc_a101
    TRUNCATE TABLE dw_silver.erp_loc_a101;
    INSERT INTO dw_silver.erp_loc_a101 (cid, cntry)
    SELECT REPLACE(cid, '-', ''), TRIM(cntry)
    FROM dw_bronze.erp_loc_a101;
    SET row_count_e_loc = ROW_COUNT();

    -- Transforming erp_px_cat_gv12
    TRUNCATE TABLE dw_silver.erp_px_cat_gv12;
    INSERT INTO dw_silver.erp_px_cat_gv12 (id, cat, subcat, maintenance)
    SELECT TRIM(id), TRIM(cat), TRIM(subcat), TRIM(maintenance)
    FROM dw_bronze.erp_px_cat_gv12;
    SET row_count_e_cat = ROW_COUNT();

    -- ============================================================================
    -- FINAL UNIFIED SUMMARY
    -- ============================================================================
    SET end_time = NOW();
    
    SELECT 
        'SUCCESS' AS load_status,
        TIMEDIFF(end_time, start_time) AS total_duration,
        row_count_c_cust AS crm_cust,
        row_count_c_prd AS crm_prd,
        row_count_c_sales AS crm_sales,
        row_count_e_cust AS erp_cust,
        row_count_e_loc AS erp_loc,
        row_count_e_cat AS erp_cat;

END$$

DELIMITER ;
