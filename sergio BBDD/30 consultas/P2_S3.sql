/*
S3.1. [M] Etiqueta más utilizada para describir series. (etiqueta).
*/

SELECT etiqueta
FROM ETIQUETADO
GROUP BY etiqueta HAVING COUNT(*) = (   SELECT MAX(COUNT(*))
                                        FROM ETIQUETADO
                                        GROUP BY etiqueta
);

/*
S3.2. [M] Serie que, entre los intereses de los usuarios, es la que más veces aparece como vista de
forma completa (el sistema lo ha anotado así en la columna vista de la tabla de intereses),
indicando también cuántas veces ha sido vista. (serie, veces_vista).
*/


SELECT serie, COUNT(*) AS veces_vista
FROM INTERES
WHERE vista = 'SI'
GROUP BY serie HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                    FROM INTERES
                                    WHERE vista = 'SI'
                                    GROUP BY serie);


/*
S3.3. [M]Nacionalidad de la que hay menos series, indicando cuántas series hay de esa
nacionalidad. (nacionalidad, n_series).
*/

SELECT nacionalidad, COUNT(*) AS n_series
FROM SERIE
GROUP BY nacionalidad HAVING COUNT(*) = ( SELECT MIN(COUNT(*))
                                    FROM SERIE
                                    GROUP BY nacionalidad);


/*
S3.4. [M] Usuario que está interesado en más series que ningún otro, incluyendo el número de
series. (usuario_id, n_series).
*/

SELECT usuario, COUNT(serie) AS n_series
FROM INTERES 
GROUP BY usuario
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM INTERES
                    GROUP BY usuario);



/*
S3.5. [M] Serie en la que más usuarios están interesados, indicando cuántos. (serie, n_usuarios).
*/


SELECT serie, COUNT(*) AS n_usuarios
FROM INTERES 
GROUP BY serie
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM INTERES
                    GROUP BY serie);

/*
S3.6. [M] Serie que más temporadas tiene, mostrando cuántas temporadas (serie, n_temporadas).
*/

SELECT serie, COUNT(*) AS n_temporadas
FROM TEMPORADA 
GROUP BY serie
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM TEMPORADA
                    GROUP BY serie);



/*
S3.7. [M] Serie que más veces está siendo vista por los usuarios, es decir, que tenga más capítulos a
medio ver por los usuarios. Como siempre, se asume que todos los capítulos que aparecen en la
lista “Estoy viendo” de un usuario son los que tiene a medio ver, pues cuando se ve un capítulo
completo, éste desaparece de su lista “Estoy viendo”. (serie, n_capitulos_a_medio).
*/


SELECT serie, COUNT(*) AS n_capitulos_a_medio
FROM ESTOY_VIENDO 
GROUP BY serie
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM ESTOY_VIENDO
                    GROUP BY serie);



/*
S3.8. [M/D] Serie que más veces está siendo vista por un mismo usuario, es decir, que tenga más
capítulos a medio ver por el mismo usuario, indicando quién es. Como siempre, se asume que
todos los capítulos que aparecen en la lista “Estoy viendo” de un usuario son los que tiene a
medio ver, pues cuando se ve un capítulo completo, éste desaparece de su lista “Estoy viendo”.
(serie, usuario, n_capitulos_a_medio).
*/

SELECT serie, usuario, COUNT(*) AS n_capitulos_a_medio
FROM ESTOY_VIENDO 
GROUP BY serie, usuario
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM ESTOY_VIENDO
                    GROUP BY serie, usuario);



/*
S3.9. [M] Nacionalidad de la que se tiene más intérpretes en la base de datos, indicando cuántos
son. (nacionalidad, n_interpretes).
*/

SELECT nacionalidad, COUNT(*) AS n_interpretes
FROM INTERPRETE 
GROUP BY nacionalidad
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM INTERPRETE
                    GROUP BY nacionalidad);


/*
S3.10. [M] Intérprete que más veces participa en series, indicando cuántas (interprete, num_veces).
*/


SELECT interprete, COUNT(*) AS num_veces
FROM REPARTO 
GROUP BY interprete
HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                    FROM REPARTO
                    GROUP BY interprete);


/*
S3.11. [M/D] Etiquetas asociadas a la serie que tiene más usuarios interesados. En orden alfabético.
(etiqueta).
*/

--Normal--
SELECT etiqueta
FROM ETIQUETADO 
WHERE serie IN (SELECT serie
                FROM INTERES
                GROUP BY serie
                HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                    FROM INTERES
                                    GROUP BY serie));
--ONLINE VIEW--
SELECT etiqueta
FROM ETIQUETADO e
JOIN (SELECT serie
                FROM INTERES
                GROUP BY serie
                HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                    FROM INTERES
                                    GROUP BY serie)) f
                                    ON e.serie = f.serie;


/*
S3.12. [M/D] Series en las que actúan como protagonistas los intérpretes que más veces participan
en series. (serie_id, titulo)
*/

--ONLINE VIEW--
SELECT serie_id, titulo
FROM SERIE s
JOIN (  SELECT serie
        FROM REPARTO
        WHERE rol = 'Protagonista' AND interprete IN (  SELECT interprete
                                                        FROM REPARTO        
                                                        GROUP BY interprete HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                                                                                FROM REPARTO
                                                                                                WHERE rol = 'Protagonista'
                                                                                                GROUP BY interprete))) f
                                                                                                ON s.serie_id = f.serie;
--NORMAL--

