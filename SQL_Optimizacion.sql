-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 09 - Índices pueden perjudicar el rendimiento?
------------------------------------------------------

USE AdventureWorks2019

GO 
-- Activamos las estadísticas
SET STATISTICS IO ON

GO

SELECT SalesOrderDetailID,
	   OrderQty
  FROM Sales.SalesOrderDetail S
 WHERE ProductID = (SELECT AVG(ProductID)
					 FROM Sales.SalesOrderDetail S2
					 WHERE S2.SalesOrderID = S.SalesOrderID
					 GROUP BY SalesOrderID)

-- Se pueden ver los datos y analizar la cantidad e información
-- una pagina pesa 8K. se multiplican los valores para ver el tamaño de la informacion que estamos procesando.

CREATE NONCLUSTERED INDEX IX_PRIMERO
ON Sales.SalesOrderDetail
(SalesOrderID ASC, ProductID ASC)
INCLUDE (SalesOrderDetailID, OrderQty)


CREATE NONCLUSTERED INDEX IX_SEGUNDO
ON Sales.SalesOrderDetail
(ProductID ASC, SalesOrderID ASC)
INCLUDE (SalesOrderDetailID, OrderQty)

-- Ejecutamos los dos indices y vemos que el segundo, donde aparentemente tienen los mismos datos solo que en orden distinto,
-- afecta el rendimiento de la consulta

DROP INDEX IX_PRIMERO ON Sales.SalesOrderDetail
DROP INDEX IX_SEGUNDO ON Sales.SalesOrderDetail
