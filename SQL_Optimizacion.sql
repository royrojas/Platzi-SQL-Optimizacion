-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 08 - Forzar Indices

USE WideWorldImporters

GO

SET STATISTICS IO ON

SELECT *
FROM [WideWorldImporters].[Sales].[Invoices]
WITH(INDEX([FK_Sales_Invoices_AccountsPersonID]))
WHERE CustomerID = 191