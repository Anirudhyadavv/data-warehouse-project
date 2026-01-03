/*
============================================================
Create Data Warehouse Databases
============================================================
Script Purpose:
  This script sets up the three-tier Data Warehouse architecture by
  creating three separate DATABASES: 'dw_bronze', 'dw_silver', and 'dw_gold'.
  
WARNING:
  Running this script will DROP these DATABASES if they exist.
  All data within them will be permanently deleted.
============================================================
*/

-- 1. Setup the Bronze Database (Raw Data)
DROP DATABASE IF EXISTS dw_bronze;
CREATE DATABASE dw_bronze;

-- 2. Setup the Silver Database (Cleaned/Transformed)
DROP DATABASE IF EXISTS dw_silver;
CREATE DATABASE dw_silver;

-- 3. Setup the Gold Database (Reporting/Aggregated)
DROP DATABASE IF EXISTS dw_gold;
CREATE DATABASE dw_gold;

-- Verify the databases were created
SHOW DATABASES;
