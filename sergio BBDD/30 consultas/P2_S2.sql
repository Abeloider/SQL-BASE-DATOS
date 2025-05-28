/*
S2.1. [F] Título y género de las series que nadie está viendo. (titulo, genero).
*/

SELECT titulo, genero
FROM SERIE
WHERE serie_id NOT IN (SELECT serie
                        FROM ESTOY_VIENDO);
                        

/*
S2.2. [F] Usuarios tales que la última vez que vieron alguna serie fue hace más de cuatro años.
(nombre, f_registro, cuota).
*/

SELECT nombre, f_registro, cuota
FROM USUARIO
WHERE usuario_id IN (SELECT usuario
                    FROM ESTOY_VIENDO
                    WHERE f_ultimo_acceso < TO_DATE('23/05/2021','dd/mm/yyyy'));
                    

/*
S2.3. [F] Etiquetas empleadas en las series que son de interés para los usuarios que no están
viendo ninguna serie. (etiqueta).
*/

SELECT DISTINCT etiqueta
FROM ETIQUETADO
WHERE serie IN (SELECT serie
                FROM interes
                WHERE usuario NOT IN (SELECT usuario
                                        FROM ESTOY_VIENDO));


/*
S2.4. [F] Usuarios que no tienen interés en ninguna serie española, ordenado por nombre.
(nombre, f_registro, email).
*/

SELECT nombre, f_registro, email
FROM USUARIO
WHERE usuario_id NOT IN (SELECT usuario
                        FROM INTERES
                        WHERE serie IN (SELECT serie_id
                                        FROM SERIE
                                        WHERE nacionalidad = 'Espana'))
                                        ORDER BY nombre;


/*
S2.5. [F/M] Intérpretes que participan como protagonistas en alguna serie 'Policiaca', ordenado
por nombre. (nombre, nacionalidad, a_nacimiento).
*/

SELECT nombre, nacionalidad, a_nacimiento
FROM INTERPRETE
WHERE interprete_id IN (SELECT interprete
                        FROM REPARTO
                        WHERE serie IN(SELECT serie_id
                                        FROM SERIE
                                        WHERE genero = 'Policiaca') AND rol = 'Protagonista')
                                        ORDER BY nombre;


/*
S2.6. [F/M] Nombres y nacionalidades de los intérpretes no españoles, que han participado en
series de nacionalidad española. Ordenado por nombre de intérprete. (nombre,
nacionalidad).
*/

SELECT nombre, nacionalidad
FROM INTERPRETE
WHERE interprete_id IN (SELECT interprete
                        FROM REPARTO
                        WHERE serie IN(SELECT serie_id
                                        FROM SERIE
                                        WHERE nacionalidad = 'Espana') AND NOT nacionalidad = 'Espana')
                                        ORDER BY nombre;


/*
S2.7. [M] Usuarios que actualmente están viendo alguna serie en cuyo reparto hay un intérprete
nacido entre 1990 y 2000. (usuario_id, nombre, email).
*/

SELECT usuario_id, nombre, email
FROM USUARIO
WHERE usuario_id IN (SELECT usuario
                    FROM ESTOY_VIENDO
                    WHERE serie IN(SELECT serie
                                    FROM REPARTO
                                    WHERE interprete IN(SELECT interprete_id
                                                        FROM INTERPRETE
                                                        WHERE a_nacimiento > 1990 AND a_nacimiento < 2000)));
                                                        

/*
S2.8. [M] Usuarios que se han dejado a medio ver el primer capítulo de la primera temporada de
alguna serie que sólo tiene una temporada. Se asume que si un usuario ha visto un capítulo
completo, éste desaparece de su lista “Estoy viendo”. No se debe utilizar agrupamiento ni
funciones de agregados. (usuario_id, nombre, cuota).
*/
                    
SELECT usuario_id, nombre, cuota
FROM USUARIO
WHERE usuario_id IN(SELECT usuario
                    FROM ESTOY_VIENDO
                    WHERE capitulo = '1' AND temporada = '1' AND serie NOT IN (SELECT serie
                                                                            FROM TEMPORADA
                                                                            WHERE temporada > 1));


/*
S2.9. [M] Series de género 'Drama' que tienen alguna etiqueta que también aparezca en alguna
serie de género 'Policiaca'. (titulo, nacionalidad, edad_minima).
*/

SELECT titulo, nacionalidad, edad_minima
FROM SERIE
WHERE genero = 'Drama' AND serie_id IN(SELECT serie
                                       FROM ETIQUETADO
                                       WHERE etiqueta IN(SELECT etiqueta
                                                        FROM ETIQUETADO
                                                        WHERE serie IN (SELECT serie_id
                                                                        FROM serie
                                                                        WHERE genero = 'Policiaca')));


