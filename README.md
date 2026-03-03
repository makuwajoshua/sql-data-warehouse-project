# 📊 Modern Data Warehouse – Bronze → Silver → Gold Architecture**

# 🏗️ Data Warehouse Layers Overview

This project follows a **Bronze → Silver → Gold architecture**, a standard modern data engineering approach for building scalable and analytics-ready data systems.

---

## 🥉 Bronze Layer – Raw Data Layer

**Purpose:**
Stores raw data exactly as received from source systems.

**Key Characteristics:**

* No transformations applied
* Preserves original structure and format
* Used for traceability and auditing
* Acts as a backup and reprocessing layer

**Why it matters:**
It ensures data lineage, debugging capability, and protection against data loss or transformation errors.

---

## 🥈 Silver Layer – Cleaned & Transformed Layer

**Purpose:**
Cleans, standardizes, and prepares data for analytical modeling.

**Key Characteristics:**

* Handles missing values
* Removes duplicates
* Standardizes formats (e.g., dates, text)
* Applies business rules
* Improves data quality

**Why it matters:**
This layer ensures consistent, reliable, and structured data before it is modeled for analytics.

---

## 🥇 Gold Layer – Business & Analytics Layer

**Purpose:**
Provides business-ready, analytics-optimized data structures.

**Key Characteristics:**

* Star schema design
* Fact and dimension tables
* Surrogate keys
* Optimized for BI tools (e.g., Power BI)

**Why it matters:**
This layer enables fast analytical queries, reporting, KPI tracking, and dashboard creation.

---

# 🔄 Flow Summary
![Data Flow](https://github.com/makuwajoshua/sql-data-warehouse-project/blob/main/Data%20Flow.PNG?raw=true)

## ⭐ Data Model (Star Schema)

![Star Schema](https://github.com/makuwajoshua/sql-data-warehouse-project/blob/main/Star%20Schema.PNG?raw=true)

* `fact_sales` is the central transactional table.
* Dimension tables provide descriptive context.
* Surrogate keys optimize performance and maintain integrity.

---

## 🛠️ Tools & Technologies

* SQL Server
* Star Schema Modeling
* Data Warehouse Design Principles
* Dimensional Modeling
* GitHub for version control

---

## 📈 Business Use Cases Enabled

This Gold Layer supports:

* Revenue trend analysis
* Customer segmentation
* Product performance tracking
* Sales forecasting inputs
* Operational reporting dashboards
* BI tools integration (Power BI / Tableau)

---

## 🎯 Skills Demonstrated

* Data Modeling (Star Schema)
* Dimensional Modeling
* Surrogate Key Design
* Business-Oriented Data Structuring
* Analytical Data Preparation
* Data Warehouse Best Practices

---
# 🧠 Sample SQL Implementation

### Example: Creating Product Dimension Table

```sql
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
WHERE prd_end_date IS NULL 
```
### Example: Creating Customer Dimension Table

```sql

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
	
```

### Example: Creating Sales Fact Table

```sql
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

```

## 🙏 Acknowledgement

This project was developed as part of my Data Engineering learning journey, inspired and guided by tutorials from **Data With Baraa**, whose structured explanations of modern data warehousing significantly supported the implementation of this architecture.

---

## 🚀 Future Improvements
* Build ETL pipelines
* Connect to the Power BI dashboard
* Add performance indexing strategy
* Automate deployment using CI/CD


## 👤 Author Vitumbiko Makuwa




