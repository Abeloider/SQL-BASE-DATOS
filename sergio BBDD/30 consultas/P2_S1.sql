/*
S1.1. [F] Título, género y edad mínima recomendada de las series no españolas [observa que la
nacionalidad española se indica con el texto 'Espana'] cuya edad mínima recomendada es inferior
a 18 años. (titulo, genero, edad_minima).
*/

SELECT titulo, genero, edad_minima
FROM SERIE
WHERE NOT nacionalidad = 'Espana' AND edad_minima < '18';


/*
S1.2. [F] Identificadores de las series y temporadas que los usuarios están viendo. Sin duplicados.
Ordenado por serie y temporada. (serie, temporada).
*/

SELECT DISTINCT serie, temporada
FROM ESTOY_VIENDO
ORDER BY serie, temporada;


/*
S1.3. [F] Capítulos de la temporada 3 o posterior de alguna serie, cuya duración sea inferior a 45
minutos, ordenado por serie y temporada. (serie, temporada, capitulo, titulo, duracion).
*/

SELECT DISTINCT serie, temporada, capitulo, titulo, duracion
FROM CAPITULO
WHERE temporada >= '3' AND duracion < '45'
ORDER BY serie, temporada;


/*
S1.4. [F] Usuarios cuya cuota está entre 50 y 100 euros y que se registraron después del
20/05/2020, ordenados por fecha de registro, de más reciente a más antigua (usuario_id,
nombre, f_registro).
*/

SELECT usuario_id, nombre, f_registro
FROM USUARIO
WHERE cuota >= 50 AND cuota <= 100 AND f_registro > TO_DATE('20/05/2020', 'dd/mm/yyyy')
ORDER BY f_registro DESC;


/*
S1.5. [F] Identificador de los usuarios que desde antes del 05/02/2025 tienen pendiente de
terminar algún capítulo del que visualizaron al menos 15 minutos. Sin duplicados y
ordenado por usuario. (usuario). 
*/



