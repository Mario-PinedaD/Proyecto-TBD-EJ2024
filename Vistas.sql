CREATE VIEW status as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 0;

CREATE VIEW direccion as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 1;

CREATE VIEW tipo_lote as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 2;


-- Esta vista se usa para la primera consulta personalizada
CREATE VIEW reporte_cargos
SELECT Clientes.CL_NUMERO as Cliente, Clientes.CL_NOM as Nombre, Clientes.CL_DIREC as Direccion, SUM(CARGOS.CAR_IMPORTE) as Cargo_total
    FROM Clientes
    JOIN CARGOS ON Clientes.CL_NUMERO = CARGOS.CL_NUMERO
    GROUP BY Clientes.CL_NUMERO;

CREATE VIEW reporte_lotes
SELECT Colono_Lote.CL_NUMERO as Cliente, Clientes.CL_NOM as Nombre, Colono_Lote.L_MANZANA as Manzana, Colono_Lote.L_NUMERO as Lote  FROM Colono_Lote
    JOIN Clientes ON Clientes.CL_NUMERO = Colono_Lote.CL_NUMERO
    ORDER BY Nombre;

CREATE VIEW reporte_cargos_fecha
SELECT CAR_FECHA as Fecha ,Clientes.CL_NUMERO as Cliente,CAR_IMPORTE as Importe FROM CARGOS
    JOIN Clientes ON Clientes.CL_NUMERO = CARGOS.CL_NUMERO;

SELECT L_MANZANA,L_NUMERO,Lote.L_IMPORTE FROM Lote where Lote.L_IMPORTE != 0 LIMIT 100;