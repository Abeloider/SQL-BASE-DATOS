--S4.1. [D] Usuarios que están interesados en todas las series. (usuario_id, nombre).
SELECT usuario_id, nombre
FROM usuario U
WHERE NOT EXISTS(SELECT *
                FROM serie S
                WHERE S.serie_id NOT IN(SELECT serie
                                        FROM interes I
                                        WHERE U.usuario_id = I.usuario )
)
;
--S4.2. [D] Series en las que están interesados todos los usuarios (serie_id, titulo).
-- series tales que 
-- NO existe un usuario que 
-- NO esta interesado en ella

--mal
--              SELECT serie_id
--              FROM serie 
--              WHERE NOT EXISTS (  SELECT * 
--                                  FROM usuario 
--                                  WHERE NOT EXISTS (
--                                                      SELECT* 
--                                                      FROM interes I
--                                                      WHERE I.serie= s.serie_id
--                                                      AND I.ususario = U.usuario_id)); 
--              --mal
--              SELECT serie_id
--              FROM serie S
--              WHERE NOT EXISTS (  SELECT * 
--                                  FROM usuario U
--                                  WHERE U.usuario_id NOT IN (  SELECT * 
--                                                               FROM usuario 
--                                                               WHERE interes I
--                                                               AND I.ususario = U.usuario_id)); 
--              --mal
--              SELECT serie_id
--              FROM serie S
--              WHERE NOT EXISTS (  SELECT ususario_id
--                                  FROM usuario U
--                                  WHERE U.usuario_id 
--              
--                                  MINUS
--              
--                                  SELECT usuario
--                                  FROM interes I
--                                  WHERE I.serie= s.serie_id
--                                  AND I.ususario = U.usuario_id); 
        
SELECT serie_id, titulo
FROM serie S
WHERE NOT EXISTS(SELECT *
                FROM usuario U
                WHERE U.usuario_id NOT IN (SELECT usuario
                                FROM interes I
                                WHERE (S.serie_id=I.serie)
                                ))
;

-- S4.3. [D] Series que están viendo todos los usuarios cuya cuota es inferior a 36 euros. (serie_id, titulo)
SELECT serie_id, titulo
FROM serie S
WHERE NOT EXISTS(SELECT *
                FROM usuario U
                WHERE cuota <36 AND U.usuario_id NOT IN(SELECT usuario
                                            FROM estoy_viendo E
                                            WHERE (S.serie_id=E.serie)
                ))
;
-- S4.4. [D] Intérpretes que participan en todas las series que  tienen  la  etiqueta  ‘Aventura’. 
-- (interprete_id, nombre). 
SELECT interprete_id, nombre
FROM interprete I
WHERE NOT EXISTS(SELECT *
                FROM serie S JOIN etiquetado E
                ON(S.serie_id=E.serie)
                WHERE etiqueta='Aventura' AND S.serie_id NOT IN (SELECT serie
                                        FROM reparto R
                                        WHERE I.interprete_id=R.interprete
                
                ))
;
-- S4.5. [D] Usuarios que están interesados en todas las series del intérprete 'Matt Smith'. (usuario_id, 
-- nombre).
SELECT usuario_id, nombre
FROM usuario U
WHERE NOT EXISTS (SELECT *
                    FROM reparto R JOIN interprete I
                    ON(R.interprete=I.interprete_id)
                    WHERE I.nombre='Matt Smith' AND R.serie NOT IN(SELECT serie
                                                                        FROM interes I
                                                                        WHERE I.usuario=U.usuario_id ))
;
