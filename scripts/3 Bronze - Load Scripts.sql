CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY

	SET @batch_start_time = GETDATE();
	PRINT '===================================================================================================================';
	PRINT 'Load Bronze Layer';
	PRINT '===================================================================================================================';

	PRINT '-------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '-------------------------------------------------------------------------------------------------------------------';
	
	SET @start_time = GETDATE();
	PRINT '>> Truncateing Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;

	PRINT '>> Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '---------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>> Inserting Data Into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT 'Calls Table: bronze.crm_sls_info to alter a sls_order_date column';
	ALTER TABLE bronze.crm_sls_info
	ALTER COLUMN sls_order_date NVARCHAR(50);

	PRINT '>> Truncating Table: bronze.crm_sls_info';
	TRUNCATE TABLE bronze.crm_sls_info;

	PRINT '>> Inserting Data Into: bronze.crm_sls_info';
	BULK INSERT bronze.crm_sls_info
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '-------------------------------------------------------------------------------------------------------------------';


	PRINT '-------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.erp_cust_info';
	TRUNCATE TABLE bronze.erp_cust_info;

	PRINT '>> Inserting Data Into: bronze.erp_cust_info';
	BULK INSERT bronze.erp_cust_info
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_erp\cust.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.erp_loc_info';
	TRUNCATE TABLE bronze.erp_loc_info;

	PRINT'>> Inserting Data Into: bronze.erp_loc_info';
	BULK INSERT bronze.erp_loc_info
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_erp\loc.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);


	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.erp_px_cat';
	TRUNCATE TABLE bronze.erp_px_cat;

	PRINT '>> Inserting Data Into: bronze.erp_px_cat';
	BULK INSERT bronze.erp_px_cat
		FROM 'C:\Users\27680\OneDrive\Documents\Data Science\Projects\SQL Data Warehousing\datasets\source_erp\px.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '-------------------------------------------------------------------------------------------------------------------';

	SET @batch_end_time = GETDATE();
	PRINT '===================================================================================================================='
	PRINT 'Loading Bronze Layer is Completed';
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