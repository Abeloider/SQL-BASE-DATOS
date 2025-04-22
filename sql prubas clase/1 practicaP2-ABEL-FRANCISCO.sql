/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: bd2109 <----- PON TU CUENTA AQUI
 Integrante 1: FRANCISCO TORNELL MINGOT             <----- NOMBRES COMPLETOS
 Integrante 2: ABELWANCHENG JIAGNWAN
*/

-- EJERCICIOS:

-- Qn 1

SELECT T.a_estreno , S.titulo titulo_serie , COALESCE(C.titulo, '****') titulo_capitulo 
FROM  serie S
JOIN temporada T ON S.serie_id = T.serie
JOIN capitulo C ON C.serie =T.serie
    AND C.temporada = T.temporada
 WHERE C.capitulo = 1 
    AND T.temporada = 1
    AND (S.nacionalidad = 'Espana' OR S.nacionalidad = 'Reino Unido')
ORDER BY T.a_estreno;


-- Qm 2

SELECT interprete_id
FROM INTERPRETE
WHERE nacionalidad <> 'Reino Unido' 
AND a_nacimiento > 1982

MINUS

SELECT interprete
FROM REPARTO
WHERE serie IN (SELECT serie_id 
                FROM SERIE 
                WHERE genero = 'Drama');

-- Qp 3

SELECT U.nombre AS nombre_usuario, COALESCE (S.titulo, '----') titulo_serie
FROM series.usuario U 
    LEFT JOIN interes N ON N.usuario = U.usuario_id
    LEFT JOIN serie S  ON N.serie = S.serie_id
WHERE U.cuota < 50 
    AND ROUND(((SYSDATE - U.f_registro)/365),1) > 3  
    ORDER BY U.nombre, S.titulo; 