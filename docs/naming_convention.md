This is a professional Markdown (.md) version of your naming conventions document, optimized for a GitHub or GitLab repository. I have cleaned up the formatting, improved the layout for readability, and added a "Best Practices" section to help you explain the logic behind these choices during an interview.

Data Warehouse Naming Conventions
1. Overview
This document outlines the standard naming conventions used for schemas, tables, views, columns, and other objects within the data warehouse. Adhering to these standards ensures consistency, maintainability, and clarity across the Bronze, Silver, and Gold layers.

2. General Principles
Case Style: Use snake_case (all lowercase letters with underscores separating words).

Language: All object names must be in English.

Reserved Words: Avoid using SQL reserved words (e.g., SELECT, TABLE, ORDER) as object names.

Scannability: Names should be descriptive enough that a business user can understand the content without a manual.

3. Table & View Naming Conventions
🥉 Bronze Layer (Raw)
Bronze tables act as a mirror of the source systems.

Pattern: <source_system>_<original_table_name>

Rules: Do not rename the source table; maintain the original structure.

Example: crm_customer_info

🥈 Silver Layer (Cleaned)
Silver tables contain deduplicated and standardized data.

Pattern: <source_system>_<original_table_name>

Rules: While the structure is cleaned, the naming follows the source system to maintain lineage.

Example: erp_loc_a101

🥇 Gold Layer (Curated/Analytical)
Gold tables use business-aligned names and are organized by their role in a Star Schema.

Pattern: <category>_<business_entity>

Categories: | Pattern | Meaning | Example | | :--- | :--- | :--- | | dim_ | Dimension Table | dim_customers, dim_products | | fact_ | Fact Table | fact_sales | | report_ | Specific Reporting View | report_monthly_sales |

4. Column Naming Conventions
🔑 Surrogate Keys
All primary keys in the Gold layer dimension tables must use a surrogate key suffix.

Pattern: <entity>_key

Purpose: To uniquely identify records independently of source system IDs.

Example: customer_key, product_key.

🛠️ Technical Columns (Metadata)
System-generated columns used for auditing and tracking data lineage.

Pattern: dwh_<column_purpose>

Example: dwh_load_date (The timestamp when the record entered the warehouse).

5. Stored Procedures
All procedures used for ETL/ELT orchestration must follow a functional naming pattern.

Pattern: load_<layer_name>

Examples:

load_bronze: Moves data from source to Bronze.

load_silver: Cleans and transforms data into Silver.

load_gold: Aggregates and models data for the final Gold layer.
