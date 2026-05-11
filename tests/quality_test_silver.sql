-- Identify Out-of-Range Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT
gen
FROM silver.erp_cust_az12;
INSERT INTO silver.erp_loc_a101
(cid,cntry)
SELECT
REPLACE(cid, '-', '') AS cid,
CASE
WHEN TRIM(cntry) = 'DE' THEN 'Germany'
WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;

-- Data Standardization & Consistency
SELECT DISTINCT
cntry
FROM silver.erp_loc_a101;


----------------------------------------------

INSERT INTO silver.erp_px_cat_g1v2
(id, cat, subcat, maintenance)
SELECT
id,
TRIM(cat) AS cat,
TRIM(subcat) AS subcat,
TRIM(maintenance) AS maintenance
FROM bronze.erp_px_cat_g1v2;

-- Check for unwanted Spaces
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance);

--------------------------------------
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT
CASE
WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
ELSE cid
END AS cid,
CASE
WHEN bdate > GETDATE() THEN NULL
ELSE bdate
END AS bdate,
CASE
WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_a212
