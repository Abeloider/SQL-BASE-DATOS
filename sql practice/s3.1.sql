--s3.19 

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


-- s3.13  para cada usuario inidcar la nacionalidad mas comun entre las series en als que esta interesadoo 
-- Es decir , si un usuario esta interesado en mas series españolas que esde cualquier otra nacionalidad 
-- , debe de aparecer su identificador junto con la nacionalidad españ en el resultado 
-- ordenador por usuario (usuario , nacionalidad)

SELECT N.usuario, S.nacionalidad, COUNT(*) n_series
FROM interes N 
        JOIN serie S ON N.serie = S.serie_id 

        --S.nacionalidad = `España`

GROUP by N.usuario, S.nacionalidad
HAVING COUNT(*) = (SELECT MAX (COUNT(*))
                     FROM interes NI
                     JOIN serie S1 on N1.serie=S1.serie_id
                     WHERE N1.usuario = n.usuario 
                     GROUP BY S1.naionalidad )
ORDER BY N.usuario;