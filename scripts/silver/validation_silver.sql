/*
===============================================================================
Validation Script: Silver Layer
===============================================================================
Purpose:
    Validate the data loaded into the Silver layer.

Checks:
    - Row counts
    - Duplicate records
    - NULL values
    - Invalid dates
    - Invalid sales
    - Invalid costs
    - Standardized values

Author: Mehak
Database: PostgreSQL
===============================================================================
*/

-- ============================================================================
-- ROW COUNTS
-- ============================================================================

SELECT 'crm_cust_info' AS table_name, COUNT(*) AS total_rows
FROM silver.crm_cust_info

UNION ALL

SELECT 'crm_prd_info', COUNT(*)
FROM silver.crm_prd_info

UNION ALL

SELECT 'crm_sales_details', COUNT(*)
FROM silver.crm_sales_details

UNION ALL

SELECT 'erp_cust_az12', COUNT(*)
FROM silver.erp_cust_az12

UNION ALL

SELECT 'erp_loc_a101', COUNT(*)
FROM silver.erp_loc_a101

UNION ALL

SELECT 'erp_px_cat_g1v2', COUNT(*)
FROM silver.erp_px_cat_g1v2;

-- ============================================================================
-- CRM CUSTOMER
-- ============================================================================

-- Duplicate Customer IDs

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- NULL Customer IDs

SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

-- Gender Values

SELECT
    cst_gndr,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_gndr;

-- Marital Status Values

SELECT
    cst_marital_status,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_marital_status;

-- ============================================================================
-- CRM PRODUCT
-- ============================================================================

-- Negative Product Cost

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- NULL Product Cost

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;

-- Product Line Values

SELECT
    prd_line,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_line;

-- Invalid Date Range

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ============================================================================
-- CRM SALES
-- ============================================================================

-- Invalid Order Dates

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL;

-- Invalid Ship Dates

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL;

-- Invalid Due Dates

SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL;

-- Negative Sales

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales < 0;

-- Negative Price

SELECT *
FROM silver.crm_sales_details
WHERE sls_price < 0;

-- NULL Sales

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales IS NULL;

-- NULL Price

SELECT *
FROM silver.crm_sales_details
WHERE sls_price IS NULL;

-- ============================================================================
-- ERP CUSTOMER
-- ============================================================================

-- Future Birth Dates

SELECT *
FROM silver.erp_cust_az12
WHERE bdate > CURRENT_DATE;

-- Gender Values

SELECT
    gen,
    COUNT(*)
FROM silver.erp_cust_az12
GROUP BY gen;

-- ============================================================================
-- ERP LOCATION
-- ============================================================================

-- Country Values

SELECT
    cntry,
    COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cntry
ORDER BY cntry;

-- ============================================================================
-- ERP PRODUCT CATEGORY
-- ============================================================================

-- Category Values

SELECT
    cat,
    COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY cat;

-- Maintenance Values

SELECT
    maintenance,
    COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY maintenance;

-- ============================================================================
-- METADATA CHECK
-- ============================================================================

SELECT
    'crm_cust_info' AS table_name,
    MIN(dwh_create_date) AS first_load,
    MAX(dwh_create_date) AS last_load
FROM silver.crm_cust_info

UNION ALL

SELECT
    'crm_prd_info',
    MIN(dwh_create_date),
    MAX(dwh_create_date)
FROM silver.crm_prd_info

UNION ALL

SELECT
    'crm_sales_details',
    MIN(dwh_create_date),
    MAX(dwh_create_date)
FROM silver.crm_sales_details

UNION ALL

SELECT
    'erp_cust_az12',
    MIN(dwh_create_date),
    MAX(dwh_create_date)
FROM silver.erp_cust_az12

UNION ALL

SELECT
    'erp_loc_a101',
    MIN(dwh_create_date),
    MAX(dwh_create_date)
FROM silver.erp_loc_a101

UNION ALL

SELECT
    'erp_px_cat_g1v2',
    MIN(dwh_create_date),
    MAX(dwh_create_date)
FROM silver.erp_px_cat_g1v2;
