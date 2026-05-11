/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process
    to populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

DECLARE @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

BEGIN TRY

SET @batch_start_time = GETDATE();

PRINT '=====================================';
PRINT 'Loading Silver Layer';
PRINT '=====================================';

PRINT '-------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '-------------------------------------';

-------------------------------------------------
-- Loading silver.crm_cust_info
-------------------------------------------------

SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;

PRINT '>> Inserting Data Into: silver.crm_cust_info';

INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

CASE
WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
ELSE 'n/a'
END AS cst_material_status,

CASE
WHEN UPPER(TRIM(cst_gndr)) IN ('F', 'FEMALE') THEN 'Female'
WHEN UPPER(TRIM(cst_gndr)) IN ('M', 'MALE') THEN 'Male'
ELSE 'n/a'
END AS cst_gndr,

cst_create_date

FROM (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY cst_id
ORDER BY cst_create_date DESC
) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;

SET @end_time = GETDATE();

PRINT '>> Load Duration: '
+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
+ ' seconds';

PRINT '>> ------------------------------------';

-------------------------------------------------
-- Loading silver.crm_prd_info
-------------------------------------------------

SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;

PRINT '>> Inserting Data Into: silver.crm_prd_info';

INSERT INTO silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,

CASE
WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
ELSE 'n/a'
END AS prd_line,

CAST(prd_start_dt AS DATE) AS prd_start_dt,

CAST(
LEAD(prd_start_dt)
OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
AS DATE
) AS prd_end_dt

FROM bronze.crm_prd_info;

SET @end_time = GETDATE();

PRINT '>> Load Duration: '
+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
+ ' seconds';

PRINT '>> ------------------------------------';

END TRY

BEGIN CATCH

PRINT '=====================================';
PRINT 'ERROR OCCURRED DURING LOADING';
PRINT 'Error Message: ' + ERROR_MESSAGE();
PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
PRINT '=====================================';

END CATCH

END;
