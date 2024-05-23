-- Funciones, Triggers y Procedimientos para la tabla LOTE

-- Función para verificar la existencia de un registro en LOTE
CREATE FUNCTION Existe_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM LOTE
    WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en LOTE
CREATE TRIGGER Antes_Insertar_LOTE
BEFORE INSERT ON LOTE
FOR EACH ROW
BEGIN
    IF Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en LOTE';
    END IF;
END $$

-- Trigger antes de actualizar en LOTE
CREATE TRIGGER Antes_Actualizar_LOTE
BEFORE UPDATE ON LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END $$

-- Trigger antes de eliminar en LOTE
CREATE TRIGGER Antes_Eliminar_LOTE
BEFORE DELETE ON LOTE
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
CREATE TRIGGER Antes_Eliminar_LOTE_Ref
BEFORE DELETE ON LOTE
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
     INSERT INTO Lote (L_MANZANA, L_NUMERO, CA_CLAVE1, CA_CLAVE2, CA_CLAVE0, L_TOTAL_M2,
                       L_IMPORTE, L_NUM_EXT, L_PAHT_MAP, L_FECHA_MANT, L_FECHA_POSIBLE)
        VALUES (p_L_MANZANA, p_L_NUMERO, p_CA_CLAVE1, p_CA_CLAVE2, p_CA_CLAVE0, p_L_TOTAL_M2,
                p_L_IMPORTE, p_L_NUM_EXT, p_L_PAHT_MAP, p_L_FECHA_MANT, p_L_FECHA_POSIBLE);
END $$

-- Procedimiento almacenado para eliminar en LOTE
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
END $$

-- Procedimiento almacenado para buscar en LOTE
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
END $$

-- Procedimiento almacenado para actualizar en LOTE
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
        CA_CLAVE1 = p_CA_CLAVE1,
        CA_CLAVE2 = p_CA_CLAVE2,
        CA_CLAVE0 = p_CA_CLAVE0,
        L_TOTAL_M2 = p_L_TOTAL_M2,
        L_IMPORTE = p_L_IMPORTE,
        L_NUM_EXT = p_L_NUM_EXT,
        L_PAHT_MAP = p_L_PAHT_MAP,
        L_FECHA_MANT = p_L_FECHA_MANT,
        L_FECHA_POSIBLE = L_FECHA_POSIBLE

    WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END $$