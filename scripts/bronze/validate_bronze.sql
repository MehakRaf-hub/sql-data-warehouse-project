/*
===============================================================================
Bronze Layer Validation
===============================================================================
Purpose:
    Validate data loaded into the Bronze layer before moving to the Silver layer.

Validation Checks:
1. Row Count Validation
2. NULL Value Validation
3. Duplicate Record Validation
4. Invalid Date Validation
5. Negative Value Validation
===============================================================================
*/

-- =============================================================================
-- ROW COUNT VALIDATION
-- =============================================================================

SELECT
'CRM Customer Table Row Count' AS validation,
CASE WHEN COUNT(*) = 18494 THEN 'PASS' ELSE 'FAIL' END AS status,
COUNT(*) AS result
FROM bronze.crm_cust_info

UNION ALL

SELECT
'CRM Product Table Row Count',
CASE WHEN COUNT(*) = 397 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT
'CRM Sales Table Row Count',
CASE WHEN COUNT(*) = 60398 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.crm_sales_details

UNION ALL

SELECT
'ERP Customer Table Row Count',
CASE WHEN COUNT(*) = 18484 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.erp_cust_az12

UNION ALL

SELECT
'ERP Location Table Row Count',
CASE WHEN COUNT(*) = 18484 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT
'ERP Category Table Row Count',
CASE WHEN COUNT(*) = 37 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.erp_px_cat_g1v2;

-- =============================================================================
-- NULL VALUE VALIDATION
-- =============================================================================

SELECT
'CRM Customer ID NULL Check' AS validation,
CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status,
COUNT(*) AS result
FROM bronze.crm_cust_info
WHERE cst_id IS NULL

UNION ALL

SELECT
'CRM Product ID NULL Check',
CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.crm_prd_info
WHERE prd_id IS NULL

UNION ALL

SELECT
'CRM Order Number NULL Check',
CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END,
COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_ord_num IS NULL;

-- =============================================================================
-- DUPLICATE CUSTOMER ID CHECK
-- =============================================================================

SELECT
cst_id,
COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- =============================================================================
-- INVALID DATE CHECK
-- =============================================================================

SELECT *
FROM bronze.crm_sales_details
WHERE sls_ship_dt < sls_order_dt;

-- =============================================================================
-- NEGATIVE VALUE CHECK
-- =============================================================================

SELECT *
FROM bronze.crm_sales_details
WHERE sls_sales < 0
OR sls_quantity < 0
OR sls_price < 0;
