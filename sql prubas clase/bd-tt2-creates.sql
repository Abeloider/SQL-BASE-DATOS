-- TUTORIAL de SQL Developer
-- Ejercicio de creacion de tablas 
/*
 *** Realizacion del tutorial con un PC propio ***
 Este script debe ser ejecutado por una cuenta de usuario no administrador 
*/

-- Sentencias de eliminacion de tablas, para poder ejecutar 
-- varias veces los CREATE o para eliminar las tablas
-- una vez terminado el tutorial
-- Dan error si no se han creado las tablas, claro.
DROP TABLE AUTORIZADO;
DROP TABLE CUENTA;
DROP TABLE CLIENTE;

-- Creacion de tablas del esquema

CREATE TABLE CLIENTE (
   codigo    CHAR(4)     NOT NULL,
   nombre    VARCHAR(20) NOT NULL,
   direccion VARCHAR(20),
   ciudad    VARCHAR(20),
   PRIMARY KEY(codigo)
);

CREATE TABLE CUENTA (
   numero  NUMBER(5)   NOT NULL, 
   saldo   NUMBER(7,2) NOT NULL,
   cliente CHAR(4)     NOT NULL,
   tipo    CHAR(10)    NOT NULL,
   PRIMARY KEY(numero),
   FOREIGN KEY (cliente) REFERENCES CLIENTE(codigo),
   CHECK (tipo IN ('Debito', 'Credito', 'Nomina', 'Joven'))
);

/*
Incluye aqui la sentencia CREATE que permita crear 
la tabla AUTORIZADO que tiene esta ficha de descripcion:

AUTORIZADO (cuenta, cliente, fecha_inicio)
Admiten nulos: -ninguno-
Clave primaria: (cuenta, cliente)
Claves ajenas:
   1. cliente Referencia_a CLIENTE(codigo)
   2. cuenta  Referencia_a CUENTA(numero)

Indicaciones:
* El tipo de datos de una clave ajena debe ser el mismo
  que el de la clave primaria a la que referencia
* El tipo de datos de "fecha_inicio" ha de ser DATE
* Recuerda terminar tu sentencia con un ;

*/

drop table autorizado;
CREATE TABLE AUTORIZADO (
    cuenta      NUMBER(5)   NOT NULL,
    cliente     CHAR(4)     NOT NULL,
    fecha_inicio      DATE        NOT NULL,
    PRIMARY KEY (cuenta, cliente),
    FOREIGN KEY (cliente) REFERENCES CLIENTE(codigo), 
    FOREIGN KeY (cuenta)  REFERENCES CUENTA(numero)
);


