/*
===============================================================================
Stored Procedure: Load Bronze Layer
===============================================================================
Purpose:
    - Truncate all Bronze tables
    - Display progress messages
    - Measure execution time
    - Handle unexpected errors

Database: PostgreSQL
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;

BEGIN

    batch_start_time := clock_timestamp();

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '========================================';

    RAISE NOTICE 'Loading CRM Tables...';

    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '✔ crm_cust_info truncated';

    TRUNCATE TABLE bronze.crm_prd_info;
    RAISE NOTICE '✔ crm_prd_info truncated';

    TRUNCATE TABLE bronze.crm_sales_details;
    RAISE NOTICE '✔ crm_sales_details truncated';

    RAISE NOTICE 'Loading ERP Tables...';

    TRUNCATE TABLE bronze.erp_cust_az12;
    RAISE NOTICE '✔ erp_cust_az12 truncated';

    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE NOTICE '✔ erp_loc_a101 truncated';

    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    RAISE NOTICE '✔ erp_px_cat_g1v2 truncated';

    batch_end_time := clock_timestamp();

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Bronze Layer Completed Successfully';
    RAISE NOTICE 'Total Duration: %', batch_end_time - batch_start_time;
    RAISE NOTICE '========================================';

EXCEPTION
WHEN OTHERS THEN

    RAISE NOTICE '========================================';
    RAISE NOTICE 'ERROR OCCURRED DURING BRONZE LOAD';
    RAISE NOTICE 'Error: %', SQLERRM;
    RAISE NOTICE '========================================';

END;
$$;
