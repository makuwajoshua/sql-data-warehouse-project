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

**Makuwa Makuwa**
Industrial Engineer | Data & BI Enthusiast
Focused on Data Engineering, Analytics Engineering, and Business Intelligence

---
