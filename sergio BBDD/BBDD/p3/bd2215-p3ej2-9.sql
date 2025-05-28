/*
Asignatura: Bases de Datos
Curso: 2024/25

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd2215
 Integrante 1: Angel Ruiz Fernandez
 Integrante 2: 
*/

--------------------------------------------------------------------------------------
-- EJERCICIO 2. Annadir / Eliminar columnas

-- a

ALTER TABLE MENSAJE ADD texto VARCHAR(35);

-- b

ALTER TABLE MIUSUARIO ADD numero_mensajes NUMERIC(3) DEFAULT 0 NOT NULL;

-- c

ALTER TABLE MIUSUARIO DROP COLUMN descripcion;

--------------------------------------------------------------------------------------
-- EJERCICIO 3. Modificar valores de una columna 

-- a

UPDATE MIUSUARIO U SET numero_mensajes  = (
    SELECT COUNT(*)
    FROM MENSAJE M
    WHERE M.usuario = U.telefono
);

COMMIT;

-- b

UPDATE MENSAJE M SET texto = 'CHAT ANTIGUO: VALORA SU BORRADO'
WHERE M.mensaje_id IN (
    SELECT C.msj_anclado
    FROM CHAT_GRUPO C
    WHERE (
        SELECT MAX(M2.diahora)
        FROM MENSAJE M2
        WHERE M2.chat_grupo = C.codigo
    ) < TO_DATE('03/04/2024','DD/MM/YYYY')
);

-- c

SELECT *
FROM MENSAJE M
WHERE M.mensaje_id IN (
SELECT C.msj_anclado
    FROM CHAT_GRUPO C
    WHERE (
        SELECT MAX(M2.diahora)
        FROM MENSAJE M2
        WHERE M2.chat_grupo = C.codigo
    ) < TO_DATE('03/04/2024','DD/MM/YYYY')
);

-- d

ROLLBACK;

SELECT *
FROM MENSAJE M
WHERE M.mensaje_id IN (
SELECT C.msj_anclado
    FROM CHAT_GRUPO C
    WHERE (
        SELECT MAX(M2.diahora)
        FROM MENSAJE M2
        WHERE M2.chat_grupo = C.codigo
    ) < TO_DATE('03/04/2024','DD/MM/YYYY')
);

--------------------------------------------------------------------------------------
-- EJERCICIO 4. Modificar el valor de una clave primaria 

-- a

ALTER TABLE CONTACTO DISABLE CONSTRAINT contacto_fk_usuario;
ALTER TABLE EMAIL_CONTACTO DISABLE CONSTRAINT email_contacto_fk_contacto_usuario;
ALTER TABLE MENSAJE DISABLE CONSTRAINT mensaje_fk_usuario;
ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT chat_grupo_fk_administrador;
ALTER TABLE PARTICIPACION DISABLE CONSTRAINT participacion_fk_usuario;

UPDATE CONTACTO SET usuario = '610000004' WHERE usuario = '600000004';
UPDATE EMAIL_CONTACTO SET usuario = '610000004' WHERE usuario = '600000004';
UPDATE MENSAJE SET usuario = '610000004' WHERE usuario = '600000004';
UPDATE CHAT_GRUPO SET administrador = '610000004' WHERE administrador = '600000004';
UPDATE PARTICIPACION SET usuario = '610000004' WHERE usuario = '600000004';

UPDATE MIUSUARIO SET telefono = '610000004' WHERE telefono = '600000004';

ALTER TABLE CONTACTO ENABLE CONSTRAINT contacto_fk_usuario;
ALTER TABLE EMAIL_CONTACTO ENABLE CONSTRAINT email_contacto_fk_contacto_usuario;
ALTER TABLE MENSAJE ENABLE CONSTRAINT mensaje_fk_usuario;
ALTER TABLE CHAT_GRUPO ENABLE CONSTRAINT chat_grupo_fk_administrador;
ALTER TABLE PARTICIPACION ENABLE CONSTRAINT participacion_fk_usuario;

-- b

SELECT * FROM MIUSUARIO WHERE telefono = '610000004';
SELECT * FROM CONTACTO WHERE usuario = '610000004';
SELECT * FROM EMAIL_CONTACTO WHERE usuario = '610000004';
SELECT * FROM MENSAJE WHERE usuario = '610000004';
SELECT * FROM CHAT_GRUPO WHERE administrador = '610000004';
SELECT * FROM PARTICIPACION WHERE usuario = '610000004';

COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 5. Borrar algunas filas de una tabla.

-- a

