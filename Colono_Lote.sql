
DELIMITER $$
-- --------------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla Colono_Lote

-- Función para verificar la existencia de un registro en Colono_Lote

CREATE FUNCTION Existe_Colono_Lote(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Colono_Lote
    WHERE CL_NUMERO = Colono_Lote.CL_NUMERO AND L_MANZANA = Colono_Lote.L_MANZANA AND L_NUMERO = Colono_Lote.L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de insertar en Colono_Lote
CREATE TRIGGER Antes_Insert_Colono_Lote
BEFORE INSERT ON Colono_Lote
FOR EACH ROW
BEGIN
    IF Existe_Colono_Lote(NEW.CL_NUMERO, NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Colono_Lote';
    END IF;
END $$

-- Trigger antes de actualizar en Colono_Lote
CREATE TRIGGER Antes_Update_Colono_Lote
BEFORE UPDATE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    END IF;
END $$

-- Trigger antes de eliminar en Colono_Lote
CREATE TRIGGER Antes_Delete_Colono_Lote
BEFORE DELETE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    END IF;
END $$

-- Función para verificar referencias en tablas hijas para Colono_Lote
CREATE FUNCTION TieneReferencias_Colono_Lote(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM CARGOS
    WHERE CL_NUMERO = CARGOS.CL_NUMERO AND L_MANZANA = CARGOS.L_MANZANA AND L_NUMERO = CARGOS.L_NUMERO;
    RETURN existe;
END $$

-- Trigger antes de eliminar en Colono_Lote que verifica referencias en tablas hijas
CREATE TRIGGER Antes_Delete_Colono_Lote_References
BEFORE DELETE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF TieneReferencias_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END $$

-- Procedimiento almacenado para insertar en Colono_Lote
CREATE PROCEDURE Insertar_Colono_Lote(
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

    -- Intentar la inserción
    INSERT INTO Colono_Lote VALUES (
        p_CL_NUMERO, p_L_MANZANA, p_L_NUMERO,
        p_CL_TELEFONO, p_CL_MAIL, p_CL_IMPORTE,
        p_CL_FECHA_ALTA, p_CL_FECHA_BAJA, p_CL_COMENTARIO
    );
END $$

-- Procedimiento almacenado para eliminar en Colono_Lote
CREATE PROCEDURE Eliminar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM Colono_Lote WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END $$

-- Procedimiento almacenado para buscar en Colono_Lote
CREATE PROCEDURE Buscar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipos de datos
    IF p_CL_NUMERO IS NULL OR p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SELECT * FROM Colono_Lote;
    ELSE
        IF Existe_Colono_Lote(p_CL_NUMERO, p_L_MANZANA, p_L_NUMERO) THEN
            SELECT * FROM Colono_Lote WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en Colono_Lote
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

    -- Intentar la actualización
    UPDATE Colono_Lote
    SET
        L_MANZANA = p_L_MANZANA,
        L_NUMERO = p_L_NUMERO,
	CL_TELEFONO = p_CL_TELEFONO,
	CL_MAIL = p_CL_MAIL,
	CL_IMPORTE = p_CL_IMPORTE,
	CL_FECHA_ALTA = p_FECHA_ALTA,
	CL_FECHA_BAJA = p_FECHA_BAJA,
	CL_COMENTARIO = p_CL_COMENTARIO
    WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END $$

DELIMITER ;
