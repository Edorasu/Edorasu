Insert into USUARIO (Nombres, Apellidos, Correo, Clave) values
('Test NOmbre','Test Apellidos', 'test@example.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')
go

Insert into CATEGORIA (Descripcion) values
('Bebidas')
go

Insert into MARCA (Descripcion) values
('Lovable')
go

Insert into DEPARTAMENTO (IdDepartamento,Descripcion) VALUES
('01','Atlantida'),
('02','Colón'),
('03','Comayagua'),
('04','Copán'),
('05','Cortes'),
('06','Choluteca'),
('07','El Paraíso'),
('08','Francisco Morazan')
GO

Insert into MUNICIPIO (IdMunicipio,Descripcion,IdDepartamento) values
--Atlantidad
('0101','La Ceiba','01'),
('0102','El Porvenir','01'),

--COLÓN
('0201','Trujillo','02'),
('0202','Balfate','02'),

--COMAYAGUA
('0301','Comayagua','03'),
('0302','Ajuterique','03')

go

insert into ALDEA (IdAldea,Descripcion,IdMunicipio,IdDepartamento) values
--LA CEIBA - MUN
('010101','Corozal','0101','01'),
('010102','El Paraíso o Bataca','0101','01'),

--EL PORVENIR - MUN
('010201','El Pino','0102','01'),
('010202','La Ruidosa','0102','01'),

--TRUJILLO - MUN
('020101','Chapagua','0201','02'),
('020102','Colonia Aguán','0201','02'),

--BALFATE - MUN
('020201','Balfate','0202','02'),
('020202','	Arenalosa','0202','02'),

--Comayagua - MUN
('030101','El Guachipilín','0301','03'),
('030102','El Horno','0301','03'),

--AJUTERIQUE - MUN
('030201','	Ajuterique','0302','03'),
('030202','		El Misterio','0302','03')
go

