
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CONSULTAS AVANZADAS (SELECT con JOIN)
--
-- Miembros del grupo
-- Yesica Alejandra Bedoya
-- Jesús Ángel Ruiz Builes
-- simon blandon villa 


--
-- CONSULTAS AVANZADAS (Niveles de JOIN y Agregación)
--

--
-- Consulta 1 (1 JOIN)
-- Muestra el nombre completo de los médicos junto con el nombre de su especialidad.
--
SELECT
    M.Nombre AS Nombre_Medico,
    M.Apellido AS Apellido_Medico,
    E.Nombre_Especialidad
FROM
    Medico M
JOIN
    Especialidad E ON M.ID_Especialidad = E.ID_Especialidad
ORDER BY
    M.Apellido ASC;


--
-- Consulta 2 (1 JOIN, con COUNT)
-- Cuenta el número total de hospitalizaciones registradas por cada hospital.
--
SELECT
    H.Nombre_Hospital,
    H.Ciudad,
    COUNT(Ho.ID_Hospitalizacion) AS Total_Hospitalizaciones
FROM
    Hospital H
JOIN
    Hospitalizacion Ho ON H.ID_Hospital = Ho.ID_Hospital
GROUP BY
    H.Nombre_Hospital, H.Ciudad
ORDER BY
    Total_Hospitalizaciones DESC;


--
-- Consulta 3 (1 JOIN)
-- Obtiene el nombre completo y la fecha de ingreso de todos los pacientes hospitalizados, ordenados por fecha.
--
SELECT
    P.Nombre AS Nombre_Paciente,
    P.Apellido AS Apellido_Paciente,
    Ho.Fecha_Ingreso
FROM
    Paciente P
JOIN
    Hospitalizacion Ho ON P.ID_Paciente = Ho.ID_Paciente
ORDER BY
    Ho.Fecha_Ingreso DESC;


--
-- Consulta 4 (2 JOINs, con MAX)
-- Lista pacientes, hospital y médico principal. Muestra la fecha de egreso más reciente (MAX).
--
SELECT
    P.Nombre AS Nombre_Paciente,
    P.Apellido AS Apellido_Paciente,
    Ho.Fecha_Ingreso,
    MAX(Ho.Fecha_Egreso) AS Ultima_Fecha_Egreso,
    M.Nombre AS Nombre_Medico,
    M.Apellido AS Apellido_Medico
FROM
    Paciente P
JOIN
    Hospitalizacion Ho ON P.ID_Paciente = Ho.ID_Paciente
JOIN
    Medico M ON Ho.ID_Medico_Principal = M.ID_Medico
GROUP BY
    P.Nombre, P.Apellido, Ho.Fecha_Ingreso, M.Nombre, M.Apellido
ORDER BY
    Ultima_Fecha_Egreso DESC NULLS LAST;


--
-- Consulta 5 (2 JOINs, con MIN)
-- Muestra enfermeros y la fecha de asignación más antigua (MIN) a una hospitalización.
--
SELECT
    E.Nombre AS Nombre_Enfermero,
    E.Apellido AS Apellido_Enfermero,
    AE.ID_Hospitalizacion,
    MIN(AE.Fecha_Asignacion) AS Primera_Asignacion
FROM
    Enfermero E
JOIN
    Asignacion_Enfermero AE ON E.ID_Enfermero = AE.ID_Enfermero
JOIN
    Hospitalizacion Ho ON AE.ID_Hospitalizacion = Ho.ID_Hospitalizacion
GROUP BY
    E.Nombre, E.Apellido, AE.ID_Hospitalizacion
ORDER BY
    Primera_Asignacion ASC;


--
-- Consulta 6 (2 JOINs)
-- Obtiene el nombre del médico y el hospital donde atendió al paciente (filtrado por especialidad, ejemplo: Cardiología).
--
SELECT
    M.Nombre AS Nombre_Medico,
    M.Apellido AS Apellido_Medico,
    H.Nombre_Hospital,
    P.Nombre AS Nombre_Paciente_Atendido
FROM
    Medico M
JOIN
    Hospitalizacion Ho ON M.ID_Medico = Ho.ID_Medico_Principal
JOIN
    Hospital H ON Ho.ID_Hospital = H.ID_Hospital
JOIN
    Paciente P ON Ho.ID_Paciente = P.ID_Paciente
WHERE
    M.ID_Especialidad = 1 -- Filtrar por Cardiología
ORDER BY
    H.Nombre_Hospital, M.Apellido;


