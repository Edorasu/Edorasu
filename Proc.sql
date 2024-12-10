--PROC ALMACENADOS

Create proc sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as begin
	SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	BEGIN
		INSERT INTO USUARIO(Nombres, Apellidos,Correo, Clave,Activo) values
		(@Nombres, @Apellidos,@Correo,@Clave,@Activo)

		set @Resultado = SCOPE_IDENTITY()
	END
	ELSE
	 SET @Mensaje = 'El correo del Usuario ya existe'
End

GO

Create proc sp_EditarUsuario(
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output, 
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo and IdUsuario != @IdUsuario)
	BEGIN
		update top (1) USUARIO set
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario

		set @Resultado = 1
	END
	ELSE
	 SET @Mensaje = 'El correo del Usuario ya existe'
End
go

