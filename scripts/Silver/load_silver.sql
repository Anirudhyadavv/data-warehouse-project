SELECT * FROM dw_silver.crm_cust_info;

-----------------------------------------------------------------

SELECT cst_id, count(*) FROM dw_bronze.crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 OR cst_id is NULL;

-------------------------------------------------------------------

INSERT INTO dw_silver.crm_cust_info(
cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
SELECT 
cst_id,cst_key,
TRIM(cst_firstname) AS cst_firstname, TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
     WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
     ELSE 'n/a'
END as cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
     ELSE 'n/a'
END as cst_gndr,
cst_create_date
FROM(
SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC	) as flag_last
FROM dw_bronze.crm_cust_info
WHERE cst_id IS NOT NULL) t
WHERE flag_last = 1;

--------------------------------------------------------------------------------------

-- Expectations: No Results
SELECT cst_firstname 
FROM dw_bronze.crm_cust_info
WHERE cst_key != TRIM(cst_firstname);

--------------------------------------------------------------------------------------

-- Data Standadization & Consistency



**************************************************************************************************************

SELECT count(*) FROM dw_silver.crm_prd_info;

-------------------------------------------------------------------------------

SELECT prd_id, count(*) FROM dw_silver.crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 OR prd_id is NULL;

select count (*) from dw_silver.crm_prd_info;
--------------------------------------------------------------------------------

INSERT INTO dw_silver.crm_prd_info(
prd_id,cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
)
SELECT 
prd_id, 
TRIM(REPLACE(SUBSTRING(prd_key,1,5),"-","_")) as cat_id, 
SUBSTRING(prd_key, 7 , LENGTH(prd_key)) as prd_key,
prd_nm,
IFNULL(prd_cost,0) as prd_cost, 
CASE  
    WHEN  UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN  UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
    WHEN  UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
    WHEN  UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
    ELSE 'n/a'
END as prd_line,
prd_start_dt, 
prd_end_dt
FROM dw_bronze.crm_prd_info;

----------------------------------------------------------------------------------

select prd_nm
from dw_silver.crm_prd_info
where prd_nm != TRIM(prd_nm);

-----------------------------------------------------------------------------------
select prd_start_dt, prd_end_dt from dw_silver.crm_prd_info
where prd_start_dt < prd_end_dt;


****************************************************************************************************************************

SELECT * FROM dw_silver.crm_sales_details;

--------------------------------------------------------------
-- Check for invalid dates
select 
nullif(sls_order_dt, 0) as sls_order_dt from dw_silver.crm_sales_details
where sls_order_dt <= 0 or length(sls_order_dt) > 10;

select sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt from dw_silver.crm_sales_details;

--------------------------------------------------------------------

select distinct sls_sales,sls_quantity,sls_price from dw_silver.crm_sales_details
where sls_sales != sls_quantity*sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,sls_quantity,sls_price;

--------------------------------------------------------------
(select distinct 
sls_sales as old_sales,
sls_quantity,
sls_price as old_price,
CASE
	when sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity*abs(sls_price)
    then sls_quantity*abs(sls_price)
    else sls_sales
END sls_sales, 
CASE
	when sls_price <= 0 or sls_price is null 
    then sls_sales/ifnull(sls_quantity,0)
	else round(sls_price,2)
END sls_price
from dw_bronze.crm_sales_details)
order by sls_sales,sls_quantity,sls_price;




INSERT INTO dw_silver.crm_sales_details(
sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
)
SELECT
sls_ord_num, 
sls_prd_key, 
sls_cust_id, 
CASE
	WHEN sls_order_dt = 0 THEN NULL
    ELSE sls_order_dt
END as sls_order_dt,
CASE
	WHEN sls_ship_dt <= '0000-00-00' THEN NULL
    ELSE sls_ship_dt
END as sls_ship_dt, 
CASE
	WHEN sls_due_dt <= '0000-00-00' THEN NULL
    ELSE sls_due_dt
END as sls_due_dt, 
CASE
	when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity*abs(sls_price)
    then sls_quantity*abs(sls_price)
    else sls_sales
END as sls_sales, 
sls_quantity,
CASE
	when sls_price <= 0 or sls_price is null 
    then (sls_quantity*abs(sls_price))/nullif(sls_quantity,0)
	else round(sls_price,2)
END as sls_price
FROM dw_bronze.crm_sales_details;

*****************************************************************************************************


SELECT * FROM dw_silver.erp_cust_az12;

INSERT INTO dw_silver.erp_cust_az12 (
cid, bdate, gen)

SELECT 
CASE
	WHEN cid like 'NAS%' THEN SUBSTRING(cid,4, LENGTH(cid))
    ELSE cid
END as cid,
CASE 
	WHEN bdate > CURRENT_DATE() THEN NULL
	ELSE bdate
END AS bdate,
CASE
	WHEN UPPER(TRIM(gen)) IN ('F','Female') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M','Male') THEN 'Male'
    ELSE 'n/a'
END as gen
FROM dw_bronze.erp_cust_az12;

----------------------------------------------------------------------------------------


select bdate from dw_bronze.erp_cust_az12
where bdate > current_date ;

select distinct(gen) from dw_bronze.erp_cust_az12;

******************************************************************************************************


SELECT * FROM dw_silver.erp_loc_a101;


INSERT INTO dw_silver.erp_loc_a101(
cid,cntry)

SELECT 
REPLACE(cid, '-', '') as cid,
CASE
	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
    WHEN TRIM(cntry) IN ('US','USA') THEN 'United State'
    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
    ELSE TRIM(cntry)
END AS cntry
FROM dw_bronze.erp_loc_a101;

select distinct(cntry) from dw_bronze.erp_loc_a101
order by cntry;

********************************************************************************************************

SELECT * FROM dw_silver.erp_px_cat_gv12;


INSERT INTO dw_silver.erp_px_cat_gv12 (
id, cat, subcat, maintenance )

SELECT id, cat, subcat, maintenance
FROM dw_bronze.erp_px_cat_gv12;

select * from dw_bronze.erp_px_cat_gv12
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance);

select distinct maintenance from dw_bronze.erp_px_cat_gv12;

*******************************************************************************************************

