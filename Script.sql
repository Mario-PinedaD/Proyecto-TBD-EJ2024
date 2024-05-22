SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

-------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla LOTE

-- Función para verificar la existencia de un registro en LOTE
CREATE FUNCTION Existe_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Lote
    WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en LOTE
CREATE TRIGGER before_insert_LOTE
BEFORE INSERT ON Lote
FOR EACH ROW
BEGIN
    IF Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en LOTE';
    END IF;
END $$

-- Trigger antes de actualizar en LOTE
CREATE TRIGGER before_update_LOTE
BEFORE UPDATE ON Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END $$

-- Trigger antes de eliminar en LOTE
CREATE TRIGGER before_delete_LOTE
BEFORE DELETE ON Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para LOTE
CREATE FUNCTION TieneReferencias_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Colono_Lote -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en LOTE que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_LOTE_references
BEFORE DELETE ON Lote
FOR EACH ROW
BEGIN
    IF TieneReferencias_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en LOTE
CREATE PROCEDURE Insertar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_L_SUPERFICIE DOUBLE,
    IN p_L_U_C VARCHAR(30),
    IN p_L_P VARCHAR(30),
    IN p_L_OBS VARCHAR(60)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la inserción
    INSERT INTO Lote (
        L_MANZANA, L_NUMERO, L_SUPERFICIE, L_U_C, L_P, L_OBS
    ) VALUES (
        p_L_MANZANA, p_L_NUMERO, p_L_SUPERFICIE, p_L_U_C, p_L_P, p_L_OBS
    );
END $$

-- Procedimiento almacenado para eliminar en LOTE
CREATE PROCEDURE Eliminar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM Lote WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END $$

-- Procedimiento almacenado para buscar en LOTE
CREATE PROCEDURE Buscar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipos de datos
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SELECT * FROM Lote;
    ELSE
        IF Existe_LOTE(p_L_MANZANA, p_L_NUMERO) THEN
            SELECT * FROM Lote WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en LOTE
CREATE PROCEDURE Actualizar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_L_SUPERFICIE DOUBLE,
    IN p_L_U_C VARCHAR(30),
    IN p_L_P VARCHAR(30),
    IN p_L_OBS VARCHAR(60)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la actualización
    UPDATE Lote
    SET
        L_SUPERFICIE = p_L_SUPERFICIE,
        L_U_C = p_L_U_C,
        L_P = p_L_P,
        L_OBS = p_L_OBS
    WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END $$

-- ================================================
-- Funciones, Triggers y Procedimientos para Clientes
-- ================================================

-- Función para verificar si existe un registro en Clientes
CREATE FUNCTION Existe_Cliente(p_CL_NUMERO DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Clientes
    WHERE CL_NUMERO = p_CL_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en Clientes que verifica duplicados
CREATE TRIGGER before_insert_Clientes
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    IF Existe_Cliente(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Clientes';
    END IF;
END $$

-- Trigger antes de actualizar en Clientes que verifica la existencia del registro
CREATE TRIGGER before_update_Clientes
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NOT Existe_Cliente(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Clientes';
    END IF;
END $$

-- Trigger antes de borrar en Clientes que verifica la existencia del registro
CREATE TRIGGER before_delete_Clientes
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    IF NOT Existe_Cliente(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Clientes';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Clientes
CREATE FUNCTION TieneReferencias_Clientes(CL_NUMERO DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Colono_Lote
    WHERE CL_NUMERO = CL_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Clientes que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_Clientes_references
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    IF TieneReferencias_Clientes(OLD.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Clientes
CREATE PROCEDURE Insertar_Cliente(
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
    INSERT INTO Clientes (
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
CREATE PROCEDURE Eliminar_Cliente(IN p_CL_NUMERO DOUBLE)
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

    DELETE FROM Clientes WHERE CL_NUMERO = p_CL_NUMERO;

    COMMIT;
END $$

-- Procedimiento almacenado para buscar en Clientes
CREATE PROCEDURE Buscar_Cliente(IN p_CL_NUMERO DOUBLE)
BEGIN
    IF p_CL_NUMERO IS NULL THEN
        SELECT * FROM Clientes;
    ELSE
        SELECT * FROM Clientes WHERE CL_NUMERO = p_CL_NUMERO;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Clientes
CREATE PROCEDURE Actualizar_Cliente(
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
    UPDATE Clientes
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

-- ================================================
-- Funciones, Triggers y Procedimientos para la Vista status
-- ================================================

-- Función para verificar si existe un registro en la vista status
CREATE FUNCTION Existe_Status(p_CA_CLAVE CHAR(5)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM status
    WHERE CA_CLAVE = p_CA_CLAVE;
    RETURN existe;
END $$

-- Trigger antes de insertar en status que verifica duplicados
CREATE TRIGGER before_insert_status
BEFORE INSERT ON status
FOR EACH ROW
BEGIN
    IF Existe_Status(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en la vista status';
    END IF;
END $$

-- Trigger antes de actualizar en status que verifica la existencia del registro
CREATE TRIGGER before_update_status
BEFORE UPDATE ON status
FOR EACH ROW
BEGIN
    IF NOT Existe_Status(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista status';
    END IF;
END $$

-- Trigger antes de borrar en status que verifica la existencia del registro
CREATE TRIGGER before_delete_status
BEFORE DELETE ON status
FOR EACH ROW
BEGIN
    IF NOT Existe_Status(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista status';
    END IF;
END $$

-- ================================================
-- Funciones, Triggers y Procedimientos para la Vista tipo_lote
-- ================================================

-- Función para verificar si existe un registro en la vista tipo_lote
CREATE FUNCTION Existe_Tipo_Lote(p_CA_CLAVE CHAR(5)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM tipo_lote
    WHERE CA_CLAVE = p_CA_CLAVE;
    RETURN existe;
END $$

-- Trigger antes de insertar en tipo_lote que verifica duplicados
CREATE TRIGGER before_insert_tipo_lote
BEFORE INSERT ON tipo_lote
FOR EACH ROW
BEGIN
    IF Existe_Tipo_Lote(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en la vista tipo_lote';
    END IF;
END $$

-- Trigger antes de actualizar en tipo_lote que verifica la existencia del registro
CREATE TRIGGER before_update_tipo_lote
BEFORE UPDATE ON tipo_lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Tipo_Lote(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista tipo_lote';
    END IF;
END $$

-- Trigger antes de borrar en tipo_lote que verifica la existencia del registro
CREATE TRIGGER before_delete_tipo_lote
BEFORE DELETE ON tipo_lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Tipo_Lote(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista tipo_lote';
    END IF;
END $$

DELIMITER ;

SHOW procedure status where Db = 'fraccionamiento';

drop procedure Eliminar_CARGOS;
drop PROCEDURE Insertar_CARGOS;