BULK INSERT bronze.customers
FROM 'C:\Pliki CSV\online_retail_II.csv'
WITH (
	FORMAT = 'CSV',
-- Ensures proper parsing of quoted fields and delimiters inside values

	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
-- Specifies line break format (LF) used in the source file
	
	TABLOCK
)