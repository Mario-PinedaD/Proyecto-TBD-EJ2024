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

DELIMITER ;
