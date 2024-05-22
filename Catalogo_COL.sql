DELIMITER $$

-- Funciones, Triggers y Procedimientos para la tabla Catalogo_COL

-- Función para verificar la existencia de un registro en Catalogo_COL
CREATE FUNCTION Existe_Catalogo_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Catalogo_COL
    WHERE CA_CLAVE = Catalogo_COL.CA_CLAVE;
    RETURN existe;
END $$

-- Trigger antes de insertar en Catalogo_COL
CREATE TRIGGER before_insert_Catalogo_COL
BEFORE INSERT ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF Existe_Catalogo_COL(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Catalogo_COL';
    END IF;
END $$

-- Trigger antes de actualizar en Catalogo_COL
CREATE TRIGGER before_update_Catalogo_COL
BEFORE UPDATE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END $$

-- Trigger antes de eliminar en Catalogo_COL
CREATE TRIGGER before_delete_Catalogo_COL
BEFORE DELETE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Catalogo_COL
CREATE FUNCTION TieneReferencias_Catalogo_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Lote -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE CA_CLAVE = Lote.CA_CLAVE0 or CA_CLAVE = Lote.CA_CLAVE1 or CA_CLAVE = Lote.CA_CLAVE2;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Catalogo_COL que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_Catalogo_COL_references
BEFORE DELETE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF TieneReferencias_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Catalogo_COL
CREATE PROCEDURE Insertar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO CHAR(1),
    IN p_CA_IMPORTE DOUBLE,
    IN p_CON_CLAVE SMALLINT(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la inserción
    INSERT INTO Catalogo_COL (
        CA_CLAVE, CA_DESCRIPCION, CA_TIPO, CA_IMPORTE, CON_CLAVE
    ) VALUES (
        p_CA_CLAVE, p_CA_DESCRIPCION, p_CA_TIPO,p_CA_IMPORTE,p_CON_CLAVE
    );
END $$

-- Procedimiento almacenado para eliminar en Catalogo_COL
CREATE PROCEDURE Eliminar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM Catalogo_COL WHERE CA_CLAVE = p_CA_CLAVE;
END $$

-- Procedimiento almacenado para buscar en Catalogo_COL
CREATE PROCEDURE Buscar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipos de datos
    IF p_CA_CLAVE IS NULL THEN
        SELECT * FROM Catalogo_COL;
    ELSE
        IF Existe_Catalogo_COL(p_CA_CLAVE) THEN
            SELECT * FROM Catalogo_COL WHERE CA_CLAVE = p_CA_CLAVE;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Catalogo_COL
CREATE PROCEDURE Actualizar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO CHAR(1),
    IN p_CA_IMPORTE DOUBLE,
    IN p_CON_CLAVE SMALLINT(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la actualización
    UPDATE Catalogo_COL
    SET
        CA_DESCRIPCION = p_CA_DESCRIPCION,
        CA_TIPO = p_CA_TIPO,
        CA_IMPORTE = p_CA_IMPORTE,
        CON_CLAVE = p_CON_CLAVE
    WHERE CA_CLAVE = p_CA_CLAVE;
END $$

DELIMITER ;