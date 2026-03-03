# 📊 Modern Data Warehouse – Gold Layer (Analytics Model)

## 📌 Project Overview

This project implements the **Gold Layer** of a modern data warehouse designed to support business intelligence, reporting, and analytics use cases.

The Gold Layer represents the **business-ready data model**, structured using a **star schema design** with:

* Dimension tables (descriptive attributes)
* Fact tables (transactional metrics)
* Surrogate keys for optimized joins
* Cleaned and analytics-ready data structures

This project was developed as part of my SQL Data Engineering & BI learning journey, with guidance and inspiration from **Data With Baraa**.

---

## 🏗️ Architecture Overview

The Gold Layer consists of:

### 1️⃣ `gold.dim_customers`

Stores customer demographic and geographic information.

**Key Features:**

* Surrogate key (`customer_key`)
* Demographic attributes (gender, marital status, birthdate)
* Geographic data (country)
* Customer identification tracking

This table enables customer segmentation, demographic analysis, and geographic reporting.

---

### 2️⃣ `gold.dim_products.`

Stores structured product-level information.

**Key Features:**

* Surrogate key (`product_key`)
* Category & subcategory hierarchy
* Product line classification
* Maintenance tracking
* Cost and availability start date

This dimension supports:

* Product performance analysis
* Category-level reporting
* Maintenance-based insights
* Product lifecycle analysis

---

### 3️⃣ `gold.fact_sales.`

Stores transactional sales data.

**Key Metrics:**

* Sales amount
* Quantity
* Unit price
* Order, shipping, and due dates

**Foreign Keys:**

* `product_key` → `dim_products`
* `customer_key` → `dim_customers`

This table enables:

* Revenue analysis
* Customer purchasing behavior insights
* Product performance tracking
* Time-based trend analysis

---

## ⭐ Data Model (Star Schema)

```
https://github.com/makuwajoshua/sql-data-warehouse-project/blob/main/docs/Star%20Schema.drawio.png
              dim_customers
                     |
                     |
dim_products ---- fact_sales
```

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

## 🙏 Acknowledgement

This project was developed as part of my Data Engineering learning journey, inspired and guided by tutorials from **Data With Baraa**, whose structured explanations of modern data warehousing significantly supported the implementation of this architecture.

---

## 🚀 Future Improvements

* Add date dimension table (`dim_date`)
* Implement incremental loading
* Build ETL pipelines
* Connect to the Power BI dashboard
* Add performance indexing strategy
* Automate deployment using CI/CD

---

## 👤 Author

Excellent 👌 — let’s elevate this into a **recruiter-grade, portfolio-level README** that:

* Shows technical depth
* Includes SQL snippets
* Adds architecture clarity
* Demonstrates engineering thinking
* Positions you for Data Engineering / BI roles

Below is your upgraded `README.md`.

---

# 📊 Modern Data Warehouse Project

## Gold Layer – Business-Ready Analytics Model

---

## 🚀 Project Overview

This project implements the **Gold Layer** of a modern data warehouse designed for analytical reporting and business intelligence.

The Gold Layer represents the **business-facing data model**, structured using **dimensional modeling (star schema)** to support:

* BI dashboards
* Revenue reporting
* Customer segmentation
* Product performance analysis
* Time-based trend analytics

This project was developed as part of my SQL Data Engineering & BI journey, guided by structured learning from **Data With Baraa**.

---

# 🏗️ Architecture Overview

The data warehouse follows a **layered architecture approach**:

```
Raw Data → Cleaning/Transformation → Gold Layer (Analytics Model)
```

The **Gold Layer** contains:

* 2 Dimension Tables
* 1 Fact Table
* Surrogate Keys
* Business-aligned naming conventions
* Optimized analytical structure

---

# ⭐ Data Model – Star Schema

```
                 dim_customers
                        |
                        |
dim_products  ------  fact_sales
```

### Central Fact Table:

* `gold.fact_sales`

### Dimension Tables:

* `gold.dim_customers`
* `gold.dim_products`

This design ensures:

* Optimized joins
* Clean separation of descriptive vs transactional data
* Scalable analytical structure
* BI tool compatibility

---

# 📂 Tables & Structure

---

## 🧍 `gold.dim_customers`

Stores demographic and geographic customer data.

### Key Attributes:

* `customer_key` (Surrogate Key)
* `customer_id`
* `country`
* `gender`
* `marital_status`
* `birthdate`
* `create_date`

### Business Use Cases:

* Customer segmentation
* Demographic analysis
* Geographic revenue reporting
* Lifetime value modeling

---

## 🛍️ `gold.dim_products`

Stores product classification and attributes.

### Key Attributes:

* `product_key` (Surrogate Key)
* `category`
* `subcategory`
* `product_line`
* `maintenance_required`
* `cost`
* `start_date`

### Business Use Cases:

* Product category performance
* Maintenance cost insights
* Product lifecycle tracking
* Margin analysis

---

## 💰 `gold.fact_sales`

Stores transactional sales records.

### Key Measures:

* `sales_amount`
* `quantity`
* `price`

### Foreign Keys:

* `product_key`
* `customer_key`

### Business Use Cases:

* Revenue trend analysis
* Sales forecasting inputs
* Order fulfillment performance
* Customer purchase behavior

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

