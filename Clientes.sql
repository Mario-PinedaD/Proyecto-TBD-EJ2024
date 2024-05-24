DELIMITER $$

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
    WHERE CL_NUMERO = CL_NUMERO;
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
