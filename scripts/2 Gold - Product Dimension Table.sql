--Product Dimension Table

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER () OVER (ORDER BY pn.prd_start_date, pn.prd_key) AS product_key,  -- Creating a Surrogate Key

	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,

	pc.px_category AS category,
	pc.px_subcat AS subcategory,
	pc.px_maintenance AS maintenance,

	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_date AS start_date,
	pn.prd_end_date AS end_date

FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat pc
ON pn.cat_id = pc.px_id
WHERE prd_end_date IS NULL -- Filter out all historical data
