-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 20 - Funciones

USE WideWorldImporters

GO

SELECT I.StockItemID,
	   I.StockItemName,
	   SUM(O.Quantity * O.UnitPrice) as Vendido
  FROM Warehouse.StockItems I INNER JOIN	
	   Sales.OrderLines O ON I.StockItemID = O.StockItemID
 WHERE I.StockItemID = 45
 GROUP BY I.StockItemID,
	   I.StockItemName
GO
SELECT I.StockItemID,
	   I.StockItemName,
	   dbo.f_TotalVendidoXProducto(I.StockItemID) as Vendido
  FROM Warehouse.StockItems I
 WHERE I.StockItemID = 45

 GO
 
-- Funcion con retorno de un valor
CREATE FUNCTION f_TotalVendidoXProducto
(
	@StockItemID int
)
RETURNS decimal
AS
BEGIN

	DECLARE @total decimal

	SELECT @total = SUM(Quantity * UnitPrice)
	  FROM  Sales.OrderLines
	 WHERE StockItemID = @StockItemID

	RETURN @total

END

GO

SELECT dbo.f_TotalVendidoXProducto(45)

GO
