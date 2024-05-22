DELIMITER //

-- Funciones, Triggers y Procedimientos para la tabla CARGOS

-- Función para verificar la existencia de un registro en CARGOS
CREATE FUNCTION Existe_CARGOS(CAR_FOLIO CHAR(10), ANT_DOCTO_CC_ID DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM CARGOS
    WHERE CAR_FOLIO = CAR_FOLIO AND ANT_DOCTO_CC_ID = ANT_DOCTO_CC_ID;
    RETURN existe;
END //

-- Trigger antes de insertar en CARGOS
CREATE TRIGGER before_insert_CARGOS
BEFORE INSERT ON CARGOS
FOR EACH ROW
BEGIN
    IF Existe_CARGOS(NEW.CAR_FOLIO, NEW.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en CARGOS';
    END IF;
END //

-- Trigger antes de actualizar en CARGOS
CREATE TRIGGER before_update_CARGOS
BEFORE UPDATE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    END IF;
END //

-- Trigger antes de eliminar en CARGOS
CREATE TRIGGER before_delete_CARGOS
BEFORE DELETE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    END IF;
END //

-- Función para verificar referencias en tablas hijas para CARGOS
CREATE FUNCTION TieneReferencias_CARGOS(CAR_FOLIO CHAR(10), ANT_DOCTO_CC_ID DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM OtraTabla -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE CAR_FOLIO = CAR_FOLIO AND ANT_DOCTO_CC_ID = ANT_DOCTO_CC_ID;
    RETURN existe;
END //

-- Trigger antes de eliminar en CARGOS que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_CARGOS_references
BEFORE DELETE ON CARGOS
FOR EACH ROW
BEGIN
    IF TieneReferencias_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END //

-- Procedimiento almacenado para insertar en CARGOS
CREATE PROCEDURE Insertar_CARGOS(
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
END //

-- Procedimiento almacenado para eliminar en CARGOS
CREATE PROCEDURE Eliminar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM CARGOS WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
END //

-- Procedimiento almacenado para buscar en CARGOS
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
END //

-- Procedimiento almacenado para actualizar en CARGOS
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
END //
-----------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla Catalogo_COL

-- Función para verificar la existencia de un registro en Catalogo_COL
CREATE FUNCTION Existe_Catalogo_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Catalogo_COL
    WHERE CA_CLAVE = CA_CLAVE;
    RETURN existe;
END //

-- Trigger antes de insertar en Catalogo_COL
CREATE TRIGGER before_insert_Catalogo_COL
BEFORE INSERT ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF Existe_Catalogo_COL(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Catalogo_COL';
    END IF;
END //

-- Trigger antes de actualizar en Catalogo_COL
CREATE TRIGGER before_update_Catalogo_COL
BEFORE UPDATE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END //

-- Trigger antes de eliminar en Catalogo_COL
CREATE TRIGGER before_delete_Catalogo_COL
BEFORE DELETE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF NOT Existe_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Catalogo_COL';
    END IF;
END //

-- Función para verificar referencias en tablas hijas para Catalogo_COL
CREATE FUNCTION TieneReferencias_Catalogo_COL(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM OtraTabla -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE CA_CLAVE = CA_CLAVE;
    RETURN existe;
END //

-- Trigger antes de eliminar en Catalogo_COL que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_Catalogo_COL_references
BEFORE DELETE ON Catalogo_COL
FOR EACH ROW
BEGIN
    IF TieneReferencias_Catalogo_COL(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END //

-- Procedimiento almacenado para insertar en Catalogo_COL
CREATE PROCEDURE Insertar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO CHAR(1)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la inserción
    INSERT INTO Catalogo_COL (
        CA_CLAVE, CA_DESCRIPCION, CA_TIPO
    ) VALUES (
        p_CA_CLAVE, p_CA_DESCRIPCION, p_CA_TIPO
    );
END //

-- Procedimiento almacenado para eliminar en Catalogo_COL
CREATE PROCEDURE Eliminar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM Catalogo_COL WHERE CA_CLAVE = p_CA_CLAVE;
END //

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
END //

-- Procedimiento almacenado para actualizar en Catalogo_COL
CREATE PROCEDURE Actualizar_Catalogo_COL(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50),
    IN p_CA_TIPO CHAR(1)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la actualización
    UPDATE Catalogo_COL
    SET
        CA_DESCRIPCION = p_CA_DESCRIPCION,
        CA_TIPO = p_CA_TIPO
    WHERE CA_CLAVE = p_CA_CLAVE;
END //
----------------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla Colono_Lote

-- Función para verificar la existencia de un registro en Colono_Lote
CREATE FUNCTION Existe_Colono_Lote(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM Colono_Lote
    WHERE CL_NUMERO = CL_NUMERO AND L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END //

-- Trigger antes de insertar en Colono_Lote
CREATE TRIGGER before_insert_Colono_Lote
BEFORE INSERT ON Colono_Lote
FOR EACH ROW
BEGIN
    IF Existe_Colono_Lote(NEW.CL_NUMERO, NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en Colono_Lote';
    END IF;
END //

-- Trigger antes de actualizar en Colono_Lote
CREATE TRIGGER before_update_Colono_Lote
BEFORE UPDATE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    END IF;
END //

-- Trigger antes de eliminar en Colono_Lote
CREATE TRIGGER before_delete_Colono_Lote
BEFORE DELETE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF NOT Existe_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en Colono_Lote';
    END IF;
END //

-- Función para verificar referencias en tablas hijas para Colono_Lote
CREATE FUNCTION TieneReferencias_Colono_Lote(CL_NUMERO DOUBLE, L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM OtraTabla -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE CL_NUMERO = CL_NUMERO AND L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END //

-- Trigger antes de eliminar en Colono_Lote que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_Colono_Lote_references
BEFORE DELETE ON Colono_Lote
FOR EACH ROW
BEGIN
    IF TieneReferencias_Colono_Lote(OLD.CL_NUMERO, OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END //

-- Procedimiento almacenado para insertar en Colono_Lote
CREATE PROCEDURE Insertar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la inserción
    INSERT INTO Colono_Lote (
        CL_NUMERO, L_MANZANA, L_NUMERO
    ) VALUES (
        p_CL_NUMERO, p_L_MANZANA, p_L_NUMERO
    );
END //

-- Procedimiento almacenado para eliminar en Colono_Lote
CREATE PROCEDURE Eliminar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM Colono_Lote WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END //

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
END //

-- Procedimiento almacenado para actualizar en Colono_Lote
CREATE PROCEDURE Actualizar_Colono_Lote(
    IN p_CL_NUMERO DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la actualización
    UPDATE Colono_Lote
    SET
        L_MANZANA = p_L_MANZANA,
        L_NUMERO = p_L_NUMERO
    WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END //
-------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla DIRECCION

-- Función para verificar la existencia de un registro en DIRECCION
CREATE FUNCTION Existe_DIRECCION(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM DIRECCION
    WHERE CA_CLAVE = CA_CLAVE;
    RETURN existe;
END //

-- Trigger antes de insertar en DIRECCION
CREATE TRIGGER before_insert_DIRECCION
BEFORE INSERT ON DIRECCION
FOR EACH ROW
BEGIN
    IF Existe_DIRECCION(NEW.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en DIRECCION';
    END IF;
END //

-- Trigger antes de actualizar en DIRECCION
CREATE TRIGGER before_update_DIRECCION
BEFORE UPDATE ON DIRECCION
FOR EACH ROW
BEGIN
    IF NOT Existe_DIRECCION(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en DIRECCION';
    END IF;
END //

-- Trigger antes de eliminar en DIRECCION
CREATE TRIGGER before_delete_DIRECCION
BEFORE DELETE ON DIRECCION
FOR EACH ROW
BEGIN
    IF NOT Existe_DIRECCION(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en DIRECCION';
    END IF;
END //

-- Función para verificar referencias en tablas hijas para DIRECCION
CREATE FUNCTION TieneReferencias_DIRECCION(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM OtraTabla -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE CA_CLAVE = CA_CLAVE;
    RETURN existe;
END //

-- Trigger antes de eliminar en DIRECCION que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_DIRECCION_references
BEFORE DELETE ON DIRECCION
FOR EACH ROW
BEGIN
    IF TieneReferencias_DIRECCION(OLD.CA_CLAVE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END //

-- Procedimiento almacenado para insertar en DIRECCION
CREATE PROCEDURE Insertar_DIRECCION(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la inserción
    INSERT INTO DIRECCION (
        CA_CLAVE, CA_DESCRIPCION
    ) VALUES (
        p_CA_CLAVE, p_CA_DESCRIPCION
    );
END //

-- Procedimiento almacenado para eliminar en DIRECCION
CREATE PROCEDURE Eliminar_DIRECCION(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM DIRECCION WHERE CA_CLAVE = p_CA_CLAVE;
END //

-- Procedimiento almacenado para buscar en DIRECCION
CREATE PROCEDURE Buscar_DIRECCION(
    IN p_CA_CLAVE CHAR(3)
)
BEGIN
    -- Validar tipos de datos
    IF p_CA_CLAVE IS NULL THEN
        SELECT * FROM DIRECCION;
    ELSE
        IF Existe_DIRECCION(p_CA_CLAVE) THEN
            SELECT * FROM DIRECCION WHERE CA_CLAVE = p_CA_CLAVE;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en DIRECCION';
        END IF;
    END IF;
END //

-- Procedimiento almacenado para actualizar en DIRECCION
CREATE PROCEDURE Actualizar_DIRECCION(
    IN p_CA_CLAVE CHAR(3),
    IN p_CA_DESCRIPCION CHAR(50)
)
BEGIN
    -- Validación de tipos y restricciones aquí

    -- Intentar la actualización
    UPDATE DIRECCION
    SET
        CA_DESCRIPCION = p_CA_DESCRIPCION
    WHERE CA_CLAVE = p_CA_CLAVE;
END //
-------------------------------------------------------------------------------------------------
-- Funciones, Triggers y Procedimientos para la tabla LOTE

-- Función para verificar la existencia de un registro en LOTE
CREATE FUNCTION Existe_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM LOTE
    WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END //

-- Trigger antes de insertar en LOTE
CREATE TRIGGER before_insert_LOTE
BEFORE INSERT ON LOTE
FOR EACH ROW
BEGIN
    IF Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en LOTE';
    END IF;
END //

-- Trigger antes de actualizar en LOTE
CREATE TRIGGER before_update_LOTE
BEFORE UPDATE ON LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END //

-- Trigger antes de eliminar en LOTE
CREATE TRIGGER before_delete_LOTE
BEFORE DELETE ON LOTE
FOR EACH ROW
BEGIN
    IF NOT Existe_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
    END IF;
END //

-- Función para verificar referencias en tablas hijas para LOTE
CREATE FUNCTION TieneReferencias_LOTE(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM OtraTabla -- Reemplaza 'OtraTabla' con la tabla hija real
    WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO;
    RETURN existe;
END //

-- Trigger antes de eliminar en LOTE que verifica referencias en tablas hijas
CREATE TRIGGER before_delete_LOTE_references
BEFORE DELETE ON LOTE
FOR EACH ROW
BEGIN
    IF TieneReferencias_LOTE(OLD.L_MANZANA, OLD.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existen referencias a este registro en otras tablas';
    END IF;
END //

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
    INSERT INTO LOTE (
        L_MANZANA, L_NUMERO, L_SUPERFICIE, L_U_C, L_P, L_OBS
    ) VALUES (
        p_L_MANZANA, p_L_NUMERO, p_L_SUPERFICIE, p_L_U_C, p_L_P, p_L_OBS
    );
END //

-- Procedimiento almacenado para eliminar en LOTE
CREATE PROCEDURE Eliminar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM LOTE WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END //

-- Procedimiento almacenado para buscar en LOTE
CREATE PROCEDURE Buscar_LOTE(
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6)
)
BEGIN
    -- Validar tipos de datos
    IF p_L_MANZANA IS NULL OR p_L_NUMERO IS NULL THEN
        SELECT * FROM LOTE;
    ELSE
        IF Existe_LOTE(p_L_MANZANA, p_L_NUMERO) THEN
            SELECT * FROM LOTE WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en LOTE';
        END IF;
    END IF;
END //

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
    UPDATE LOTE
    SET
        L_SUPERFICIE = p_L_SUPERFICIE,
        L_U_C = p_L_U_C,
        L_P = p_L_P,
        L_OBS = p_L_OBS
    WHERE L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
END //

