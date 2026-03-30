IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL
	DROP TABLE bronze.customers;
GO
CREATE TABLE bronze.customers (
	Invoice NVARCHAR(100),
	StockCode NVARCHAR(100),
	Description NVARCHAR(50),
	Quantity INT,
	InvoiceDate DATETIME,
	Price NUMERIC(10,2),
	CustomerID NVARCHAR(50),
	Country NVARCHAR(50)
)