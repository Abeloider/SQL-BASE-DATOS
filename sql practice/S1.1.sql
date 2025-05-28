/* S1.1. [F] Título, género y edad mínima recomendada de las series no españolas [observa que la
nacionalidad española se indica con el texto 'Espana'] cuya edad mínima recomendada es inferior
a 18 años. (titulo, genero, edad_minima). */

SELECT titulo, genero, edad_minima
FROM serie
WHERE nacionalidad != 'Espana'
and edad_minima < 18; 

-- S1.2. [F] Identificadores de las series y temporadas que los usuarios están viendo. Sin duplicados.
-- Ordenado por serie y temporada. (serie, temporada).

SELECT DISTINCT serie, temporada
FROM ESTOY_VIENDO
order by serie, temporada 

-- S1.3. [F] Capítulos de la temporada 3 o posterior de alguna serie, cuya duración sea inferior a 45
-- minutos, ordenado por serie y temporada. (serie, temporada, capitulo, titulo, duracion).

SELECT serie, temporada, capitulo, titulo, duracion 
FROM capitulo
WHERE temporada >= 3
AND duracion < 45 
ORDER BY serie, temporada; 

-- S1.4. [F] Usuarios cuya cuota está entre 50 y 100 euros y que se registraron después del
-- 20/05/2020, ordenados por fecha de registro, de más reciente a más antigua (usuario_id,
-- nombre, f_registro).

SELECT usuario_id, nombre, f_registro
FROM usuario
WHERE cuota BETWEEN 50 AND 100 AND f_registro > TO_DATE('20/05/2020', 'dd/mm/yyyy')
ORDER BY f_registro desc

-- S1.5. [F] Identificador de los usuarios que desde antes del 05/02/2025 tienen pendiente de
-- terminar algún capítulo del que visualizaron al menos 15 minutos. Sin duplicados y
-- ordenado por usuario. (usuario). 

SELECT DISTINCT(usuario)
FROM estoy_viendo
WHERE  f_ultimo_acceso < TO_DATE('05/02/2025', 'dd/mm/yyyy') AND minuto >= 15
ORDER BY usuario
;

-- S1.6. [F] Intérpretes nacidos en la década de los 70 (del siglo XX, claro) de nacionalidad británica
-- ('Reino Unido'), ordenado por año de nacimiento y por nombre. (interprete_id, nombre,
-- a_nacimiento).

SELECT *
FROM interprete
WHERE a_nacimiento BETWEEN 1970 AND 1979 AND nacionalidad = 'Reino Unido'
ORDER BY a_nacimiento, nombre
;

-- S1.7. [F] Para cada usuario cuyo nombre incluye el texto ‘ia’, mostrar el nombre, email y mes (no la
-- fecha, sino el mes en letras) en que se registró en la plataforma. (nombre, email,
-- mes_registro).

SELECT *
FROM usuario
WHERE nombre LIKE '%ia%'
;


-- S1.8. [F] Para cada usuario registrado antes del 1 de enero de 2021 y que paga una cuota inferior a
-- 80€, mostrar cómo quedaría su cuota si aumentara un 5% redondeada a dos decimales
-- [Puedes utilizar la función ROUND(valor, numero_decimales)]. Ordenado por identificador de
-- usuario. (usuario_id, nombre, nueva_cuota).

SELECT usuario_id,nombre, ROUND(cuota*1.05,2)AS nueva_cuota
FROM usuario
WHERE f_registro < TO_DATE('01/01/2021','dd/mm/yyyy') AND cuota < 80
ORDER BY usuario_id
;


-- S1.9. [F] Nombres de los usuarios registrados hace más de 5 años, incluyendo el nº de años que
-- hace que se registraron redondeado a 1 decimal. Ordenado por nombre. (nombre,
-- tiempo_registro). [Nota: la función SYSDATE devuelve la fecha actual del sistema y la resta entre dos
-- fechas obtiene el número de días transcurridos entre ellas].

SELECT nombre, ROUND(SYSDATE - _registro/365,1)
FROM usuario 
WHERE (SYSDATE - f_registro) > 5
ORDER BY nombre; 

-- S1.10. [F] Para los usuarios ‘U222’ y ‘U777’ mostrar cada serie que están viendo, la temporada,
-- capítulo, el minuto por el que se quedaron (siempre que hayan visto más de 20 minutos), y
-- los días que han pasado desde la última vez que accedieron a la serie, sin decimales.
-- Ordenado por usuario y serie. (usuario, serie, temporada, capitulo, minuto, dias).

