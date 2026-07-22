IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT
	, cst_key NVARCHAR(50)
	, cst_firstname NVARCHAR(50)
	, cst_lastname NVARCHAR(50)
	, cst_material_status NVARCHAR(50)
	, cst_gndr NVARCHAR(50)
	, cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT
	, prd_key NVARCHAR(50)
	, prd_nm NVARCHAR(50)
	, prd_cost INT
	, prd_line NVARCHAR(50)
	, prd_start_dt DATE
	, prd_end_dt DATE
);

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50)
	, sls_prd_key NVARCHAR(50)
	, sls_cust_id INT
	, sls_order_dt INT
	, sls_ship_dt INT
	, sls_due_dt INT
	, sls_sales INT
	, sls_quantity INT
	, sls_price INT
	);

	CREATE TABLE bronze.erp_cust_az12 (
		cid NVARCHAR(50)
		, bdate DATE
		, gen NVARCHAR(50)
	);

	CREATE TABLE bronze.erp_loc_a101 (
		cid NVARCHAR(50)
		, cntr NVARCHAR(50)
	);

	CREATE TABLE bronze.erp_px_cat_g1v2 (
		id NVARCHAR(50)
		, cat NVARCHAR(50)
		, subcat NVARCHAR(50)
		, maintenance NVARCHAR(50)
	);




  CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '========================'
		PRINT 'Loading the bronze layer'
		PRINT '========================'
	
		PRINT '========================'
		PRINT 'Loading the crm data'
		PRINT '========================'

		SET @start_time = GETDATE(); 
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);
		
		SET @end_time = GETDATE();
		PRINT 'Load time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH  (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);

		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);


		PRINT '========================'
		PRINT 'Loading the erp data'
		PRINT '========================'

		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);

		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\ACER\Desktop\SQL project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
			);
		PRINT '========================'
		PRINT 'END'
		PRINT '========================'
	END TRY
	BEGIN CATCH
		PRINT '========================'
		PRINT 'ERROR!'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST (ERROR_NUMBER() AS NVARCHAR(50));
		PRINT '========================'
	END CATCH
END
