/*
===================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==================================================================
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
thhe bronze tables before loading data.
- Uses the BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME;

    BEGIN TRY

        PRINT '============================';
        PRINT 'Loading Bronze Layer';
        PRINT '============================';

        PRINT '----------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '----------------------------';

        -- =========================================
        -- CRM CUSTOMER INFO
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------';

        -- =========================================
        -- CRM PRODUCT INFO
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------';

        -- =========================================
        -- CRM SALES DETAILS
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '----------------------------';

        -- =========================================
        -- ERP CUSTOMER
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_a212';

                TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------';

        -- =========================================
        -- ERP LOCATION
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------';

        -- =========================================
        -- ERP PRODUCT CATEGORY
        -- =========================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Gnana prakash\OneDrive\Desktop\DSQLData\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '============================';
        PRINT 'Bronze Layer Loaded Successfully';
        PRINT '============================';

    END TRY

    BEGIN CATCH

        PRINT '=============================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=============================================';

    END CATCH

END;
