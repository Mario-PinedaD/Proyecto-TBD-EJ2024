DROP TABLE IF EXISTS `CARGOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CARGOS` (
  `CAR_FOLIO` char(10) NOT NULL COMMENT 'Folio del Cargo',
  `ANT_DOCTO_CC_ID` double NOT NULL COMMENT 'Numero del Cargo anterior',
  `L_MANZANA` char(3) NOT NULL COMMENT 'Folio del Cargo',
  `L_NUMERO` char(6) NOT NULL COMMENT 'Folio del Cargo',
  `CON_CLAVE` smallint(6) DEFAULT NULL COMMENT 'Clave del concepto del Ingreso CONTABIL.Conc_in',
  `CAR_FECHA` datetime NOT NULL COMMENT 'Fecha del Cargo',
  `CAR_IMPORTE` double DEFAULT NULL COMMENT 'IMPORTE del Cargo',
  `CAR_IVA` double DEFAULT '0' COMMENT 'Monto del IVA',
  `CAR_DESCRIPCION` char(100) DEFAULT NULL COMMENT 'Folio del Cargo',
  `CL_NUMERO` double DEFAULT NULL COMMENT 'Numero de Colono ACTUAL',
  `CAR_POLIZA_PRO` char(8) DEFAULT NULL COMMENT 'Numero de Poliza de DIIARIOS ',
  `ANT_CLIENTE_ID` int(11) DEFAULT NULL COMMENT 'Numero de Colono antes',
  `ANT_CONC_CC_ID` int(11) DEFAULT '0' COMMENT 'CLAVE del concepto Anterior CONCEPTO_CC_ID',
  `CAR_FECHA_VENCE` datetime DEFAULT NULL,
  `CAR_DESCUENTO` double DEFAULT NULL,
  `CAR_INICIO` smallint(6) DEFAULT '0',
  PRIMARY KEY (`CAR_FOLIO`,`ANT_DOCTO_CC_ID`) USING BTREE,
  KEY `Idx_Lote` (`L_MANZANA`,`L_NUMERO`),
  KEY `FK_CONCEPTO` (`CON_CLAVE`),
  KEY `CAR_FOLIO` (`CAR_FOLIO`),
  KEY `Index_CARGOFECHA` (`CAR_FECHA`),
  KEY `FK_COLONO_CAR` (`CL_NUMERO`,`L_MANZANA`,`L_NUMERO`) USING BTREE,
  CONSTRAINT `FK_COLONO` FOREIGN KEY (`L_MANZANA`, `L_NUMERO`) REFERENCES `colono_lote` (`L_MANZANA`, `L_NUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Catalogo_COL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Catalogo_COL` (
  `CA_CLAVE` char(3) NOT NULL DEFAULT '' COMMENT '0 (0,1,2,3,4,5,6) 1(P..,G..,C..) ',
  `CA_TIPO` smallint(6) DEFAULT NULL COMMENT '0 STATUS, 1 CALLE, 2 TIPO',
  `CA_DESCRIPCION` char(30) DEFAULT NULL,
  `CA_IMPORTE` double DEFAULT NULL,
  `CON_CLAVE` smallint(6) DEFAULT NULL COMMENT 'Clave del concepto en CONTABILIDA Conc_in',
  PRIMARY KEY (`CA_CLAVE`),
  KEY `Idx_Catatalogo` (`CA_TIPO`,`CA_CLAVE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Clientes` (
  `CL_NUMERO` double NOT NULL DEFAULT '1',
  `CL_TERR` smallint(6) DEFAULT '0',
  `CL_NOM` char(200) DEFAULT NULL,
  `CL_CONT` char(200) DEFAULT NULL,
  `CL_DIREC` char(100) DEFAULT NULL,
  `CL_CIUD` char(50) DEFAULT 'MEDELLIN DE BRAVO',
  `CL_COLONIA` char(100) DEFAULT NULL,
  `CL_CP` float DEFAULT '94274',
  `CL_LADA` float DEFAULT NULL,
  `CL_TELEF` char(50) DEFAULT NULL,
  `CL_DSCTO` float DEFAULT NULL,
  `CL_DPAGO` smallint(6) DEFAULT NULL,
  `CL_DCRED` smallint(6) DEFAULT NULL,
  `CL_FPAGO` datetime DEFAULT NULL,
  `CL_FULTR` datetime DEFAULT NULL,
  `CL_CRED` float DEFAULT NULL,
  `CL_SALDO` float DEFAULT NULL,
  `CL_RFC` char(13) DEFAULT NULL,
  `CL_CURP` char(18) DEFAULT NULL,
  `CL_GIRO` char(100) DEFAULT NULL,
  `CL_CUOTA` float DEFAULT '0',
  `CL_LOCALIDAD` smallint(6) DEFAULT NULL,
  `CL_FISM` smallint(6) DEFAULT NULL,
  `CL_FAFM` smallint(6) DEFAULT NULL,
  `CL_MUNICIPIO` char(100) DEFAULT NULL,
  `CL_ESTADO` char(100) DEFAULT NULL,
  `CL_LOCALIDAD_FACT` char(100) DEFAULT NULL,
  `CL_NUM_INT` char(15) DEFAULT NULL,
  `CL_NUM_EXT` char(15) DEFAULT NULL,
  `CL_MAIL` char(100) DEFAULT NULL,
  `C_CTA` smallint(6) DEFAULT NULL,
  `C_SCTA1` int(11) DEFAULT NULL,
  `C_SCTA2` int(11) DEFAULT NULL,
  `C_SCTA3` double DEFAULT NULL,
  `C_SCTA4` int(11) DEFAULT NULL,
  `CL_CONTACTO` char(50) DEFAULT NULL,
  `CL_BANCO` char(50) DEFAULT NULL,
  `CL_CTA_BANCO` char(20) DEFAULT NULL,
  `CL_CLABE_BANCO` char(20) DEFAULT NULL,
  `CL_FECHA_BAJA` datetime DEFAULT NULL,
  PRIMARY KEY (`CL_NUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Colono_Lote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Colono_Lote` (
  `CL_NUMERO` double NOT NULL DEFAULT '0' COMMENT 'Clave del Colono (Tabla Clientes)',
  `L_MANZANA` char(3) NOT NULL DEFAULT '' COMMENT 'M..Palmas, G.. Green, B.. Fit',
  `L_NUMERO` char(6) NOT NULL DEFAULT '' COMMENT 'Numero del Lote',
  `CL_TELEFONO` char(35) DEFAULT NULL COMMENT 'Telefonos',
  `CL_MAIL` char(100) DEFAULT NULL,
  `CL_IMPORTE` double DEFAULT NULL,
  `CL_FECHA_ALTA` datetime DEFAULT NULL,
  `CL_FECHA_BAJA` datetime DEFAULT NULL,
  `CL_COMENTARIO` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`CL_NUMERO`,`L_MANZANA`,`L_NUMERO`),
  KEY `FK_Colono_Lote` (`L_MANZANA`,`L_NUMERO`),
  KEY `In_Manz` (`L_MANZANA`),
  KEY `Ind_Lote` (`L_NUMERO`),
  CONSTRAINT `FK_Cliente` FOREIGN KEY (`CL_NUMERO`) REFERENCES `clientes` (`CL_NUMERO`),
  CONSTRAINT `FK_Colono_Lote` FOREIGN KEY (`L_MANZANA`, `L_NUMERO`) REFERENCES `lote` (`L_MANZANA`, `L_NUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Lote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Lote` (
  `L_MANZANA` char(3) NOT NULL DEFAULT '' COMMENT 'M..Palmas, G.. Green, B.. Fit',
  `L_NUMERO` char(6) NOT NULL DEFAULT '' COMMENT 'L...',
  `CA_CLAVE1` char(3) DEFAULT NULL COMMENT 'Nombre de la Direccion',
  `CA_CLAVE2` char(3) DEFAULT NULL COMMENT 'LTA 240(10x24),LTB 240(12x20),LTC 200(10x20),LTD 225,LGA 250,LGB 245,LGC 200',
  `CA_CLAVE0` char(3) DEFAULT NULL COMMENT '0 BALDIO1 CASA,2 JARDIN,3 CONSTRUCION,4 DEPTO,5 INCONCLUSA,6 LOCAL',
  `L_TOTAL_M2` double DEFAULT NULL,
  `L_IMPORTE` double DEFAULT NULL,
  `L_NUM_EXT` char(6) DEFAULT NULL,
  `L_PAHT_MAP` char(150) DEFAULT NULL,
  `L_FECHA_MANT` datetime DEFAULT NULL COMMENT 'Ultima fecha de Mantenimiento',
  `L_FECHA_POSIBLE` datetime DEFAULT NULL,
  PRIMARY KEY (`L_MANZANA`,`L_NUMERO`),
  KEY `FK_STATUS_Lote` (`CA_CLAVE0`),
  KEY `FK_CALLE_Lote` (`CA_CLAVE1`),
  KEY `FK_Tipo_Lote` (`CA_CLAVE2`),
  CONSTRAINT `FK_CALLE_Lote` FOREIGN KEY (`CA_CLAVE1`) REFERENCES `catalogo_col` (`CA_CLAVE`),
  CONSTRAINT `FK_STATUS_Lote` FOREIGN KEY (`CA_CLAVE0`) REFERENCES `catalogo_col` (`CA_CLAVE`),
  CONSTRAINT `FK_Tipo_Lote` FOREIGN KEY (`CA_CLAVE2`) REFERENCES `catalogo_col` (`CA_CLAVE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

CREATE VIEW status as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion ,CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 0;

CREATE VIEW direccion as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 1;

CREATE VIEW tipo_lote as
    SELECT CA_CLAVE as clave_catalogo ,CA_DESCRIPCION as descripcion, CA_IMPORTE as importe ,CON_CLAVE as clave_contab FROM Catalogo_COL WHERE CA_TIPO = 2;