SELECT usuario,serie,temporada,capitulo,minuto,ROUND(SYSDATE-f_ultimo_acceso,0)
FROM estoy_viendo
WHERE usuario IN('U222','U777') AND minuto>20


-- S1.11. [F] Nombre y nacionalidad de los intérpretes que participan en la serie con código ‘S001’,
-- incluyendo el rol con el que han participado. Ordenado por rol. (nombre, nacionalidad, rol).

SELECT nombre,nacionalidad,rol
FROM interprete I JOIN reparto R
ON(I.interprete_id = R.interprete)
WHERE R.serie = 'S001'
ORDER BY R.rol
;

-- S1.12. [F] Etiquetas asociadas a las series estadounidenses ('Estados Unidos') de género ‘Drama’,
-- ordenado por identificador de serie. (serie, titulo, etiqueta).

SELECT serie,titulo,etiqueta
FROM etiquetado E JOIN serie S
ON(E.serie=S.serie_id)
WHERE nacionalidad ='Estados Unidos' AND genero = 'Drama'
ORDER BY S.serie_id
;

-- S1.13. [F] Intérpretes británicos ('Reino Unido') que han participado en alguna serie con un papel
-- protagonista o secundario, ordenados por nombre. (nombre, a_nacimiento, rol).
SELECT Distinct(nombre),a_nacimiento,rol
FROM interprete I JOIN reparto R
ON(i.interprete_id = R.interprete)
WHERE I.nacionalidad = 'Reino Unido' AND R.rol IN('Protagonista','Secundario')
ORDER BY nombre
;


-- S1.14. [F/M] Series de interés para el usuario llamado ‘Turiano’, ordenadas alfabéticamente por
-- título en orden descendente. (titulo, f_interes).
SELECT titulo, f_interes
FROM interes I JOIN usuario U
    ON(I.usuario = U.usuario_id)
    JOIN serie S 
        ON(I.serie = S.serie_id)
WHERE nombre = 'Turiano'
ORDER BY titulo desc
;

-- S1.15. [F/M] Identificador y nombre de los intérpretes que participan como figurantes (‘Figuracion’)
-- en el reparto de alguna serie, indicando el identificador y título de la serie. (interprete,
-- nombre, serie, titulo).
SELECT interprete_id, nombre, serie, titulo
FROM interprete I JOIN reparto R
    ON(I.interprete_id = R.interprete)
    JOIN serie S 
        ON(R.serie = S.serie_id)
WHERE rol = 'Figuracion'
;

-- S1.16. [F/M] Para cada serie cuyo género es ‘Ciencia Ficcion’ y que tiene alguna temporada con
-- algún capítulo cuya duración está entre 50 y 53 minutos, mostrar el título de la serie, el
-- número de la temporada, el año de estreno de la temporada, el número de capítulo y el título
-- del capítulo. Ordenado por título de serie y número de temporada. (titulo_serie, temporada,
-- a_estreno, capitulo, titulo_capitulo).
SELECT S.titulo, T.temporada, t.a_estreno, c.capitulo, C.titulo
FROM serie S JOIN capitulo C
    ON(S.serie_id = C.serie)
    JOIN temporada T
    ON(t.temporada = c.temporada AND C.serie = T.serie)
WHERE genero = 'Ciencia Ficcion' AND duracion BETWEEN 50 AND 53
ORDER BY S.titulo, temporada
;

-- S1.17. [F/M] Nombre y email de los usuarios que están viendo alguna serie de género ‘Policiaca’,
-- incluyendo el título de la serie y el capítulo que tienen a medio. En orden descendente por
-- nombre. (nombre, email, titulo, temporada, capitulo).

SELECT nombre, email, titulo, temporada, capitulo
FROM serie S JOIN estoy_viendo E
ON (S.serie_id = E.serie)
JOIN usuario U
ON (U.usuario_id = E.usuario)
WHERE genero = 'Policiaca'
;


-- S1.18. [F/M] Títulos de las series de interés para usuarios registrados antes del 2019. Ordenado por
-- título de serie. (titulo, nombre_usuario).
SELECT titulo, nombre
FROM usuario U JOIN interes I
    ON(u.usuario_id = i.usuario)
    JOIN serie S
    ON(s.serie_id = i.serie )
WHERE u.f_registro <TO_DATE('01/01/2019','dd/mm/yyyy')
ORDER BY titulo
;



