# 📁 Data Warehouse Naming Conventions

This document defines the architectural standards for naming schemas, tables, views, and columns within the Data Warehouse. Consistent naming ensures that the data lineage remains clear as it moves from raw ingestion to business-ready reporting.

---

## 📑 Table of Contents
1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
3. [Column Naming Conventions](#column-naming-conventions)
4. [Stored Procedure Standards](#stored-procedure-standards)

---

## ⚖️ General Principles
- **Case Style:** `snake_case` (all lowercase, underscores for spaces).
- **Language:** All identifiers must be in English.
- **Reserved Words:** Never use SQL reserved keywords (e.g., `SELECT`, `FROM`, `GROUP`) as object names.
- **Scannability:** Names should be intuitive for both developers and business analysts.

---

## 🏗️ Table Naming Conventions

### 🥉 Bronze Layer (Raw)
The Bronze layer stores data in its original form. Names must preserve the source identity.
- **Pattern:** `<source_system>_<original_table_name>`
- **Example:** `crm_customer_info`

### 🥈 Silver Layer (Cleaned)
The Silver layer stores deduplicated and standardized data.
- **Pattern:** `<source_system>_<original_table_name>`
- **Example:** `erp_loc_a101`

### 🥇 Gold Layer (Curated)
The Gold layer uses business-friendly names organized into a Star Schema.
- **Pattern:** `<category>_<business_entity>`

| Pattern | Meaning | Example(s) |
|:---|:---|:---|
| `dim_` | **Dimension Table:** Descriptive attributes. | `dim_customers`, `dim_products` |
| `fact_` | **Fact Table:** Quantitative metrics/transactions. | `fact_sales` |
| `report_` | **Report Table:** Pre-aggregated data for specific views. | `report_monthly_sales` |

---

## 🏷️ Column Naming Conventions

### 🔑 Surrogate Keys
All primary keys in the Gold layer dimensions must use a surrogate key suffix.
- **Pattern:** `<entity>_key`
- **Logic:** Unique integers (usually generated via `ROW_NUMBER()`) that act as a stable join-bridge between Facts and Dimensions.
- **Example:** `customer_key`



### 🛠️ Technical Columns
Metadata columns used for auditing and data lineage.
- **Pattern:** `dwh_<purpose>`
- **Example:** `dwh_load_date` (The timestamp indicating when the record was processed).

---

## ⚙️ Stored Procedure Standards
All ETL/ELT orchestration logic must be encapsulated
