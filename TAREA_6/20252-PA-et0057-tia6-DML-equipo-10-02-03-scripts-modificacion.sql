--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE MODIFICACIÓN DE LA BASE DE DATOS (UPDATE, DELETES)
--
-- Miembros del grupo
--simon blando villa
--jesus angel ruiz 
--yesica alejandra lópez bedoya

--
-- INSTRUCCIONES DE MODIFICACIÓN SOLICITADAS
--
--2.1	Pacientes	5	●	* Actualizar la informaciòn de 5 registros de la tabla pacientes
-- Una actualizaciòn de UN SOLO campo en cada uno de los 5 registros Debe seleccionar 5 campos diferentes. No debe repetir un mismo campo Justifique la actualizaciòn. Nota: Escenario simulado/hipotètico. 
--2.2	Médicos	5 	Idem al ìtem 2.1. pero con médicos
--2.4	Enfermeras	5	Idem al ìtem 2.1. pero con enfermeros/ras
--2.5	Hospitales	5 	Idem al ìtem 2.1. pero con hospitales
--2.6	Hospitalizaciones 	5	Idem al ìtem 2.1. pero con hospitalizaciones
--
--Pacientes	5	Eliminar 5 pacientes
--Médicos	5 	Eliminar 5 médicos
--Especialidades Médicas	2 	Eliminar 2 especialidades médicas 
--Enfermeras	5	Actualizar la informaciòn de 10 campos del registro pacientes. No debe repetir el mismo campo en cada caso. Justifique su respuesta de porquè modificó el dato. Recuerde que es una situación hipotética.
--Hospitales	5 	Actualizar la informaciòn de 10 campos del registro pacientes. No debe repetir el mismo campo en cada caso. Justifique su respuesta de porquè modificó el dato. Recuerde que es una situación hipotética.
--Hospitalizaciones 	5	Actualizar la informaciòn de 10 campos del registro pacientes. No debe repetir el mismo campo en cada caso. Justifique su respuesta de porquè modificó el dato. Recuerde que es una situación hipotética.

-- Instrucciones UPDATE 
--
-- ACTUALIZACIÓN DE REGISTROS (DML - UPDATE)

-- 2.1. Actualización en la Tabla PACIENTE (Corrección de Nombre)
UPDATE Paciente SET Nombre = 'Luis Alberto' WHERE ID_Paciente = 'P10001';
UPDATE Paciente SET Nombre = 'Laura Sofía' WHERE ID_Paciente = 'P10006';
UPDATE Paciente SET Nombre = 'Javier David' WHERE ID_Paciente = 'P10021';
UPDATE Paciente SET Nombre = 'Andrea Carolina' WHERE ID_Paciente = 'P10026';
UPDATE Paciente SET Nombre = 'Pedro José' WHERE ID_Paciente = 'P10041';

-- 2.2. Actualización en la Tabla MEDICO (Corrección/Ajuste de Apellido)
UPDATE Medico SET Apellido = 'Muñoz De Soto' WHERE ID_Medico = 'M20001';
UPDATE Medico SET Apellido = 'Ruiz Martínez' WHERE ID_Medico = 'M20002';
UPDATE Medico SET Apellido = 'Gómez Ríos' WHERE ID_Medico = 'M20003';
UPDATE Medico SET Apellido = 'Díaz Morales' WHERE ID_Medico = 'M20004';
UPDATE Medico SET Apellido = 'Hernández Lázaro' WHERE ID_Medico = 'M20005';

-- 2.3. Actualización en la Tabla ESPECIALIDAD (Añadir Clarificación/Subespecialidad)
UPDATE Especialidad SET Nombre_Especialidad = 'Cardiología Intervencionista' WHERE ID_Especialidad = 1;
UPDATE Especialidad SET Nombre_Especialidad = 'Pediatría Neonatal' WHERE ID_Especialidad = 2;
UPDATE Especialidad SET Nombre_Especialidad = 'Neumología Respiratoria' WHERE ID_Especialidad = 3;
UPDATE Especialidad SET Nombre_Especialidad = 'Traumatología Deportiva' WHERE ID_Especialidad = 4;
UPDATE Especialidad SET Nombre_Especialidad = 'Reumatología Pediátrica' WHERE ID_Especialidad = 5;

