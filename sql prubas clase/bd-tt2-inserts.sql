-- TUTORIAL de SQL Developer

/*
 *** Realizacion del tutorial con un PC propio ***
 Este script debe ser ejecutado por una cuenta de usuario no administrador 
*/

-- Introduccion de datos en las tablas.
-- Observe que las cadenas de caracteres necesitan comillas simples.
   
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad) 
  VALUES ('C210', 'Garcia, A.', 'Gran Via, 6', 'Murcia');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad)
  VALUES ('C300', 'Lopez, B.', 'Ronda Norte, 3', 'Murcia');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad)
  VALUES ('C003', 'Azorin, C.', 'Paseo Rosales, 9', 'Molina');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad)
  VALUES ('C689', 'Perez, D.', 'Plaza Mayor, 2', 'Cieza');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad) 
  VALUES ('C333', 'Gomez, F.', 'Ronda Este, 6', 'Patino');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad)
  VALUES ('C220', 'Sanchez, E.', 'Costera baja, 5', 'Aljucer');
INSERT INTO CLIENTE (codigo, nombre, direccion, ciudad)
  VALUES ('C100', 'Hita, G.', 'Plaza Chica, 7', 'Casillas');

INSERT INTO CUENTA (numero, saldo, cliente, tipo) 
  VALUES(200, 85005, 'C689', 'Debito');
INSERT INTO CUENTA (numero, saldo, cliente, tipo)
  VALUES(505, 40000, 'C003', 'Credito');
INSERT INTO CUENTA (numero, saldo, cliente, tipo)
  VALUES(821, 50000, 'C210', 'Joven');
INSERT INTO CUENTA (numero, saldo, cliente, tipo)
  VALUES(426, 35620, 'C003', 'Debito');
INSERT INTO CUENTA (numero, saldo, cliente, tipo)
  VALUES(105, 29872, 'C300', 'Nomina');

INSERT INTO AUTORIZADO(cuenta, cliente, fecha_inicio) 
  VALUES(505, 'C220', TO_DATE('11/01/2021', 'dd/mm/yyyy'));
INSERT INTO AUTORIZADO(cuenta, cliente, fecha_inicio) 
  VALUES(505, 'C300', TO_DATE('22/02/2022', 'dd/mm/yyyy'));
INSERT INTO AUTORIZADO(cuenta, cliente, fecha_inicio) 
  VALUES(821, 'C100', TO_DATE('03/03/2023', 'dd/mm/yyyy'));
INSERT INTO AUTORIZADO(cuenta, cliente, fecha_inicio)
  VALUES(505, 'C333', TO_DATE('04/04/2024', 'dd/mm/yyyy'));

-- Confirmacion de los datos introducidos: los hace permanentes en la BD.
COMMIT;