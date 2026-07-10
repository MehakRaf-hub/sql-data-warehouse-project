DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS

SELECT

    ROW_NUMBER() OVER (ORDER BY p.prd_start_dt, p.prd_id) AS product_key,

    p.prd_id                AS product_id,

    p.prd_key               AS product_number,

    p.prd_nm                AS product_name,

    c.cat                   AS category,

    c.subcat                AS subcategory,

    p.prd_line              AS product_line,

    c.maintenance           AS maintenance,

    p.prd_cost              AS product_cost,

    p.prd_start_dt          AS start_date

FROM silver.crm_prd_info p

LEFT JOIN silver.erp_px_cat_g1v2 c
    ON p.cat_id = c.id

WHERE p.prd_end_dt IS NULL;