-- S1.19. [F/M] Capítulo que están viendo los usuarios cuya fecha de último acceso es anterior a
-- 01/02/2025, indicando el título de la serie y el título del capítulo y el nombre del usuario.
-- Ordenado por nombre de usuario. (nombre_usuario, titulo_serie, titulo_capitulo, minuto).
SELECT U.nombre nombre_usuario, 
        S.titulo titulo_serie,
        C.titulo titulo_capitulo,
        minuto
FROM estoy_viendo E
    JOIN usuario U ON E.usuario = U.usuairo_id
    JOIN serie S ON E.serie = S.serie_id
    JOIN capitulo C on E.serie= C.serie_id
                    AND E.temporada = C.temporada 
                    AND E.capitulo = E.capitulo

WHERE f_ultimo_acceso < TO_DATE ('01/02/2025','dd-mm/yyyyy')
-- S1.20. [F/M] Nombres y edad de los intérpretes de nacionalidad española, nacidos después de 1985
-- y que participan en series que algún usuario está viendo. (nombre, edad).

SELECT nombre, TO_DATE((SYSDATE - a_nacimiento*365),'yy') AS edad
FROM interprete I JOIN reparto R
    ON(i.interprete_id = R.interprete)
WHERE nacionalidad = 'Espana' AND a_nacimiento > 1985
;

-- S1.21. [F/M] Para cada serie de interés para algún usuario marcada como vista por tal usuario,
-- mostrar su título, su género y el año de estreno de su temporada 1. Ordenado por título de
-- serie. (titulo, genero, a_estreno).

SELECT nacionalidad
FROM interprete
GROUP BY nacionalidad
HAVING COUNT (nacionalidad) = 1
ORDER BY nacionalidad
;

-- S1.22. [M] Listado de usuarios y las series de su interés. Deben aparecer también los usuarios que
-- no tengan lista de intereses, para los cuales se debe mostrar el texto ‘SIN INTERESES’ en la
-- columna ‘serie_id’. Ordenado descendentemente por nombre de usuario. (nombre, serie_id).

SELECT nombre, COALESCE(I.serie,'SIN INTERES') AS serie_id
FROM usuario U LEFT JOIN interes I 
    ON (U.usuario_id = I.usuario)
ORDER BY nombre desc;

-- S1.23. [M] Listado de series de género ‘Policiaca’ y sus etiquetas. Deben aparecer también las series
-- que no tienen etiquetas, y se debe mostrar el texto ‘*SIN ETIQUETAS*’ en la columna
-- ‘etiqueta’. Ordenado por titulo de serie y etiqueta. (titulo_serie, etiqueta).

SELECT titulo AS titulo_serie, COALESCE (E.etiqueta,'SIN ETIQUETAS') AS etiqueta 
FROM serie S LEFT JOIN etiquetado E ON (S.serie_id = E.serie)
where genero = 'Policiaca'
ORDER BY titulo_serie desc, etiqueta desc;

-- S1.24. [M] Series y los usuarios que las están viendo. Deben aparecer también las series que no está
-- viendo nadie, para las cuales se debe mostrar el texto ‘*NADIE*’ en la columna
-- “nombre_usuario”. Ordenado por titulo de serie y nombre de usuario. (titulo_serie,
-- nombre_usuario).
SELECT titulo AS titulo_serie, COALESCE(usuario, '*NADIE*') AS nombre_usuario 
FROM serie S LEFT JOIN estoy_viendo E ON (S.serie_id=E.serie)
             LEFT JOIN usuario U ON (E.usuario = U.usuario_id)
ORDER BY serie_id, nombre_usuario;

-- S1.25. [M] Listado de usuarios y series que están viendo. Deben aparecer también los usuarios que
-- no están viendo ninguna serie, y se debe mostrar el texto ‘*NADA*’ en la columna
-- ‘titulo_serie’. Ordenado por nombre de usuario y titulo de serie. (nombre_usuario,
-- titulo_serie).
SELECT nombre, COALESCE(titulo,'*NADA*')
FROM estoy_viendo E RIGHT JOIN usuario U
ON (E.usuario = U.usuario_id)
LEFT JOIN serie S
ON (S.serie_id = E.serie)
GROUP BY U.nombre, S.titulo
ORDER BY U.nombre, S.titulo
;


-- S1.26. [F] Identificadores de las series que no tienen ninguna etiqueta. Hay que usar operadores de
-- conjuntos (serie).

