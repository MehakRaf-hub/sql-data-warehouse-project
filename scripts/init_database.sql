/*
=============================================================
Create Database and Schemas
=============================================================

Script Purpose:
    This script initializes the Data Warehouse project by creating
    the required schemas: bronze, silver, and gold.

    PostgreSQL does not allow creating or dropping the currently
    connected database from within the same SQL script. Therefore,
    create the 'DataWarehouse' database first using pgAdmin or
    the PostgreSQL command line, then connect to it before running
    this script.

Schemas:
    bronze - Stores raw data directly from source systems.
    silver - Stores cleaned and transformed data.
    gold   - Stores business-ready data for reporting and analytics.

WARNING:
    If the DROP SCHEMA statements are uncommented, all objects
    inside the schemas will be permanently deleted.
=============================================================
*/

-- ==========================================================
-- Optional: Drop existing schemas
-- Uncomment the following lines only if you want to recreate
-- the schemas from scratch.
-- ==========================================================

-- DROP SCHEMA IF EXISTS bronze CASCADE;
-- DROP SCHEMA IF EXISTS silver CASCADE;
-- DROP SCHEMA IF EXISTS gold CASCADE;

-- ==========================================================
-- Create Schemas
-- ==========================================================

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;
