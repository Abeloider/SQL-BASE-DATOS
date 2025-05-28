/*
Asignatura: Bases de Datos
Curso: 2024/25 
Convocatoria: junio

Practica: P1. Diseno Logico
---------------------------
Cuenta Oracle: bd2215
Estudiante(s): Angel Ruiz Fernandez
---------------------------
*/
-- opcional:
-- Sentencias DROP para re-ejecucion del script
-- en el orden inverso al de creacion

DROP TABLE PARTICIPACION;
DROP TABLE CHAT_GRUPO;
DROP TABLE MENSAJE_IMAGEN;
DROP TABLE MENSAJE_TEXTO;
DROP TABLE MENSAJE;
DROP TABLE EMAIL_CONTACTO;
DROP TABLE CONTACTO;
DROP TABLE USUARIO;


-- Sentencias CREATE (y ALTER) para crear las tablas del esquema
-- en el orden que evite errores de integridad referencial

CREATE TABLE USUARIO (
    telefono        NUMBER(9)   NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    fecha_registro  DATE        NOT NULL,
    idioma          CHAR(2)     NOT NULL,
    descripcion     VARCHAR(30),
    CONSTRAINT usuario_pk       PRIMARY KEY(telefono)
);

CREATE TABLE CONTACTO (
    telefono        NUMBER(9)   NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    apellidos       VARCHAR(30),
    cumdia          NUMBER(2),
    cummes          NUMBER(2),
    usuario         NUMBER(9),
    CONSTRAINT contacto_pk      PRIMARY KEY(telefono, usuario),
    CONSTRAINT contacto_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES USUARIO(telefono),
    CONSTRAINT contacto_dia_ok  CHECK (cumdia BETWEEN 1 AND 31),
    CONSTRAINT contacto_mes_ok  CHECK (cummes BETWEEN 1 AND 12)
);

CREATE TABLE EMAIL_CONTACTO (
    telefono        NUMBER(9)   NOT NULL,
    usuario         NUMBER(9) NOT NULL,
    mail            VARCHAR(30) NOT NULL,
    CONSTRAINT email_contacto_pk
        PRIMARY KEY(telefono, usuario),
    CONSTRAINT email_contacto_fk_telefono_usuario
        FOREIGN KEY(telefono, usuario)      REFERENCES CONTACTO(telefono, usuario)
);

CREATE TABLE MENSAJE (
    mensaje_id      CHAR(10)    NOT NULL,
    usuario         NUMBER(9)   NOT NULL,
    reenviado       CHAR(1)     DEFAULT 'N' NOT NULL,
    diahora         DATE        DEFAULT sysdate NOT NULL    ,
    grupo           CHAR(4)     NOT NULL,
    responde        CHAR(10),
    CONSTRAINT mensaje_pk   PRIMARY KEY(mensaje_id),
    CONSTRAINT mensaje_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES USUARIO(telefono),
    CONSTRAINT mensaje_reenviado_ok   CHECK (reenviado IN ('Y', 'N'))
);

ALTER TABLE MENSAJE ADD
    CONSTRAINT mensaje_fk_responde
    FOREIGN KEY(responde)   REFERENCES MENSAJE(mensaje_id);

CREATE TABLE MENSAJE_TEXTO (
    mensaje         CHAR(10)        NOT NULL,
    texto           VARCHAR(1024)   NOT NULL,
    CONSTRAINT mensaje_texto_pk     PRIMARY KEY(mensaje),
    CONSTRAINT mensaje_texto_fk_mensaje
        FOREIGN KEY(mensaje) REFERENCES MENSAJE(mensaje_id)
);

CREATE TABLE MENSAJE_IMAGEN (
    mensaje         CHAR(10)        NOT NULL,
    ubicacion       VARCHAR(30)     NOT NULL,
    tamano          NUMBER(12)      NOT NULL,
    formato         VARCHAR(4)      NOT NULL,
    comentario      VARCHAR(255),
    CONSTRAINT mensaje_imagen_pk     PRIMARY KEY(mensaje),
    CONSTRAINT mensaje_imagen_fk_mensaje
        FOREIGN KEY(mensaje) REFERENCES MENSAJE(mensaje_id),
    CONSTRAINT mensaje_tamano_nocero CHECK (tamano != 0),
    CONSTRAINT mensaje_formato_ok   CHECK (formato IN ('JPG', 'PNG', 'BMP', 'TIFF', 'HEIF', 'RAW'))
);

CREATE TABLE CHAT_GRUPO (
    codigo          CHAR(4)     NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    fecha_creacion  DATE        NOT NULL,
    administrador   NUMBER(9)   NOT NULL,
    anclado         CHAR(10)    NOT NULL,
    miembros        NUMBER(3)   NOT NULL,
    CONSTRAINT chat_grupo_pk    PRIMARY KEY(codigo),
    CONSTRAINT chat_grupo_fk_administrador
        FOREIGN KEY(administrador)  REFERENCES USUARIO(telefono),
    CONSTRAINT chat_grupo_fk_anclado
        FOREIGN KEY(anclado)        REFERENCES MENSAJE(mensaje_id)
);

ALTER TABLE MENSAJE ADD
    CONSTRAINT mensaje_fk_grupo
    FOREIGN KEY(grupo)      REFERENCES CHAT_GRUPO(codigo);

CREATE TABLE PARTICIPACION (
    usuario         NUMBER(9)   NOT NULL,
    grupo           CHAR(4)     NOT NULL,
    fecha_inicio    DATE        NOT NULL,
    CONSTRAINT participacion_pk PRIMARY KEY(usuario, grupo),
    CONSTRAINT participacion_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES USUARIO(telefono),
    CONSTRAINT participacion_fk_grupo
        FOREIGN KEY(grupo)      REFERENCES CHAT_GRUPO(codigo)
);



