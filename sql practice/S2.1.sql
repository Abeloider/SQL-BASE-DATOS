-- S2.1. [F] Título y género de las series que nadie está viendo. (titulo, genero).
SELECT S.titulo , S.genero
FROM SERIE S 
LEFT JOIN ESTOY_VIENDO E ON S.serie_id = E.serie
WHERE E.serie IS NULL; 

-- Otra forma de hacerlo
SELECT titulo, genero
FROM serie
WHERE serie_id NOT IN(SELECT serie
                    FROM estoy_viendo)
;

-- S2.2. [F] Usuarios tales que la última vez que vieron alguna serie fue hace más de cuatro años.
-- (nombre, f_registro, cuota).
SELECT nombre, f_registro, cuota
FROM usuario
WHERE usuario_id IN (SELECT usuario
                        FROM estoy_viendo
                        WHERE (SYSDATE - f_ultimo_acceso)/365 > 4)
;

-- S2.3. [F] Etiquetas empleadas en las series que son de interés para los usuarios que no están
-- viendo ninguna serie. (etiqueta).

SELECT etiqueta
FROM etiquetado 
WHERE serie IN (SELECT serie
                FROM interes
                WHERE usuario NOT IN(SELECT usuario
                                    FROM estoy_viendo))
;
-- S2.4. [F] Usuarios que no tienen interés en ninguna serie española, ordenado por nombre.
-- (nombre, f_registro, email).

SELECT nombre, f_registro, email
FROM usuario
WHERE usuario_id NOT IN(SELECT usuario
                        FROM interes I JOIN serie S
                        ON (I.serie = S.serie_id)
                        WHERE nacionalidad = 'Espana' )
ORDER BY nombre
;

-- S2.5. [F/M] Intérpretes que participan como protagonistas en alguna serie 'Policiaca', ordenado
-- por nombre. (nombre, nacionalidad, a_nacimiento).

SELECT *
FROM interprete
WHERE interprete_id IN (SELECT interprete
                        FROM reparto
                        WHERE rol = 'Protagonista' AND serie IN (SELECT serie_id
                                                                FROM serie
                                                                WHERE genero = 'Policiaca'))
;

-- S2.6. [F/M] Nombres y nacionalidades de los intérpretes no españoles, que han participado en
-- series de nacionalidad española. Ordenado por nombre de intérprete. (nombre,
-- nacionalidad).

SELECT nombre, nacionalidad
FROM interprete
WHERE nacionalidad <> 'Espana' AND interprete_id IN(SELECT interprete
                                                    FROM reparto R JOIN serie S
                                                    ON (R.serie = S.serie_id)
                                                    WHERE (S.nacionalidad = 'Espana'))
ORDER BY nacionalidad
;

-- S2.7. [M] Usuarios que actualmente están viendo alguna serie en cuyo reparto hay un intérprete
-- nacido entre 1990 y 2000. (usuario_id, nombre, email).
SELECT usuario_id, nombre, email
FROM usuario
WHERE usuario_id IN(SELECT usuario
                 FROM estoy_viendo
                 WHERE serie IN (SELECT serie
                                FROM reparto
                                WHERE interprete IN (SELECT interprete_id
                                                    FROM interprete
                                                    WHERE a_nacimiento BETWEEN 1990 AND 2000)))
;
-- S2.8. [M] Usuarios que se han dejado a medio ver el primer capítulo de la primera temporada de
-- alguna serie que sólo tiene una temporada. Se asume que si un usuario ha visto un capítulo
-- completo, éste desaparece de su lista “Estoy viendo”. No se debe utilizar agrupamiento ni
-- funciones de agregados. (usuario_id, nombre, cuota).

-- agrupamiento es el GROUP BY y lo de las funciones de agregado es el COUNT()
SELECT usuario_id, nombre, cuota
FROM usuario U
WHERE (U.usuario_id IN (SELECT usuario
        FROM estoy_viendo E
        WHERE capitulo = 1 AND NOT EXISTS (SELECT *
                                            FROM temporada T
                                            WHERE E.serie = T.serie AND T.temporada <> 1)))
;

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

--S2.9                      //NO SE 
SELECT *
FROM serie S JOIN etiquetado E
    ON (s.serie_id = e.serie)
