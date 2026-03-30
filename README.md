# From-Raw-Data-to-Business-Insights-Sales-Analytics-Project-Power-BI

**1. Project Overview**

This project walks through a complete analytical process - starting from a raw CSV file and ending with a business-ready dashboard.
The original dataset was reshaped from a single table into a structured model that 	separates transactional data from descriptive attributes.
This made the analysis more transparent and easier to work with, ultimately enabling the 	creation of an interactive dashboard.
The final output focuses on clear, business-oriented insights and recommendations, helping 	identify trends, key drivers, and potential areas for further analysis.

**2. Architecture (Bronze, Silver, Gold Layers)**

To prepare data for dashboard use, the Medallion architecture was implemented. 

Bronze Layer – database and schemas were created in this layer as the first step of the 	project. During data import, additional configurations were required to ensure the 	import was correct (see SQL script for implementation details: "bronze_table_load" file).
	
Silver Layer – main purpose of this layer was to clean and standardize data. 

Key transformations:
- removed missing customer IDs  
- standardized invoice dates  

<details>
<summary>Show full list of cleaning decisions</summary>

The main elements interfering with the data:
  - records with missing customer identifiers were removed, as they represent incomplete transactions and cannot be used in customer-based analysis;
  - invoice dates were standardized by selecting the earliest available date per invoice, treating it as the reference point for when the transaction was initiated.

Elements that were intentionally left unchanged:
  - negative values in quantity columns – they represent customer returns and further in the project there is distinction between total sales which includes customers returns (net sales) and those which are not (gross sales)
  - unorthodox product id's, their presence do not interfere with overall analyses as such IDs are often present in real-life businesses;
  - prices equal to 0, their overall quantity does not affect the analyses in significant form, their presence can indicate that in some cases products with those prices were treated as discounts or promotions;
  - some customers appear with more than one country, this shows that they have multiple delivery addresses rather than inconsistent customer records;
  - several product IDs are assigned to more than one product description, this inconsistency is caused by changes in product descriptions which often happens in real-life businesses.
Additionally, several location names were corrected to present same form with the rest of the locations (UK = United Kingdom).


</details>

Gold Layer - transforms data into a star schema (fact and dimensional tables) and creates business-ready model optimized for analytical queries. 
<details>
  <summary>Show full description</summary>
Originally gold layer was	meant to be represented by views but due to optimization issues (too much time to execute queries in analytic section) they were replaced with actual tables. The dimensional tables were designed in a way, that every table combined with table of facts (measures), provided information about different business area.
</details>

**3. Data Modelling**
	
Star schema – three dimensional tables (customers, dates, products) provides descriptive 	information about business and they each connect to the fact table that consists measurable 	data. This kind of approach allows to conduct analyses in an efficient and more structured 	form.
These tables were each presented with their own surrogate keys, to make future analyses 	more convenient and more suitable for modifications.

**4. Data Quality Checks**
	
Bronze Quality Check – detects every flaw that original dataset possesses but do not fix 	them (see SQL script for details: "quality_checks" file).

Silver Quality Check - validates the repair of inconsistent data found in the bronze layer.

Gold Quality Check – checking the correctness of data import from the silver layer and 	validates joining of newly created tables by their surrogate keys.
	
**5. Business Questions & Insights**

Sales over Time

**How do sales change over time and are there any trends to notice?**
	
The dashboard shows total gross and net sales over time alongside quarter-over-quarter 	dynamics. 
	
Key observations:
  - overall, sales show upward trend;
  - there is only one case of sales decline;
  - the highest sales period repeats itself in the same quarter;
  - growth is not consistent.

Sales by Country

**How is revenue distributed between countries and which customers generate most 	revenue per client?**
	
This dashboard shows average sales per customer by country and overall sales in each 	country.

Key observations:
  - most revenue is concentrated in a single country;
  - the highest revenue per customer is generated outside the primary market.

Product Sales Distribution
	
**Which products generate the most revenue and how do volume, revenue, and order 	frequency relate to each other?**
	
This dashboard presents distribution of revenue and volume sold per product.

Key observations:
  - the top two products generate roughly twice as much revenue as the next product; 
  - most products are tightly clustered in terms of relationship between revenue and quantity, indicating no major deviations from the general trend;
  - only a small number of products deviate from this trend;
  - the distribution of product quantities is relatively even, with no clear dominant product.

**6. Dashboard**
Download the full interactive dashboard here:
[01_sales_analytics_report.pbix](07_dashboard_overview/01_sales_analytics_report.pbix)

<img width="600" height="442" alt="Zrzut ekranu 2026-03-30 084915" src="https://github.com/user-attachments/assets/8ee5c485-5929-42a7-9516-6fa9fe2819ee" />

<img width="600" height="442" alt="image" src="https://github.com/user-attachments/assets/7cefc925-4189-45d5-8e9e-8b4c8971c814" />

<img width="600" height="442" alt="image" src="https://github.com/user-attachments/assets/863f3579-d15d-41f5-9a7a-e20d0d634ef7" />


**7. Key Insights**

  - The analyzed period, despite its short time frame, may indicate a clear seasonality in sales.
  - The company focuses mainly on domestic sales, but the most valuable customers are foreign ones.
  - Despite its distinctive individual products, the company does not have any that would generate a large portion of revenues on its own. The company is highly diversified in terms of products.

**8. Recommendations**

Analyzing a longer period of company's operations could be useful in confirming (or denying) the existence of a clear seasonality in sales.
If confirmed, it would be worth analyzing the balance of revenues and costs in order to optimize profits in periods of falling sales.
It's worth analyzing the sales conditions among customers who generate the highest revenue per customer. It may turn out that our company had a real impact on the value of their orders during contact with these customers.

**9. Project Structure**

- 01_database_setup
- 02_bronze_layer
- 03_silver_layer
- 04_gold_layer
- 05_quality_checks
- 06_analytical-data_preparation
- 07_dashboard_overview
  
**10. Tools**
  - Power BI
  - SQL (SQL Server)
  - CSV files