--
-- Consulta 7 (3 JOINs, con AVG)
-- Calcula la duración promedio de estancia (AVG) en días de las hospitalizaciones, agrupadas por especialidad.
-- NOTA: Usa el operador de intervalo para compatibilidad con PostgreSQL.
--
SELECT
    E.Nombre_Especialidad,
    AVG(Ho.Fecha_Egreso - Ho.Fecha_Ingreso) AS Duracion_Promedio_Intervalo
FROM
    Especialidad E
JOIN
    Medico M ON E.ID_Especialidad = M.ID_Especialidad
JOIN
    Hospitalizacion Ho ON M.ID_Medico = Ho.ID_Medico_Principal
WHERE
    Ho.Fecha_Egreso IS NOT NULL
GROUP BY
    E.Nombre_Especialidad
ORDER BY
    Duracion_Promedio_Intervalo DESC;


--
-- Consulta 8 (3 JOINs)
-- Lista médicos de Pediatría que atendieron pacientes en un hospital específico (ejemplo: Medellín).
--
SELECT
    M.Nombre AS Nombre_Medico,
    M.Apellido AS Apellido_Medico,
    H.Nombre_Hospital,
    E.Nombre_Especialidad
FROM
    Medico M
JOIN
    Especialidad E ON M.ID_Especialidad = E.ID_Especialidad
JOIN
    Hospitalizacion Ho ON M.ID_Medico = Ho.ID_Medico_Principal
JOIN
    Hospital H ON Ho.ID_Hospital = H.ID_Hospital
WHERE
    E.Nombre_Especialidad = 'Pediatría' AND H.Ciudad = 'Medellín'
ORDER BY
    M.Apellido ASC;


--
-- Consulta 9 (4 JOINs, con SUM)
-- Calcula la suma total de días (SUM) de hospitalización para cada paciente atendido por un enfermero específico.
-- NOTA: Usa el operador de intervalo para compatibilidad con PostgreSQL.
--
SELECT
    Enf.Nombre AS Nombre_Enfermero,
    Enf.Apellido AS Apellido_Enfermero,
    H.Nombre_Hospital,
    P.Nombre AS Nombre_Paciente,
    SUM(Ho.Fecha_Egreso - Ho.Fecha_Ingreso) AS Total_Intervalo_Atendido
FROM
    Enfermero Enf
JOIN
    Asignacion_Enfermero AE ON Enf.ID_Enfermero = AE.ID_Enfermero
JOIN
    Hospitalizacion Ho ON AE.ID_Hospitalizacion = Ho.ID_Hospitalizacion
JOIN
    Hospital H ON Ho.ID_Hospital = H.ID_Hospital
JOIN
    Paciente P ON Ho.ID_Paciente = P.ID_Paciente
WHERE
    Ho.Fecha_Egreso IS NOT NULL
GROUP BY
    Enf.Nombre, Enf.Apellido, H.Nombre_Hospital, P.Nombre
ORDER BY
    Total_Intervalo_Atendido DESC;


--
-- Consulta 10 (5 JOINs)
-- Muestra el listado detallado (Paciente, Hospital, Médico, Especialidad, Enfermero) de hospitalizaciones en Enero 2025.
-- NOTA: Se usa LEFT JOIN para incluir hospitalizaciones que quizás no tienen enfermero asignado.
--
SELECT
    P.Nombre AS Paciente,
    P.Apellido AS Apellido_Paciente,
    H.Nombre_Hospital,
    M.Nombre AS Medico_Principal,
    E.Nombre_Especialidad,
    Enf.Nombre AS Enfermero_Asignado,
    Ho.Fecha_Ingreso,
    Ho.Fecha_Egreso
FROM
    Hospitalizacion Ho
JOIN
    Paciente P ON Ho.ID_Paciente = P.ID_Paciente
JOIN
    Hospital H ON Ho.ID_Hospital = H.ID_Hospital
JOIN
    Medico M ON Ho.ID_Medico_Principal = M.ID_Medico
JOIN
    Especialidad E ON M.ID_Especialidad = E.ID_Especialidad
LEFT JOIN
    Asignacion_Enfermero AE ON Ho.ID_Hospitalizacion = AE.ID_Hospitalizacion
LEFT JOIN
    Enfermero Enf ON AE.ID_Enfermero = Enf.ID_Enfermero
WHERE
    Ho.Fecha_Ingreso >= '2025-01-01' AND Ho.Fecha_Ingreso <= '2025-01-31'
ORDER BY
    Ho.Fecha_Ingreso, P.Apellido;