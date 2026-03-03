--Transformation after data integration

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER () OVER (ORDER BY ci.cust_id) AS customer_key,
	ci.cust_id AS customer_id,
	ci.cust_key AS customer_number,
	ci.cust_firstname AS first_name,
	ci.cust_lastname AS last_name,
	la.cust_country AS country,
	ci.cust_material_status AS marital_status,

	CASE WHEN ci.cust_gender != 'n/a' THEN ci.cust_gender  --CRM is the Master for gender Info
		ELSE COALESCE (ca.cust_gender, 'n/a')

	END AS new_gender,
	ca.cust_birth_date AS birth_date,
	ci.cust_create_date AS create_date
	
FROM silver.crm_cust_info  ci
LEFT JOIN silver.erp_cust_info  ca
ON ci.cust_key = ca.cust_id
LEFT JOIN silver.erp_loc_info la
ON ci.cust_key = la.cust_id
	