WHERE s.genero = 'Drama'
INTERSECT
SELECT *
FROM serie S JOIN etiquetado E
    ON (s.serie_id = e.serie)
WHERE genero = 'Policiaca'
;


-- S2.10. [M/D] Usuarios que pagan una cuota inferior a 65 euros y anotaron que alguna serie era de
-- su interés después del 1 de enero de 2024, o bien que se registraron en 2022 y no están viendo
-- ninguna serie. Ordenado por identificador de usuario. (usuario_id, nombre, f_registro).

SELECT usuario_id, nombre, f_registro
FROM usuario
WHERE cuota  < 65 AND 
usuario_id IN (
SELECT usuario
FROM interes
WHERE f_interes > TO_DATE('01/01/2024','dd/mm/yyyy')) OR(usuario_id IN(
SELECT usuario_id
FROM usuario
WHERE f_registro BETWEEN TO_DATE('01/01/2022','dd/mm/yyyy') AND TO_DATE('31/12/2022','dd/mm/yyyy') AND usuario_id NOT IN (SELECT usuario
                            FROM estoy_viendo)))
;

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

--S2.11                     // NO SE
SELECT *
FROM capitulo
WHERE temporada = 2 AND duracion > (SELECT MAX(duracion)
                                    FROM capitulo
                                    WHERE temporada = 3)
;
  
-- S2.12. [M] Series tales que han pasado 2 o más años entre el estreno de su primera y su segunda
-- temporada . (titulo, nacionalidad).

SELECT S.titulo, S.nacionalidad 
FROM SERIE S 
JOIN temporada T ON S.serie_id = T.serie and T.temporada =1
JOIN temporada T2 ON S.serie_id = T2.serie and T2.temporada =2
WHERE T2.a_estreno NOT BETWEEN T.a_estreno AND T.a_estreno +1;  -- correcto
-- que no esta entre el año de estreno de la primera temporada hasta el año de estreno de la primera temporada
SELECT titulo, nacionalidad
FROM serie S 
JOIN temporada T1 ON(S.serie_id = T1.serie AND T1.temporada =1)
JOIN temporada T2 ON(S.serie_id = T2.serie AND T2.temporada =2)
WHERE (T2.a_estreno - T1.a_estreno) > 1
;


-- S2.13. [M/D] Series que algún usuario está viendo para las que no indicó que eran de su interés.
-- (serie_id, titulo, genero).
SELECT *
FROM serie
WHERE serie_id IN(SELECT serie
                    FROM estoy_viendo
                    WHERE (serie , usuario) NOT IN(SELECT serie , usuario
                                                     FROM interes))

;
-- S2.14. [F] Para cada etiqueta, mostrar en cuántas series aparece. Ordenado por número de series.
-- (etiqueta, n_series).
SELECT etiqueta, COUNT (*) as numeroseries
FROM etiquetado E
JOIN serie S ON(E.serie=S.serie_id)
GROUP BY etiqueta
ORDER BY numeroseries
;

-- S2.15. [F] Cuántas series hay de cada nacionalidad. Ordenado por número de series.
-- (nacionalidad, n_series).
SELECT nacionalidad, SUM(1) as n_serie
FROM SERIE 
GROUP BY nacionalidad 
ORDER BY n_serie; -- correcto 


SELECT nacionalidad,COUNT(*)
FROM serie
GROUP BY nacionalidad
ORDER BY nacionalidad
;


-- S2.16. [F] Cuántas series cuya edad mínima recomendada es superior a 12 hay de cada género, en
-- orden descendente por género. (genero, n_series).
SELECT genero, COUNT(*) N_SERIES
FROM serie
WHERE edad_minima >12
GROUP BY genero
order by genero desc
;

-- S2.17. [F] Para cada usuario indicar cuántas series, de las que se interesó, ya ha visto de forma
-- completa. (usuario, n_series_vistas).

SELECT usuario, COUNT(serie)
FROM interes
WHERE vista ='SI' AND (serie, usuario) NOT IN(SELECT serie, usuario
                                FROM estoy_viendo)
GROUP BY (usuario)
;

