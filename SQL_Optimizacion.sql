-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 05 - Introducción Planes de Ejecución

USE WideWorldImporters

GO

SET STATISTICS IO ON

GO

SELECT TOP 10000 * 
  FROM Application.People p INNER JOIN 
       Sales.InvoiceLines i ON p.PersonID = i.LastEditedBy INNER JOIN 
       Warehouse.StockItemTransactions s ON p.PersonID = s.LastEditedBy
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

GO

SELECT * FROM Purchasing.PurchaseOrders


-- Para desplegar pantalla
-- TOOLS \ OPTIONS \ Query Results \ SQL Server \ Result to Grid



SET STATISTICS IO ON

SELECT (SELECT MAX([OrderDate])
FROM [Sales].[Orders]) mx,
(SELECT
MIN([BackorderOrderID])
FROM [Sales].[Orders]) mn;

GO

SELECT MAX([OrderDate]) mx,
MIN([BackorderOrderID]) mn
FROM [Sales].[Orders];