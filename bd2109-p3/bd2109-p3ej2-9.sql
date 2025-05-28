-- CABECERA
/*
Asignatura: Bases de Datos
Curso: 2024/25
Práctica: P3. Definición y Modificación de Datos en SQL
Equipo de prácticas: bd2109
Integrante 1: Abelwancheng JiagnWan
Integrante 2: Francisco Tornell Mingot
*/

-- EJERCICIO 2. Añadir / Eliminar columnas

ALTER TABLE MENSAJE ADD (texto VARCHAR2(35));
ALTER TABLE MIUSUARIO ADD (numero_mensajes NUMBER(3) DEFAULT 0 NOT NULL);
ALTER TABLE MIUSUARIO DROP COLUMN descripcion;

-- EJERCICIO 3. Modificar valores de una columna

UPDATE MIUSUARIO m
SET numero_mensajes = (
    SELECT COUNT(*)
    FROM MENSAJE e
    WHERE e.usuario = m.telefono
);
COMMIT;

UPDATE MENSAJE e
SET texto = 'CHAT ANTIGUO: VALORA SU BORRADO'
WHERE e.mensaje_id IN (
    SELECT mensaje_anclado_id
    FROM CHAT_GRUPO
    WHERE fecha_creacion < TO_DATE('03/04/2024','dd/mm/yyyy')
);

SELECT mensaje_id, texto
FROM MENSAJE
WHERE mensaje_id IN (
    SELECT mensaje_anclado_id
    FROM CHAT_GRUPO
    WHERE fecha_creacion < TO_DATE('03/04/2024','dd/mm/yyyy')
);

ROLLBACK;

SELECT mensaje_id, texto
FROM MENSAJE
WHERE mensaje_id IN (
    SELECT mensaje_anclado_id
    FROM CHAT_GRUPO
    WHERE fecha_creacion < TO_DATE('03/04/2024','dd/mm/yyyy')
);

-- EJERCICIO 4. Modificar el valor de una clave primaria

-- Desactivación de restricciones si has nombrado alguna explícitamente
-- Asegúrate de usar los nombres reales de tus constraints si los definiste
ALTER TABLE MENSAJE DISABLE ALL TRIGGERS;
ALTER TABLE CHAT_GRUPO DISABLE ALL TRIGGERS;
ALTER TABLE CONTACTO DISABLE ALL TRIGGERS;
ALTER TABLE EMAIL_CONTACTO DISABLE ALL TRIGGERS;
ALTER TABLE PARTICIPACION DISABLE ALL TRIGGERS;

UPDATE MENSAJE SET usuario = 610000004 WHERE usuario = 600000004;
UPDATE CHAT_GRUPO SET administrador = 610000004 WHERE administrador = 600000004;
UPDATE CONTACTO SET usuario = 610000004 WHERE usuario = 600000004;
UPDATE EMAIL_CONTACTO SET usuario = 610000004 WHERE usuario = 600000004;
UPDATE PARTICIPACION SET usuario = 610000004 WHERE usuario = 600000004;
UPDATE MIUSUARIO SET telefono = 610000004 WHERE telefono = 600000004;

ALTER TABLE MENSAJE ENABLE ALL TRIGGERS;
ALTER TABLE CHAT_GRUPO ENABLE ALL TRIGGERS;
ALTER TABLE CONTACTO ENABLE ALL TRIGGERS;
ALTER TABLE EMAIL_CONTACTO ENABLE ALL TRIGGERS;
ALTER TABLE PARTICIPACION ENABLE ALL TRIGGERS;

COMMIT;

-- Comprobaciones
SELECT * FROM MIUSUARIO WHERE telefono = 610000004;
SELECT * FROM MENSAJE WHERE usuario = 610000004;
SELECT * FROM CHAT_GRUPO WHERE administrador = 610000004;
SELECT * FROM CONTACTO WHERE usuario = 610000004;
SELECT * FROM EMAIL_CONTACTO WHERE usuario = 610000004;
SELECT * FROM PARTICIPACION WHERE usuario = 610000004;

-- EJERCICIO 5. Borrar algunas filas de una tabla
-- Selección de filas a borrar (verificación)
SELECT m.mensaje_id
FROM MENSAJE m
WHERE m.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
  AND m.msj_original IS NULL
  AND NOT EXISTS (
      SELECT 1 
      FROM CHAT_GRUPO cg 
      WHERE cg.mensaje_anclado_id = m.mensaje_id
  )
  AND EXISTS (
      SELECT 1 
      FROM CHAT_GRUPO cg 
      WHERE cg.codigo = m.chat_grupo 
        AND cg.miembros > 3
  )
  AND m.usuario IN (
      SELECT p.usuario 
      FROM PARTICIPACION p 
      GROUP BY p.usuario 
      HAVING COUNT(p.chat_grupo) < 4
  );

-- Sentencia DELETE corregida
DELETE FROM MENSAJE m
WHERE m.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
  AND m.msj_original IS NULL
  AND NOT EXISTS (
      SELECT 1 
      FROM CHAT_GRUPO cg 
      WHERE cg.mensaje_anclado_id = m.mensaje_id
  )
  AND EXISTS (
      SELECT 1 
      FROM CHAT_GRUPO cg 
      WHERE cg.codigo = m.chat_grupo 
        AND cg.miembros > 3
  )
  AND m.usuario IN (
      SELECT p.usuario 
      FROM PARTICIPACION p 
      GROUP BY p.usuario 
      HAVING COUNT(p.chat_grupo) < 4
  );

