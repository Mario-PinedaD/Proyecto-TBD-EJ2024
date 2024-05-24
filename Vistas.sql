DROP VIEW IF EXISTS status;
CREATE VIEW status as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 0;

DROP VIEW IF EXISTS direccion;
CREATE VIEW direccion as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 1;

DROP VIEW IF EXISTS tipo_LOTE;
CREATE VIEW tipo_LOTE as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 2;

DROP VIEW IF EXISTS reporte_cargos;
CREATE VIEW reporte_cargos as
SELECT CLIENTES.CL_NUMERO as Cliente, CLIENTES.CL_NOM as Nombre, CLIENTES.CL_DIREC as Direccion,CARGOS.CAR_FECHA as Fecha, SUM(CARGOS.CAR_IMPORTE) as Cargo_total
    FROM CLIENTES
    JOIN CARGOS ON CLIENTES.CL_NUMERO = CARGOS.CL_NUMERO
    GROUP BY CLIENTES.CL_NUMERO;

DROP VIEW IF EXISTS reporte_LOTEs;
CREATE VIEW reporte_LOTEs as
SELECT COLONO_LOTE.CL_NUMERO as Cliente, CLIENTES.CL_NOM as Nombre, COLONO_LOTE.L_MANZANA as Manzana, COLONO_LOTE.L_NUMERO as LOTE  FROM COLONO_LOTE
    JOIN CLIENTES ON CLIENTES.CL_NUMERO = COLONO_LOTE.CL_NUMERO
    ORDER BY Nombre;

DROP VIEW IF EXISTS reporte_importe_status;
CREATE VIEW reporte_importe_status as
SELECT CATALOGO_COL.CA_DESCRIPCION AS Status,SUM(CARGOS.CAR_IMPORTE) AS Importe_Total FROM CATALOGO_COL
    JOIN LOTE ON CATALOGO_COL.CA_CLAVE = LOTE.CA_CLAVE0
    JOIN CARGOS ON LOTE.L_MANZANA = CARGOS.L_MANZANA AND LOTE.L_NUMERO = CARGOS.L_NUMERO
    GROUP BY CATALOGO_COL.CA_TIPO, CATALOGO_COL.CA_DESCRIPCION;

DROP VIEW IF EXISTS reporte_cargos_fecha;
CREATE VIEW reporte_cargos_fecha as
SELECT CAR_FECHA as Fecha ,CLIENTES.CL_NUMERO as Cliente,CAR_IMPORTE as Importe FROM CARGOS
    JOIN CLIENTES ON CLIENTES.CL_NUMERO = CARGOS.CL_NUMERO
    ORDER BY Fecha;
DELIMITER $$

DROP PROCEDURE IF EXISTS obtener_reporte_cargos;
CREATE PROCEDURE obtener_reporte_cargos(IN P_FECHA date)
BEGIN
    IF ISNULL(P_FECHA) THEN
        SELECT * FROM reporte_cargos;
    ELSE
        SELECT * FROM reporte_cargos WHERE Fecha = P_FECHA;
    END IF;
END$$

DROP PROCEDURE IF EXISTS obtener_reporte_LOTEs;
CREATE PROCEDURE obtener_reporte_LOTEs(IN P_CLIENTE double)
BEGIN
    IF ISNULL(P_CLIENTE) THEN
        SELECT * FROM reporte_LOTEs;
    ELSE
        SELECT * FROM reporte_LOTEs WHERE Cliente = P_CLIENTE;
    END IF;
END$$

DROP PROCEDURE IF EXISTS obtener_importe_status;
CREATE PROCEDURE obtener_importe_status()
BEGIN
    SELECT * FROM reporte_importe_status;
END$$

DROP PROCEDURE IF EXISTS obtener_importe_cargos_fecha;
CREATE PROCEDURE obtener_importe_cargos_fecha(IN P_FECHA_INICIO date,IN P_FECHA_FIN date)
BEGIN
    IF ISNULL(P_FECHA_INICIO) OR  isnull(P_FECHA_FIN) THEN
        SELECT * FROM reporte_LOTEs;
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

DROP FUNCTION IF EXISTS Existe_TipoLOTE;
CREATE FUNCTION Existe_TipoLOTE(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM tipo_LOTE
    WHERE tipo_LOTE.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DELIMITER ;