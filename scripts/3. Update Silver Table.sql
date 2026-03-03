IF OBJECT_ID ('silver.crm_sls_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_sls_info;

CREATE TABLE silver.crm_sls_info (
	sls_order_number NVARCHAR(50),
	sls_product_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_date DATE,
	sls_ship_date DATE,
	sls_due_date DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

SELECT *
FROM silver.crm_cust_info