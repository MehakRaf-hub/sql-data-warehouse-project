# SQL Data Warehouse Project (Bronze - Silver - Gold Architecture)

## 📌 Project Overview

This project demonstrates the implementation of a modern Data Warehouse using the **Medallion Architecture (Bronze, Silver, and Gold layers)** in PostgreSQL.

The project loads raw CSV files into a Bronze layer, cleans and standardizes the data in the Silver layer, and creates business-ready analytical views in the Gold layer using a Star Schema.

---

## 🏗️ Architecture

```
CSV Files
     │
     ▼
Bronze Layer
(Raw Data)
     │
     ▼
Silver Layer
(Cleaned & Standardized)
     │
     ▼
Gold Layer
├── dim_customers
├── dim_products
└── fact_sales
     │
     ▼
Analytics / Power BI / Reporting
```

---

## 📂 Project Structure

```
DataWarehouse_Project
│
├── datasets
│   ├── source_crm
│   └── source_erp
│
├── scripts
│   ├── bronze
│   │   ├── ddl_bronze.sql
│   │   ├── load_bronze.sql
│   │   └── validation_bronze.sql
│   │
│   ├── silver
│   │   ├── ddl_silver.sql
│   │   ├── load_silver.sql
│   │   └── validation_silver.sql
│   │
│   └── gold
│       ├── ddl_gold.sql
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── fact_sales.sql
│       └── validation_gold.sql
│
└── README.md
```

---

## 🛠️ Technologies Used

- PostgreSQL
- pgAdmin 4
- SQL
- Visual Studio Code
- Git & GitHub

---

## 📥 Data Sources

The project uses six CSV files.

### CRM

- crm_cust_info.csv
- crm_prd_info.csv
- crm_sales_details.csv

### ERP

- erp_cust_az12.csv
- erp_loc_a101.csv
- erp_px_cat_g1v2.csv

---

# Bronze Layer

## Purpose

The Bronze layer stores the raw source data exactly as received from the CSV files.

No business rules or transformations are applied.

### Tasks Performed

- Created Bronze schema
- Created Bronze tables
- Loaded CSV files
- Preserved raw data
- Added ETL execution logging

---

# Silver Layer

## Purpose

The Silver layer cleans, validates, and standardizes the Bronze data before it is used for analytics.

### Data Cleaning Performed

### CRM Customer

- Removed duplicate customer IDs
- Removed duplicate customer keys
- Removed NULL customer IDs
- Trimmed spaces from names
- Standardized gender values
- Standardized marital status values

### CRM Product

- Standardized product line values
- Replaced NULL product costs
- Corrected product validity dates
- Generated category IDs
- Kept only cleaned product information

### CRM Sales

- Converted text dates to DATE format
- Corrected invalid dates
- Fixed sales, quantity, and price inconsistencies
- Removed invalid numeric values

### ERP Customer

- Standardized gender values
- Removed future birth dates

### ERP Location

- Standardized country names

### ERP Product Category

- Cleaned category information

---

# Gold Layer

## Purpose

The Gold layer provides business-ready data for reporting and analytics.

Instead of tables, Gold uses Views.

### Views Created

### dim_customers

Contains:

- Customer Key
- Customer ID
- Customer Number
- Name
- Country
- Gender
- Marital Status
- Birth Date
- Create Date

---

### dim_products

Contains:

- Product Key
- Product ID
- Product Number
- Product Name
- Category
- Subcategory
- Product Line
- Maintenance
- Product Cost

---

### fact_sales

Contains:

- Order Number
- Customer Key
- Product Key
- Order Date
- Ship Date
- Due Date
- Sales Amount
- Quantity
- Price

---

# Data Validation

Validation scripts were created for every layer to verify:

- Row counts
- Duplicate records
- NULL values
- Missing foreign keys
- Sample data
- Successful ETL execution

---

# SQL Concepts Used

This project demonstrates the use of:

- CREATE TABLE
- CREATE VIEW
- Stored Procedures
- LEFT JOIN
- CASE
- COALESCE
- ROW_NUMBER()
- LEAD()
- Window Functions
- TRIM()
- SUBSTRING()
- REPLACE()
- CAST()
- DATE Conversion
- Common Data Cleaning Techniques

---

# Key Learning Outcomes

- Data Warehouse Design
- Medallion Architecture
- ETL Development
- SQL Data Cleaning
- Star Schema Design
- Dimension & Fact Modeling
- Data Validation
- PostgreSQL Development

---

# Future Improvements

- Incremental data loading
- ETL logging tables
- Scheduling using pgAgent or Cron
- Power BI Dashboard
- Data Quality Monitoring

---

# Author

**Mehak**

SQL Data Warehouse Project using PostgreSQL
