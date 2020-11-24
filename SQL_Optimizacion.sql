-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 21 - Procedimientos almacenados
------------------------------------------------------


	SELECT I.StockItemName,
		   dbo.f_TotalVendidoXProducto(I.StockItemID)
	  FROM Warehouse.StockItems I INNER JOIN	
		   Sales.OrderLines O ON I.StockItemID = O.StockItemID
	 WHERE I.StockItemID = 45
	 GROUP BY I.StockItemID,
		   I.StockItemName

CREATE or ALTER PROCEDURE msp_retornaItem(
@StockItemID int,
@StockItemName NVARCHAR(100) output,
@Vendido decimal output
)
AS 
BEGIN

	SELECT @StockItemName = I.StockItemName,
		   @Vendido = dbo.f_TotalVendidoXProducto(I.StockItemID)
	  FROM Warehouse.StockItems I INNER JOIN	
		   Sales.OrderLines O ON I.StockItemID = O.StockItemID
	 WHERE I.StockItemID = @StockItemID
	 GROUP BY I.StockItemID,
		   I.StockItemName

END

GO

CREATE or ALTER PROCEDURE msp_retornaItem01(
@StockItemID int
)
AS 
	SET NOCOUNT ON
BEGIN

	SELECT I.StockItemID ,
		   I.StockItemName,
		   SUM(O.Quantity * O.UnitPrice) as Vendido
	  FROM Warehouse.StockItems I INNER JOIN	
		   Sales.OrderLines O ON I.StockItemID = O.StockItemID
	 WHERE I.StockItemID = @StockItemID
	 GROUP BY I.StockItemID,
		   I.StockItemName

END

exec msp_retornaItem01 45
GO
declare @StockItemName nvarchar(100)
declare @vendido decimal
exec msp_retornaItem 45, @StockItemName output, @vendido output
select @StockItemName, @vendido


-----------------------------------------------
--- Retorna Json or XML

USE Platzi

select * from UsuarioSource
FOR XML AUTO, ELEMENTS,  ROOT('Usuarios')

select * from UsuarioSource
FOR XML PATH('Usuario'), ELEMENTS, ROOT('UsuarioSource')


USE AdventureWorks2012
GO
SELECT Cust.CustomerID,
       OrderHeader.CustomerID,
       OrderHeader.SalesOrderID,
       OrderHeader.Status
FROM Sales.Customer Cust 
INNER JOIN Sales.SalesOrderHeader OrderHeader
ON Cust.CustomerID = OrderHeader.CustomerID
FOR XML PATH('Ordenes'), Root ('OrdenesCliente');



-------------------------
-- Retorna Json

USE AdventureWorks2019

SELECT * FROM Person.Person
WHERE BusinessEntityID = 1
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

SELECT PhoneNumber, PhoneNumberTypeID FROM Person.PersonPhone
WHERE BusinessEntityID = 1

select EmailAddress from Person.EmailAddress
WHERE BusinessEntityID = 1


SELECT BusinessEntityID,
		FirstName,
		LastName
		,
		(SELECT E.EmailAddress,
			    Ph.PhoneNumber
		   FROM Person.EmailAddress E INNER JOIN
			    Person.PersonPhone Ph ON E.BusinessEntityID = P.BusinessEntityID
									 AND E.BusinessEntityID = PH.BusinessEntityID
		  WHERE E.BusinessEntityID = P.BusinessEntityID
		 FOR JSON PATH) [DatosPersonales]
FROM Person.Person P
WHERE BusinessEntityID = 1
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

SET @jsonOutput = 



USE Platzi

SELECT codigo, 
	   nombre as 'usuario.nombre', 
	   puntos as 'usuario.puntos' 
  FROM usuariosource
FOR JSON PATH


, WITHOUT_ARRAY_WRAPPER


-------




USE Platzi

DECLARE @jsonVariable NVARCHAR(MAX);

SET @jsonVariable = N'[
  {
    "Order": {  
      "Number":"SO43659",  
      "Date":"2011-05-31T00:00:00"  
    },  
    "AccountNumber":"AW29825",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":1  
    }  
  },  
  {  
    "Order": {  
      "Number":"SO43661",  
      "Date":"2011-06-01T00:00:00"  
    },  
    "AccountNumber":"AW73565",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":3  
    }  
  }
]';

-- INSERT INTO <sampleTable>  
SELECT SalesOrderJsonData.Number, 
	   SalesOrderJsonData.Customer 
FROM OPENJSON (@jsonVariable, N'$')
  WITH (
    Number VARCHAR(200) N'$.Order.Number',
    Date DATETIME N'$.Order.Date',
    Customer VARCHAR(200) N'$.AccountNumber',
    Quantity INT N'$.Item.Quantity'
  ) AS SalesOrderJsonData
  WHERE SalesOrderJsonData.Number = N'SO43659';



