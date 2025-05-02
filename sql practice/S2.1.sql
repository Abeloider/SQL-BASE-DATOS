-- S2.1. [F] Título y género de las series que nadie está viendo. (titulo, genero).
SELECT S.titulo , S.genero
FROM SERIE S 
LEFT JOIN ESTOY_VIENDO E ON S.serie_id = E.serie
WHERE E.serie IS NULL; 

-- S2.2. [F] Usuarios tales que la última vez que vieron alguna serie fue hace más de cuatro años.
-- (nombre, f_registro, cuota).

    SELECT U.nombre, U.f_registro, U.cuota
    FROM USUARIO U
    LEFT JOIN ESTOY_VIENDO E ON U.usuario_id = E.usuario
    WHERE E.f_ultimo_acceso < ADD_MONTHS(SYSDATE, -48)
    order by U.cuota;


    SELECT nombre, f_registro, cuota
FROM USUARIO
WHERE usuario_id IN (
    SELECT usuario
    FROM ESTOY_VIENDO
    WHERE f_ultimo_acceso < ADD_MONTHS(SYSDATE, -48)
)
ORDER BY cuota;

-- S2.3. [F] Etiquetas empleadas en las series que son de interés para los usuarios que no están
-- viendo ninguna serie. (etiqueta).

SELECT DISTINCT E.etiqueta
FROM ETIQUETADO E
JOIN INTERES I ON E.serie = I.serie
WHERE I.usuario IN (
    SELECT usuario_id 
    FROM USUARIO 
    WHERE usuario_id NOT IN (SELECT DISTINCT usuario FROM ESTOY_VIENDO)
);

-- S2.4. [F] Usuarios que no tienen interés en ninguna serie española, ordenado por nombre.
-- (nombre, f_registro, email).

SELECT U.nombre, U.f_registro, U.email
FROM USUARIO U
WHERE U.usuario_id NOT IN (
    SELECT I.usuario
    FROM INTERES I
    JOIN SERIE S ON I.serie = S.serie_id
    WHERE S.nacionalidad = 'Espana'
)
ORDER BY U.nombre;

-- S2.5. [F/M] Intérpretes que participan como protagonistas en alguna serie 'Policiaca', ordenado
-- por nombre. (nombre, nacionalidad, a_nacimiento).

SELECT DISTINCT I.nombre, I.nacionalidad, I.a_nacimiento 
FROM INTERPRETE I 
JOIN reparto R ON I.interprete_id = R.interprete 
JOIN SERIE S ON R.serie= S.serie_id 
WHERE S.genero = 'Policiaca' and R.rol = 'Protagonista'
ORDER BY nombre; -- me da


-- S2.6. [F/M] Nombres y nacionalidades de los intérpretes no españoles, que han participado en
-- series de nacionalidad española. Ordenado por nombre de intérprete. (nombre,
-- nacionalidad).

SELECT DISTINCT I.nombre, I.nacionalidad 
FROM INTERPRETE I 
JOIN REPARTO R ON I.interprete_id = R.interprete 
JOIN SERIE S ON R.serie = S.serie_id 
WHERE I.nacionalidad != 'Espana' -- cuidado con el Espana 
AND S.nacionalidad = 'Espana'
ORDER BY I.nombre;

-- S2.7. [M] Usuarios que actualmente están viendo alguna serie en cuyo reparto hay un intérprete
-- nacido entre 1990 y 2000. (usuario_id, nombre, email).

    SELECT DISTINCT U.usuario_id, U.nombre, U.email
    FROM USUARIO U
    JOIN ESTOY_VIENDO E ON U.usuario_id = E.usuario
    JOIN REPARTO R ON E.serie = R.serie
    JOIN INTERPRETE I ON R.interprete = I.interprete_id
    WHERE I.a_nacimiento BETWEEN 1990 AND 2000; 


-- S2.8. [M] Usuarios que se han dejado a medio ver el primer capítulo de la primera temporada de
-- alguna serie que sólo tiene una temporada. Se asume que si un usuario ha visto un capítulo
-- completo, éste desaparece de su lista “Estoy viendo”. No se debe utilizar agrupamiento ni
-- funciones de agregados. (usuario_id, nombre, cuota).

-- agrupamiento es el GROUP BY y lo de las funciones de agregado es el COUNT()

SELECT U.usuario_id, U.nombre, U.cuota 
FROM USUARIO U
JOIN ESTOY_VIENDO E ON E.usuario = U.usuario_id 
JOIN TEMPORADA T ON E.serie = u.serie
WHERE EV.temporada = 1
AND EV.capitulo = 1
AND EV.minuto > 0
AND NOT EXISTS (
    SELECT 1 FROM TEMPORADA T2
    WHERE T2.serie = T.serie
    AND T2.temporada <> 1
); -- usuaro_id

