
-- S3.1. [M] Etiqueta más utilizada para describir series. (etiqueta).
SELECT etiqueta
FROM etiquetado
GROUP BY etiqueta
HAVING COUNT(etiqueta) = (SELECT MAX(COUNT(etiqueta)) 
                            FROM etiquetado 
                            GROUP BY etiqueta
);

-- S3.2. [M] Serie que, entre los intereses de los usuarios, es la que más veces aparece como vista de
-- forma completa (el sistema lo ha anotado así en la columna vista de la tabla de intereses),
-- indicando también cuántas veces ha sido vista. (serie, veces_vista).

SELECT serie, COUNT(*)
FROM interes
WHERE vista = 'SI'
GROUP BY serie
HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                FROM interes
                WHERE vista='SI'
                GROUP BY serie)
;

-- S3.3. [M]Nacionalidad de la que hay menos series, indicando cuántas series hay de esa
-- nacionalidad. (nacionalidad, n_series).

SELECT nacionalidad, COUNT(nacionalidad)
FROM serie
GROUP BY nacionalidad
HAVING COUNT (nacionalidad) = (SELECT MIN(COUNT(serie_id))
                                FROM serie
                                GROUP BY nacionalidad)
;

-- S3.4. [M] Usuario que está interesado en más series que ningún otro, incluyendo el número de
-- series. (usuario_id, n_series).

SELECT usuario, COUNT(*)n_series
FROM interes
GROUP BY usuario
HAVING COUNT (*)=(SELECT MAX(COUNT(*))
                    FROM interes
                    GROUP BY usuario)
;

-- S3.5. [M] Serie en la que más usuarios están interesados, indicando cuántos. (serie, n_usuarios).

SELECT serie, COUNT (DISTINCT(usuario))
FROM interes
GROUP BY serie
HAVING COUNT (serie) =(SELECT MAX(COUNT(DISTINCT(usuario)))
                        FROM capitulo C JOIN interes I
                        ON(c.serie = i.serie)
                        GROUP BY c.serie)
;

-- S3.6. [M] Serie que más temporadas tiene, mostrando cuántas temporadas (serie, n_temporadas).

SELECT serie, COUNT(*) N_TEMPORADAS
FROM temporada
GROUP BY serie
HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                FROM temporada
                GROUP BY serie)
;

-- S3.7. [M] Serie que más veces está siendo vista por los usuarios, es decir, que tenga más capítulos
-- a medio ver por los usuarios. Como siempre, se asume que todos los capítulos que aparecen en
-- la lista “Estoy viendo” de un usuario son los que tiene a medio ver, pues cuando se ve un
-- capítulo completo, éste desaparece de su lista “Estoy viendo”. (serie, n_capitulos_a_medio).
SELECT serie, COUNT(usuario)
FROM estoy_viendo
GROUP BY serie
HAVING COUNT(serie) = (SELECT MAX(COUNT(usuario))
                        FROM estoy_viendo
                        GROUP BY serie)
;
-- S3.8. [M/D] Serie que más veces está siendo vista por un mismo usuario, es decir, que tenga más
-- capítulos a medio ver por el mismo usuario, indicando quién es. Como siempre, se asume que
-- todos los capítulos que aparecen en la lista “Estoy viendo” de un usuario son los que tiene a
-- medio ver, pues cuando se ve un capítulo completo, éste desaparece de su lista “Estoy viendo”.
-- (serie, usuario, n_capitulos_a_medio).
SELECT serie,usuario,COUNT(*)N_CAPITULOS_A_MEDIO
FROM estoy_viendo
GROUP BY serie,usuario
HAVING COUNT(*)=(SELECT MAX(COUNT(*))
FROM estoy_viendo
GROUP BY serie,usuario)
;
-- S3.9. [M] Nacionalidad de la que se tiene más intérpretes en la base de datos, indicando cuántos
-- son. (nacionalidad, n_interpretes).
SELECT nacionalidad, COUNT(interprete_id)
FROM interprete
GROUP BY nacionalidad
HAVING COUNT (interprete_id) = (SELECT MAX(COUNT(interprete_id))
                                FROM interprete
                                GROUP BY nacionalidad)

