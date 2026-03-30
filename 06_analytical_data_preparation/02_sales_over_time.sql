CREATE VIEW gold.sales_dynamics AS
	WITH dynamics AS (	
		SELECT
			year_number,
			quarter_number,
			SUM(gross_sales) AS total_gross_sales,
			LAG(SUM(gross_sales)) OVER(ORDER BY year_number, quarter_number) AS previous_quarter_gross_sales,
			SUM(net_sales) AS total_net_sales,
			LAG(SUM(net_sales)) OVER(ORDER BY year_number, quarter_number) AS previous_quarter_net_sales
		FROM gold.fact_sales_line fs
		INNER JOIN gold.dim_date dd
		ON fs.date_key = dd.date_key
		GROUP BY year_number, quarter_number
	)
	SELECT
		year_number,
		quarter_number,
		CONCAT(year_number, '-Q', quarter_number) AS quarter_label,
		total_gross_sales,
		previous_quarter_gross_sales,
		gross_sales_growth,
		CASE
			WHEN gross_sales_growth > 0 THEN 'growth'
			WHEN gross_sales_growth < 0 THEN 'decline'
			ELSE 'no change'
		END AS gross_trend_flag,
		total_net_sales,
		previous_quarter_net_sales,
		net_sales_growth,
		CASE
			WHEN net_sales_growth > 0 THEN 'growth'
			WHEN net_sales_growth < 0 THEN 'decline'
			ELSE 'no change'
		END AS net_trend_flag
	FROM (
		SELECT
			year_number,
			quarter_number,
			total_gross_sales,
			previous_quarter_gross_sales,
			CAST((total_gross_sales - previous_quarter_gross_sales)/previous_quarter_gross_sales AS NUMERIC(10,4)) AS gross_sales_growth,
			total_net_sales,
			previous_quarter_net_sales,
			CAST((total_net_sales - previous_quarter_net_sales)/previous_quarter_net_sales AS NUMERIC(10,4)) AS net_sales_growth
		FROM dynamics
		) t