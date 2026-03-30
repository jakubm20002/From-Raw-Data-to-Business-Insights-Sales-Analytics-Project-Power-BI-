IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
	DROP TABLE silver.customers
GO
CREATE TABLE silver.customers (
	invoice NVARCHAR(50),
	product_id NVARCHAR(50),
	product_description NVARCHAR(100),
	quantity INT,
	invoice_date DATETIME,
	price NUMERIC(10,2),
	customer_id INT,
	location NVARCHAR(50)
)