;
-- S3.10. [M] Intérprete que más veces participa en series, indicando cuántas (interprete, num_veces).
SELECT interprete, COUNT(*)num_veces
FROM reparto
GROUP BY interprete
HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                    FROM reparto
                    GROUP BY interprete)
;
-- S3.11. [M/D] Etiquetas asociadas a la serie que tiene más usuarios interesados. En orden alfabético.
-- (etiqueta).
SELECT etiqueta
FROM etiquetado
WHERE serie =(SELECT serie
                FROM interes 
                GROUP BY serie
                HAVING COUNT (USUARIO) = (SELECT MAX(COUNT(usuario))
                                            FROM interes
                                            GROUP BY serie))
;

-- S3.12. [M/D] Series en las que actúan como protagonistas los intérpretes que más veces participan
-- en series. (serie_id, titulo)
SELECT *
FROM reparto
WHERE rol='Protagonista'AND interprete IN(SELECT interprete
                                            FROM reparto
                                            GROUP BY interprete
                                            HAVING COUNT(serie)=(SELECT MAX(COUNT(serie))
                                                            FROM reparto
                                                            GROUP BY interprete))

;

-- S3.13. [DD] Para cada usuario indicar la nacionalidad más común entre las series en las que está
-- interesado. Es decir, si un usuario está interesado en más series españolas que de cualquier otra
-- nacionalidad, debe aparecer su identificador junto con la nacionalidad 'Espana' en el resultado.
-- Ordenado por usuario. (usuario, nacionalidad).

--jodida

-- S3.14. [D] Título y edad mínima recomendada de la serie que más temporadas tiene, indicando
-- cuántas. (titulo, edad_minima, n_temporadas).
SELECT titulo, edad_minima, n_temporada
FROM serie S JOIN (SELECT serie, count(temporada)n_temporada
                    FROM temporada
                    GROUP BY serie
                    HAVING COUNT(temporada)=(SELECT MAX(COUNT(temporada))
                                                FROM temporada
                                                GROUP BY serie))X
ON(S.serie_id=X.serie)

;
-- S3.15. [D] Título y género de la serie que más veces aparece en la lista de intereses de los usuarios,
-- indicando cuántos son los usuarios interesados en ella. (titulo, genero, n_interesados)

SELECT titulo, genero, n_interesados
FROM serie S 
    JOIN (SELECT serie, COUNT(usuario) AS n_interesados
            FROM interes
            GROUP BY serie
            HAVING COUNT (serie) =(SELECT MAX(COUNT(usuario))
                                    FROM interes
                                    GROUP BY serie))C
ON S.serie_id=C.serie
;

-- S3.16. [D] Serie en las que participan más intérpretes, indicando cuántos son (serie_id, titulo,
-- n_interpretes).

SELECT serie_id, titulo, n_interpretes
FROM serie S JOIN(SELECT serie, COUNT(interprete)n_interpretes
                    FROM reparto
                    GROUP BY serie
                    HAVING COUNT(interprete)=(SELECT MAX(COUNT(interprete))
                                                FROM reparto
                                                GROUP BY serie))X
ON(S.serie_id=X.serie)
;
SELECT serie, COUNT(interprete)n_interpretes
FROM reparto
GROUP BY serie
HAVING COUNT(interprete)=(SELECT MAX(COUNT(interprete))
                            FROM reparto
                            GROUP BY serie
                            )
;

-- S3.17. [D] Nombre y año de nacimiento del intérprete que más veces participa en series, indicando
-- en cuántas (nombre, a_nacimiento, n_series).
SELECT nombre, a_nacimiento, n_series
FROM interprete I JOIN(SELECT interprete, COUNT(serie) AS n_series
                    FROM reparto
                    GROUP BY interprete
                    HAVING COUNT (serie)=(SELECT MAX(COUNT(serie)) 
                                            FROM reparto
                                            GROUP BY interprete)) X
ON(I.interprete_id = X.interprete)
;


-- S3.18. [M/D] Para cada intérprete, mostrar en cuántas series ha participado, cuántas de ellas son de
-- genero 'Policiaca' y cuántas de ellas tienen una etiqueta 'Thriller'. (nombre, n_series,
-- n_policiacas, n_thrillers).
SELECT nombre,n_series,N_POLICIACAS,n_thriller
FROM interprete I JOIN(SELECT interprete,COUNT(*)n_series
                        FROM reparto
                        GROUP BY interprete)X