-- S2.9. [M] Series de género 'Drama' que tienen alguna etiqueta que también aparezca en alguna
-- serie de género 'Policiaca'. (titulo, nacionalidad, edad_minima).

SELECT S.titulo, S.nacionalidad, S.edad_minima 
FROM SERIE S 
JOIN ETIQUETADO E ON E.serie = S.serie_id 
WHERE S.genero = 'Drama'
and E.etiqueta in (
    SELECT E2.etiqueta 
    FROM ETIQUETADO E2 
    JOIN SERIE S2 ON E2.serie = S2.serie_id 
    WHERE S2.genero = 'Policiaca' 
); -- ME DA

-- S2.10. [M/D] Usuarios que pagan una cuota inferior a 65 euros y anotaron que alguna serie era de
-- su interés después del 1 de enero de 2024, o bien que se registraron en 2022 y no están viendo
-- ninguna serie. Ordenado por identificador de usuario. (usuario_id, nombre, f_registro).

SELECT U.usuario_id, U.nombre, U.f_registro
FROM USUARIO U
WHERE (U.cuota < 65 
         AND U.usuario_id IN (SELECT I.usuario 
                            FROM INTERES I 
                            WHERE I.f_interes > TO_DATE('2024-01-01', 'YYYY-MM-DD')))

   OR (U.f_registro BETWEEN TO_DATE('2022-01-01', 'YYYY-MM-DD') AND TO_DATE('2022-12-31', 'YYYY-MM-DD') 
       AND U.usuario_id NOT IN (SELECT DISTINCT EV.usuario FROM ESTOY_VIENDO EV))
       
ORDER BY U.usuario_id;

-- S2.11. [M] Series que tengan algún capítulo de la segunda temporada con una duración mayor que
-- todos los capítulos de la tercera temporada. (serie_id, titulo).
SELECT DISTINCT S.serie_id, S.titulo -- EL DISTINT PARA QUE NO SALGAN REPETIDOS
FROM serie S 
JOIN capitulo C ON S.serie_id = C.serie
WHERE C.temporada = 2 and C.duracion > ALL (
    SELECT C.duracion 
    FROM CAPITULO C
    WHERE C.serie = S.serie_id AND C.temporada = 3
);
  
-- S2.12. [M] Series tales que han pasado 2 o más años entre el estreno de su primera y su segunda
-- temporada . (titulo, nacionalidad).

SELECT S.titulo, S.nacionalidad 
FROM SERIE S 
JOIN temporada T ON S.serie_id = T.serie and T.temporada =1
JOIN temporada T2 ON S.serie_id = T2.serie and T2.temporada =2
WHERE T2.a_estreno NOT BETWEEN T.a_estreno AND T.a_estreno +1;  -- correcto
-- que no esta entre el año de estreno de la primera temporada hasta el año de estreno de la primera temporada



-- S2.13. [M/D] Series que algún usuario está viendo para las que no indicó que eran de su interés.
-- (serie_id, titulo, genero).
SELECT DISTINCT S.serie_id, S.titulo, S.genero
FROM SERIE S 
JOIN ESTOY_VIENDO E ON E.serie = S.serie_id
WHERE S.serie_id NOT IN (
    SELECT I.serie 
    FROM INTERES I 
    WHERE I.usuario = E.usuario -- no interesado igual a no estabiendo el usuario
)

-- S2.14. [F] Para cada etiqueta, mostrar en cuántas series aparece. Ordenado por número de series.
-- (etiqueta, n_series).
SELECT etiqueta, SUM(1) AS n_series
FROM ETIQUETADO
GROUP BY etiqueta -- agrupamos para el num de etiquetas
ORDER BY n_series ;

-- S2.15. [F] Cuántas series hay de cada nacionalidad. Ordenado por número de series.
-- (nacionalidad, n_series).
SELECT nacionalidad, SUM(1) as n_serie
FROM SERIE 
GROUP BY nacionalidad 
ORDER BY n_serie; -- correcto 

-- S2.16. [F] Cuántas series cuya edad mínima recomendada es superior a 12 hay de cada género, en
-- orden descendente por género. (genero, n_series).

SELECT genero, SUM(1) as n_series 
FROM SERIE S
WHERE S.edad_minima > 12 
GROUP BY genero 
ORDER BY genero desc;

-- S2.17. [F] Para cada usuario indicar cuántas series, de las que se interesó, ya ha visto de forma
-- completa. (usuario, n_series_vistas).

