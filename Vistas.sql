CREATE VIEW status as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 0;

CREATE VIEW direccion as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 1;

CREATE VIEW tipo_lote as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 2;