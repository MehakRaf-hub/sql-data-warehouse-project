/*
===============================================================================
Validation Script: Gold Layer
===============================================================================
Purpose:
    Validates the Gold Layer after creating the views.
===============================================================================
*/

------------------------------------------------------------
-- Total Customers
------------------------------------------------------------
SELECT COUNT(*) AS total_customers
FROM gold.dim_customers;

------------------------------------------------------------
-- Total Products
------------------------------------------------------------
SELECT COUNT(*) AS total_products
FROM gold.dim_products;

------------------------------------------------------------
-- Total Sales
------------------------------------------------------------
SELECT COUNT(*) AS total_sales
FROM gold.fact_sales;

------------------------------------------------------------
-- Duplicate Customer Keys
------------------------------------------------------------
SELECT
    customer_key,
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Duplicate Product Keys
------------------------------------------------------------
SELECT
    product_key,
    COUNT(*)
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Missing Customer Keys in Fact Table
------------------------------------------------------------
SELECT COUNT(*) AS missing_customer_keys
FROM gold.fact_sales
WHERE customer_key IS NULL;

------------------------------------------------------------
-- Missing Product Keys in Fact Table
------------------------------------------------------------
SELECT COUNT(*) AS missing_product_keys
FROM gold.fact_sales
WHERE product_key IS NULL;

------------------------------------------------------------
-- Sample Customer Data
------------------------------------------------------------
SELECT *
FROM gold.dim_customers
LIMIT 10;

------------------------------------------------------------
-- Sample Product Data
------------------------------------------------------------
SELECT *
FROM gold.dim_products
LIMIT 10;

------------------------------------------------------------
-- Sample Sales Data
------------------------------------------------------------
SELECT *
FROM gold.fact_sales
LIMIT 10;
