-- Select de Clientes

CREATE PROCEDURE Select_Clientes(IN p_CL_NUMERO DOUBLE)
BEGIN
    IF p_CL_NUMERO IS NULL THEN
        -- Caso 3: Si CL_NUMERO es NULL, mostrar todos los datos
        SELECT * FROM clientes;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM clientes WHERE CL_NUMERO = p_CL_NUMERO) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CL_NUMERO, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM clientes WHERE CL_NUMERO = p_CL_NUMERO;
        END IF;
    END IF;
END //

CREATE PROCEDURE Select_Catalogo_COL(IN p_CA_CLAVE CHAR(3))
BEGIN
    IF p_CA_CLAVE IS NULL THEN
        -- Caso 3: Si CA_CLAVE es NULL, mostrar todos los datos
        -- Falta darle "Formato"
        SELECT * FROM catalogo_col;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM catalogo_col WHERE CA_CLAVE = p_CA_CLAVE) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CA_CLAVE, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM catalogo_col WHERE CA_CLAVE = p_CA_CLAVE;
        END IF;
    END IF;
END //

CREATE PROCEDURE Select_Colono_Lote(IN p_CL_NUMERO DOUBLE, IN p_L_MANZANA CHAR(3), IN p_L_NUMERO CHAR(6))
BEGIN
    IF p_CL_NUMERO IS NULL AND p_L_MANZANA IS NULL AND p_L_NUMERO IS NULL THEN
        -- Caso 3: Si todos los parámetros son NULL, mostrar todos los datos
        SELECT * FROM colono_lote;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM colono_lote WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CL_NUMERO, '-', p_L_MANZANA, '-', p_L_NUMERO, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM colono_lote WHERE CL_NUMERO = p_CL_NUMERO AND L_MANZANA = p_L_MANZANA AND L_NUMERO = p_L_NUMERO;
        END IF;
    END IF;
END //

--Select de la tabla de cargos:

CREATE PROCEDURE Select_Cargos(IN p_CL_NUMERO DOUBLE)
BEGIN
    IF p_CL_NUMERO IS NULL THEN
        -- Caso 3: Si CL_NUMERO es NULL, mostrar todos los dato
        -- Falta darle formato a la tabla
        SELECT * FROM cargos;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM cargos WHERE CL_NUMERO = p_CL_NUMERO) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('El numero de cliente: ', p_CL_NUMERO, ', no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            -- Falta darle formato a la tabla
            SELECT * FROM cargos WHERE CL_NUMERO = p_CL_NUMERO;
        END IF;
    END IF;
END //


CREATE PROCEDURE Select_Clientes(IN p_CL_NUMERO DOUBLE)
BEGIN
    IF p_CL_NUMERO IS NULL THEN
        -- Caso 3: Si CL_NUMERO es NULL, mostrar todos los datos
        SELECT * FROM clientes;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM clientes WHERE CL_NUMERO = p_CL_NUMERO) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CL_NUMERO, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM clientes WHERE CL_NUMERO = p_CL_NUMERO;
        END IF;
    END IF;
END //

CREATE PROCEDURE Select_Status(IN p_CA_CLAVE CHAR(3))
BEGIN
    IF p_CA_CLAVE IS NULL THEN
        -- Caso 3: Si CA_CLAVE es NULL, mostrar todos los datos
        -- Falta darle "Formato"
        SELECT * FROM status;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM status WHERE CA_CLAVE = p_CA_CLAVE) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CA_CLAVE, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM catalogo_col WHERE CA_CLAVE = p_CA_CLAVE;
        END IF;
    END IF;
END //

CREATE PROCEDURE Select_Direccion(IN p_CA_CLAVE CHAR(3))
BEGIN
    IF p_CA_CLAVE IS NULL THEN
        -- Caso 3: Si CA_CLAVE es NULL, mostrar todos los datos
        -- Falta darle "Formato"
        SELECT * FROM direccion;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM direccion WHERE CA_CLAVE = p_CA_CLAVE) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CA_CLAVE, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM direccion WHERE CA_CLAVE = p_CA_CLAVE;
        END IF;
    END IF;
END //

CREATE PROCEDURE Select_Tipo_Lote(IN p_CA_CLAVE CHAR(3))
BEGIN
    IF p_CA_CLAVE IS NULL THEN
        -- Caso 3: Si CA_CLAVE es NULL, mostrar todos los datos
        -- Falta darle "Formato"
        SELECT * FROM tipo_lote;
    ELSE
        -- Caso 1: Verificar si la llave no existe
        IF (SELECT COUNT(*) FROM tipo_lote WHERE CA_CLAVE = p_CA_CLAVE) = 0 THEN
            -- Mensaje indicando que la llave no existe
            SELECT CONCAT('La llave ', p_CA_CLAVE, ' no existe') AS mensaje;
        ELSE
            -- Caso 2: La llave existe, mostrar los registros correspondientes
            SELECT * FROM tipo_lote WHERE CA_CLAVE = p_CA_CLAVE;
        END IF;
    END IF;
END //