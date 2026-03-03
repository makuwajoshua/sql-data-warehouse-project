CREATE View gold.fact_sales AS
SELECT 
sd.sls_order_number AS order_number,
pr.product_key AS product_key,
cu.customer_key AS customer_key,
sd.sls_order_date AS order_date,
sd.sls_ship_date AS shipping_date,
sd.sls_due_date AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price

FROM silver.crm_sls_info sd
LEFT JOIN gold.dim_products pr
ON sd.sls_product_key = pr.product_number	

LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