(SELECT serie_id
FROM serie) 
MINUS 
(select serie
FROM etiquetado);

-- S1.27. [F] Identificadores de las series cuyo género no sea ‘Policiaca’, tales que ningún usuario la
-- está viendo. Hay que usar operadores de conjuntos. (serie).

(SELECT serie_id
FROM serie
WHERE genero <> 'Policiaca')
MINUS
(SELECT serie
FROM estoy_viendo)
;

-- S1.28. [F] Identificadores de las series que son de interés para algún usuario y que tengan la
-- etiqueta ‘Thriller’ pero que no están siendo vistas por ningún usuario. No usar JOIN, sino
-- sólo operadores de conjuntos. (serie).

SELECT serie
FROM interes
INTERSECT
SELECT serie
FROM etiquetado
WHERE etiqueta = 'Thriller'
MINUS
SELECT serie
FROM estoy_viendo
;


-- S1.29. [F] Identificadores de los intérpretes que participan en el reparto de alguna serie como
-- protagonistas y en alguna otra serie como actores/actrices de reparto. Hay que usar
-- operadores de conjuntos. (interprete).
(SELECT interprete
FROM reparto
WHERE rol ='Protagonista')
INTERSECT
(SELECT interprete
FROM reparto
WHERE rol ='Reparto')
;
-- S1.30. [F] Usuarios que tienen lista de intereses pero no están viendo nada. Hay que usar
-- operadores de conjuntos. (usuario).
SELECT usuario
FROM interes
MINUS
SELECT usuario
FROM estoy_viendo
;

-- S1.31. [M] Series de interés para algún usuario, cuya fecha de registro de dicho interés es posterior
-- al 15/01/2023, tales que ese mismo usuario no la está viendo. Ordenado por los
-- identificadores de serie y de usuario. Hay que usar operadores de conjuntos. (serie, usuario).
(SELECT serie, usuario
FROM interes
WHERE f_interes > TO_DATE('15/01/2023','dd/mm/yyyy'))
MINUS
(SELECT serie, usuario
FROM estoy_viendo)
;
-- S1.32. [F/M] Identificadores de los usuarios que tienen a medio ver alguna serie a la que no
-- acceden desde hace más de 6 meses, o bien que pagan una cuota inferior a 70 euros y se
-- registraron en 2022 o después. Hay que usar operadores de conjuntos. (usuario).
SELECT usuario
FROM estoy_viendo
WHERE f_ultimo_acceso < SYSDATE-6*30
UNION
SELECT usuario_id
FROM usuario
WHERE cuota < 70 AND f_registro > TO_DATE('31/12/2021','dd/mm/yyyy')

-- S1.33. [F/M] Series de género ‘Drama’ cuya edad mínima es 18, y con algún capítulo de su segunda
-- temporada cuya duración está entre 60 y 100 minutos. Hay que usar operadores de
-- conjuntos. (serie).
(SELECT serie_id
FROM serie
WHERE genero = 'Drama' AND edad_minima = 18)
INTERSECT
(SELECT serie
FROM capitulo
WHERE (temporada = 2) AND (duracion BETWEEN 60 AND 100)
)
;

-- S1.34. [F/M] Series de interés para los usuarios cuya cuota está entre 30 y 45 euros, o bien que
-- tengan una edad mínima inferior a 16, o bien que tengan algún capítulo en cuyo título
-- aparezca el número 4. Hay que usar operadores de conjuntos. (serie).
SELECT serie
FROM interes I JOIN usuario U
    ON(i.usuario = u.usuario_id)
WHERE cuota BETWEEN 30 AND 45
UNION
SELECT serie_id
FROM serie
WHERE edad_minima <16
UNION
SELECT serie
FROM capitulo
WHERE titulo LIKE '%4%'

;
-- S1.35. [F/M] Identificador de los intérpretes que han participado con rol ‘Reparto’ en alguna serie y
-- que hayan nacido en la década de los 80 del siglo XX, pero que nunca hayan formado parte
-- de series estadounidenses. Hay que usar operadores de conjuntos. (interprete).

(
  SELECT i.interprete_id
  FROM interprete i
  JOIN reparto r ON i.interprete_id = r.interprete
  WHERE r.rol = 'Reparto'
    AND i.a_nacimiento BETWEEN 1980 AND 1989
)
MINUS
(
  SELECT r.interprete
  FROM reparto r
  JOIN serie s ON r.serie = s.serie_id
  WHERE s.nacionalidad = 'Estados Unidos'
);













