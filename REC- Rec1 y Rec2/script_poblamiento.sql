                                ---  POBLAMIENTO  --- 

-- 0. Poblamiento de DEPARTAMENTO
INSERT INTO DEPARTAMENTO (cod_departamento, nombre_departamento) VALUES
('05', 'ANTIOQUIA'),
('23', 'CÓRDOBA'),
('41', 'HUILA'),
('20', 'CESAR'),
('68', 'SANTANDER'),
('66', 'RISARALDA'),
('25', 'CUNDINAMARCA'),
('76', 'VALLE DEL CAUCA'),
('15', 'BOYACÁ'),
('13', 'BOLÍVAR'),
('11', 'BOGOTÁ D.C.');



-- 1. Poblamiento de SEXO
INSERT INTO SEXO (id_sexo, nombre_sexo) VALUES
(1, 'Hombre'),
(2, 'Mujer');



-- 2. Poblamiento de SEMESTRE
INSERT INTO SEMESTRE (id_semestre, descripcion_semestre) VALUES
(1, 'Semestre 1'),
(2, 'Semestre 2');



-- 3. Poblamiento de METODOLOGIA 
INSERT INTO METODOLOGIA (id_metodologia, nombre_metodologia) VALUES 
(1, 'Presencial'), 
(2, 'A distancia'), 
(3, 'Virtual');



-- 4. Poblamiento de AREA_CONOCIMIENTO 
INSERT INTO AREA_CONOCIMIENTO (id_area_conocimiento, nombre_area_conocimiento) VALUES
(5, 'Ciencias sociales y humanas'), 
(1, 'Agronomía, veterinaria y afines'),
(6, 'Economía, administración, contaduría y afines');



-- 5. Poblamiento de MUNICIPIO 
INSERT INTO MUNICIPIO (cod_municipio, nombre_municipio, cod_departamento_fk) VALUES
('05001', 'Medellín', '05'), 
('23001', 'Montería', '23'),
('41615', 'Rivera', '41'),
('41001', 'Neiva', '41'),
('41551', 'Pitalito', '41'),
('20011', 'Aguachica', '20'),
('68001', 'Bucaramanga', '68'),
('20001', 'Valledupar', '20'),
('66001', 'Pereira', '66'),
('25175', 'Chía', '25'),
('76001', 'Cali', '76'),
('15001', 'Tunja', '15'),
('13001', 'Cartagena De Indias', '13'),
('25843', 'Villa De San Diego De Ubaté', '25'),
('76622', 'Roldanillo', '76'),
('11001', 'Bogotá, D.C.', '11');

--  DIMENSIONES DE NIVEL (Dependen de las anteriores)


-- 6. Poblamiento de IES 
INSERT INTO IES (cod_ies, nombre_ies, caracter_ies, sector_ies, ies_acreditada, cod_municipio_fk) VALUES
('2719', 'UNIVERSIDAD CATÓLICA LUIS AMIGÓ', 'Universidad', 'PRIVADA', 'N', '05001'),
('1113', 'UNIVERSIDAD DE CORDOBA', 'Universidad', 'OFICIAL', 'S', '23001'),
('9905', 'FUNDACION ESCUELA TECNOLOGICA DE NEIVA - JESUS OVIEDO PEREZ -FET', 'Institución Universitaria/Escuela Tecnológica', 'PRIVADA', 'N', '41615'),
('2828', 'CORPORACION UNIVERSITARIA DEL HUILA-CORHUILA-', 'Institución Universitaria/Escuela Tecnológica', 'PRIVADA', 'N', '41001'),
('1123', 'UNIVERSIDAD POPULAR DEL CESAR', 'Universidad', 'OFICIAL', 'N', '20011'),
('1320', 'UNIDADES TECNOLOGICAS DE SANTANDER', 'Institución Tecnológica', 'OFICIAL', 'N', '68001'),
('2832', 'UNIVERSIDAD DE SANTANDER - UDES', 'Universidad', 'PRIVADA', 'N', '68001'),
('2737', 'FUNDACION UNIVERSITARIA DEL AREA ANDINA', 'Institución Universitaria/Escuela Tecnológica', 'PRIVADA', 'S', '66001'),
('1117', 'UNIVERSIDAD DE LA SABANA', 'Universidad', 'PRIVADA', 'S', '25175'),
('9103', 'ESCUELA MILITAR DE AVIACION MARCO FIDEL SUAREZ', 'Institución Universitaria/Escuela Tecnológica', 'OFICIAL', 'S', '76001'),
('1106', 'UNIVERSIDAD PEDAGOGICA Y TECNOLOGICA DE COLOMBIA - UPTC', 'Universidad', 'OFICIAL', 'S', '15001'),
('1205', 'UNIVERSIDAD DE CARTAGENA', 'Universidad', 'OFICIAL', 'S', '13001'),
('1216', 'UNIVERSIDAD DE CUNDINAMARCA-UDEC', 'Universidad', 'OFICIAL', 'N', '25843'),
('4101', 'INSTITUTO DE EDUCACION TECNICA PROFESIONAL DE ROLDANILLO', 'Institución Técnica Profesional', 'OFICIAL', 'N', '76622'),
('1111', 'UNIVERSIDAD TECNOLOGICA DE PEREIRA - UTP', 'Universidad', 'OFICIAL', 'S', '66001'),
('1301', 'UNIVERSIDAD DISTRITAL-FRANCISCO JOSE DE CALDAS', 'Universidad', 'OFICIAL', 'S', '11001'),
('1815', 'CORPORACION UNIVERSIDAD PILOTO DE COLOMBIA', 'Universidad', 'PRIVADA', 'S', '11001'),
('1104', 'INSTITUCION UNIVERSITARIA PASCUAL BRAVO', 'Inst. Universitaria/Escuela Tecnológica', 'OFICIAL', 'S', '05001');


