DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS

SELECT

    s.sls_ord_num      AS order_number,

    p.product_key,

    c.customer_key,

    s.sls_order_dt     AS order_date,

    s.sls_ship_dt      AS ship_date,

    s.sls_due_dt       AS due_date,

    s.sls_sales        AS sales_amount,

    s.sls_quantity     AS quantity,

    s.sls_price        AS price

FROM silver.crm_sales_details s

LEFT JOIN gold.dim_customers c
    ON s.sls_cust_id = c.customer_id

LEFT JOIN gold.dim_products p
    ON s.sls_prd_key = p.product_number;