SELECT usuario, COUNT(DISTINCT serie) as n_seri_vistas
FROM INTERES
WHERE vista = 'SI'
GROUP BY usuario;

-- S2.18. [F] Cuántos usuarios están interesados en cada serie. Ordenado por serie. (serie,
-- n_usuarios).
SELECT serie, SUM(1) AS n_usuario
FROM INTERES
GROUP BY serie
ORDER BY serie; -- coorecto 

-- S2.19. [F] Etiquetas utilizadas en más de 3 series. (etiqueta).

SELECT etiqueta 
FROM ETIQUETADO 
GROUP BY etiqueta
HAVING SUM(1) > 3; -- tambien se peude poner con COUNT(DISTINCT serie) > 3

-- S2.20. [F/M] Cuántas series hay con algún capítulo que no tiene título. Trata de resolverlo sin
-- acceder a la tabla SERIE. (n_series).

SELECT n_serie
FROM capitulo
WHERE titulo IS NULL
GROUP BY serie;




-- S2.21. [F/M] ¿Cuáles son las nacionalidades para las que solo hay un intérprete en la base de
-- datos? Ordenadas alfabéticamente. (nacionalidad).

-- S2.22. [F/M] Mostrar el identificador de las series que tienen 4 o más temporadas junto con el
-- número de temporadas. Ordenado por serie. (serie, n_temporadas).

-- S2.23. [F/M] Para cada serie en la que participa el actor 'David Tennant' indicar el número de veces
-- en total que aparece en la lista de intereses de los usuarios (serie, likes).

-- S2.24. [F/M] Cuál es la media de las cuotas que pagan los usuarios que están interesados en más
-- de tres series. (cuota_media).

-- S2.25. [F/M] Series con más de 3 temporadas, de nacionalidad no británica y cuya edad mínima
-- es inferior a 18 (titulo, nacionalidad, genero).

-- S2.26. [M] Cuántos capítulos con duración inferior a 45 minutos tiene cada temporada de cada
-- serie con más de 2 temporadas. Ordenado por serie y temporada. (serie, temporada,
-- n_capitulos).

-- S2.27. [M] Usuarios que están viendo alguna serie que solo tiene 2 temporadas. (nombre, cuota).

-- S2.28. [M] Usuarios interesados en más de 5 series. (nombre, f_registro, cuota).

-- S2.29. [M] Intérpretes que han participado en más de una serie, en orden alfabético. (nombre,
-- nacionalidad, a_nacimiento).

-- S2.30. [M/D] Usuarios que están viendo más de un capítulo de la misma serie. (nombre).

-- S2.31. [M/D] En cuántas series británicas participa cada interprete de nacionalidad
-- estadounidense. (interprete, n_series_brit).

-- S2.32. [M/D] Número de usuarios que están viendo cada serie. Si un usuario está viendo varios
-- capítulos de la misma serie, solo debe ser considerado una vez. Deben aparecer todas las series
-- y para las que no están siendo vistas por nadie debe aparecer el valor 0 en la columna
-- n_usuarios. Ordenado por identificador de serie. (serie_id, n_usuarios).


-- S2.33. [M/D] Número de series que está viendo cada usuario, en orden descendente por el
-- número de series. Si un usuario está viendo diferentes capítulos de la misma serie, solo debe
-- ser considerada una vez. Deben mostrarse todos los usuarios; para los que no están viendo
-- ninguna serie debe aparecer un 0 en la columna series_en_curso. (usuario_id, series_en_curso).

-- S2.34. [M/D] Número de series en las que se ha interesado cada usuario pero que todavía no ha
-- empezado a ver, es decir, no aparecen anotadas como ya vistas ni el usuario las tiene a medio
-- ver (usuario, series_pendientes).

-- S2.35. [M/D] Mostrar cuántas temporadas y cuántos capítulos en total tiene cada serie en la que
-- participa algún intérprete con nacionalidad 'Espana'. Ordenado por identificador de serie.
-- (serie, n_temporadas, n_capitulos).
SELECT 
    T.serie,
    COUNT(DISTINCT T.temporada) AS n_temporadas,
    COUNT(C.serie) AS n_capitulos
FROM TEMPORADA T
JOIN CAPITULO C ON T.serie = C.serie AND T.temporada = C.temporada
JOIN REPARTO R ON T.serie = R.serie
JOIN INTERPRETE I ON R.interprete = I.interprete_id
WHERE I.nacionalidad = 'Espana'
GROUP BY T.serie
ORDER BY T.serie; -- TA MAL
