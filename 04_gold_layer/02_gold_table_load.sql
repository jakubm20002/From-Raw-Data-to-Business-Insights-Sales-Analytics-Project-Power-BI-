TRUNCATE TABLE gold.dim_customer;

INSERT INTO gold.dim_customer (
	customer_key,
	customer_id,
	location
)
SELECT
	ROW_NUMBER() OVER(ORDER BY customer_id, location) AS customer_key,
	customer_id,
	location
FROM silver.customers
GROUP BY customer_id, location;

TRUNCATE TABLE gold.dim_date;

INSERT INTO gold.dim_date (
	date_key,
	date,
	year_number,
	quarter_number,
	month_number,
	week_number,
	weekday_name
)
SELECT
	ROW_NUMBER() OVER (ORDER BY invoice_date) AS date_key,
	invoice_date AS date,
	year_number,
	quarter_number,
	month_number,
	week_number,
	weekday_name
FROM (
	SELECT
		DISTINCT invoice_date,
		DATEPART(year, invoice_date) AS year_number,
		DATEPART(quarter, invoice_date) AS quarter_number,
		DATEPART(month, invoice_date) AS month_number,
		DATEPART(week, invoice_date) AS week_number,
		DATENAME(weekday, invoice_date) AS weekday_name
	FROM silver.customers
) t;

TRUNCATE TABLE gold.dim_product;

INSERT INTO gold.dim_product (
	product_key,
	product_id,
	product_description,
	product_type
)
SELECT
	ROW_NUMBER() OVER(ORDER BY product_id) AS product_key,
	product_id,
	product_description,
	CASE
		WHEN product_id IN('POST', 'BANK CHARGES', 'D', 'C2', 'DOT', 'CRUK') THEN 'Service'
		ELSE 'Product'
	END AS product_type
FROM silver.customers
GROUP BY product_id, product_description;

TRUNCATE TABLE gold.fact_sales_line;

INSERT INTO gold.fact_sales_line (
	sales_line_id,
	invoice_number,
	product_key,
	customer_key,
	date_key,
	quantity,
	price,
	gross_sales,
	net_sales
)
SELECT
	ROW_NUMBER() OVER (ORDER BY sc.invoice) AS sales_line_id,
	sc.invoice AS invoice_number,
	dp.product_key,
	dc.customer_key,
	dd.date_key,
	sc.quantity,
	sc.price,
	CASE
		WHEN quantity < 0 THEN '0'
		ELSE price * quantity
	END AS gross_sales,
	price * quantity AS net_sales
FROM silver.customers sc
INNER JOIN gold.dim_customer dc
ON sc.customer_id = dc.customer_id AND sc.location = dc.location
INNER JOIN gold.dim_product dp
ON sc.product_id = dp.product_id AND sc.product_description = dp.product_description
INNER JOIN gold.dim_date dd
ON sc.invoice_date = dd.date