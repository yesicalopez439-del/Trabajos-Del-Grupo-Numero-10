
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CONSULTAS BÁSICAS (SELECT sin JOIN)
--
-- Miembros del grupo
-- Yesica Alejandra Bedoya
-- Jesús Ángel Ruiz Builes
-- simon blandon villa 


--
-- CONSULTAS BÁSICAS (SELECT sin JOIN / De una sola tabla)
--

--
-- Consulta 1: Listar todos los nombres de los pacientes masculinos.
--
SELECT
    Nombre,
    Apellido
FROM
    Paciente
WHERE
    Genero = 'M'
ORDER BY
    Apellido ASC;


--
-- Consulta 2: Obtener todas las especialidades cuyo ID es mayor que 5.
--
SELECT
    ID_Especialidad,
    Nombre_Especialidad
FROM
    Especialidad
WHERE
    ID_Especialidad > 5
ORDER BY
    ID_Especialidad ASC;


--
-- Consulta 3: Listar todos los hospitales ubicados en la ciudad de 'Bogotá'.
--
SELECT
    Nombre_Hospital,
    Ciudad
FROM
    Hospital
WHERE
    Ciudad = 'Bogotá'
ORDER BY
    Nombre_Hospital ASC;


--
-- Consulta 4: Obtener el ID y el nombre de todos los enfermeros de género Femenino.
--
SELECT
    ID_Enfermero,
    Nombre,
    Apellido
FROM
    Enfermero
WHERE
    Genero = 'F'
ORDER BY
    Apellido ASC;


--
-- Consulta 5: Listar los médicos cuyo apellido comience con la letra 'R'.
--
SELECT
    Nombre,
    Apellido,
    ID_Medico
FROM
    Medico
WHERE
    Apellido LIKE 'R%'
ORDER BY
    Apellido ASC;


--
-- Consulta 6: Obtener las hospitalizaciones (ID y fechas) que ocurrieron después del 1 de octubre de 2025.
--
SELECT
    ID_Hospitalizacion,
    Fecha_Ingreso,
    Fecha_Egreso
FROM
    Hospitalizacion
WHERE
    Fecha_Ingreso > '2025-10-01'
ORDER BY
    Fecha_Ingreso ASC;


--
-- Consulta 7: Seleccionar el nombre completo de los pacientes nacidos antes del año 2000.
--
SELECT
    Nombre,
    Apellido,
    Fecha_Nacimiento
FROM
    Paciente
WHERE
    Fecha_Nacimiento < '2000-01-01'
ORDER BY
    Fecha_Nacimiento DESC;


--
-- Consulta 8: Listar todos los médicos que tienen la Especialidad ID 1 (Cardiología).
--
SELECT
    Nombre,
    Apellido,
    ID_Medico
FROM
    Medico
WHERE
    ID_Especialidad = 1
ORDER BY
    Apellido ASC;


--
-- Consulta 9: Obtener el ID de la asignación y el ID del enfermero para asignaciones hechas en una fecha específica (ejemplo: '2025-01-01').
--
SELECT
    ID_Hospitalizacion,
    ID_Enfermero,
    Fecha_Asignacion
FROM
    Asignacion_Enfermero
WHERE
    Fecha_Asignacion = '2025-01-01'
ORDER BY
    ID_Hospitalizacion ASC;


--
-- Consulta 10: Listar el ID de los hospitales cuyo nombre contenga la palabra 'Central'.
--
SELECT
    ID_Hospital,
    Nombre_Hospital
FROM
    Hospital
WHERE
    Nombre_Hospital LIKE '%Central%'
ORDER BY
    ID_Hospital ASC;

