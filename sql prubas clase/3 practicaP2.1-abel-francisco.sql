/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: bd2109 <----- PON TU CUENTA AQUI
 Integrante 1: FRANCISCO TORNELL MINGOT             <----- NOMBRES COMPLETOS
 Integrante 2: ABELWANCHENG JIAGNWAN
*/

-- Q7

SELECT titulo, nacionalidad
FROM SERIE
WHERE serie_id IN (
    SELECT serie
    FROM INTERES
    WHERE usuario IN (
                SELECT usuario_id
                FROM USUARIO
                WHERE cuota < 50 )
) AND serie_id IN (
                SELECT serie
                FROM REPARTO
                WHERE interprete IN (
                                SELECT interprete_id
                                FROM INTERPRETE
                                WHERE nacionalidad = 'Estados Unidos'
                                )
                                GROUP BY serie
                                HAVING COUNT(interprete) > 3 )
                                AND serie_id IN (
                                                SELECT serie
                                                FROM ETIQUETADO
                                                GROUP BY serie
                                                HAVING COUNT(etiqueta) < 4
);



-- Q8

SELECT nombre, nacionalidad, a_nacimiento
FROM INTERPRETE
WHERE interprete_id IN (
                    SELECT interprete
                    FROM REPARTO
                    WHERE serie = (
                                    SELECT serie
                                    FROM INTERES
                                    GROUP BY serie
                                    HAVING COUNT(usuario) = (SELECT MAX(COUNT(usuario))
                                                            FROM INTERES
                                                            GROUP BY serie
                                     )
                    )
    AND rol = 'Protagonista'
);




-- Q9

SELECT DISTINCT EV.usuario, EV.serie, EV.temporada AS ultima_temporada
FROM ESTOY_VIENDO EV
JOIN TEMPORADA T ON EV.serie = T.serie AND EV.temporada = T.temporada
JOIN ETIQUETADO E ON E.serie = EV.serie
WHERE E.etiqueta = 'Accion'AND EV.temporada = (
                                             SELECT MAX(EV2.temporada)
                                             FROM ESTOY_VIENDO EV2
                                             WHERE EV2.usuario = EV.usuario AND EV2.serie = EV.serie
                                            )
ORDER BY EV.usuario;
    