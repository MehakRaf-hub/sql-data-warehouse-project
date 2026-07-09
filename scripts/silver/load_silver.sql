/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Loads cleaned and standardized data from the Bronze layer into
    the Silver layer.

Author: Mehak
Database: PostgreSQL
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    batch_start TIMESTAMP;
    batch_end   TIMESTAMP;
BEGIN

    batch_start := clock_timestamp();

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '========================================';

    ------------------------------------------------------------
    -- CRM CUSTOMER INFO
    ------------------------------------------------------------

    RAISE NOTICE 'Loading crm_cust_info...';

    TRUNCATE TABLE silver.crm_cust_info;

    -- Data cleaning and INSERT will be added here

    ------------------------------------------------------------
    -- CRM PRODUCT INFO
    ------------------------------------------------------------

    RAISE NOTICE 'Loading crm_prd_info...';

    TRUNCATE TABLE silver.crm_prd_info;

    -- INSERT will be added later

    ------------------------------------------------------------
    -- CRM SALES DETAILS
    ------------------------------------------------------------

    RAISE NOTICE 'Loading crm_sales_details...';

    TRUNCATE TABLE silver.crm_sales_details;

    -- INSERT will be added later

    ------------------------------------------------------------
    -- ERP CUSTOMER
    ------------------------------------------------------------

    RAISE NOTICE 'Loading erp_cust_az12...';

    TRUNCATE TABLE silver.erp_cust_az12;

    -- INSERT will be added later

    ------------------------------------------------------------
    -- ERP LOCATION
    ------------------------------------------------------------

    RAISE NOTICE 'Loading erp_loc_a101...';

    TRUNCATE TABLE silver.erp_loc_a101;

    -- INSERT will be added later

    ------------------------------------------------------------
    -- ERP PRODUCT CATEGORY
    ------------------------------------------------------------

    RAISE NOTICE 'Loading erp_px_cat_g1v2...';

    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    -- INSERT will be added later

    batch_end := clock_timestamp();

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Silver Layer Loaded Successfully';
    RAISE NOTICE 'Execution Time: % seconds',
        EXTRACT(EPOCH FROM (batch_end - batch_start));
    RAISE NOTICE '========================================';

EXCEPTION
    WHEN OTHERS THEN

        RAISE NOTICE '========================================';
        RAISE NOTICE 'Error while loading Silver Layer';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE '========================================';

END;
$$;
