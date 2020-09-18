-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 20 - Funciones

USE WideWorldImporters

GO

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


SELECT dbo.f_TotalVendidoXProducto(45)