SELECT M.mensaje_id
FROM MENSAJE M
WHERE
    M.diahora < TO_DATE('10/02/2025','DD/MM/YYYY') AND
    M.mensaje_id NOT IN (
        SELECT C.msj_anclado
        FROM CHAT_GRUPO C
    ) AND
    M.msj_original IS NOT NULL AND
    M.chat_grupo IN (
        SELECT P.chat_grupo
        FROM PARTICIPACION P
        GROUP BY P.chat_grupo
        HAVING COUNT(*) > 3
    ) AND
    M.usuario IN (
        SELECT P2.usuario
        FROM PARTICIPACION P2
        GROUP BY P2.usuario
        HAVING COUNT(*) < 4
    );
    
DELETE
FROM MENSAJE M
WHERE
    M.diahora < TO_DATE('10/02/2025','DD/MM/YYYY') AND
    M.mensaje_id NOT IN (
        SELECT C.msj_anclado
        FROM CHAT_GRUPO C
    ) AND
    M.msj_original IS NOT NULL AND
    M.chat_grupo IN (
        SELECT P.chat_grupo
        FROM PARTICIPACION P
        GROUP BY P.chat_grupo
        HAVING COUNT(*) > 3
    ) AND
    M.usuario IN (
        SELECT P2.usuario
        FROM PARTICIPACION P2
        GROUP BY P2.usuario
        HAVING COUNT(*) < 4
    );
    
COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 6. Borrar algunas filas de varias tablas.

-- a

-- para borra mensajes hay que quitar constraint de anclado

ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT chat_grupo_fk_msj_anclado;

-- primero borrar los que responden a mensajes

DELETE
FROM MENSAJE M
WHERE M.chat_grupo = 'C004' AND M.msj_original IS NOT NULL;

-- despues borrar todos (los sin relacionar y los que no tenian respuesta)

DELETE
FROM MENSAJE M
WHERE M.chat_grupo = 'C004';

-- borrar participaciones

DELETE
FROM PARTICIPACION P
WHERE P.chat_grupo = 'C004';

-- borrar grupo en si mismo

DELETE
FROM CHAT_GRUPO C
WHERE C.codigo = 'C004';

-- reactivar constraint

ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT chat_grupo_fk_msj_anclado;

--------------------------------------------------------------------------------------
-- EJERCICIO 7. Crear y manipular una vista.

-- a

CREATE VIEW INTERACCION_ADMIN AS
    SELECT U.telefono tel_admin, U.nombre nom_admin, U.fecha_registro f_registro, C.nombre nom_chat, A.n_mensajes
    FROM CHAT_GRUPO C
    JOIN MIUSUARIO U ON C.administrador = U.telefono
    INNER JOIN (
        SELECT M.usuario, M.chat_grupo, COUNT(*) n_mensajes
        FROM MENSAJE M
        GROUP BY M.chat_grupo, M.usuario
    ) A ON A.usuario = U.telefono AND A.chat_grupo = C.codigo;

-- b

SELECT *
FROM INTERACCION_ADMIN;

-- c

DROP VIEW INTERACCION_ADMIN;

CREATE VIEW INTERACCION_ADMIN AS
    SELECT U.telefono tel_admin, U.nombre nom_admin, C.nombre nom_chat, A.n_mensajes, B.total_mensajes
    FROM CHAT_GRUPO C
    JOIN MIUSUARIO U ON C.administrador = U.telefono
    INNER JOIN (
        SELECT M.usuario, M.chat_grupo, COUNT(*) n_mensajes
        FROM MENSAJE M
        GROUP BY M.chat_grupo, M.usuario
    ) A ON A.usuario = U.telefono AND A.chat_grupo = C.codigo
    INNER JOIN (
        SELECT M2.chat_grupo, COUNT(*) total_mensajes
        FROM MENSAJE M2
        GROUP BY M2.chat_grupo
    ) B ON B.chat_grupo = C.codigo;

SELECT *
FROM INTERACCION_ADMIN;

-- d

INSERT INTO MENSAJE (usuario, chat_grupo, mensaje_id, texto) VALUES
    ('600000008', 'C007', 'MSJ00701', 'Q deberes puso la de mates?');
    
INSERT INTO MENSAJE (usuario, chat_grupo, mensaje_id, msj_original, texto) VALUES
    ('600000011', 'C007', 'MSJ00702', 'MSJ00701', 'Toda la pagina 36 del libro');

-- e
    
SELECT *
FROM INTERACCION_ADMIN;

-- Si, porque la view es como un alias a una query, es como hacer un select, y la select toma cambios sin commitear

COMMIT;

SELECT *
FROM INTERACCION_ADMIN;
