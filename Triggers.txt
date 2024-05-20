-- Drop functions if they already exist
DROP FUNCTION IF EXISTS ExisteCliente;
DROP FUNCTION IF EXISTS ExisteLote;
DROP FUNCTION IF EXISTS ExisteStatus;
DROP FUNCTION IF EXISTS ExisteDireccion;
DROP FUNCTION IF EXISTS ExisteTipoLote;
DROP FUNCTION IF EXISTS ExisteColonoLote;

-- Create function to check if a client exists
DELIMITER //
CREATE FUNCTION ExisteCliente(CL_NUMERO DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM Clientes WHERE CL_NUMERO = CL_NUMERO);
    RETURN existe;
END //
DELIMITER ;

-- Create function to check if a lot exists
DELIMITER //
CREATE FUNCTION ExisteLote(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM Lote WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO);
    RETURN existe;
END //
DELIMITER ;

-- Create function to check if a status exists in the 'status' view
DELIMITER //
CREATE FUNCTION ExisteStatus(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM status WHERE CA_CLAVE = CA_CLAVE);
    RETURN existe;
END //
DELIMITER ;

-- Create function to check if an address exists in the 'direcciones' view
DELIMITER //
CREATE FUNCTION ExisteDireccion(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM direcciones WHERE CA_CLAVE = CA_CLAVE);
    RETURN existe;
END //
DELIMITER ;

-- Create function to check if a lot type exists in the 'tipo_lote' view
DELIMITER //
CREATE FUNCTION ExisteTipoLote(CA_CLAVE CHAR(3)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM tipo_lote WHERE CA_CLAVE = CA_CLAVE);
    RETURN existe;
END //
DELIMITER ;

-- Create function to check if a record exists in colono_lote
DELIMITER //
CREATE FUNCTION ExisteColonoLote(L_MANZANA CHAR(3), L_NUMERO CHAR(6)) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SET existe = EXISTS (SELECT 1 FROM Colono_Lote WHERE L_MANZANA = L_MANZANA AND L_NUMERO = L_NUMERO);
    RETURN existe;
END //
DELIMITER ;

-- Drop triggers if they already exist
DROP TRIGGER IF EXISTS BeforeInsertColonoLote;
DROP TRIGGER IF EXISTS BeforeInsertLote;
DROP TRIGGER IF EXISTS BeforeInsertCargos;

-- Create trigger before inserting into colono_lote to check client and lot
DELIMITER //
CREATE TRIGGER BeforeInsertColonoLote
BEFORE INSERT ON Colono_Lote
FOR EACH ROW
BEGIN
    IF NOT ExisteCliente(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;
    IF NOT ExisteLote(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El lote no existe';
    END IF;
END //
DELIMITER ;

-- Create trigger before inserting into lote to check status, address and lot type
DELIMITER //
CREATE TRIGGER BeforeInsertLote
BEFORE INSERT ON Lote
FOR EACH ROW
BEGIN
    IF NOT ExisteStatus(NEW.CA_CLAVE0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El status no existe';
    END IF;
    IF NOT ExisteDireccion(NEW.CA_CLAVE1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La dirección no existe';
    END IF;
    IF NOT ExisteTipoLote(NEW.CA_CLAVE2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de lote no existe';
    END IF;
END //
DELIMITER ;

-- Create trigger before inserting into cargos to check colono_lote record
DELIMITER //
CREATE TRIGGER BeforeInsertCargos
BEFORE INSERT ON Cargos
FOR EACH ROW
BEGIN
    IF NOT ExisteColonoLote(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro en colono_lote no existe';
    END IF;
END //
DELIMITER ;
