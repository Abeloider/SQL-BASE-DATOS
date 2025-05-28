1/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: bd2215 <----- PON TU CUENTA AQUI
 Integrante 1: Angel Ruiz F <----- NOMBRES COMPLETOS
 Integrante 2: 
*/

-- EJERCICIOS:

-- Q7

SELECT titulo, nacionalidad
FROM SERIE
WHERE serie_id IN (
    (
        SELECT serie
        FROM ETIQUETADO
        GROUP BY serie
        HAVING COUNT(*) < 4
    )
    INTERSECT
    (
        SELECT serie
        FROM INTERES
        WHERE usuario IN (
            SELECT usuario_id
            FROM USUARIO
            WHERE cuota < 50
        )
    )
    INTERSECT
    (
        SELECT serie
        FROM REPARTO
        WHERE interprete IN (
            SELECT interprete_id
            FROM INTERPRETE
            WHERE nacionalidad = 'Estados Unidos'
        )
        GROUP BY serie
        HAVING COUNT(*) > 3
    )
);

-- Q8

SELECT nombre, nacionalidad, a_nacimiento
FROM INTERPRETE
WHERE interprete_id IN (
    SELECT interprete
    FROM REPARTO
    WHERE serie IN (
        SELECT serie
        FROM INTERES
        GROUP BY serie
        HAVING COUNT(*) = (
            SELECT MAX(COUNT(*))
            FROM INTERES
            GROUP BY serie
        )
    )
    AND rol = 'Protagonista'
);

-- Q9

SELECT DISTINCT e.usuario, e.serie, e.temporada ultima_temporada
FROM ESTOY_VIENDO e
WHERE e.serie IN (
    SELECT serie
    FROM ETIQUETADO q
    WHERE q.etiqueta = 'Accion'
) AND e.temporada = (
    SELECT MAX(t.temporada)
    FROM TEMPORADA t
    WHERE t.serie = e.serie
)
ORDER BY e.usuario;

SELECT DISTINCT e.usuario, e.serie, e.temporada ultima_temporada
FROM ESTOY_VIENDO e JOIN TEMPORADA t ON e.serie = t.serie
WHERE e.serie IN (
    SELECT serie
    FROM ETIQUETADO q
    WHERE q.etiqueta = 'Accion'
)
AND e.temporada = MAX(t.temporada)
--GROUP BY t.serie
ORDER BY e.usuario;
