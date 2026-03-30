TRUNCATE TABLE silver.customers;

INSERT INTO silver.customers (
	invoice,
	product_id,
	product_description,
	quantity,
	invoice_date,
	price,
	customer_id,
	location
)
SELECT DISTINCT
	TRIM(Invoice) AS invoice,
	TRIM(StockCode) AS product_id,
	TRIM(Description) AS product_description,
	Quantity AS quantity,
	MIN(InvoiceDate) OVER(PARTITION BY invoice) AS invoice_date,
	Price AS price,
	LEFT(CustomerID, 5) AS customer_id,
	--This way of fixing this specific column is possible, because every record has same construction and length (7)
	CASE
		WHEN Country = 'USA' THEN 'United States'
		WHEN Country = 'RSA' THEN 'Republic of South Africa'
		WHEN Country = 'EIRE' THEN 'Ireland'
		WHEN Country = 'Korea' THEN 'South Korea'
		WHEN Country = 'Unspecified' THEN 'n/a'
		ELSE TRIM(Country)
	END AS location
FROM bronze.customers
WHERE CustomerID IS NOT NULL

