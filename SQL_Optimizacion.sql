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
 
-- Reiterando que forzar el uso de un indice no es una buena idea, exepto en casoa aislados de uso temporal. Siempre es recomendado reescribir una consulta para que se utilice el indice adecuado.