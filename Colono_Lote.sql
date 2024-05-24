
DELIMITER $$
-- --------------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla Colono_Lote

-- Función para verificar la existencia de un registro en Colono_Lote
DROP FUNCTION IF EXISTS Existe_COLONO_LOTE $$
CREATE FUNCTION Existe_COLONO_LOTE(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM COLONO_LOTE
    WHERE CL_NUMERO = Colono_Lote.CL_NUMERO AND L_MANZANA = Colono_Lote.L_MANZANA AND L_NUMERO = Colono_Lote.L_NUMERO;
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
DROP PROCEDURE IF EXISTS Antes_Eliminar_COLONO_LOTE_Ref $$

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

DELIMITER ;
