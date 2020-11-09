-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 07 - Crear Indices, entender plan de ejecucion

USE WideWorldImporters

GO

SET STATISTICS IO ON

SELECT TOP 10000 * 
  FROM Application.People p INNER JOIN 
       Sales.InvoiceLines i ON p.PersonID = i.LastEditedBy INNER JOIN 
       Warehouse.StockItemTransactions s ON p.PersonID = s.LastEditedBy
 ORDER BY i.StockItemID

