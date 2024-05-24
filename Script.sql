SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

DROP VIEW IF EXISTS STATUS$$
CREATE VIEW STATUS as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 0$$

DROP VIEW IF EXISTS DIRECCION$$
CREATE VIEW DIRECCION as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 1$$

DROP VIEW IF EXISTS TIPO_LOTE$$
CREATE VIEW TIPO_LOTE as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM CATALOGO_COL WHERE CA_TIPO = 2$$

DROP VIEW IF EXISTS REPORTE_CARGOS$$
CREATE VIEW REPORTE_CARGOS as
SELECT CLIENTES.CL_NUMERO as Cliente, CLIENTES.CL_NOM as Nombre, CLIENTES.CL_DIREC as Direccion,CARGOS.CAR_FECHA as Fecha, SUM(CARGOS.CAR_IMPORTE) as Cargo_total
    FROM CLIENTES
    JOIN CARGOS ON CLIENTES.CL_NUMERO = CARGOS.CL_NUMERO
    GROUP BY CLIENTES.CL_NUMERO$$

DROP VIEW IF EXISTS REPORTE_LOTES$$
CREATE VIEW REPORTE_LOTES as
SELECT COLONO_LOTE.CL_NUMERO as Cliente, CLIENTES.CL_NOM as Nombre, COLONO_LOTE.L_MANZANA as Manzana, COLONO_LOTE.L_NUMERO as LOTE  FROM COLONO_LOTE
    JOIN CLIENTES ON CLIENTES.CL_NUMERO = COLONO_LOTE.CL_NUMERO
    ORDER BY Nombre$$

DROP VIEW IF EXISTS REPORTE_IMPORTE_STATUS$$
CREATE VIEW REPORTE_IMPORTE_STATUS as
SELECT CATALOGO_COL.CA_DESCRIPCION AS Status,SUM(CARGOS.CAR_IMPORTE) AS Importe_Total FROM CATALOGO_COL
    JOIN LOTE ON CATALOGO_COL.CA_CLAVE = LOTE.CA_CLAVE0
    JOIN CARGOS ON LOTE.L_MANZANA = CARGOS.L_MANZANA AND LOTE.L_NUMERO = CARGOS.L_NUMERO
    GROUP BY CATALOGO_COL.CA_TIPO, CATALOGO_COL.CA_DESCRIPCION$$

DROP VIEW IF EXISTS REPORTE_CARGOS_FECHA$$
CREATE VIEW REPORTE_CARGOS_FECHA as
SELECT CAR_FECHA as Fecha ,CLIENTES.CL_NUMERO as Cliente,CAR_IMPORTE as Importe FROM CARGOS
    JOIN CLIENTES ON CLIENTES.CL_NUMERO = CARGOS.CL_NUMERO
    ORDER BY Fecha$$

DROP PROCEDURE IF EXISTS OBTENER_REPORTE_CARGOS$$
CREATE PROCEDURE OBTENER_REPORTE_CARGOS(IN P_FECHA date)
BEGIN
    IF ISNULL(P_FECHA) THEN
        SELECT * FROM REPORTE_CARGOS;
    ELSE
        SELECT * FROM REPORTE_CARGOS WHERE Fecha = P_FECHA;
    END IF;
END$$

DROP PROCEDURE IF EXISTS OBTENER_REPORTE_CARGOS$$
CREATE PROCEDURE OBTENER_REPORTE_CARGOS(IN P_CLIENTE double)
BEGIN
    IF ISNULL(P_CLIENTE) THEN
        SELECT * FROM REPORTE_LOTES;
    ELSE
        SELECT * FROM REPORTE_LOTES WHERE Cliente = P_CLIENTE;
    END IF;
END$$

DROP PROCEDURE IF EXISTS OBTENER_IMPORTE_STATUS$$
CREATE PROCEDURE OBTENER_IMPORTE_STATUS()
BEGIN
    SELECT * FROM REPORTE_IMPORTE_STATUS;
END$$

DROP PROCEDURE IF EXISTS OBTENER_IMPORTE_CARGOS_FECHA$$
CREATE PROCEDURE OBTENER_IMPORTE_CARGOS_FECHA(IN P_FECHA_INICIO date,IN P_FECHA_FIN date)
BEGIN
    IF ISNULL(P_FECHA_INICIO) OR  isnull(P_FECHA_FIN) THEN
        SELECT * FROM REPORTE_LOTES;
    ELSE
        SELECT * FROM REPORTE_CARGOS_FECHA WHERE Fecha BETWEEN P_FECHA_INICIO AND P_FECHA_FIN;
    END IF;
END$$

