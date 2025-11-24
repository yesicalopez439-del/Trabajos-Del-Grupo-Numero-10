                                  ---   CREACION ---
-- DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
    cod_departamento CHAR(2) PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL UNIQUE
);

-- MUNICIPIO
CREATE TABLE MUNICIPIO (
    cod_municipio CHAR(5) PRIMARY KEY,
    nombre_municipio VARCHAR(100) NOT NULL,
    cod_departamento_fk CHAR(2) NOT NULL,
    CONSTRAINT fk_municipio_departamento 
        FOREIGN KEY (cod_departamento_fk) 
        REFERENCES DEPARTAMENTO(cod_departamento)
);

-- AREA DE CONOCIMIENTO
CREATE TABLE AREA_CONOCIMIENTO (
    id_area_conocimiento INTEGER PRIMARY KEY,
    nombre_area_conocimiento VARCHAR(100) UNIQUE NOT NULL
);

-- METODOLOGIA
CREATE TABLE METODOLOGIA (
    id_metodologia INTEGER PRIMARY KEY,
    nombre_metodologia VARCHAR(50) UNIQUE NOT NULL
);

-- SEXO
CREATE TABLE SEXO (
    id_sexo INTEGER PRIMARY KEY,
    nombre_sexo VARCHAR(10) UNIQUE NOT NULL
);

-- SEMESTRE
CREATE TABLE SEMESTRE (
    id_semestre INTEGER PRIMARY KEY,
    descripcion_semestre VARCHAR(20) UNIQUE NOT NULL
);

-- INSTITUCIONES (IES)
CREATE TABLE IES (
    cod_ies VARCHAR(20) PRIMARY KEY,
    nombre_ies VARCHAR(200) UNIQUE NOT NULL,
    caracter_ies VARCHAR(50) NOT NULL,
    sector_ies VARCHAR(50) NOT NULL,
    ies_acreditada CHAR(1) CHECK (ies_acreditada IN ('S','N')),
    cod_municipio_fk CHAR(5) NOT NULL,
    CONSTRAINT fk_ies_municipio 
        FOREIGN KEY (cod_municipio_fk) 
        REFERENCES MUNICIPIO(cod_municipio)
);

-- PROGRAMA ACADÉMICO
CREATE TABLE PROGRAMA (
    cod_programa VARCHAR(20) PRIMARY KEY,
    nombre_programa VARCHAR(200) NOT NULL,
    nivel_academico VARCHAR(50) NOT NULL,
    programa_acreditado CHAR(1) CHECK (programa_acreditado IN ('S','N')),
    id_area_conocimiento_fk INTEGER NOT NULL,
    id_metodologia_fk INTEGER NOT NULL,
    CONSTRAINT fk_programa_area 
        FOREIGN KEY (id_area_conocimiento_fk) 
        REFERENCES AREA_CONOCIMIENTO(id_area_conocimiento),
    CONSTRAINT fk_programa_metodologia 
        FOREIGN KEY (id_metodologia_fk) 
        REFERENCES METODOLOGIA(id_metodologia)
);

-- TABLA DE GRADUADOS (HECHOS)
CREATE TABLE GRADUADOS (
    id_registro BIGSERIAL PRIMARY KEY,
    cod_ies_fk VARCHAR(20) NOT NULL,
    cod_programa_fk VARCHAR(20) NOT NULL,
    id_sexo_fk INTEGER NOT NULL,
    id_semestre_fk INTEGER NOT NULL,
    total_graduados INTEGER NOT NULL CHECK (total_graduados >= 0),

    CONSTRAINT fk_graduados_ies 
        FOREIGN KEY (cod_ies_fk) 
        REFERENCES IES(cod_ies),

    CONSTRAINT fk_graduados_programa 
        FOREIGN KEY (cod_programa_fk) 
        REFERENCES PROGRAMA(cod_programa),

    CONSTRAINT fk_graduados_sexo 
        FOREIGN KEY (id_sexo_fk) 
        REFERENCES SEXO(id_sexo),

    CONSTRAINT fk_graduados_semestre 
        FOREIGN KEY (id_semestre_fk) 
        REFERENCES SEMESTRE(id_semestre)
);