-- S2.18. [F] Cuántos usuarios están interesados en cada serie. Ordenado por serie. (serie,
-- n_usuarios).
SELECT serie, COUNT(*) n_usuarios
FROM interes
GROUP BY serie
ORDER BY serie
;

-- S2.19. [F] Etiquetas utilizadas en más de 3 series. (etiqueta).

SELECT etiqueta 
FROM ETIQUETADO 
GROUP BY etiqueta
HAVING SUM(1) > 3; -- tambien se peude poner con COUNT(DISTINCT serie) > 3

-- S2.20. [F/M] Cuántas series hay con algún capítulo que no tiene título. Trata de resolverlo sin
-- acceder a la tabla SERIE. (n_series).

SELECT COUNT(DISTINCT(serie)) n_series
FROM capitulo
WHERE titulo IS NULL
;

-- S2.21. [F/M] ¿Cuáles son las nacionalidades para las que solo hay un intérprete en la base de
-- datos? Ordenadas alfabéticamente. (nacionalidad).
SELECT nacionalidad 
FROM interprete 
GROUP BY nacionalidad
HAVING COUNT (nacionalidad) = 1
;
-- S2.22. [F/M] Mostrar el identificador de las series que tienen 4 o más temporadas junto con el
-- número de temporadas. Ordenado por serie. (serie, n_temporadas).

SELECT serie, COUNT(*) n_temporadas
FROM temporada
GROUP BY serie
HAVING COUNT(*)>=4
;
-- S2.23. [F/M] Para cada serie en la que participa el actor 'David Tennant' indicar el número de veces
-- en total que aparece en la lista de intereses de los usuarios (serie, likes).

SELECT serie, COUNT(serie) AS likes
FROM interes 
WHERE serie IN (SELECT serie 
                FROM reparto 
                WHERE interprete IN (SELECT interprete_id 
                                    FROM interprete 
                                    WHERE nombre = 'David Tennant'))
                                GROUP BY serie;


-- S2.24. [F/M] Cuál es la media de las cuotas que pagan los usuarios que están interesados en más
-- de tres series. (cuota_media).

SELECT AVG(cuota) AS cuota_media
FROM usuario 
WHERE usuario_id  IN (SELECT usuario
                    FROM interes
                    GROUP BY usuario
                    HAVING COUNT(*) > 3 )
                    ; 



-- S2.25. [F/M] Series con más de 3 temporadas, de nacionalidad no británica y cuya edad mínima
-- es inferior a 18 (titulo, nacionalidad, genero).
SELECT TITULO, NACIONALIDAD ,GENERO
FROM serie
WHERE nacionalidad <> 'Reino Unido' AND edad_minima <18 AND serie_id IN(SELECT DISTINCT(serie)
                                                                        FROM capitulo
                                                                        WHERE temporada >=3)
;
-- S2.26. [M] Cuántos capítulos con duración inferior a 45 minutos tiene cada temporada de cada
-- serie con más de 2 temporadas. Ordenado por serie y temporada. (serie, temporada,
-- n_capitulos).

SELECT c.SERIE, c.TEMPORADA, COUNT(*) AS N_CAPITULOS
FROM CAPITULO c
WHERE c.DURACION < 45
  AND c.SERIE IN (
    SELECT t.SERIE
    FROM TEMPORADA t
    GROUP BY t.SERIE
    HAVING COUNT(DISTINCT t.TEMPORADA) > 2
)
GROUP BY c.SERIE, c.TEMPORADA
ORDER BY c.SERIE, c.TEMPORADA;
;

-- S2.27. [M] Usuarios que están viendo alguna serie que solo tiene 2 temporadas. (nombre, cuota).
SELECT nombre, cuota
FROM usuario
WHERE usuario_id IN(SELECT usuario
                    FROM estoy_viendo
                    WHERE serie IN(SELECT serie 
                                    FROM capitulo
                                    GROUP BY serie
                                    HAVING COUNT (DISTINCT (temporada))=2
                                    ))
;
-- S2.28. [M] Usuarios interesados en más de 5 series. (nombre, f_registro, cuota).

SELECT nombre, f_registro, cuota
FROM usuario
WHERE usuario_id IN (SELECT U.usuario_id
                    FROM interes I JOIN usuario U
                    ON (I.usuario = U.usuario_id)
                    GROUP BY U.usuario_id
                    HAVING COUNT (*)>5)
