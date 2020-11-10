-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 14 - Trigger captura de errores



USE [PlatziSQL]
GO
/****** Object:  Trigger [dbo].[t_update]    Script Date: 11/10/2020 12:14:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   TRIGGER [dbo].[t_update] 
   ON  [dbo].[UsuarioTarget]
   AFTER INSERT, UPDATE
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;

	DECLARE @codigo int
	SELECT @codigo = codigo FROM inserted

	IF @codigo = 7
	BEGIN
		Print 'NO se realizó un update'
		ROLLBACK;
		RETURN;
	END
	
	-- SELECT Codigo, Nombre, Puntos from inserted
	
	Print 'Se realizó un update'

END


GO

select * from UsuarioTarget where Codigo = 8
update UsuarioTarget set Nombre = 'Andres Soto' where Codigo = 8
select * from UsuarioTarget where Codigo = 8