CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY

	SET @batch_start_time = GETDATE();
	PRINT '===================================================================================================================';
	PRINT 'Load Silver Layer';
	PRINT '===================================================================================================================';

	PRINT '-------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	--CRM Source:Customer Info Transformation
	PRINT '>> Truncating Table silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	PRINT '>> Inserting Data Into: silver.crm_cust_info';
	INSERT INTO silver.crm_cust_info(
		cust_id,
		cust_key,
		cust_firstname,
		cust_lastname,
		cust_material_status,
		cust_gender,
		cust_create_date)

	SELECT 
	cust_id,
	cust_key,
	TRIM(cust_firstname) AS cust_firstname,
	TRIM(cust_lastname) AS cust_lastname,

	CASE WHEN UPPER(TRIM(cust_material_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cust_material_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END cust_material_status,

	CASE WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
		 WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
		 ELSE 'n/a'
	END cust_gender,

	cust_create_date
	FROM(
		SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) as flag_last
		FROM
		bronze.crm_cust_info
		WHERE cust_id IS NOT NULL
		)t WHERE flag_last = 1
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';
	
	SET @start_time = GETDATE()
	--CRM Source:Product Info Transformation
	PRINT '>> Truncating Table silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	PRINT '>> Inserting Data Into: silver.crm_prd_info';
	INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
	)
	SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        -- Extract product key
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,

	CASE UPPER(TRIM(prd_line)) 
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,  -- Map product line codes to descriptive values

	prd_start_date,

	DATEADD(day, -1, 
		LEAD(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date)) 
		AS prd_end_date  -- Calculate end date as one day before the next start date
	FROM bronze.crm_prd_info
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	--CRM Source: Sales Info Transformation
	PRINT '>> Truncating Table silver.crm_sls_info';
	TRUNCATE TABLE silver.crm_sls_info;
	PRINT '>> Inserting Data Into: silver.crm_sls_info';
	INSERT INTO silver.crm_sls_info (
		sls_order_number,
		sls_product_key,
		sls_cust_id,
		sls_order_date,
		sls_ship_date,
		sls_due_date,
		sls_sales ,
		sls_quantity,
		sls_price
	)
	SELECT
	sls_order_number,
	sls_product_key,
	sls_cust_id,

	CASE 
		-- 1. Value is already a DATE >> keep it
		WHEN TRY_CONVERT(DATE, sls_order_date) IS NOT NULL 
		THEN TRY_CONVERT(DATE, sls_order_date)

		-- 2. Value is an INT in YYYYYMMDD format >> convert it
		WHEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_order_date)) IS NOT NULL
		THEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_order_date))

		--3. Everyting else >> invalid
		ELSE NULL
	END AS sls_order_date, 

	CASE 
		-- 1. Value is already a DATE >> keep it
		WHEN TRY_CONVERT(DATE, sls_ship_date) IS NOT NULL 
		THEN TRY_CONVERT(DATE, sls_ship_date)

		-- 2. Value is an INT in YYYYYMMDD format >> convert it
		WHEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_ship_date)) IS NOT NULL
		THEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_ship_date))

		--3. Everyting else >> invalid
		ELSE NULL
	END AS sls_ship_date, 

	CASE 
		-- 1. Value is already a DATE >> keep it
		WHEN TRY_CONVERT(DATE, sls_due_date) IS NOT NULL 
		THEN TRY_CONVERT(DATE, sls_due_date)

		-- 2. Value is an INT in YYYYYMMDD format >> convert it
		WHEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_due_date)) IS NOT NULL
		THEN TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_due_date))

		--3. Everyting else >> invalid
		ELSE NULL
	END AS sls_due_date, 

	CASE WHEN sls_sales is NULL OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,

	sls_quantity,

	CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price
	FROM bronze.crm_sls_info;
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';
	
	SET @start_time = GETDATE();
	--ERP Source: Customer Info Transformation
	PRINT '>> Truncating Table silver.erp_cust_info';
	TRUNCATE TABLE silver.erp_cust_info;
	PRINT '>> Inserting Data Into: silver.erp_cust_info';
	INSERT INTO silver.erp_cust_info (cust_id, cust_birth_date, cust_gender)
	SELECT
	CASE WHEN cust_id LIKE 'NAS%' THEN SUBSTRING(cust_id, 4, len(cust_id))
		ELSE cust_id
	END AS cust_id,

	CASE WHEN cust_birth_date > GETDATE() THEN NULL
		 ELSE cust_birth_date
	END AS cust_birth_date,

	CASE WHEN UPPER(TRIM(cust_gender)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(cust_gender)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END AS cust_gender

	FROM bronze.erp_cust_info
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';

	PRINT '-------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE()
	--ERP Source Location Info Transformation
	PRINT '>> Truncating Table silver.erp_loc_info';
	TRUNCATE TABLE silver.crm_sls_info;
	PRINT '>> Inserting Data Into: silver.erp_loc_info';
	INSERT INTO silver.erp_loc_info (cust_id, cust_country)

	SELECT

		REPLACE(cust_id, '-', '') cust_id,

		CASE WHEN TRIM(cust_country) = 'DE' THEN 'Germany'
			WHEN TRIM(cust_country) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cust_country) = '' OR cust_country IS NULL THEN 'n/a'
			ELSE TRIM(cust_country)
		END as loc_country	-- Normalize and Handle missing or blank country codes

	FROM bronze.erp_loc_info
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE()
	--ERP Source: Product Info Transformation
	PRINT '>> Truncating Table silver.erp_px_cat';
	TRUNCATE TABLE silver.erp_px_cat;
	PRINT '>> Inserting Data Into: silver.erp_px_cat';
	INSERT INTO silver.erp_px_cat
	(px_id, px_category, px_subcat, px_maintenance)
	SELECT
	px_id,
	px_category,
	px_subcat,
	px_maintenance
	FROM bronze.erp_px_cat
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';

	SET @batch_end_time = GETDATE();
	PRINT '===================================================================================================================='
	PRINT 'Loading Silver Layer is Completed';
	PRINT ' Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
	PRINT '===================================================================================================================='
	END TRY

	BEGIN CATCH
		PRINT '=========================================================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT ' Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================================================================================';
	END CATCH
END