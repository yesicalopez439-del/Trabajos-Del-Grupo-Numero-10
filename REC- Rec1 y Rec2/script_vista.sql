--yesica alejandra bedoya--
-- TABLA 1: area_conocimiento--
-- Sirve para clasificar los programas (ej: Ingeniería, Humanidades, Salud).--
CREATE TABLE area_conocimiento (
    id_area_conocimiento INT PRIMARY KEY,
    nombre_area_conocimiento VARCHAR(100)
    --2. Departamento--
-- Almacena los departamentos geográficos (como Antioquia o Cundinamarca).--
CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(100)
);
-- TABLA 3: ies (Instituciones de Educación Superior)--
-- Es la lista de universidades e institutos.--
CREATE TABLE ies (
    id_ies INT PRIMARY KEY,
    nombre_ies VARCHAR(150)
);
-- TABLA 4: metodologia--
-- Define cómo se dan las clases (ej: Presencial, Virtual, a Distancia).--
CREATE TABLE metodologia (
    id_metodologia INT PRIMARY KEY,
    nombre_metodologia VARCHAR(50)
);
-- TABLA 5: municipio--
-- Los municipios dentro de cada departamento (ej: Bogotá, Medellín).--
CREATE TABLE municipio (
    id_municipio INT PRIMARY KEY,
    nombre_municipio VARCHAR(100)
);
-- TABLA 6: programa--
-- La lista de carreras o programas académicos (ej: Ingeniería de Sistemas, Derecho).--
CREATE TABLE programa (
    id_programa INT PRIMARY KEY,
    nombre_programa VARCHAR(100)
);
-- TABLA 7: aula (Nuevo: Salones de Clase)--
-- Aquí registramos los salones o espacios de clase que tiene la institución.--
CREATE TABLE aula (
    id_aula SERIAL PRIMARY KEY,
    codigo_aula VARCHAR(20) NOT NULL UNIQUE,
    capacidad INT,
    tipo_aula VARCHAR(50) -- 'Laboratorio', 'Magistral', etc.--
);
--tablas con Relaciones (Llaves Foráneas)--
-- TABLA 8: personal (Nuevo: Profesores/Staff)--
-- Guardamos quién trabaja en la institución y a qué IES pertenece.--
CREATE TABLE personal (
    id_personal SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    fk_ies_id INT REFERENCES ies(id_ies) -- Se enlaza con la IES (Tabla 3)--
);
-- TABLA 9: personal_programa (Nuevo: Quién enseña qué)--
-- Esta es una tabla de unión que me dice qué profesores están asociados a qué carreras.--
CREATE TABLE personal_programa (
    id_personal_programa SERIAL PRIMARY KEY,
    fk_personal_id INT REFERENCES personal(id_personal), -- Se enlaza con Personal (Tabla 8)--
    fk_programa_id INT REFERENCES programa(id_programa), -- Se enlaza con Programa (Tabla 6)--
    rol_programa VARCHAR(50),
    UNIQUE (fk_personal_id, fk_programa_id)
);
-- TABLA 10: graduados (Tabla de Hechos Central)--
-- Esta es la tabla que almacena los números importantes: cuántos se graduaron en qué año.--
-- ¡Tiene 6 llaves foráneas para poder hacer informes detallados!---
CREATE TABLE graduados (
    id_graduado SERIAL PRIMARY KEY,
    anio_graduacion INT NOT NULL,
    cantidad_graduados INT NOT NULL,
    -- LLAVES FORÁNEAS (Las uniones a las tablas 1 a 6)--
    fk_programa_id INT REFERENCES programa(id_programa),
    fk_ies_id INT REFERENCES ies(id_ies),
    fk_departamento_id INT REFERENCES departamento(id_departamento),
    fk_municipio_id INT REFERENCES municipio(id_municipio),
    fk_area_conocimiento_id INT REFERENCES area_conocimiento(id_area_conocimiento),
    fk_metodologia_id INT REFERENCES metodologia(id_metodologia)
);
--Vista de Informe--
-- VISTA: VISTA_GRADUADOS_DETALLADOS--
-- FUNCIÓN: Muestra los datos de la tabla 'graduados' (Tabla 10) pero reemplazando los IDs por los nombres completos.--
CREATE OR REPLACE VIEW VISTA_GRADUADOS_DETALLADOS AS
SELECT
    -- Lo que medimos:--
    g.id_graduado,
    g.anio_graduacion,
    g.cantidad_graduados,
    -- Los nombres completos (los JOINs hacen magia aquí):--
    p.nombre_programa,
    i.nombre_ies,
    dpto.nombre_departamento,
    m.nombre_municipio,
    ac.nombre_area_conocimiento,
    met.nombre_metodologia
FROM
    graduados g
    -- Unimos Graduados con sus 6 tablas de referencia (JOINs):--
    INNER JOIN programa p 
        ON g.fk_programa_id = p.id_programa
    INNER JOIN ies i 
        ON g.fk_ies_id = i.id_ies
    INNER JOIN departamento dpto 
        ON g.fk_departamento_id = dpto.id_departamento
    INNER JOIN municipio m 
        ON g.fk_municipio_id = m.id_municipio
    INNER JOIN area_conocimiento ac 
        ON g.fk_area_conocimiento_id = ac.id_area_conocimiento
    INNER JOIN metodologia met 
        ON g.fk_metodologia_id = met.id_metodologia

WHERE
    g.fk_programa_id IS NOT NULL
ORDER BY
    g.id_graduado;
    