-- 7. Poblamiento de PROGRAMA 
INSERT INTO PROGRAMA (cod_programa, nombre_programa, nivel_academico, programa_acreditado, id_area_conocimiento_fk, id_metodologia_fk) VALUES
('53127', 'ACTIVIDAD FISICA Y DEPORTE', 'PREGRADO', 'N', 5, 1),
('5129', 'ACUICULTURA', 'PREGRADO', 'N', 1, 1),
('103648', 'ADMINISTRACIÓN DE LA SALUD OCUPACIONAL', 'PREGRADO', 'N', 6, 1),
('3165', 'ADMINISTRACIÓN BANCARIA Y FINANCIERA', 'PREGRADO', 'N', 6, 1),
('17791', 'ADMINISTRACIÓN', 'PREGRADO', 'N', 6, 1),
('107432', 'ADMINISTRACIÓN DE EMPRESAS', 'PREGRADO', 'N', 6, 3),
('53949', 'ADMINISTRACIÓN FINANCIERA', 'PREGRADO', 'N', 6, 1),
('101943', 'ADMINISTRACIÓN FINANCIERA', 'PREGRADO', 'S', 6, 1),
('104355', 'ADMINISTRACIÓN & SERVICIOS', 'PREGRADO', 'S', 6, 1),
('1714', 'ADMINISTRACIÓN AERONÁUTICAS', 'PREGRADO', 'S', 6, 1),
('104809', 'ADMINISTRACIÓN AGROINDUSTRIAL', 'PREGRADO', 'N', 1, 3),
('51871', 'ADMINISTRACIÓN AGROPECUARIA', 'PREGRADO', 'N', 6, 2),
('2512', 'ADMINISTRACIÓN AGROPECUARIA', 'PREGRADO', 'N', 6, 1),
('53774', 'ADMINISTRACIÓN AGROPECUARIA', 'PREGRADO', 'N', 6, 1),
('105066', 'ADMINISTRACIÓN AMBIENTAL', 'PREGRADO', 'S', 6, 1),
('11845', 'ADMINISTRACIÓN AMBIENTAL', 'PREGRADO', 'S', 6, 1),
('103194', 'ADMINISTRACIÓN AMBIENTAL', 'PREGRADO', 'N', 6, 1);


-- 8. GRADUADOS (HECHOS)


INSERT INTO GRADUADOS (cod_ies_fk, cod_programa_fk, id_sexo_fk, id_semestre_fk, total_graduados) VALUES

-- UNIVERSIDAD CATÓLICA LUIS AMIGÓ 
('2719', '53127', 1, 1, 40),
('2719', '53127', 1, 2, 37),
('2719', '53127', 2, 1, 8),
('2719', '53127', 2, 2, 6),

-- UNIVERSIDAD DE CORDOBA 
('1113', '5129', 1, 1, 32),
('1113', '5129', 1, 2, 16),
('1113', '5129', 2, 1, 12),
('1113', '5129', 2, 2, 9),

-- FUNDACIÓN ESCUELA TECNOLÓGICA
('9905', '103648', 1, 2, 5),
('9905', '103648', 2, 1, 6),
('9905', '103648', 2, 2, 8),

-- CORHUILA 
('2828', '3165', 1, 1, 4),
('2828', '3165', 1, 2, 3),
('2828', '3165', 2, 1, 2),
('2828', '3165', 2, 2, 1),

-- UNIVERSIDAD POPULAR DEL CESAR 
('1123', '17791', 2, 1, 13),

-- UNIDADES TECNOLOGICAS DE SANTANDER 
('1320', '107432', 1, 1, 3),
('1320', '107432', 1, 2, 6),
('1320', '107432', 2, 1, 7),
('1320', '107432', 2, 2, 9),

-- UNIVERSIDAD DE SANTANDER 
('2832', '53949', 1, 1, 7),
('2832', '53949', 1, 2, 6),
('2832', '53949', 2, 1, 5),

-- FUNDACIÓN UNIVERSITARIA DEL ÁREA ANDINA 
('2737', '101943', 1, 2, 1),
('2737', '101943', 2, 1, 1),

-- UNIVERSIDAD DE LA SABANA 
('1117', '104355', 1, 1, 3),
('1117', '104355', 1, 2, 9),
('1117', '104355', 2, 1, 1),
('1117', '104355', 2, 2, 6),

-- ESCUELA MILITAR DE AVIACION 
('9103', '1714', 1, 2, 7),
('9103', '1714', 2, 2, 6),

-- UPTC
('1106', '104809', 1, 2, 2),
('1106', '104809', 2, 1, 1),
('1106', '104809', 2, 2, 4),

-- UNIVERSIDAD DE CARTAGENA 
('1205', '51871', 1, 2, 1),

-- UNIVERSIDAD DE CUNDINAMARCA 
('1216', '2512', 1, 1, 1),

-- UT PEREIRA 
('1111', '105066', 1, 1, 4),
('1111', '105066', 1, 2, 3),
('1111', '105066', 2, 1, 1),
('1111', '105066', 2, 2, 4),

-- UNIVERSIDAD DISTRITAL 
('1301', '11845', 1, 1, 8),
('1301', '11845', 1, 2, 9),
('1301', '11845', 2, 1, 1),
('1301', '11845', 2, 2, 3),

-- UNIVERSIDAD PILOTO 
('1815', '103194', 1, 1, 1),
('1815', '103194', 1, 2, 2),

-- INSTITUCIÓN UNIVERSITARIA PASCUAL BRAVO
('1104', '53127', 1, 1, 15),
('1104', '53127', 1, 2, 8),
('1104', '53127', 2, 1, 7),
('1104', '53127', 2, 2, 5);