/*
S2.10. [M/D] Usuarios que pagan una cuota inferior a 65 euros y anotaron que alguna serie era de
su interés después del 1 de enero de 2024, o bien que se registraron en 2022 y no están viendo
ninguna serie. Ordenado por identificador de usuario. (usuario_id, nombre, f_registro).
*/

SELECT usuario_id, nombre, f_registro
FROM USUARIO
WHERE cuota < '65' AND usuario_id IN (SELECT usuario
                                    FROM INTERES
                                    WHERE f_interes > TO_DATE('01/01/2024','dd/mm/yyyy')) OR (f_registro = TO_DATE('2022','yyyy') AND usuario_id NOT IN(SELECT usuario
                                                                                                                                                        FROM ESTOY_VIENDO));
                                                                                                                                                        

/*
S2.11. [M] Series que tengan algún capítulo de la segunda temporada con una duración mayor que
todos los capítulos de la tercera temporada. (serie_id, titulo).
*/


SELECT serie_id, titulo
FROM SERIE
WHERE serie_id IN (SELECT S.serie
                    FROM CAPITULO S
                    WHERE S.temporada = '2' AND duracion > ALL (SELECT duracion
                                                              FROM CAPITULO
                                                              WHERE temporada = '3' AND serie=S.serie));


/*
S2.12. [M] Series tales que han pasado 2 o más años entre el estreno de su primera y su segunda
temporada . (titulo, nacionalidad).
*/

SELECT titulo, nacionalidad
FROM SERIE
WHERE serie_id IN (SELECT t1.serie
                    FROM TEMPORADA t1
                    WHERE t1.temporada = 1 AND EXISTS (SELECT serie
                                                       FROM TEMPORADA t2
                                                       WHERE t2.serie = t1.serie AND t2.temporada = 2 AND t2.a_estreno - t1.a_estreno >= 2));


/*
S2.13. [M/D] Series que algún usuario está viendo para las que no indicó que eran de su interés.
(serie_id, titulo, genero).
*/

SELECT serie_id, titulo, genero
FROM SERIE
WHERE serie_id IN (SELECT S.serie
                    FROM ESTOY_VIENDO S
                    WHERE S.usuario NOT IN (SELECT usuario
                                            FROM INTERES
                                            WHERE S.serie = serie)); 



/*
S2.14. [F] Para cada etiqueta, mostrar en cuántas series aparece. Ordenado por número de series.
(etiqueta, n_series).
*/

SELECT etiqueta, COUNT(serie) AS n_series
FROM ETIQUETADO
GROUP BY etiqueta
ORDER BY n_series;


/*
S2.15. [F] Cuántas series hay de cada nacionalidad. Ordenado por número de series.
(nacionalidad, n_series).
*/

SELECT nacionalidad, COUNT(serie_id) AS n_series
FROM SERIE
GROUP BY nacionalidad
ORDER BY n_series;


/*
S2.16. [F] Cuántas series cuya edad mínima recomendada es superior a 12 hay de cada género, en
orden descendente por género. (genero, n_series).
*/

SELECT genero, COUNT(serie_id) AS n_series
FROM SERIE
WHERE edad_minima > '12'
GROUP BY genero
ORDER BY genero DESC;


/*
S2.17. [F] Para cada usuario indicar cuántas series, de las que se interesó, ya ha visto de forma
completa. (usuario, n_series_vistas).
*/

SELECT usuario, COUNT(vista) AS n_series_vistas
FROM INTERES
WHERE vista = 'SI'
GROUP BY usuario;


/*
S2.18. [F] Cuántos usuarios están interesados en cada serie. Ordenado por serie. (serie,
n_usuarios).
*/

SELECT serie, COUNT(usuario) AS n_usuarios
FROM INTERES
GROUP BY serie;


/*
S2.19. [F] Etiquetas utilizadas en más de 3 series. (etiqueta).
*/

SELECT etiqueta
FROM ETIQUETADO
GROUP BY etiqueta HAVING COUNT(etiqueta) > 3;


/*
S2.20. [F/M] Cuántas series hay con algún capítulo que no tiene título. Trata de resolverlo sin
acceder a la tabla SERIE. (n_series).
*/


SELECT COUNT(DISTINCT serie) AS n_series
FROM CAPITULO
WHERE titulo IS NULL;


/*
S2.21. [F/M] ¿Cuáles son las nacionalidades para las que solo hay un intérprete en la base de
datos? Ordenadas alfabéticamente. (nacionalidad).
*/


SELECT nacionalidad
FROM INTERPRETE
GROUP BY nacionalidad HAVING COUNT(*) = 1
ORDER BY nacionalidad;


