/*
====================================
Bronze Quality Check
====================================
*/
--Checking for duplicates
--Expected: 0
SELECT
	Invoice,
	StockCode,
	Description,
	Quantity,
	InvoiceDate,
	price,
	CustomerID,
	Country,
	COUNT(*) AS duplicates
FROM bronze.customers
GROUP BY 
	Invoice,
	StockCode,
	Description,
	Quantity,
	InvoiceDate,
	price,
	CustomerID,
	Country
HAVING COUNT(*) > 1;

--Counting NULLs in CustomerID column
--Expected: 0
SELECT
	COUNT(*) AS customer_nulls_count
FROM bronze.customers
WHERE CustomerID IS NULL
;
--Counting NULLS in Invoice column
--Expected: 0
SELECT
	COUNT(*) AS invoice_nulls_count
FROM bronze.customers
WHERE Invoice IS NULL;

--Counting NULLs in StockCode column
--Expected: 0
SELECT
	COUNT(*) AS stockcode_nulls_count
FROM bronze.customers
WHERE StockCode IS NULL;

--Checking for prices = 0
SELECT
	*
FROM bronze.customers
WHERE price = 0
AND
CustomerID IS NOT NULL;

--Checking for extra customer location
SELECT
	CustomerID,
	COUNT(*) AS country_count 
FROM (
	SELECT
		CustomerID,
		Country
	FROM bronze.customers
	GROUP BY CustomerID, Country
) t
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- Checking activity period of the company.
SELECT
	MIN(InvoiceDate) first_invoice_date,
	MAX(InvoiceDate) last_invoice_date,
	DATEDIFF(month, MIN(InvoiceDate), MAX(InvoiceDate)) AS activity_period_in_months
FROM bronze.customers;

-- Checking for multiple product description under one product_id
SELECT
	StockCode,
	COUNT(*) AS product_count
FROM (
	SELECT
		StockCode,
		Description
	FROM bronze.customers
	GROUP BY StockCode, Description
) t
GROUP BY StockCode
HAVING COUNT(*) > 1;

--Checking for multiple timestamps for the same invoice
SELECT
	invoice,
	COUNT(DISTINCT InvoiceDate) AS timestamp_count
FROM bronze.customers
GROUP BY invoice
HAVING COUNT(DISTINCT InvoiceDate) > 1;
-- Checking for time differecne between same invoices
SELECT
	invoice,
	MAX(InvoiceDate) - MIN(InvoiceDate) AS time_diff
FROM bronze.customers
GROUP BY invoice
ORDER BY time_diff DESC;

/*
======================
Silver Quality Check
======================
*/

--Checking for duplicates
--Expected: 0
SELECT
	invoice,
	product_id,
	product_description,
	quantity,
	invoice_date,
	price,
	customer_id,
	location,
	COUNT(*) AS duplicates
FROM silver.customers
GROUP BY 
	invoice,
	product_id,
	product_description,
	quantity,
	invoice_date,
	price,
	customer_id,
	location
HAVING COUNT(*) > 1;

--Counting NULLs in customer_id column
--Expected: 0
SELECT
	COUNT(*) AS customer_nulls_count
FROM silver.customers
WHERE customer_id IS NULL;

-- Checking for time differecne between same invoices
SELECT
	invoice,
	MAX(invoice_date) - MIN(invoice_date) AS time_diff
FROM silver.customers
GROUP BY invoice
ORDER BY time_diff DESC
-- Invoice timestamps originally differed by 1 or 2 minutes within the same invoice.;

/*
=====================
Gold Quality Check
=====================
*/

--Checking for invoices with invalid customer_keys
--Expected: no results
SELECT
	*
FROM gold.fact_sales_line fs
LEFT JOIN gold.dim_customer dc
ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

--Checking for invoices with invalid date_keys
--Expected: no results
SELECT
	*
FROM gold.fact_sales_line fs
LEFT JOIN gold.dim_date dd
ON fs.date_key = dd.date_key
WHERE dd.date_key IS NULL;

--Checking for invoices with invalid product_keys
--Expected: no results
SELECT
	*
FROM gold.fact_sales_line fs
LEFT JOIN gold.dim_product dp
ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;

/*
===========================================================
Checking the correctness of import from the silver layer
===========================================================
*/

--Checking key sums
--Expected: same results in both queries
SELECT
COUNT(*),
SUM(quantity),
SUM(price)
FROM silver.customers;
SELECT
COUNT(*),
SUM(quantity),
SUM(price)
FROM gold.fact_sales_line;

--Checking for duplicates
--Expected: no results
SELECT sales_line_id, COUNT(*)
FROM gold.fact_sales_line
GROUP BY sales_line_id
HAVING COUNT(*) > 1