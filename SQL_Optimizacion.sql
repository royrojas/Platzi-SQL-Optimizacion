-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 08 - Forzar Indices
------------------------------------------------------

USE WideWorldImporters

GO

SET STATISTICS IO ON

-- En este ejemplo indicamos que queremos utulizar el índice FK_Sales_Invoices_AccountsPersonID

SELECT *
FROM [WideWorldImporters].[Sales].[Invoices]
WITH(INDEX([FK_Sales_Invoices_AccountsPersonID]))
WHERE CustomerID = 191
 
-- Reiterando que forzar el uso de un indice NO es una buena idea, exepto en casos aislados de uso temporal. 
-- Imaginemos una migracion o una carga especial de datos donde queremos que los datos se comporten de una forma en específico.
-- Siempre es recomendado reescribir una consulta para que se utilice el indice adecuado.