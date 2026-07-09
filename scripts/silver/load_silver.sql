/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Loads and cleans data from the Bronze layer into the Silver layer.

Actions:
    - Truncates Silver tables
    - Cleans and standardizes data
    - Loads cleaned data into Silver
    - Prints execution logs
    - Measures execution time
    - Handles runtime errors

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

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '';
    RAISE NOTICE '----------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '----------------------------------------';

    ---------------------------------------------------------------------------
    -- CRM CUSTOMER INFO
    ---------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table: silver.crm_cust_info';

    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info
    (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date,
        dwh_create_date
    )

    SELECT

        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),

        CASE
            WHEN UPPER(TRIM(cst_material_status))='S'
                THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status))='M'
                THEN 'Married'
            ELSE 'n/a'
        END,

        CASE
            WHEN UPPER(TRIM(cst_gndr))='F'
                THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr))='M'
                THEN 'Male'
            ELSE 'n/a'
        END,

        cst_create_date,

        CURRENT_TIMESTAMP

    FROM
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                   PARTITION BY cst_id
                   ORDER BY cst_create_date DESC
               ) rn

        FROM bronze.crm_cust_info

        WHERE cst_id IS NOT NULL

    ) t

    WHERE rn = 1;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.crm_cust_info
    );

    ---------------------------------------------------------------------------
    -- CRM PRODUCT INFO
    ---------------------------------------------------------------------------

    RAISE NOTICE '';
    RAISE NOTICE 'Loading Table: silver.crm_prd_info';

    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info
    (
        prd_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt,
        dwh_create_date
    )

    SELECT

        prd_id,

        SUBSTRING(prd_key,7),

        TRIM(prd_nm),

        COALESCE(prd_cost,0),

        CASE

            WHEN TRIM(prd_line)='M'
                THEN 'Mountain'

            WHEN TRIM(prd_line)='R'
                THEN 'Road'

            WHEN TRIM(prd_line)='S'
                THEN 'Other Sales'

            WHEN TRIM(prd_line)='T'
                THEN 'Touring'

            ELSE 'n/a'

        END,

        prd_start_dt::DATE,

        (
            LEAD(prd_start_dt)
            OVER
            (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ) - INTERVAL '1 day'
        )::DATE,

        CURRENT_TIMESTAMP

    FROM bronze.crm_prd_info;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.crm_prd_info
    );

    ---------------------------------------------------------------------------
    -- CRM SALES DETAILS
    ---------------------------------------------------------------------------

    RAISE NOTICE '';
    RAISE NOTICE 'Loading Table: silver.crm_sales_details';

    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details
    (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price,
        dwh_create_date
    )

    SELECT

        sls_ord_num,

        sls_prd_key,

        sls_cust_id,

        CASE
            WHEN LENGTH(sls_order_dt)=8
                THEN TO_DATE(sls_order_dt,'YYYYMMDD')
            ELSE NULL
        END,

        CASE
            WHEN LENGTH(sls_ship_dt)=8
                THEN TO_DATE(sls_ship_dt,'YYYYMMDD')
            ELSE NULL
        END,

        CASE
            WHEN LENGTH(sls_due_dt)=8
                THEN TO_DATE(sls_due_dt,'YYYYMMDD')
            ELSE NULL
        END,

        CASE
            WHEN sls_sales IS NULL OR sls_sales <= 0
                THEN ABS(COALESCE(sls_price,0) * COALESCE(sls_quantity,0))
            ELSE sls_sales
        END,

        sls_quantity,

        ABS(COALESCE(sls_price,0)),

        CURRENT_TIMESTAMP

    FROM bronze.crm_sales_details;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.crm_sales_details
    );

    ---------------------------------------------------------------------------
    -- ERP TABLES
    ---------------------------------------------------------------------------

    RAISE NOTICE '';
    RAISE NOTICE '----------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '----------------------------------------';

    ---------------------------------------------------------------------------
    -- ERP CUSTOMER
    ---------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table: silver.erp_cust_az12';

    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12
    (
        cid,
        bdate,
        gen,
        dwh_create_date
    )

    SELECT

        REPLACE(TRIM(cid),'NAS',''),

        CASE
            WHEN bdate > CURRENT_DATE
                THEN NULL
            ELSE bdate
        END,

        CASE
            WHEN UPPER(TRIM(gen)) IN ('M','MALE')
                THEN 'Male'

            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE')
                THEN 'Female'

            ELSE 'n/a'
        END,

        CURRENT_TIMESTAMP

    FROM bronze.erp_cust_az12;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.erp_cust_az12
    );

    ---------------------------------------------------------------------------
    -- ERP LOCATION
    ---------------------------------------------------------------------------

    RAISE NOTICE '';
    RAISE NOTICE 'Loading Table: silver.erp_loc_a101';

    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101
    (
        cid,
        cntry,
        dwh_create_date
    )

    SELECT

        REPLACE(TRIM(cid),'-',''),

        CASE

            WHEN TRIM(cntry) IN ('US','USA','United States')
                THEN 'United States'

            WHEN TRIM(cntry) IN ('DE','Germany')
                THEN 'Germany'

            WHEN TRIM(cntry)='Australia'
                THEN 'Australia'

            WHEN TRIM(cntry)='Canada'
                THEN 'Canada'

            WHEN TRIM(cntry)='France'
                THEN 'France'

            WHEN TRIM(cntry)='United Kingdom'
                THEN 'United Kingdom'

            WHEN cntry IS NULL OR TRIM(cntry)=''
                THEN 'n/a'

            ELSE TRIM(cntry)

        END,

        CURRENT_TIMESTAMP

    FROM bronze.erp_loc_a101;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.erp_loc_a101
    );

    ---------------------------------------------------------------------------
    -- ERP PRODUCT CATEGORY
    ---------------------------------------------------------------------------

    RAISE NOTICE '';
    RAISE NOTICE 'Loading Table: silver.erp_px_cat_g1v2';

    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2
    (
        id,
        cat,
        subcat,
        maintenance,
        dwh_create_date
    )

    SELECT

        TRIM(id),

        TRIM(cat),

        TRIM(subcat),

        TRIM(maintenance),

        CURRENT_TIMESTAMP

    FROM bronze.erp_px_cat_g1v2;

    RAISE NOTICE 'Rows Loaded: %',
    (
        SELECT COUNT(*)
        FROM silver.erp_px_cat_g1v2
    );

    ---------------------------------------------------------------------------
    -- COMPLETED
    ---------------------------------------------------------------------------

    batch_end := clock_timestamp();

    RAISE NOTICE '';
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Silver Layer Loaded Successfully';
    RAISE NOTICE 'Execution Time: % seconds',
        ROUND(EXTRACT(EPOCH FROM (batch_end - batch_start)),2);
    RAISE NOTICE '================================================';

EXCEPTION
    WHEN OTHERS THEN

        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR OCCURRED WHILE LOADING SILVER LAYER';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE '================================================';

END;
$$;
