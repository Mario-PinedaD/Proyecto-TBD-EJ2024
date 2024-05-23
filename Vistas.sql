CREATE VIEW status as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 0;

CREATE VIEW direccion as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 1;

CREATE VIEW tipo_lote as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 2;

CREATE VIEW reporte_cargos as
SELECT Clientes.CL_NUMERO as Cliente, Clientes.CL_NOM as Nombre, Clientes.CL_DIREC as Direccion,CARGOS.CAR_FECHA as Fecha, SUM(CARGOS.CAR_IMPORTE) as Cargo_total
    FROM Clientes
    JOIN CARGOS ON Clientes.CL_NUMERO = CARGOS.CL_NUMERO
    GROUP BY Clientes.CL_NUMERO;

CREATE VIEW reporte_lotes as
SELECT Colono_Lote.CL_NUMERO as Cliente, Clientes.CL_NOM as Nombre, Colono_Lote.L_MANZANA as Manzana, Colono_Lote.L_NUMERO as Lote  FROM Colono_Lote
    JOIN Clientes ON Clientes.CL_NUMERO = Colono_Lote.CL_NUMERO
    ORDER BY Nombre;

CREATE VIEW reporte_importe_status as
SELECT Catalogo_COL.CA_DESCRIPCION AS Status,SUM(CARGOS.CAR_IMPORTE) AS Importe_Total FROM Catalogo_COL
    JOIN Lote ON Catalogo_COL.CA_CLAVE = Lote.CA_CLAVE0
    JOIN CARGOS ON Lote.L_MANZANA = CARGOS.L_MANZANA AND Lote.L_NUMERO = CARGOS.L_NUMERO
    GROUP BY Catalogo_COL.CA_TIPO, Catalogo_COL.CA_DESCRIPCION;

CREATE VIEW reporte_cargos_fecha as
SELECT CAR_FECHA as Fecha ,Clientes.CL_NUMERO as Cliente,CAR_IMPORTE as Importe FROM CARGOS
    JOIN Clientes ON Clientes.CL_NUMERO = CARGOS.CL_NUMERO
    ORDER BY Fecha;
DELIMITER $$

CREATE PROCEDURE obtener_reporte_cargos(IN P_FECHA date)
BEGIN
    IF ISNULL(P_FECHA) THEN
        SELECT * FROM reporte_cargos;
    ELSE
        SELECT * FROM reporte_cargos WHERE Fecha = P_FECHA;
    END IF;
END$$

CREATE PROCEDURE obtener_reporte_lotes(IN P_CLIENTE double)
BEGIN
    IF ISNULL(P_CLIENTE) THEN
        SELECT * FROM reporte_lotes;
    ELSE
        SELECT * FROM reporte_lotes WHERE Cliente = P_CLIENTE;
    END IF;
END$$

CREATE PROCEDURE obtener_importe_status()
BEGIN
    SELECT * FROM reporte_importe_status;
END$$

CREATE PROCEDURE obtener_importe_cargos_fecha(IN P_FECHA_INICIO date,IN P_FECHA_FIN date)
BEGIN
    IF ISNULL(P_FECHA_INICIO) OR  isnull(P_FECHA_FIN) THEN
        SELECT * FROM reporte_lotes;
    ELSE
        SELECT * FROM reporte_cargos_fecha WHERE Fecha BETWEEN P_FECHA_INICIO AND P_FECHA_FIN;
    END IF;
END$$

DROP FUNCTION IF EXISTS Existe_Status;
CREATE FUNCTION Existe_Status(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM status
    WHERE status.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DROP FUNCTION IF EXISTS Existe_Direccion;
CREATE FUNCTION Existe_Direccion(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM direccion
    WHERE direccion.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DROP FUNCTION IF EXISTS Existe_TipoLote;
CREATE FUNCTION Existe_TipoLote(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM tipo_lote
    WHERE tipo_lote.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DELIMITER ;