SELECT serie_id, titulo
FROM SERIE 
WHERE serie_id IN ( SELECT serie
                    FROM REPARTO
                    WHERE rol = 'Protagonista' AND interprete IN (SELECT interprete
                                                                  FROM REPARTO        
                                                                  GROUP BY interprete HAVING COUNT(*) = (   SELECT MAX(COUNT(*))
                                                                                                            FROM REPARTO
                                                                                                            WHERE rol = 'Protagonista'
                                                                                                            GROUP BY interprete)));


/*
S3.13. [DD] Para cada usuario indicar la nacionalidad más común entre las series en las que está
interesado. Es decir, si un usuario está interesado en más series españolas que de cualquier otra
nacionalidad, debe aparecer su identificador junto con la nacionalidad 'Espana' en el resultado.
Ordenado por usuario. (usuario, nacionalidad).
*/

-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------
-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------
-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------
SELECT DISTINCT usuario, nacionalidad
FROM INTERES
JOIN (SELECT serie_id,nacionalidad
     FROM SERIE 
     WHERE serie_id IN (SELECT serie
                        FROM INTERES)
                        GROUP BY serie_id,nacionalidad HAVING COUNT(*) = (  SELECT MAX(COUNT(*))
                                                FROM SERIE
                                                GROUP BY serie_id,nacionalidad))f
                                                ON serie = f.serie_id
                                                ORDER BY usuario;
-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------
-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------
-------------ESTA MAL----ESTA MAL-------ESTA MAL----------ESTA MAL--------------ESTA MAL---------------ESTA MAL------------------








--------------------------------------------
SELECT usuario,nacionalidad
FROM interes it 
JOIN (SELECT serie_id,nacionalidad
      FROM serie )g 
      ON g.serie_id = serie
      GROUP BY usuario,nacionalidad
      HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                       FROM interes  
                       JOIN (SELECT serie_id,nacionalidad
                             FROM serie )h 
                             ON h.serie_id = serie
                             WHERE it.usuario=usuario                
                             GROUP BY usuario,nacionalidad)
                             ORDER BY usuario;  



----------------------------------------------------------------------------------------

/*
S3.14. [D] Título y edad mínima recomendada de la serie que más temporadas tiene, indicando
cuántas. (titulo, edad_minima, n_temporadas).
*/

SELECT titulo, edad_minima, (SELECT COUNT(temporada) 
                             FROM temporada t
                             WHERE t.serie = serie_id) AS n_temporadas
FROM SERIE
WHERE serie_id IN (SELECT serie
                    FROM TEMPORADA
                    GROUP BY serie HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                                       FROM TEMPORADA
                                                       GROUP BY serie));

/*
S3.15. [D] Título y género de la serie que más veces aparece en la lista de intereses de los usuarios,
indicando cuántos son los usuarios interesados en ella. (titulo, genero, n_interesados)
*/

SELECT titulo, genero, (SELECT COUNT(serie) 
                             FROM INTERES I
                             WHERE I.serie = serie_id) AS n_interesados
FROM SERIE
WHERE serie_id IN (SELECT serie
                    FROM INTERES
                    GROUP BY serie HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                                       FROM INTERES
                                                       GROUP BY serie));



/*
S3.16. [D] Serie en las que participan más intérpretes, indicando cuántos son (serie_id, titulo,
n_interpretes).
*/

SELECT serie_id, titulo, (SELECT COUNT(serie) 
                             FROM REPARTO R
                             WHERE R.serie = serie_id) AS n_interpretes
FROM SERIE
WHERE serie_id IN (SELECT serie
                    FROM REPARTO
                    GROUP BY serie HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                                            FROM REPARTO
                                                            GROUP BY serie));


/*
S3.17. [D] Nombre y año de nacimiento del intérprete que más veces participa en series, indicando
en cuántas (nombre, a_nacimiento, n_series).
*/

SELECT nombre, a_nacimiento, (SELECT COUNT(serie) 
                             FROM REPARTO R
                             WHERE R.interprete = I.interprete_id) AS n_series
FROM INTERPRETE I
WHERE interprete_id IN (SELECT interprete
                        FROM REPARTO 
                        GROUP BY interprete HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                                            FROM REPARTO
                                                            GROUP BY interprete));



/*
S3.18. [M/D] Para cada intérprete, mostrar en cuántas series ha participado, cuántas de ellas son de
genero 'Policiaca' y cuántas de ellas tienen una etiqueta 'Thriller'. (nombre, n_series, n_policiacas,
n_thrillers).
*/

SELECT nombre, n_series, n_policiacas, n_thrillers
FROM interprete I
JOIN (SELECT R.interprete, COUNT(R.serie) n_series
        FROM reparto R
        GROUP BY interprete) X ON I.interprete_id=X.interprete
    
JOIN (SELECT R.interprete, COUNT(R.serie) n_policiacas
        FROM reparto R
        WHERE R.serie IN (SELECT S.serie_id
                            FROM serie S
                            WHERE genero='Policiaca')
                            GROUP BY R.interprete )Y ON I.interprete_id=Y.interprete

JOIN (SELECT R.interprete, COUNT(R.serie) n_thrillers
        FROM reparto R
        WHERE R.serie IN (SELECT E.serie
                            FROM etiquetado E
                            WHERE etiqueta='Thriller')
                            GROUP BY R.interprete )Z ON I.interprete_id=Z.interprete
                            ORDER BY I.nombre;





/*
S3.19. [D] Para cada usuario, mostrar los identificadores de las series de nacionalidad británica que
está viendo, y cuántos capítulos está viendo de cada una de esas series. Ordenado por usuario y
serie. (nombre, serie, n_capitulos).
Parte 2: Deben aparecer todos los usuarios, de modo que para aquellos que no están viendo ninguna
serie británica, la columna serie debe mostrar tres guiones: '---' y la columna n_capitulos debe
contener un 0.
*/






















