USE WideWorldImporters

GO

SELECT TOP 10000 * FROM Application.People p
INNER JOIN Sales.InvoiceLines i ON p.PersonID = i.LastEditedBy
INNER JOIN Warehouse.StockItemTransactions s ON p.PersonID = s.LastEditedBy
ORDER BY i.StockItemID

GO

SELECT *
FROM Sales.Invoices
--WITH(INDEX([FK_Sales_Invoices_AccountsPersonID]))
WHERE CustomerID = 191

GO

SELECT * FROM Warehouse.VehicleTemperatures

GO

SELECT * FROM Sales.InvoiceLines

GO

SELECT * FROM Sales.Invoices WHERE OrderID = 100


-- Para desplegar pantalla
-- TOOLS \ OPTIONS \ Query Results \ SQL Server \ Result to Grid
