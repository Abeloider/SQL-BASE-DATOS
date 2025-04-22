--s4.2 

-- series tales que 
-- NO existe un usuario que 
-- NO esta interesado en ella

SELECT serie_id
FROM serie 
WHERE NOT EXISTS (  SELECT * 
                    FROM usuario 
                    WHERE NOT EXISTS (
                                        SELECT* 
                                        FROM interes I
                                        WHERE I.serie= s.serie_id
                                        AND I.ususario = U.usuario_id)); 

SELECT serie_id
FROM serie S
WHERE NOT EXISTS (  SELECT * 
                    FROM usuario U
                    WHERE U.usuario_id NOT IN (  SELECT * 
                                                 FROM usuario 
                                                 WHERE interes I
                                                 AND I.ususario = U.usuario_id)); 

SELECT serie_id
FROM serie S
WHERE NOT EXISTS (  SELECT ususario_id
                    FROM usuario U
                    WHERE U.usuario_id 

                    MINUS

                    SELECT usuario
                    FROM interes I
                    WHERE I.serie= s.serie_id
                    AND I.ususario = U.usuario_id); 
        
           
           