--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN y CONSULTAS DE UNA VISTA 
--
-- Miembros del grupo
----simon blando villa
--jesus angel ruiz 
--yesica alejandra lópez bedoya
--
--
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
-- Insert #1 Registrar Paciente --
BEGIN;

INSERT INTO paciente (nombre, apellido, fecha_nacimiento)
VALUES ('Daniel', 'López', '1988-04-10');

COMMIT;

--
-- Consulta 2
--
-- Insert #2 Registrar Medico -- 
BEGIN;

INSERT INTO medico (nombre, especialidad_id)
VALUES ('Carolina Suárez', 2);

COMMIT;

--
--Consulta 3
--
-- Insert #3 Registar una Hospitalizacion --

BEGIN;

INSERT INTO hospitalizacion (visita_id, fecha_ingreso, fecha_salida, dias_estancia, costo_total, medico_id)
VALUES (8, '2025-02-01', '2025-02-05', 4, 900000, 1);

COMMIT;

--
-- Consulta 4
--
--- UPDATE ---

-- Update #1 Cambiar nombre de paciente --

BEGIN;

UPDATE paciente
SET nombre = 'Dani'
WHERE paciente_id = 1;

COMMIT;

--
-- Consulta 5
--
-- Update #2 Actualizar dias de estancia --

BEGIN;

UPDATE hospitalizacion
SET dias_estancia = 7
WHERE hospitalizacion_id = 3;

COMMIT;

--
-- Consulta 6
--
-- Update #3 Cambiar especialidad de medico --

BEGIN;

UPDATE medico
SET especialidad_id = 3
WHERE medico_id = 2;

COMMIT;

--
-- Consulta 7
--
--- DELETE ---

-- Delete #1 Eliminar diagnostico --

BEGIN;

DELETE FROM diagnostico
WHERE diagnostico_id = 12;

COMMIT;

--
-- Consulta 8
--
-- Delete #2 Eliminar una visita sin depencencias --

BEGIN;

DELETE FROM visita
WHERE visita_id = 20;

COMMIT;
--
-- Consulta 9
--
-- Delete #3 Eliminar una especialidad -- 

BEGIN;

DELETE FROM especialidad
WHERE especialidad_id = 7;

COMMIT;

