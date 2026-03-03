/*
==================================================
Create Database and Schemas
==================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse'
    after checking if it already exists.

    If the database exists, it is dropped and recreated.
    Additionally, the script sets up three schemas within
    the database: bronze, silver, and gold.

WARNING:
    Running this script will DROP the entire DataWarehouse
    database if it exists. All data will be permanently
    deleted. Proceed with caution and ensure backups exist.
==================================================
*/

USE master;
GO

/* =========================
   DROP DATABASE IF EXISTS
   ========================= */
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

/* =========================
   CREATE DATABASE
   ========================= */
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

/* =========================
   CREATE SCHEMAS
   ========================= */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO

