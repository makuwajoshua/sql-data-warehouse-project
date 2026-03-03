/* =========================
   CRM CUSTOMER INFO
   ========================= */
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

ALTER AUTHORIZATION ON SCHEMA::silver TO dbo;
GO

CREATE TABLE silver.crm_cust_info (
    cust_id INT,
    cust_key NVARCHAR(50),
    cust_firstname NVARCHAR(50),
    cust_lastname NVARCHAR(50),
    cust_material_status NVARCHAR(50),
    cust_gender NVARCHAR(50),
    cust_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

/* =========================
   CRM PRODUCT INFO
   ========================= */
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost NVARCHAR(50),
    prd_line NVARCHAR(50),
    prd_start_date DATE,
    prd_end_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

/* =========================
   CRM SALES INFO
   ========================= */
IF OBJECT_ID('silver.crm_sls_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_sls_info;
GO

CREATE TABLE silver.crm_sls_info (
    sls_order_number NVARCHAR(50),
    sls_product_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_date DATE,
    sls_ship_date DATE,
    sls_due_date DATE,
    sls_sales INT,
    sls_quantity NVARCHAR(50),
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

/* =========================
   ERP CUSTOMER INFO
   ========================= */
IF OBJECT_ID('silver.erp_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_info;
GO

CREATE TABLE silver.erp_cust_info (
    cust_id NVARCHAR(50),
    cust_birth_date DATE,
    cust_gender NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

/* =========================
   ERP LOCATION INFO
   ========================= */
IF OBJECT_ID('silver.erp_loc_info', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_info;
GO

CREATE TABLE silver.erp_loc_info (
    cust_id NVARCHAR(50),
    cust_country NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

/* =========================
   ERP PRICE CATEGORY
   ========================= */
IF OBJECT_ID('silver.erp_px_cat', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat;
GO

CREATE TABLE silver.erp_px_cat (
    px_id NVARCHAR(50),
    px_category NVARCHAR(50),
    px_subcat NVARCHAR(50),
    px_maintenance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO





