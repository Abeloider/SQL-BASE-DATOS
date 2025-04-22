/* TUTORIAL de SQL Developer
Consultas que acceden a las tablas del esquema de Clientes y Cuentas
*/

-- Todas las cuentas
SELECT * 
FROM CUENTA;

-- Todos los clientes
SELECT * 
FROM CLIENTE;

-- Clientes de Murcia
-- Lo encerrado entre comillas simples es un literal y distingue mayusculas/minusculas. 
SELECT *
FROM CLIENTE
WHERE ciudad = 'Murcia';

-- Nombre, direccion y ciudad de clientes que NO viven en Murcia
SELECT nombre, direccion, ciudad
FROM CLIENTE
WHERE ciudad <> 'Murcia'; -- Tambien valdria !=

-- Numero de cada cuenta y codigo y nombre del cliente titular
SELECT Q.numero, C.codigo, C.nombre 
FROM CLIENTE C JOIN CUENTA Q 
               ON (C.codigo = Q.cliente);

-- Nombre de los clientes autorizados en la cuenta 505.
SELECT nombre
FROM CLIENTE
WHERE codigo IN
    (SELECT cliente
     FROM AUTORIZADO
     WHERE cuenta = 505);
	 
-- Clientes no autorizados en ninguna cuenta
SELECT nombre
FROM CLIENTE
WHERE codigo NOT IN
     (SELECT cliente
      FROM AUTORIZADO);

-- Clientes titulares de cuentas de ahorro y el saldo de las cuentas
SELECT C.nombre, Q.numero, Q.saldo
FROM CLIENTE C JOIN CUENTA Q 
               ON C.codigo = Q.cliente
WHERE Q.tipo = 'Debito';