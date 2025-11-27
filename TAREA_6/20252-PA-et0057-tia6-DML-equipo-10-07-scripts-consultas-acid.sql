--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN y CONSULTAS DE UNA VISTA 
--
-- Miembros del grupo
--simon blando villa
--jesus angel ruiz 
--yesica alejandra lópez bedoya


--
-- SCRIPT CREACIÖN DE LA VISTA
--
CREATE OR REPLACE VIEW vw_hospitalizacion AS
SELECT
    p.paciente_id,
    p.nombre AS nombre_paciente,
    p.apellido AS apellido_paciente,

    v.visita_id,
    v.fecha_visita,
    v.motivo,

    d.diagnostico_id,
    d.nombre AS diagnostico_nombre,

    h.hospitalizacion_id,
    h.fecha_ingreso,
    h.fecha_salida,
    h.dias_estancia,
    h.costo_total,

    e.especialidad_id,
    e.nombre AS especialidad_nombre,

    m.medico_id,
    m.nombre AS nombre_medico
FROM paciente p
JOIN visita v              ON p.paciente_id = v.paciente_id
JOIN diagnostico d         ON v.diagnostico_id = d.diagnostico_id
JOIN hospitalizacion h     ON v.visita_id = h.visita_id
JOIN medico m              ON h.medico_id = m.medico_id
JOIN especialidad e        ON m.especialidad_id = e.especialidad_id;
-- TOTAL: 6 JOIN

--
-- SCRIPT DE CONSULTAS UTILIZANDO LA VISTA
--

--
-- Consulta 1
--
--  Pacientes hospitalizados por especialidad
--  (COUNT, GROUP BY, ORDER BY)
SELECT 
    especialidad_nombre AS especialidad,
    COUNT(*) AS total_pacientes
FROM vw_hospitalizacion
GROUP BY especialidad_nombre
ORDER BY total_pacientes DESC;
--
-- Consulta 2
--
--  Costo acumulado por paciente
--  (SUM, GROUP BY, ORDER BY)
SELECT 
    paciente_id,
    nombre_paciente,
    SUM(costo_total) AS costo_acumulado
FROM vw_hospitalizacion
GROUP BY paciente_id, nombre_paciente
ORDER BY costo_acumulado DESC;
--
-- Consulta 3
--
--  Duración máxima y mínima de estancia por diagnóstico
--  (MAX, MIN, GROUP BY)
SELECT 
    diagnostico_nombre,
    MAX(dias_estancia) AS max_estancia,
    MIN(dias_estancia) AS min_estancia
FROM vw_hospitalizacion
GROUP BY diagnostico_nombre
ORDER BY diagnostico_nombre;
--
-- Consulta 4
--
--  Cantidad de hospitalizaciones por año
--  (COUNT, GROUP BY, ORDER BY)

SELECT 
    EXTRACT(YEAR FROM fecha_ingreso) AS anio,
    COUNT(*) AS total_hospitalizaciones
FROM vw_hospitalizacion
GROUP BY anio
ORDER BY anio;
--
-- Consulta 5
--
--  Costo total de hospitalización por especialidad
--  (SUM, GROUP BY, ORDER BY)

SELECT 
    especialidad_nombre AS especialidad,
    SUM(costo_total) AS costo_total_especialidad
FROM vw_hospitalizacion
GROUP BY especialidad_nombre
ORDER BY costo_total_especialidad DESC;