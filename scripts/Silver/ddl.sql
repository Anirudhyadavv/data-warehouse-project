DROP TABLE IF EXISTS dw_silver.crm_cust_info;
DROP TABLE IF EXISTS dw_silver.crm_prd_info;
DROP TABLE IF EXISTS dw_silver.crm_sales_details;
DROP TABLE IF EXISTS dw_silver.erp_cust_az12;
DROP TABLE IF EXISTS dw_silver.erp_loc_a101;
DROP TABLE IF EXISTS dw_silver.erp_px_cat_gv12;


CREATE TABLE dw_silver.crm_cust_info(
cst_id INT,
cst_key	VARCHAR (50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status	VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dw_silver.crm_prd_info(
prd_id INT,
cat_id VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost DECIMAL(10, 2),
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dw_silver.crm_sales_details(
sls_ord_num	VARCHAR(50),
sls_prd_key	VARCHAR(50),
sls_cust_id	INT,
sls_order_dt DATE,
sls_ship_dt	DATE,
sls_due_dt	DATE,
sls_sales DECIMAL(10, 2),
sls_quantity INT,
sls_price DECIMAL(10, 2),
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE dw_silver.erp_cust_az12(
cid	VARCHAR(50),
bdate DATE,
gen VARCHAR(50),
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE dw_silver.erp_loc_a101(
cid	VARCHAR(50),
cntry VARCHAR(50),
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dw_silver.erp_px_cat_gv12(
id VARCHAR(50),
cat VARCHAR(50),	
subcat VARCHAR(50),	
maintenance VARCHAR(50),
dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
