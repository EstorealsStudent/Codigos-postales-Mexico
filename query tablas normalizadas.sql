CREATE DATABASE TuBaseDeDatos
COLLATE Latin1_General_CI_AI;

use TuBaseDeDatos

drop database TuBaseDeDatos

CREATE TABLE codigospostaless (
  d_codigo NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_asenta NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_tipo_asenta NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    D_mnpio NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_estado NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_ciudad NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_CP NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_estado NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_oficina NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_CP NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_tipo_asenta NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_mnpio NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    id_asenta_cpcons NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    d_zona NVARCHAR(255) COLLATE Latin1_General_CI_AI,
    c_cve_ciudad NVARCHAR(255) COLLATE Latin1_General_CI_AI
) ;
-- Cargar datos desde el archivo de texto
BULK INSERT codigospostales
FROM 'C:\Users\estor\Downloads\CPdescarga.txt'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- 65001 es el código de página para UTF-8
)


select*from TuBaseDeDatos

drop table codigospostaless

-- Crear tabla cat_estados
CREATE TABLE cat_estados (
  idestado tinyint NOT NULL,
  estado varchar(31) COLLATE Latin1_General_BIN NOT NULL,
  PRIMARY KEY (idestado)
);

-- Crear tabla cat_municipios
CREATE TABLE cat_municipios (
  idmunicipio int NOT NULL,
  idestado tinyint NOT NULL,
  municipio varchar(49) COLLATE Latin1_General_BIN NOT NULL,
  PRIMARY KEY (idmunicipio),
  CONSTRAINT fk_cat_municipios_cat_estados1 FOREIGN KEY (idestado) REFERENCES cat_estados (idestado)
);
drop table cat_municipios

-- Crear tabla cat_cp
CREATE TABLE cat_cp (
  idcp int NOT NULL,
  idmunicipio int NOT NULL,
  idestado tinyint NOT NULL,
  cp smallint NOT NULL,
  colonia varchar(60) COLLATE Latin1_General_BIN NOT NULL,
  PRIMARY KEY (idcp),
  CONSTRAINT fk_cat_cp_cat_estados1 FOREIGN KEY (idestado) REFERENCES cat_estados (idestado),
  CONSTRAINT fk_cat_cp_cat_municipios1 FOREIGN KEY (idmunicipio) REFERENCES cat_municipios (idmunicipio)
);
--llenar estados
insert into cat_estados(estado)
select  distinct d_estado from codigospostales
  --llenar municipios
insert into cat_municipios (idestado,[cve],municipio)
select  distinct c_estado,c_mnpio,D_mnpio
  from codigospostales
  go
  select * from [dbo].[cat_municipios]

  --llenar tabla codigos postales
  insert into [dbo].[cat_cp]([idmunicipio],[cp],[colonia])
select [idmunicipio],[d_codigo],[d_asenta] from codigospostales
join[dbo].[cat_municipios] on [c_estado]=[idestado] and [c_mnpio]=[cve]

select* from cat_cp

