CREATE TABLE gold.fact_sales_line (
	sales_line_id INT,
	invoice_number NVARCHAR(50),
	product_key INT,
	customer_key INT,
	date_key INT,
	quantity INT,
	price NUMERIC(10,2),
	gross_sales NUMERIC(10,2),
	net_sales NUMERIC(10,2)
);

CREATE TABLE gold.dim_customer (
	customer_key INT,
	customer_id INT,
	location VARCHAR(50)
);

CREATE TABLE gold.dim_date (
	date_key INT,
	date DATETIME,
	year_number INT,
	quarter_number INT,
	month_number INT,
	week_number INT,
	weekday_name VARCHAR(50)
);

CREATE TABLE gold.dim_product (
	product_key INT,
	product_id NVARCHAR(50),
	product_description NVARCHAR(100),
	product_type VARCHAR(50)
)