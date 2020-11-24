-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 13 - Trigger, qué es? como funciona?
------------------------------------------------------


CREATE OR ALTER TRIGGER t_insert 
   ON  UsuarioTarget
   AFTER INSERT
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;

	select Codigo, Nombre, Puntos from inserted

	Print 'Se realizó un insert'

END

GO

CREATE OR ALTER TRIGGER t_update 
   ON  UsuarioTarget
   AFTER UPDATE
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;
	
	select Codigo, Nombre, Puntos from inserted
	
	Print 'Se realizó un update'

END
GO

insert into UsuarioTarget values(11, 'Maria', 15)
update UsuarioTarget set Nombre = 'Carlos Soto Soto' where Codigo = 8

-- Podriamos tener un trigger que cuando se ingrese una venta, nos recalcule los valores de la tabla de inventario

--
