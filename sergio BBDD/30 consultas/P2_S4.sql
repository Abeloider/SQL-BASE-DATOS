/*
S4.1. [D] Usuarios que están interesados en todas las series. (usuario_id, nombre).
*/

SELECT usuario_id, nombre
FROM usuario u
WHERE NOT EXISTS(SELECT serie_id
                 FROM serie
                 WHERE (u.usuario_id, serie_id) NOT IN(SELECT usuario, serie
                                                       FROM interes));
                                                       
                                                       
                                                       
-------------------------------------------------------------------------------------------------------                                                       
SELECT i.interprete_id, i.nombre
FROM interprete I
WHERE NOT EXISTS(SELECT *
                FROM serie S
                WHERE S.nacionalidad = 'Espana' AND NOT EXISTS(SELECT *
                                                                FROM reparto R
                                                                WHERE R.serie = S.serie_id AND R.interprete = I.interprete_id));
-------------------------------------------------------------------------------------------------------



/*
S4.2. [D] Series en las que están interesados todos los usuarios (serie_id, titulo).
*/
SELECT serie_id, titulo
FROM SERIE S
WHERE NOT EXISTS(SELECT usuario_id
                 FROM USUARIO
                 WHERE (usuario_id, S.serie_id) NOT IN(SELECT usuario, serie
                                                       FROM INTERES));
                                                       
/*
S4.3. [D] Series que están viendo todos los usuarios cuya cuota es inferior a 36 euros. (serie_id, titulo)
*/
SELECT serie_id, titulo
FROM SERIE S
WHERE NOT EXISTS(SELECT usuario_id
                 FROM USUARIO
                 WHERE (usuario_id, S.serie_id) NOT IN(SELECT usuario, serie
                                                       FROM ESTOY_VIENDO) AND cuota < '36');


/*
S4.4. [D] Intérpretes que participan en todas las series que tienen la etiqueta ‘Aventura’.
(interprete_id, nombre).
*/

SELECT interprete_id, nombre
FROM INTERPRETE
WHERE NOT EXISTS (SELECT serie_id
                    FROM SERIE
                    WHERE (serie_id,interprete_id) NOT IN (SELECT serie, interprete
                                                            FROM REPARTO) AND serie_id IN (SELECT serie
                                                                                            FROM ETIQUETADO
                                                                                            WHERE etiqueta = 'Aventura'));
                                                            

/*
S4.5. [D] Usuarios que están interesados en todas las series del intérprete 'Matt Smith'. (usuario_id,
nombre).
*/


SELECT usuario_id, nombre
FROM usuario u
WHERE NOT EXISTS(SELECT serie_id
                 FROM serie
                 WHERE (u.usuario_id, serie_id) NOT IN(SELECT usuario, serie
                                                       FROM interes) AND serie_id IN (SELECT serie
                                                                                    FROM REPARTO
                                                                                    WHERE interprete IN (SELECT interprete_id
                                                                                                        FROM INTERPRETE
                                                                                                        WHERE nombre = 'Matt Smith')));



