;
SELECT usuario
FROM interes I JOIN usuario U
ON (I.usuario = U.usuario_id)
GROUP BY U.usuario_id
HAVING COUNT (*)>5
;

-- S2.29. [M] Intérpretes que han participado en más de una serie, en orden alfabético. (nombre,
-- nacionalidad, a_nacimiento).
SELECT nombre, nacionalidad, a_nacimiento
FROM interprete
WHERE interprete_id IN (SELECT interprete
                        FROM reparto
                        GROUP BY interprete
                        HAVING COUNT (serie)>1)
ORDER BY nombre
;

-- S2.30. [M/D] Usuarios que están viendo más de un capítulo de la misma serie. (nombre).
SELECT nombre
FROM usuario
WHERE usuario_id IN(SELECT usuario
                    FROM estoy_viendo
                    GROUP BY usuario,serie
                    HAVING COUNT (*)>1)
;


-- S2.31. [M/D] En cuántas series británicas participa cada interprete de nacionalidad
-- estadounidense. (interprete, n_series_brit).
SELECT interprete
FROM reparto
WHERE serie IN (SELECT serie_id
                FROM serie
                WHERE nacionalidad = 'Reino Unido') 
            AND interprete IN (SELECT interprete_id
                                FROM interprete
                                WHERE nacionalidad = 'Estados Unidos')
;


-- S2.32. [M/D] Número de usuarios que están viendo cada serie. Si un usuario está viendo varios
-- capítulos de la misma serie, solo debe ser considerado una vez. Deben aparecer todas las series
-- y para las que no están siendo vistas por nadie debe aparecer el valor 0 en la columna
-- n_usuarios. Ordenado por identificador de serie. (serie_id, n_usuarios).
SELECT serie_id, COALESCE(COUNT(DISTINCT(usuario)),0) n_usuarios
FROM serie S LEFT JOIN estoy_viendo E
ON (S.serie_id = E.serie)
GROUP BY serie_id
ORDER BY serie_id
;

SELECT *
FROM serie S LEFT JOIN estoy_viendo E
ON (S.serie_id = E.serie)
;

-- S2.33. [M/D] Número de series que está viendo cada usuario, en orden descendente por el
-- número de series. Si un usuario está viendo diferentes capítulos de la misma serie, solo debe
-- ser considerada una vez. Deben mostrarse todos los usuarios; para los que no están viendo
-- ninguna serie debe aparecer un 0 en la columna series_en_curso. (usuario_id, series_en_curso).
-- esta_viendo, usuario

SELECT usuario_id, COUNT(DISTINCT (serie)) AS series_en_curso
FROM estoy_viendo E LEFT JOIN usuario U ON (E.usuario=U.usuario_id) 
GROUP BY usuario_id
ORDER BY COUNT(serie) desc; 



-- S2.34. [M/D] Número de series en las que se ha interesado cada usuario pero que todavía no ha
-- empezado a ver, es decir, no aparecen anotadas como ya vistas ni el usuario las tiene a medio
-- ver (usuario, series_pendientes).
-- series, usuario, interes 

SELECT usuario, COUNT(*) AS series_pendientes
FROM interes I
WHERE vista = 'NO' AND serie NOT IN (SELECT serie 
                                    FROM estoy_viendo E
                                    WHERE I.usuario = E.usuario AND I.serie=E.serie)
GROUP BY usuario; 

; 


-- S2.35. [M/D] Mostrar cuántas temporadas y cuántos capítulos en total tiene cada serie en la que
-- participa algún intérprete con nacionalidad 'ESTADOS UNIDOS'. Ordenado por identificador de serie.
-- (serie, n_temporadas, n_capitulos).
-- tablas interprete, 

SELECT serie, COUNT (DISTINCT(temporada)) AS n_temporadas, COUNT (capitulo) AS n_capitulos 
FROM capitulo
WHERE serie IN ( SELECT serie 
                FROM reparto 
                WHERE interprete IN (SELECT interprete_id
                                FROM interprete 
                                WHERE nacionalidad = 'Estados Unidos' ))
GROUP BY serie
ORDER BY serie; 