ON(I.interprete_id=X.interprete)
JOIN(SELECT interprete,COUNT(*)n_policiacas
FROM serie S JOIN reparto R
ON(S.serie_id=R.serie)
WHERE (genero='Policiaca')
GROUP BY interprete)Y
ON(I.interprete_id=Y.interprete)
JOIN(SELECT interprete,COUNT(*)n_thriller
FROM etiquetado E JOIN reparto R
ON(E.serie=R.serie)
WHERE (etiqueta='Thriller')
GROUP BY interprete)Z
ON(I.interprete_id=Z.interprete)
;
-- S3.19. [D] Para cada usuario, mostrar los identificadores de las series de nacionalidad británica que
-- está viendo, y cuántos capítulos está viendo de cada una de esas series. Ordenado por usuario
-- y serie. (nombre, serie, n_capitulos).
--parte 1
        SELECT usuario, serie, n_capitulos
        FROM usuario U
                JOIN (SELECT usuario, serie, COUNT(*) n_capitulos
                        FROM estoy_viendo
                        WHERE serie IN (SELECT serie_id
                                        FROM serie 
                                        WHERE nacionalidad = 'Reino Unido')  
                        GROUP BY usuario, serie) E
                 ON U.usuario_id = E.usuario; 

        SELECT usuario, serie, n_capitulos
        FROM usuario U
                JOIN estoy_viendo E ON U.usuario_id = E.usuario
                       WHERE serie IN ( SELECT serie_id
                                        FROM serie 
                                        WHERE nacionalidad = 'Reino Unido')
                                 GROUP BY usuario, serie ;       

-- Parte 2: Deben aparecer todos los usuarios, de modo que para aquellos que no están viendo
-- ninguna serie británica, la columna serie debe mostrar tres guiones: '---' y la columna
-- n_capitulos debe contener un 0.
-- parte 2 
        SELECT nombrem, COALESCE(serie, '----') , COALESCE(n_capitulos, 0) 
        FROM usuario U 
                LEFT JOIN ( SELECT usuario, serie, COUNT(*) n_capitulos
                            FROM estoy_viendo
                            WHERE serie IN (SELECT serie_id
                                            FROM serie 
                                            WHERE nacionalidad = 'Reino Unido')  

                        GROUP BY usuario, serie) E
        ON U.usuario_id = E.usuario; 


-- S3.20. [D] Para cada serie, indicar cuántas temporadas tiene, cuántos usuarios están interesados en
-- ella, y cuántos usuarios la están viendo. Ordenado por título de serie. (titulo, n_temporadas,
-- n_interesados, n_visores).
--  Parte 2. Deben aparecer todas las series. Si no tienen usuarios interesados, o ninguno la está
-- viendo, debe mostrarse un 0 en la(s) columna(s) correspondiente(s).

SELECT titulo,N_TEMPORADAS,N_INTERESADOS,COALESCE(N_USUARIOS,0)AS N_USUARIOS
FROM serie S
LEFT JOIN(SELECT serie, COUNT(*)N_TEMPORADAS
FROM temporada
GROUP BY serie)X
ON(S.serie_id=X.serie)
LEFT JOIN(SELECT serie, COUNT(*)n_interesados
FROM interes
GROUP BY serie)Y
ON(S.serie_id=Y.serie)
LEFT JOIN(SELECT serie, COUNT(DISTINCT(usuario))n_usuarios
FROM estoy_viendo
GROUP BY serie)Z
ON(S.serie_id=Z.serie)
order by titulo
;


-- S3.21. [D] Para cada serie, mostrar cuántas etiquetas tiene, cuántas temporadas, y cuántos capítulos
-- de duración inferior a 50 minutos. (titulo, n_etiquetas, n_temporadas, n_capitulos).
-- Parte 2. Deben aparecer todas las series. Si no tienen etiquetas o no tienen capítulos de
-- duración inferior a 50 minutos, debe mostrarse un 0 en la(s) columna(s) correspondiente(s).

--??













--s3.19 