DROP FUNCTION IF EXISTS EXISTE_STATUS$$
CREATE FUNCTION EXISTE_STATUS(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM STATUS
    WHERE STATUS.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DROP FUNCTION IF EXISTS EXISTE_DIRECCION$$
CREATE FUNCTION EXISTE_DIRECCION(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM DIRECCION
    WHERE DIRECCION.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

DROP FUNCTION IF EXISTS EXISTE_TIPO_LOTE$$
CREATE FUNCTION EXISTE_TIPO_LOTE(clave_catalogo CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM TIPO_LOTE
    WHERE TIPO_LOTE.clave_catalogo = clave_catalogo;
    RETURN existe;
END$$

-- ----------------------------------------------------------------------

-- Función para verificar la existencia de un registro en Catalogo_COL
DELIMITER $$

DROP FUNCTION IF EXISTS Existe_CATALOGO_COL $$

CREATE FUNCTION Existe_CATALOGO_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM CATALOGO_COL
    WHERE CA_CLAVE = CATALOGO_COL.CA_CLAVE;
    RETURN existe;
END $$

-- Trigger antes de insertar en Catalogo_COL
DROP TRIGGER IF EXISTS Antes_Insertar_CATALOGO_COL $$

CREATE TRIGGER Antes_Insertar_CATALOGO_COL
BEFORE INSERT ON CATALOGO_COL
FOR EACH ROW
BEGIN
    IF Existe_CATALOGO_COL(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Catalogo_COL';
    END IF;
END $$

-- Trigger antes de actualizar en Catalogo_COL
DROP TRIGGER IF EXISTS Antes_Actualizar_CATALOGO_COL $$
CREATE TRIGGER Antes_Actualizar_CATALOGO_COL
BEFORE UPDATE ON CATALOGO_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_CATALOGO_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END $$

-- Trigger antes de eliminar en Catalogo_COL
DROP TRIGGER IF EXISTS Antes_Eliminar_CATALOGO_COL $$
CREATE TRIGGER Antes_Eliminar_CATALOGO_COL
BEFORE DELETE ON CATALOGO_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_CATALOGO_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Catalogo_COL
DROP FUNCTION IF EXISTS TieneReferencias_CATALOGO_COL $$

CREATE FUNCTION TieneReferencias_CATALOGO_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM LOTE
    WHERE CA_CLAVE = LOTE.CA_CLAVE0 or CA_CLAVE = LOTE.CA_CLAVE1 or CA_CLAVE = LOTE.CA_CLAVE2;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Catalogo_COL que verifica referencias en tablas hijas
DROP TRIGGER IF EXISTS Antes_Eliminar_CATALOGO_COL_Ref $$
CREATE TRIGGER Antes_Eliminar_CATALOGO_COL_Ref
BEFORE DELETE ON CATALOGO_COL
FOR EACH ROW
BEGIN
    IF TieneReferencias_CATALOGO_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Catalogo_COL
DROP PROCEDURE IF EXISTS Insertar_CATALOGO_COL $$

CREATE PROCEDURE Insertar_CATALOGO_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO SMALLINT,
    IN p_CA_IMPORTE DOUBLE,
    IN p_CON_CLAVE SMALLINT(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_CA_CLAVE IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='La clave no puede ser null';
    ELSE
    -- Intentar la inserción
    INSERT INTO CATALOGO_COL (
        CA_CLAVE, CA_DESCRIPCION, CA_TIPO, CA_IMPORTE, CON_CLAVE
    ) VALUES (
        p_CA_CLAVE, p_CA_DESCRIPCION, p_CA_TIPO,p_CA_IMPORTE,p_CON_CLAVE
    );
    END IF;
END $$

-- Procedimiento almacenado para eliminar en Catalogo_COL
DROP PROCEDURE IF EXISTS Eliminar_CATALOGO_COL $$

CREATE PROCEDURE Eliminar_CATALOGO_COL(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    IF p_CA_CLAVE IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='La clave no puede ser null';
    ELSE
        DELETE FROM CATALOGO_COL WHERE CA_CLAVE = p_CA_CLAVE;
    END IF;
END $$

-- Procedimiento almacenado para buscar en Catalogo_COL
DROP PROCEDURE IF EXISTS Buscar_CATALOGO_COL $$

CREATE PROCEDURE Buscar_CATALOGO_COL(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipos de datos
    IF p_CA_CLAVE IS NULL THEN
        SELECT * FROM CATALOGO_COL;
    ELSE
        IF Existe_CATALOGO_COL(p_CA_CLAVE) THEN
            SELECT * FROM CATALOGO_COL WHERE CA_CLAVE = p_CA_CLAVE;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Catalogo_COL
DROP PROCEDURE IF EXISTS Actualizar_CATALOGO_COL $$

CREATE PROCEDURE Actualizar_CATALOGO_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO SMALLINT,
    IN p_CA_IMPORTE DOUBLE,
    IN p_CON_CLAVE SMALLINT(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_CA_CLAVE IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='La clave no puede ser null';
    ELSE
    -- Intentar la actualización
    UPDATE CATALOGO_COL
    SET
        CA_DESCRIPCION = p_CA_DESCRIPCION,
        CA_TIPO = p_CA_TIPO,
        CA_IMPORTE = p_CA_IMPORTE,
        CON_CLAVE = p_CON_CLAVE
    WHERE CA_CLAVE = p_CA_CLAVE;
  END IF;
END $$

-- ------------------------------------------------------------------------------

-- Función para verificar si existe un registro en Clientes
DROP FUNCTION IF EXISTS Existe_CLIENTES $$

CREATE FUNCTION Existe_CLIENTES(p_CL_NUMERO DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM CLIENTES
    WHERE CL_NUMERO = p_CL_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en Clientes que verifica duplicados
DROP TRIGGER IF EXISTS Antes_Insertar_CLIENTES $$

CREATE TRIGGER Antes_Insertar_CLIENTES
BEFORE INSERT ON CLIENTES
FOR EACH ROW
BEGIN
    IF Existe_CLIENTES(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Clientes';
    END IF;
END $$

-- Trigger antes de actualizar en Clientes que verifica la existencia del registro
DROP TRIGGER IF EXISTS Antes_Actualizar_CLIENTES $$

CREATE TRIGGER Antes_Actualizar_CLIENTES
BEFORE UPDATE ON CLIENTES
FOR EACH ROW
BEGIN
    IF NOT Existe_CLIENTES(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Clientes';
    END IF;
END $$

-- Trigger antes de borrar en Clientes que verifica la existencia del registro
DROP TRIGGER IF EXISTS Antes_Eliminar_CLIENTES $$

CREATE TRIGGER Antes_Eliminar_CLIENTES
BEFORE DELETE ON CLIENTES
FOR EACH ROW
BEGIN
    IF NOT Existe_CLIENTES(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Clientes';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Clientes
DROP FUNCTION IF EXISTS TieneReferencias_CLIENTES $$

CREATE FUNCTION TieneReferencias_CLIENTES(CL_NUMERO DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM COLONO_LOTE
    WHERE COLONO_LOTE.CL_NUMERO = CL_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Clientes que verifica referencias en tablas hijas
DROP TRIGGER IF EXISTS Antes_Eliminar_CLIENTES_Ref $$

CREATE TRIGGER Antes_Eliminar_CLIENTES_Ref
BEFORE DELETE ON CLIENTES
FOR EACH ROW
BEGIN
    IF TieneReferencias_CLIENTES(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Clientes
DROP PROCEDURE IF EXISTS Insertar_CLIENTES $$

CREATE PROCEDURE Insertar_CLIENTES(
    IN p_CL_NUMERO DOUBLE,
    IN p_CL_TERR SMALLINT,
    IN p_CL_NOM CHAR(200),
    IN p_CL_CONT CHAR(200),
    IN p_CL_DIREC CHAR(100),
    IN p_CL_CIUD CHAR(50),
    IN p_CL_COLONIA CHAR(100),
    IN p_CL_CP FLOAT,
    IN p_CL_LADA FLOAT,
    IN p_CL_TELEF CHAR(50),
    IN p_CL_DSCTO FLOAT,
    IN p_CL_DPAGO SMALLINT,
    IN p_CL_DCRED SMALLINT,
    IN p_CL_FPAGO DATETIME,
    IN p_CL_FULTR DATETIME,
    IN p_CL_CRED FLOAT,
    IN p_CL_SALDO FLOAT,
    IN p_CL_RFC CHAR(13),
    IN p_CL_CURP CHAR(18),
    IN p_CL_GIRO CHAR(100),
    IN p_CL_CUOTA FLOAT,
    IN p_CL_LOCALIDAD SMALLINT,
    IN p_CL_FISM SMALLINT,
    IN p_CL_FAFM SMALLINT,
    IN p_CL_MUNICIPIO CHAR(100),
    IN p_CL_ESTADO CHAR(100),
    IN p_CL_LOCALIDAD_FACT CHAR(100),
    IN p_CL_NUM_INT CHAR(15),
    IN p_CL_NUM_EXT CHAR(15),
    IN p_CL_MAIL CHAR(100),
    IN p_C_CTA SMALLINT,
    IN p_C_SCTA1 INT,
    IN p_C_SCTA2 INT,
    IN p_C_SCTA3 DOUBLE,
    IN p_C_SCTA4 INT,
    IN p_CL_CONTACTO CHAR(50),
    IN p_CL_BANCO CHAR(50),
    IN p_CL_CTA_BANCO CHAR(20),
    IN p_CL_CLABE_BANCO CHAR(20),
    IN p_CL_FECHA_BAJA DATETIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Ocurrió un error durante la inserción en la tabla Clientes' AS mensaje;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Validación de tipos y restricciones aquí
    IF p_CL_NUMERO IS NULL OR p_CL_NOM IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los campos CL_NUMERO y CL_NOM son obligatorios';
    END IF;

    -- Intentar la inserción
    INSERT INTO CLIENTES (
        CL_NUMERO, CL_TERR, CL_NOM, CL_CONT, CL_DIREC, CL_CIUD, CL_COLONIA, CL_CP, CL_LADA, CL_TELEF, CL_DSCTO, CL_DPAGO,
        CL_DCRED, CL_FPAGO, CL_FULTR, CL_CRED, CL_SALDO, CL_RFC, CL_CURP, CL_GIRO, CL_CUOTA, CL_LOCALIDAD, CL_FISM, CL_FAFM,
        CL_MUNICIPIO, CL_ESTADO, CL_LOCALIDAD_FACT, CL_NUM_INT, CL_NUM_EXT, CL_MAIL, C_CTA, C_SCTA1, C_SCTA2, C_SCTA3,
        C_SCTA4, CL_CONTACTO, CL_BANCO, CL_CTA_BANCO, CL_CLABE_BANCO, CL_FECHA_BAJA
    ) VALUES (
        p_CL_NUMERO, p_CL_TERR, p_CL_NOM, p_CL_CONT, p_CL_DIREC, p_CL_CIUD, p_CL_COLONIA, p_CL_CP, p_CL_LADA, p_CL_TELEF,
        p_CL_DSCTO, p_CL_DPAGO, p_CL_DCRED, p_CL_FPAGO, p_CL_FULTR, p_CL_CRED, p_CL_SALDO, p_CL_RFC, p_CL_CURP, p_CL_GIRO,
        p_CL_CUOTA, p_CL_LOCALIDAD, p_CL_FISM, p_CL_FAFM, p_CL_MUNICIPIO, p_CL_ESTADO, p_CL_LOCALIDAD_FACT, p_CL_NUM_INT,
        p_CL_NUM_EXT, p_CL_MAIL, p_C_CTA, p_C_SCTA1, p_C_SCTA2, p_C_SCTA3, p_C_SCTA4, p_CL_CONTACTO, p_CL_BANCO, p_CL_CTA_BANCO,
        p_CL_CLABE_BANCO, p_CL_FECHA_BAJA
    );

    COMMIT;
END $$

-- Procedimiento almacenado para eliminar en Clientes
DROP PROCEDURE IF EXISTS Eliminar_CLIENTES $$

CREATE PROCEDURE Eliminar_CLIENTES(IN p_CL_NUMERO DOUBLE)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Ocurrió un error durante la eliminación en la tabla Clientes' AS mensaje;
        ROLLBACK;
    END;

    START TRANSACTION;

    IF p_CL_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El campo CL_NUMERO es obligatorio';
    END IF;

    DELETE FROM CLIENTES WHERE CL_NUMERO = p_CL_NUMERO;

    COMMIT;
END $$

-- Procedimiento almacenado para buscar en Clientes
DROP PROCEDURE IF EXISTS Buscar_CLIENTES $$

CREATE PROCEDURE Buscar_CLIENTES(IN p_CL_NUMERO DOUBLE)
BEGIN
    IF p_CL_NUMERO IS NULL THEN
        SELECT * FROM CLIENTES;
    ELSE
        SELECT * FROM CLIENTES WHERE CL_NUMERO = p_CL_NUMERO;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Clientes
DROP PROCEDURE IF EXISTS Actualizar_CLIENTES $$

CREATE PROCEDURE Actualizar_CLIENTES(
    IN p_CL_NUMERO DOUBLE,
    IN p_CL_TERR SMALLINT,
    IN p_CL_NOM CHAR(200),
    IN p_CL_CONT CHAR(200),
    IN p_CL_DIREC CHAR(100),
    IN p_CL_CIUD CHAR(50),
    IN p_CL_COLONIA CHAR(100),
    IN p_CL_CP FLOAT,
    IN p_CL_LADA FLOAT,
    IN p_CL_TELEF CHAR(50),
    IN p_CL_DSCTO FLOAT,
    IN p_CL_DPAGO SMALLINT,
    IN p_CL_DCRED SMALLINT,
    IN p_CL_FPAGO DATETIME,
    IN p_CL_FULTR DATETIME,
    IN p_CL_CRED FLOAT,
    IN p_CL_SALDO FLOAT,
    IN p_CL_RFC CHAR(13),
    IN p_CL_CURP CHAR(18),
    IN p_CL_GIRO CHAR(100),
    IN p_CL_CUOTA FLOAT,
    IN p_CL_LOCALIDAD SMALLINT,
    IN p_CL_FISM SMALLINT,
    IN p_CL_FAFM SMALLINT,
    IN p_CL_MUNICIPIO CHAR(100),
    IN p_CL_ESTADO CHAR(100),
    IN p_CL_LOCALIDAD_FACT CHAR(100),
    IN p_CL_NUM_INT CHAR(15),
    IN p_CL_NUM_EXT CHAR(15),
    IN p_CL_MAIL CHAR(100),
    IN p_C_CTA SMALLINT,
    IN p_C_SCTA1 INT,
    IN p_C_SCTA2 INT,
    IN p_C_SCTA3 DOUBLE,
    IN p_C_SCTA4 INT,
    IN p_CL_CONTACTO CHAR(50),
    IN p_CL_BANCO CHAR(50),
    IN p_CL_CTA_BANCO CHAR(20),
    IN p_CL_CLABE_BANCO CHAR(20),
    IN p_CL_FECHA_BAJA DATETIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Ocurrió un error durante la actualización en la tabla Clientes' AS mensaje;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Validación de tipos y restricciones aquí
    IF p_CL_NUMERO IS NULL OR p_CL_NOM IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los campos CL_NUMERO y CL_NOM son obligatorios';
    END IF;

    -- Intentar la actualización
    UPDATE CLIENTES
    SET
        CL_TERR = p_CL_TERR,
        CL_NOM = p_CL_NOM,
        CL_CONT = p_CL_CONT,
        CL_DIREC = p_CL_DIREC,
        CL_CIUD = p_CL_CIUD,
        CL_COLONIA = p_CL_COLONIA,
        CL_CP = p_CL_CP,
        CL_LADA = p_CL_LADA,
        CL_TELEF = p_CL_TELEF,
        CL_DSCTO = p_CL_DSCTO,
        CL_DPAGO = p_CL_DPAGO,
        CL_DCRED = p_CL_DCRED,
        CL_FPAGO = p_CL_FPAGO,
        CL_FULTR = p_CL_FULTR,
        CL_CRED = p_CL_CRED,
        CL_SALDO = p_CL_SALDO,
        CL_RFC = p_CL_RFC,
        CL_CURP = p_CL_CURP,
        CL_GIRO = p_CL_GIRO,
        CL_CUOTA = p_CL_CUOTA,
        CL_LOCALIDAD = p_CL_LOCALIDAD,
        CL_FISM = p_CL_FISM,
        CL_FAFM = p_CL_FAFM,
        CL_MUNICIPIO = p_CL_MUNICIPIO,
        CL_ESTADO = p_CL_ESTADO,
        CL_LOCALIDAD_FACT = p_CL_LOCALIDAD_FACT,
        CL_NUM_INT = p_CL_NUM_INT,
        CL_NUM_EXT = p_CL_NUM_EXT,
        CL_MAIL = p_CL_MAIL,
        C_CTA = p_C_CTA,
        C_SCTA1 = p_C_SCTA1,
        C_SCTA2 = p_C_SCTA2,
        C_SCTA3 = p_C_SCTA3,
        C_SCTA4 = p_C_SCTA4,
        CL_CONTACTO = p_CL_CONTACTO,
        CL_BANCO = p_CL_BANCO,
        CL_CTA_BANCO = p_CL_CTA_BANCO,
        CL_CLABE_BANCO = p_CL_CLABE_BANCO,
        CL_FECHA_BAJA = p_CL_FECHA_BAJA
    WHERE CL_NUMERO = p_CL_NUMERO;

    COMMIT;
END $$

-- --------------------------------------------------------------------------------

-- Funciones, Triggers y Procedimientos para la tabla LOTE

-- Función para verificar la existencia de un registro en LOTE
DROP FUNCTION IF EXISTS Existe_LOTE $$

CREATE FUNCTION Existe_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM LOTE
    WHERE LOTE.L_MANZANA = L_MANZANA AND LOTE.L_NUMERO = L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en LOTE
DROP TRIGGER IF EXISTS Antes_Insertar_LOTE $$

CREATE TRIGGER Antes_Insertar_LOTE
BEFORE INSERT ON LOTE
FOR EACH ROW
BEGIN
    IF Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en LOTE';
    ELSEIF EXISTE_STATUS(NEW.CA_CLAVE0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El status referenciado no existe.';
    ELSEIF EXISTE_DIRECCION(NEW.CA_CLAVE1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La direccion referenciada no existe.';
    ELSEIF EXISTE_TIPO_LOTE(NEW.CA_CLAVE2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de lote referenciado no existe.';
    END IF;
END $$

-- Trigger antes de actualizar en LOTE
DROP TRIGGER IF EXISTS Antes_Actualizar_LOTE $$

CREATE TRIGGER Antes_Actualizar_LOTE
BEFORE UPDATE ON LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    ELSEIF NOT EXISTE_STATUS(NEW.CA_CLAVE0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El status referenciado no existe.';
    ELSEIF NOT EXISTE_DIRECCION(NEW.CA_CLAVE1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La direccion referenciada no existe.';
    ELSEIF NOT EXISTE_TIPO_LOTE(NEW.CA_CLAVE2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de lote referenciado no existe.';
    ELSEIF NEW.CA_CLAVE0 != OLD.CA_CLAVE0 OR NEW.CA_CLAVE1 != OLD.CA_CLAVE1 OR NEW.CA_CLAVE2 != OLD.CA_CLAVE2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar las referencias hacia status, direccion y tipo de lote.';
    END IF;
END $$

-- Trigger antes de eliminar en LOTE
DROP TRIGGER IF EXISTS Antes_Eliminar_LOTE $$
CREATE TRIGGER Antes_Eliminar_LOTE
BEFORE DELETE ON LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para LOTE
DROP FUNCTION IF EXISTS TieneReferencias_LOTE $$

CREATE FUNCTION TieneReferencias_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM COLONO_LOTE -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE COLONO_LOTE.L_MANZANA = L_MANZANA AND COLONO_LOTE.L_NUMERO = L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en LOTE que verifica referencias en tablas hijas
DROP TRIGGER IF EXISTS Antes_Eliminar_LOTE_Ref $$

CREATE TRIGGER Antes_Eliminar_LOTE_Ref
BEFORE DELETE ON LOTE
FOR EACH ROW
BEGIN
    IF TieneReferencias_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en LOTE
DROP PROCEDURE IF EXISTS Insertar_LOTE $$

CREATE PROCEDURE Insertar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_L_CA_CLAVE1 CHAR(3),
    IN p_L_CA_CLAVE2 CHAR(3),
    IN p_L_CA_CLAVE0 CHAR(3),
    IN p_L_TOTAL_M2 DOUBLE,
    IN p_L_IMPORTE DOUBLE,
    IN p_L_NUM_EXT CHAR(6),
    IN p_L_PAHT_MAP CHAR(150),
    IN p_L_FECHA_MANT DATETIME,
    IN p_L_FECHA_POSIBLE DATETIME
)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L_MANZANA y L_NUMERO no pueden ser nulos';
    ELSE

    -- Intentar la inserción
     INSERT INTO LOTE (L_MANZANA, L_NUMERO, CA_CLAVE1, CA_CLAVE2, CA_CLAVE0, L_TOTAL_M2,
                       L_IMPORTE, L_NUM_EXT, L_PAHT_MAP, L_FECHA_MANT, L_FECHA_POSIBLE)
        VALUES (p_L_MANZANA, p_L_NUMERO, p_L_CA_CLAVE1, p_L_CA_CLAVE2, p_L_CA_CLAVE0, p_L_TOTAL_M2,
                p_L_IMPORTE, p_L_NUM_EXT, p_L_PAHT_MAP, p_L_FECHA_MANT, p_L_FECHA_POSIBLE);
    END IF;
END $$

-- Procedimiento almacenado para eliminar en LOTE
DROP PROCEDURE IF EXISTS Eliminar_LOTE $$

CREATE PROCEDURE Eliminar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L_MANZANA y L_NUMERO no pueden ser nulos';
    ELSE
        DELETE FROM LOTE WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
    END IF;
END $$

-- Procedimiento almacenado para buscar en LOTE
DROP PROCEDURE IF EXISTS Buscar_LOTE $$

CREATE PROCEDURE Buscar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipos de datos
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L_MANZANA y L_NUMERO no pueden ser nulos';
    ELSE
        IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
            SELECT * FROM LOTE;
        ELSE
            IF Existe_LOTE(p_L_MANZANA, p_L_NUMERO) THEN
                SELECT * FROM LOTE WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
            END IF;
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en LOTE
DROP PROCEDURE IF EXISTS Actualizar_LOTE $$

CREATE PROCEDURE Actualizar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_L_CA_CLAVE1 CHAR(3),
    IN p_L_CA_CLAVE2 CHAR(3),
    IN p_L_CA_CLAVE0 CHAR(3),
    IN p_L_TOTAL_M2 DOUBLE,
    IN p_L_IMPORTE DOUBLE,
    IN p_L_NUM_EXT CHAR(6),
    IN p_L_PAHT_MAP CHAR(150),
    IN p_L_FECHA_MANT DATETIME,
    IN p_L_FECHA_POSIBLE DATETIME
)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L_MANZANA y L_NUMERO no pueden ser nulos';
    ELSE
        -- Intentar la actualización
        UPDATE LOTE
        SET
            L_MANZANA = p_L_MANZANA,
            L_NUMERO = p_L_NUMERO,
            CA_CLAVE1 = p_L_CA_CLAVE1,
            CA_CLAVE2 = p_L_CA_CLAVE2,
            CA_CLAVE0 = p_L_CA_CLAVE0,
            L_TOTAL_M2 = p_L_TOTAL_M2,
            L_IMPORTE = p_L_IMPORTE,
            L_NUM_EXT = p_L_NUM_EXT,
            L_PAHT_MAP = p_L_PAHT_MAP,
            L_FECHA_MANT = p_L_FECHA_MANT,
            L_FECHA_POSIBLE = p_L_FECHA_POSIBLE

        WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
    END IF;
END $$

-- --------------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla Colono_Lote

-- Función para verificar la existencia de un registro en Colono_Lote
DROP FUNCTION IF EXISTS Existe_COLONO_LOTE $$
CREATE FUNCTION Existe_COLONO_LOTE(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM COLONO_LOTE
    WHERE CL_NUMERO = COLONO_LOTE.CL_NUMERO AND L_MANZANA = COLONO_LOTE.L_MANZANA AND L_NUMERO = COLONO_LOTE.L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en Colono_Lote
DROP TRIGGER IF EXISTS Antes_Insertar_COLONO_LOTE $$
CREATE TRIGGER Antes_Insertar_COLONO_LOTE
BEFORE INSERT ON COLONO_LOTE
FOR EACH ROW
BEGIN
    IF Existe_COLONO_LOTE(NEW.CL_NUMERO, NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Colono_Lote';

    ELSEIF NOT Existe_CLIENTES(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el CLiente referenciado';
    END IF;

END $$

-- Trigger antes de actualizar en Colono_Lote
DROP TRIGGER IF EXISTS Antes_Actualizar_COLONO_LOTE $$
CREATE TRIGGER Antes_Actualizar_COLONO_LOTE
BEFORE UPDATE ON COLONO_LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_COLONO_LOTE(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    ELSEIF NOT Existe_CLIENTES(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el CLiente referenciado';
    ELSEIF NEW.CL_NUMERO != OLD.CL_NUMERO THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar las referencias hacia el cliente.';
    ELSEIF NEW.L_MANZANA != OLD.L_MANZANA OR NEW.L_NUMERO != OLD.L_NUMERO THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar las referencias hacia el lote.';
    END IF;

END $$

-- Trigger antes de eliminar en Colono_Lote
DROP TRIGGER IF EXISTS Antes_Eliminar_COLONO_LOTE $$
CREATE TRIGGER Antes_Eliminar_COLONO_LOTE
BEFORE DELETE ON COLONO_LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_COLONO_LOTE(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Colono_Lote
DROP FUNCTION IF EXISTS TieneReferencias_COLONO_LOTE $$

CREATE FUNCTION TieneReferencias_COLONO_LOTE(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM CARGOS
    WHERE CL_NUMERO = CARGOS.CL_NUMERO AND L_MANZANA = CARGOS.L_MANZANA AND L_NUMERO = CARGOS.L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Colono_Lote que verifica referencias en tablas hijas
DROP TRIGGER IF EXISTS Antes_Eliminar_COLONO_LOTE_Ref $$
CREATE TRIGGER Antes_Eliminar_COLONO_LOTE_Ref
BEFORE DELETE ON COLONO_LOTE
FOR EACH ROW
BEGIN
    IF TieneReferencias_COLONO_LOTE(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Colono_Lote
DROP PROCEDURE IF EXISTS Insertar_COLONO_LOTE $$

CREATE PROCEDURE Insertar_COLONO_LOTE(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_CL_TELEFONO CHAR(35),
    IN p_CL_MAIL CHAR(100),
    IN p_CL_IMPORTE DOUBLE,
    IN p_CL_FECHA_ALTA DATETIME,
    IN p_CL_FECHA_BAJA DATETIME,
    IN p_CL_COMENTARIO VARCHAR(45)

)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_CL_NUMERO IS NULL OR p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='El numero de cliente, el numero de manzana y numero de lote no puede ser NULL';
    ELSE
    -- Intentar la inserción
    INSERT INTO COLONO_LOTE VALUES (
        p_CL_NUMERO, p_L_MANZANA, p_L_NUMERO,
        p_CL_TELEFONO, p_CL_MAIL, p_CL_IMPORTE,
        p_CL_FECHA_ALTA, p_CL_FECHA_BAJA, p_CL_COMENTARIO
    );
    END IF;
END $$

-- Procedimiento almacenado para eliminar en Colono_Lote
DROP PROCEDURE IF EXISTS Eliminar_COLONO_LOTE $$

CREATE PROCEDURE Eliminar_COLONO_LOTE(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    IF p_CL_NUMERO IS NULL OR p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='El numero de cliente, el numero de manzana y numero de lote no puede ser NULL';
    ELSE
    -- Validar tipo de dato de la llave primaria
    DELETE FROM COLONO_LOTE WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
    END IF;
END $$

-- Procedimiento almacenado para buscar en Colono_Lote
DROP PROCEDURE IF EXISTS Buscar_Colono_Lote $$

CREATE PROCEDURE Buscar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipos de datos
    IF p_CL_NUMERO IS NULL OR p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SELECT * FROM COLONO_LOTE;
    ELSE
        IF Existe_COLONO_LOTE(p_CL_NUMERO, p_L_MANZANA, p_L_NUMERO) THEN
            SELECT * FROM COLONO_LOTE WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Colono_Lote
DROP PROCEDURE IF EXISTS Actualizar_Colono_Lote $$

CREATE PROCEDURE Actualizar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_CL_TELEFONO CHAR(35),
    IN p_CL_MAIL CHAR(100),
    IN p_CL_IMPORTE DOUBLE,
    IN p_CL_FECHA_ALTA DATETIME,
    IN p_CL_FECHA_BAJA DATETIME,
    IN p_CL_COMENTARIO VARCHAR(45)

)
BEGIN
    -- Validación de tipos y restricciones aquí
    IF p_CL_NUMERO IS NULL OR p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='El numero de cliente, el numero de manzana y numero de lote no puede ser NULL';
    ELSE
    -- Intentar la actualización
    UPDATE COLONO_LOTE
    SET
        L_MANZANA = p_L_MANZANA,
        L_NUMERO = p_L_NUMERO,
	CL_TELEFONO = p_CL_TELEFONO,
	CL_MAIL = p_CL_MAIL,
	CL_IMPORTE = p_CL_IMPORTE,
	CL_FECHA_ALTA = p_CL_FECHA_ALTA,
	CL_FECHA_BAJA = p_CL_FECHA_BAJA,
	CL_COMENTARIO = p_CL_COMENTARIO
    WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
    END IF;
END $$

-- ---------------------------------------------------------------------------------------

-- Funciones, Triggers y Procedimientos para la tabla CARGOS

-- Función para verificar la existencia de un registro en CARGOS
DROP FUNCTION IF EXISTS Existe_CARGOS $$

CREATE FUNCTION Existe_CARGOS(CAR_FOLIO CHAR(10), ANT_DOCTO_CC_ID DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(CARGOS.CAR_IMPORTE) > 0 INTO existe
    FROM CARGOS
    WHERE CARGOS.CAR_FOLIO = CAR_FOLIO AND CARGOS.ANT_DOCTO_CC_ID = ANT_DOCTO_CC_ID;
    RETURN existe;
END $$


-- Trigger antes de insertar en CARGOS
DROP TRIGGER IF EXISTS Antes_Insertar_CARGOS $$

CREATE TRIGGER Antes_Insertar_CARGOS
BEFORE INSERT ON CARGOS
FOR EACH ROW
BEGIN
    IF Existe_CARGOS(NEW.CAR_FOLIO, NEW.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en CARGOS';
    ELSEIF NOT Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el Lote referenciado';
    ELSEIF NOT Existe_CLIENTES(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el Cliente referenciado';
    END IF;
END $$

-- Trigger antes de actualizar en CARGOS

DROP TRIGGER IF EXISTS Antes_Actualizar_CARGOS $$
CREATE TRIGGER Antes_Actualizar_CARGOS
BEFORE UPDATE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    ELSEIF NEW.L_MANZANA != OLD.L_MANZANA OR NEW.L_NUMERO != OLD.L_NUMERO THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar las referencias hacia el lote.';
    END IF;
END $$


-- Trigger antes de eliminar en CARGOS

DROP TRIGGER IF EXISTS Antes_Eliminar_CARGOS $$

CREATE TRIGGER Antes_Eliminar_CARGOS
BEFORE DELETE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    END IF;
END $$


-- Procedimiento almacenado para insertar en CARGOS
DROP PROCEDURE IF EXISTS Insertar_CARGOS $$

CREATE PROCEDURE Insertar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_CON_CLAVE SMALLINT,
    IN p_CAR_FECHA DATETIME,
    IN p_CAR_IMPORTE DOUBLE,
    IN p_CAR_IVA DOUBLE,
    IN p_CAR_DESCRIPCION CHAR(100),
    IN p_CL_NUMERO DOUBLE,
    IN p_CAR_POLIZA_PRO CHAR(8),
    IN p_ANT_CLIENTE_ID INT,
    IN p_ANT_CONC_CC_ID INT,
    IN p_CAR_FECHA_VENCE DATETIME,
    IN p_CAR_DESCUENTO DOUBLE,
    IN p_CAR_INICIO SMALLINT
)
BEGIN
    -- Intentar la inserción
    INSERT INTO CARGOS (
        CAR_FOLIO, ANT_DOCTO_CC_ID, L_MANZANA, L_NUMERO, CON_CLAVE, CAR_FECHA,
        CAR_IMPORTE, CAR_IVA, CAR_DESCRIPCION, CL_NUMERO, CAR_POLIZA_PRO,
        ANT_CLIENTE_ID, ANT_CONC_CC_ID, CAR_FECHA_VENCE, CAR_DESCUENTO, CAR_INICIO
    ) VALUES (
        p_CAR_FOLIO, p_ANT_DOCTO_CC_ID, p_L_MANZANA, p_L_NUMERO, p_CON_CLAVE, p_CAR_FECHA,
        p_CAR_IMPORTE, p_CAR_IVA, p_CAR_DESCRIPCION, p_CL_NUMERO, p_CAR_POLIZA_PRO,
        p_ANT_CLIENTE_ID, p_ANT_CONC_CC_ID, p_CAR_FECHA_VENCE, p_CAR_DESCUENTO, p_CAR_INICIO
    );
END $$


-- Procedimiento almacenado para eliminar en CARGOS
DROP PROCEDURE IF EXISTS Eliminar_CARGOS $$

CREATE PROCEDURE Eliminar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM CARGOS WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
END $$

-- Procedimiento almacenado para buscar en CARGOS
DROP PROCEDURE IF EXISTS Buscar_CARGOS $$

CREATE PROCEDURE Buscar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE
)
BEGIN
    -- Validar tipos de datos
    IF p_CAR_FOLIO IS NULL OR p_ANT_DOCTO_CC_ID IS NULL THEN
        SELECT * FROM CARGOS;
    ELSE
        IF Existe_CARGOS(p_CAR_FOLIO, p_ANT_DOCTO_CC_ID) THEN
            SELECT * FROM CARGOS WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en CARGOS
DROP PROCEDURE IF EXISTS Actualizar_CARGOS $$

    CREATE PROCEDURE Actualizar_CARGOS(
        IN p_CAR_FOLIO CHAR(10),
        IN p_ANT_DOCTO_CC_ID DOUBLE,
        IN p_L_MANZANA CHAR(3),
        IN p_L_NUMERO CHAR(6),
        IN p_CON_CLAVE SMALLINT(6),
        IN p_CAR_FECHA DATETIME,
        IN p_CAR_IMPORTE DOUBLE,
        IN p_CAR_IVA DOUBLE,
        IN p_CAR_DESCRIPCION CHAR(100),
        IN p_CL_NUMERO DOUBLE,
        IN p_CAR_POLIZA_PRO CHAR(8),
        IN p_ANT_CLIENTE_ID INT(11),
        IN p_ANT_CONC_CC_ID INT(11),
        IN p_CAR_FECHA_VENCE DATETIME,
        IN p_CAR_DESCUENTO DOUBLE,
        IN p_CAR_INICIO SMALLINT(6)
    )
    BEGIN
        -- Validación de tipos y restricciones aquí

        -- Intentar la actualización
        UPDATE CARGOS
        SET
            L_MANZANA = p_L_MANZANA,
            L_NUMERO = p_L_NUMERO,
            CON_CLAVE = p_CON_CLAVE,
            CAR_FECHA = p_CAR_FECHA,
            CAR_IMPORTE = p_CAR_IMPORTE,
            CAR_IVA = p_CAR_IVA,
            CAR_DESCRIPCION = p_CAR_DESCRIPCION,
            CL_NUMERO = p_CL_NUMERO,
            CAR_POLIZA_PRO = p_CAR_POLIZA_PRO,
            ANT_CLIENTE_ID = p_ANT_CLIENTE_ID,
            ANT_CONC_CC_ID = p_ANT_CONC_CC_ID,
            CAR_FECHA_VENCE = p_CAR_FECHA_VENCE,
            CAR_DESCUENTO = p_CAR_DESCUENTO,
            CAR_INICIO = p_CAR_INICIO
        WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
    END $$

DELIMITER ;