-- 2.4. Actualización en la Tabla ENFERMERO (Corrección/Ajuste de Apellido)
UPDATE Enfermero SET Apellido = 'Soto Rincón' WHERE ID_Enfermero = 'E30001';
UPDATE Enfermero SET Apellido = 'Vargas Gómez' WHERE ID_Enfermero = 'E30002';
UPDATE Enfermero SET Apellido = 'Pérez Rivas' WHERE ID_Enfermero = 'E30003';
UPDATE Enfermero SET Apellido = 'Rodríguez Díaz' WHERE ID_Enfermero = 'E30004';
UPDATE Enfermero SET Apellido = 'Gómez López' WHERE ID_Enfermero = 'E30005';

-- 2.5. Actualización en la Tabla HOSPITAL (Actualizar Estatus/Acreditación)
UPDATE Hospital SET Nombre_Hospital = 'Hospital Universitario Metropolitano' WHERE ID_Hospital = 1;
UPDATE Hospital SET Nombre_Hospital = 'Clínica Los Álamos de Excelencia' WHERE ID_Hospital = 2;
UPDATE Hospital SET Nombre_Hospital = 'Centro Médico del Sur Avanzado' WHERE ID_Hospital = 3;
UPDATE Hospital SET Nombre_Hospital = 'Hospital de la Paz Central' WHERE ID_Hospital = 4;
UPDATE Hospital SET Nombre_Hospital = 'Clínica Materno Infantil Integral' WHERE ID_Hospital = 5;

-- 2.6. Actualización en la Tabla HOSPITALIZACION (Corrección de Fecha de Egreso)
-- Se ajusta la fecha de egreso en 1 día.
UPDATE Hospitalizacion SET Fecha_Egreso = '2025-01-06' WHERE ID_Hospitalizacion = 1;
UPDATE Hospitalizacion SET Fecha_Egreso = '2025-01-11' WHERE ID_Hospitalizacion = 2;
UPDATE Hospitalizacion SET Fecha_Egreso = '2025-01-16' WHERE ID_Hospitalizacion = 3;
UPDATE Hospitalizacion SET Fecha_Egreso = '2025-01-21' WHERE ID_Hospitalizacion = 4;
UPDATE Hospitalizacion SET Fecha_Egreso = '2025-01-26' WHERE ID_Hospitalizacion = 5;

--
-- INSTRUCCIONES DELETE 
-- 
-- ELIMINACIÓN DE REGISTROS (DML - DELETE)

-- Se eliminan todas las filas que referencian a los registros que se borrarán en Medico, Paciente u Hospital.
DELETE FROM Hospitalizacion 
WHERE 
    ID_Paciente IN ('P10001', 'P10002', 'P10003', 'P10004', 'P10005')
    OR ID_Medico_Principal IN ('M20001', 'M20002', 'M20003', 'M20004', 'M20005')
    OR ID_Hospital IN (1, 2, 3, 4, 5);

-- 2.  ELIMINACIÓN DE DEPENDENCIAS SECUNDARIAS
DELETE FROM Paciente WHERE ID_Paciente IN ('P10001', 'P10002', 'P10003', 'P10004', 'P10005');
DELETE FROM Hospital WHERE ID_Hospital IN (1, 2, 3, 4, 5);

-- 3.  ELIMINACIÓN DE MÉDICOS (Limpia dependencia a Especialidad)
-- Se borran TODOS los médicos cuya especialidad es 1 o 2 (para poder borrar las especialidades después).
DELETE FROM Medico WHERE ID_Especialidad IN (1, 2);

-- 4.  ELIMINACIÓN DE ESPECIALIDAD (Tabla Padre)
-- Ahora es seguro eliminar las Especialidades 1 y 2.
DELETE FROM Especialidad WHERE ID_Especialidad IN (1, 2);

-- 5.  ELIMINACIÓN DE ENFERMERO (Tabla sin dependencias)
DELETE FROM Enfermero WHERE ID_Enfermero IN ('E30006', 'E30007', 'E30008', 'E30009', 'E30010');