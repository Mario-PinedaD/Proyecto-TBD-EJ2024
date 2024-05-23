-- Función para verificar si existe un registro en la vista status
CREATE FUNCTION Existe_STATUS(p_CA_CLAVE CHAR(5)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM STATUS
    WHERE CA_CLAVE = p_CA_CLAVE;
    RETURN existe;
END $$

-- Trigger antes de insertar en status que verifica duplicados
CREATE TRIGGER Antes_Insertar_STATUS
BEFORE INSERT ON STATUS
FOR EACH ROW
BEGIN
    IF Existe_Status(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en la vista status';
    END IF;
END $$

-- Trigger antes de actualizar en status que verifica la existencia del registro
CREATE TRIGGER Antes_Actualizar_STATUS
BEFORE UPDATE ON STATUS
FOR EACH ROW
BEGIN
    IF NOT Existe_Status(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista status';
    END IF;
END $$

-- Trigger antes de borrar en status que verifica la existencia del registro
CREATE TRIGGER Antes_Borrar_STATUS
BEFORE DELETE ON STATUS
FOR EACH ROW
BEGIN
    IF NOT Existe_STATUS(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en la vista status';
    END IF;
END $$
