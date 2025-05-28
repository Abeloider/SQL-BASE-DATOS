/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: bd2215 <----- PON TU CUENTA AQUI
 Integrante 1: Angel Ruiz Fernandez             <----- NOMBRES COMPLETOS
 Integrante 2: 
*/

-- EJERCICIOS:

-- Q10

SELECT S.titulo, COALESCE(n_interpretes, 0) n_interpretes, COALESCE(n_protas, 0) n_protas, COALESCE(n_yanquis, 0) n_yanquis
FROM serie S JOIN (
    SELECT serie, COUNT(*) n_interpretes
    FROM reparto
    GROUP BY serie
) A ON S.serie_id = A.serie
JOIN (
    SELECT serie, COUNT(*) n_protas
    FROM reparto
    WHERE rol = 'Protagonista'
    GROUP BY serie
) B ON S.serie_id = B.serie
LEFT JOIN (
    SELECT serie, COUNT(*) n_yanquis
    FROM reparto JOIN interprete ON interprete = interprete_id
    WHERE nacionalidad = 'Estados Unidos'
    GROUP BY serie
) C ON S.serie_id = C.serie
ORDER BY S.titulo;

-- Q11

SELECT interprete_id, nombre
FROM interprete I
WHERE NOT EXISTS (
    SELECT *
    FROM serie S
    WHERE S.nacionalidad = 'Espana' AND S.serie_id NOT IN (
        SELECT R.serie
        FROM reparto R
        WHERE R.interprete = I.interprete_id 
    )
);

-- Q12

SELECT U.usuario_id, U.nombre,  A.ultima_vez, B.capitulos_a_medio
FROM usuario U JOIN (
    SELECT N.usuario, MAX(N.f_interes) ultima_vez
    FROM interes N 
    WHERE N.serie IN (
        SELECT serie_id
        FROM serie
        WHERE genero != 'Policiaca'
    )
    GROUP BY N.usuario
) A ON U.usuario_id = A.usuario
JOIN (
    SELECT usuario, COUNT(*) capitulos_a_medio
    FROM estoy_viendo
    WHERE minuto > 15
    GROUP BY usuario
) B ON U.usuario_id = B.usuario
WHERE cuota < 60
ORDER BY A.ultima_vez;
