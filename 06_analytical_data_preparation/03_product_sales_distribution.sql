CREATE VIEW gold.products_analysis AS
	SELECT
		dp.product_key,
		product_description,
		SUM(quantity) AS total_quantity_sold,
		COUNT(DISTINCT invoice_number) AS number_of_orders,
		SUM(gross_sales) AS total_gross_sales,
		SUM(net_sales) AS total_net_sales,
		CAST(SUM(net_sales) / NULLIF(SUM(quantity), 0) AS NUMERIC(10,2)) AS avg_selling_price
	FROM gold.fact_sales_line fs
	INNER JOIN gold.dim_product dp
	ON fs.product_key = dp.product_key
	GROUP BY dp.product_key, product_description
	HAVING product_description != 'Manual'