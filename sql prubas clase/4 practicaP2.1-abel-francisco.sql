/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: bd2109 <----- PON TU CUENTA AQUI
 Integrante 1: FRANCISCO TORNELL MINGOT             <----- NOMBRES COMPLETOS
 Integrante 2: ABELWANCHENG JIAGNWAN
*/

-- Q10
--parte 1


SELECT titulo,  n_interpretes,  n_protas,n_yanquis
FROM SERIE S
JOIN ( SELECT serie,  COUNT(*) n_interpretes 
       FROM REPARTO 
       GROUP BY serie
        ) K ON S.serie_id=  K.serie 
        
JOIN ( SELECT serie,  COUNT(*) n_protas
       FROM REPARTO 
       WHERE rol = 'Protagonista'
       GROUP BY serie
        ) L ON S.serie_id = L.serie
        
JOIN ( SELECT serie,  COUNT(*) n_yanquis
       FROM REPARTO 
       WHERE interprete IN (SELECT interprete_id
                            FROM INTERPRETE
                            WHERE nacionalidad='Estados Unidos'
                            )
                            GROUP BY serie ) B ON S.serie_id= B.serie
      
            
ORDER BY titulo; 


--PARTE 2
SELECT titulo,  n_interpretes,  n_protas, COALESCE (n_yanquis,0) n_yanquis
FROM SERIE S
JOIN ( SELECT serie,  COUNT(*) n_interpretes 
       FROM REPARTO 
       GROUP BY serie
        ) K ON S.serie_id=  K.serie 
        
JOIN ( SELECT serie,  COUNT(*) n_protas
       FROM REPARTO 
       WHERE rol = 'Protagonista'
       GROUP BY serie
        ) L ON S.serie_id = L.serie
        
LEFT  JOIN ( SELECT serie,  COUNT(*) n_yanquis
       FROM REPARTO 
       WHERE interprete IN (SELECT interprete_id
                            FROM INTERPRETE
                            WHERE nacionalidad='Estados Unidos'
                            ) 
                            GROUP BY serie ) B ON S.serie_id= B.serie
      
            
ORDER BY titulo; 


-- Q11

SELECT interprete_id, nombre
FROM INTERPRETE
WHERE NOT EXISTS (
    SELECT serie_id
    FROM SERIE
    WHERE nacionalidad = 'Espana'
    MINUS
    SELECT serie
    FROM REPARTO
    WHERE interprete = INTERPRETE.interprete_id
);



-- Q12
















