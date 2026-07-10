/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================

Purpose:
    Creates the Gold Layer views.

Author: Mehak
Database: PostgreSQL

===============================================================================
*/

DROP VIEW IF EXISTS gold.fact_sales;

DROP VIEW IF EXISTS gold.dim_products;

DROP VIEW IF EXISTS gold.dim_customers;
