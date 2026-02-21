/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Explore database structure and schema organization
    - Identify fact and dimension tables
    - Inspect column metadata and nullability
    - Gain scale awareness before analysis

Tables Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve a list of all warehouse tables
SELECT 
    table_catalog, 
    table_schema, 
    table_name, 
    table_type
FROM information_schema.tables
WHERE table_schema LIKE 'dw_%';


-- Retrieve column metadata for dim_customers
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'dim_customers';


-- Tables grouped by schema (Bronze / Silver / Gold)
SELECT 
    table_schema, 
    COUNT(*) AS tables_count
FROM information_schema.tables
WHERE table_schema LIKE 'dw_%'
GROUP BY table_schema;


-- Identify fact and dimension tables in Gold layer
SELECT 
    table_schema,
    table_name,
    CASE 
        WHEN table_name LIKE 'fact_%' THEN 'fact_table'
        WHEN table_name LIKE 'dim_%'  THEN 'dimension_table'
        ELSE 'n/a'
    END AS table_type
FROM information_schema.tables
WHERE table_schema = 'dw_gold';


-- Approximate row counts (scale awareness)
-- NOTE:
-- TABLE_ROWS is NULL for dw_gold objects because they are implemented as VIEWS.
-- MySQL does not maintain row count metadata for views.
-- Row volume analysis is therefore performed on Silver base tables.
SELECT 
    table_schema, 
    table_name, 
    table_rows
FROM information_schema.tables
WHERE table_schema = 'dw_gold';