/*
S2.22. [F/M] Mostrar el identificador de las series que tienen 4 o más temporadas junto con el
número de temporadas. Ordenado por serie. (serie, n_temporadas).
*/

SELECT serie, COUNT(serie) AS n_temporadas
FROM TEMPORADA
GROUP BY serie HAVING COUNT(*) >= '4';


/*
S2.23. [F/M] Para cada serie en la que participa el actor 'David Tennant' indicar el número de veces
en total que aparece en la lista de intereses de los usuarios (serie, likes).
*/

SELECT serie, COUNT(serie) AS likes
FROM INTERES
WHERE serie IN(SELECT serie
                FROM REPARTO
                WHERE interprete IN(SELECT interprete_id
                                    FROM INTERPRETE
                                    WHERE nombre = 'David Tennant')) GROUP BY serie;



/*
S2.24. [F/M] Cuál es la media de las cuotas que pagan los usuarios que están interesados en más
de tres series. (cuota_media).
*/

SELECT AVG(cuota) AS cuota_media
FROM USUARIO
WHERE usuario_id IN(SELECT usuario
                    FROM INTERES
                    GROUP BY usuario HAVING COUNT(*) > '3');
                    
                    

/*
S2.25. [F/M] Series con más de 3 temporadas, de nacionalidad no británica y cuya edad mínima es
inferior a 18 (titulo, nacionalidad, genero).
*/

SELECT titulo, nacionalidad, genero
FROM SERIE
WHERE NOT nacionalidad = 'Reino Unido' AND edad_minima < '18' AND serie_id IN (SELECT serie
                                                                            FROM TEMPORADA
                                                                            GROUP BY serie HAVING COUNT(*) > 3);



/*
S2.26. [M] Cuántos capítulos con duración inferior a 45 minutos tiene cada temporada de cada serie
con más de 2 temporadas. Ordenado por serie y temporada. (serie, temporada, n_capitulos).
*/

SELECT DISTINCT serie, temporada, COUNT(*) AS n_capitulos
FROM CAPITULO
WHERE duracion < '45' AND serie IN(SELECT serie
                                    FROM TEMPORADA
                                    GROUP BY serie HAVING COUNT(*) > '2')
                                    GROUP BY serie, temporada;


/*
S2.27. [M] Usuarios que están viendo alguna serie que solo tiene 2 temporadas. (nombre, cuota).
*/

SELECT nombre, cuota
FROM USUARIO
WHERE usuario_id IN(SELECT usuario
                    FROM ESTOY_VIENDO
                    WHERE serie IN(SELECT serie
                                    FROM TEMPORADA
                                    GROUP BY serie HAVING COUNT(*) = 2));



/*
S2.28. [M] Usuarios interesados en más de 5 series. (nombre, f_registro, cuota).
*/

SELECT nombre, f_registro, cuota
FROM USUARIO
WHERE usuario_id IN(SELECT usuario
                    FROM INTERES
                    GROUP BY usuario HAVING COUNT(*) > '5');




/*
S2.29. [M] Intérpretes que han participado en más de una serie, en orden alfabético. (nombre,
nacionalidad, a_nacimiento).
*/

SELECT nombre, nacionalidad, a_nacimiento
FROM INTERPRETE
WHERE interprete_id IN( SELECT interprete
                        FROM REPARTO
                        GROUP BY interprete HAVING COUNT(*) > '1')
                        ORDER BY nombre;








/*
S2.32. [M/D] Número de usuarios que están viendo cada serie. Si un usuario está viendo varios
capítulos de la misma serie, solo debe ser considerado una vez. Deben aparecer todas las series
y para las que no están siendo vistas por nadie debe aparecer el valor 0 en la columna
n_usuarios. Ordenado por identificador de serie. (serie_id, n_usuarios).
*/


SELECT serie_id,(SELECT COUNT(DISTINCT usuario) 
FROM ESTOY_VIENDO 
WHERE serie = s.serie_id) AS n_usuarios
FROM SERIE s
ORDER BY serie_id;





/*
S2.35. [M/D] Mostrar cuántas temporadas y cuántos capítulos en total tiene cada serie en la que
participa algún intérprete con nacionalidad 'Estados Unidos'. Ordenado por identificador de
serie. (serie, n_temporadas, n_capitulos).
*/

SELECT C.serie, (SELECT COUNT(DISTINCT temporada) 
                    FROM temporada t
                    WHERE t.serie = C.serie) AS n_temporadas, COUNT(*) AS n_capitulos
FROM CAPITULO C
WHERE serie IN(SELECT serie
            FROM REPARTO
            WHERE interprete IN(SELECT interprete_id
                                FROM INTERPRETE
                                WHERE nacionalidad = 'Estados Unidos')) GROUP BY serie;
