COMMIT

-- EJERCICIO 6. Borrar datos relacionados a un chat

-- Deshabilitar restricciones usando los nombres correctos (verificar en el esquema)
ALTER TABLE MENSAJE DISABLE CONSTRAINT id_chat; -- Nombre real de la FK a CHAT_GRUPO
ALTER TABLE MENSAJE DISABLE CONSTRAINT tlf_usuario; -- Si es necesario
ALTER TABLE PARTICIPACION DISABLE CONSTRAINT participacion_fk_chatgrupo;

-- Eliminar referencias al mensaje anclado
UPDATE CHAT_GRUPO SET mensaje_anclado_id = NULL WHERE codigo = 'C004';

-- Borrar en orden de dependencia
DELETE FROM MENSAJE WHERE chat_grupo = 'C004';
DELETE FROM PARTICIPACION WHERE chat_grupo = 'C004';
DELETE FROM CHAT_GRUPO WHERE codigo = 'C004';

-- Reactivar restricciones
ALTER TABLE MENSAJE ENABLE CONSTRAINT id_chat;
ALTER TABLE MENSAJE ENABLE CONSTRAINT tlf_usuario;
ALTER TABLE PARTICIPACION ENABLE CONSTRAINT participacion_fk_chatgrupo;
COMMIT;


-- EJERCICIO 7. Crear y manipular una vista


-- Crear vista sin referencia circular
CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    cg.administrador AS tel_admin,
    mu.nombre AS nom_admin,
    cg.nombre AS nom_chat,
    COUNT(CASE WHEN m.usuario = cg.administrador THEN 1 END) AS n_mensajes,
    COUNT(m.mensaje_id) AS total_mensajes
FROM CHAT_GRUPO cg
JOIN MIUSUARIO mu ON cg.administrador = mu.telefono
LEFT JOIN MENSAJE m ON m.chat_grupo = cg.codigo
GROUP BY cg.administrador, mu.nombre, cg.nombre;

-- Modificar vista eliminando f_registro (redefiniéndola desde tablas)
CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    tel_admin,
    nom_admin,
    nom_chat,
    n_mensajes,
    total_mensajes
FROM (
    SELECT 
        cg.administrador AS tel_admin,
        mu.nombre AS nom_admin,
        cg.nombre AS nom_chat,
        COUNT(CASE WHEN m.usuario = cg.administrador THEN 1 END) AS n_mensajes,
        COUNT(m.mensaje_id) AS total_mensajes
    FROM CHAT_GRUPO cg
    JOIN MIUSUARIO mu ON cg.administrador = mu.telefono
    LEFT JOIN MENSAJE m ON m.chat_grupo = cg.codigo
    GROUP BY cg.administrador, mu.nombre, cg.nombre
);-- Crear vista sin referencia circular
CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    cg.administrador AS tel_admin,
    mu.nombre AS nom_admin,
    cg.nombre AS nom_chat,
    COUNT(CASE WHEN m.usuario = cg.administrador THEN 1 END) AS n_mensajes,
    COUNT(m.mensaje_id) AS total_mensajes
FROM CHAT_GRUPO cg
JOIN MIUSUARIO mu ON cg.administrador = mu.telefono
LEFT JOIN MENSAJE m ON m.chat_grupo = cg.codigo
GROUP BY cg.administrador, mu.nombre, cg.nombre;

-- Modificar vista eliminando f_registro (redefiniéndola desde tablas)
CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    tel_admin,
    nom_admin,
    nom_chat,
    n_mensajes,
    total_mensajes
FROM (
    SELECT 
        cg.administrador AS tel_admin,
        mu.nombre AS nom_admin,
        cg.nombre AS nom_chat,
        COUNT(CASE WHEN m.usuario = cg.administrador THEN 1 END) AS n_mensajes,
        COUNT(m.mensaje_id) AS total_mensajes
    FROM CHAT_GRUPO cg
    JOIN MIUSUARIO mu ON cg.administrador = mu.telefono
    LEFT JOIN MENSAJE m ON m.chat_grupo = cg.codigo
    GROUP BY cg.administrador, mu.nombre, cg.nombre
);

-- e) Explicación: La vista no se actualiza automáticamente al insertar nuevos mensajes 
-- porque es una vista no materializada. Para ver los cambios, se debe consultar de nuevo.

-- EJERCICIO 8. Asertos (ejecutar sólo la SELECT)

-- Aserto 1: "Todo chat de grupo debe tener al menos un mensaje"
SELECT * 
FROM CHAT_GRUPO cg
WHERE NOT EXISTS (
    SELECT 1 
    FROM MENSAJE m 
    WHERE m.chat_grupo = cg.codigo
);

-- Aserto 2: "El mensaje anclado debe estar en el mismo chat"
SELECT * 
FROM CHAT_GRUPO cg
WHERE cg.mensaje_anclado_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM MENSAJE m
      WHERE m.mensaje_id = cg.mensaje_anclado_id
        AND m.chat_grupo = cg.codigo
  );

-- EJERCICIO 9. Índice para mejorar rendimiento

-- Eliminar índice si existe
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX idx_contacto_usuario';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Crear índice
CREATE INDEX idx_contacto_usuario ON CONTACTO(usuario);

-- Comentario:
-- 1) El nuevo valor de COSTE es: 82
-- 2) Sí, ha mejorado respecto al coste inicial de 150. Se nota que el plan de ejecución accede
-- más rápido a la tabla CONTACTO por el índice creado. 👍
