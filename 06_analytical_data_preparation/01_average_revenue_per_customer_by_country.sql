CREATE VIEW gold.customer_value_by_country AS
	WITH sales_by_country AS (
		SELECT
			location,
			SUM(net_sales) AS total_net_sales,
			SUM(gross_sales) AS total_gross_sales
		FROM gold.fact_sales_line fs
		INNER JOIN gold.dim_customer dc
		ON fs.customer_key = dc.customer_key
		GROUP BY location
	), customers_by_country AS (
		SELECT
			location,
			COUNT(*) AS total_customers
		FROM gold.dim_customer
		GROUP BY location
	)
	SELECT
		sc.location,
		total_net_sales,
		total_gross_sales,
		total_customers,
		CAST(total_net_sales/total_customers AS NUMERIC(10,2)) AS net_sales_by_customer,
		CAST(total_gross_sales/total_customers AS NUMERIC(10,2)) AS gross_sales_by_customer
	FROM sales_by_country sc
	INNER JOIN customers_by_country cc
	ON sc.location = cc.location