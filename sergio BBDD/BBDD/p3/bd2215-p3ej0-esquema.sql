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
DROP TABLE CHAT_GRUPO CASCADE CONSTRAINTS;
DROP TABLE MENSAJE_IMAGEN;
DROP TABLE MENSAJE_TEXTO;
DROP TABLE MENSAJE CASCADE CONSTRAINTS;
DROP TABLE EMAIL_CONTACTO;
DROP TABLE CONTACTO;
DROP TABLE MIUSUARIO;


-- Sentencias CREATE (y ALTER) para crear las tablas del esquema
-- en el orden que evite errores de integridad referencial

CREATE TABLE MIUSUARIO (
    telefono        NUMBER(9)   NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    fecha_registro  DATE        NOT NULL,
    idioma          CHAR(10)    NOT NULL,
    descripcion     VARCHAR(30),
    CONSTRAINT miusuario_pk     PRIMARY KEY(telefono)
);

CREATE TABLE CONTACTO (
    telefono        NUMBER(9)   NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    apellidos       VARCHAR(30),
    dia             NUMBER(2),
    mes             NUMBER(2),
    usuario         NUMBER(9),
    CONSTRAINT contacto_pk      PRIMARY KEY(telefono, usuario),
    CONSTRAINT contacto_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES MIUSUARIO(telefono)
        ON DELETE CASCADE,
    CONSTRAINT contacto_dia_ok  CHECK (dia BETWEEN 1 AND 31),
    CONSTRAINT contacto_mes_ok  CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT contacto_mes_dia_consistent CHECK ((dia IS NULL AND mes IS NULL) OR (dia IS NOT NULL AND mes IS NOT NULL))
);

CREATE TABLE EMAIL_CONTACTO (
    contacto        NUMBER(9)   NOT NULL,
    usuario         NUMBER(9)   NOT NULL,
    email           VARCHAR(30) NOT NULL,
    CONSTRAINT email_contacto_pk
        PRIMARY KEY(contacto, usuario, email),
    CONSTRAINT email_contacto_fk_contacto_usuario
        FOREIGN KEY(contacto, usuario)      REFERENCES CONTACTO(telefono, usuario)
        ON DELETE CASCADE
);

CREATE TABLE MENSAJE (
    mensaje_id      CHAR(10)    NOT NULL,
    usuario         NUMBER(9)   NOT NULL,
    reenviado       CHAR(2)     DEFAULT 'NO' NOT NULL,
    diahora         DATE        DEFAULT sysdate NOT NULL,
    chat_grupo      CHAR(4)     NOT NULL,
    msj_original    CHAR(10),
    CONSTRAINT mensaje_pk   PRIMARY KEY(mensaje_id),
    CONSTRAINT mensaje_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES MIUSUARIO(telefono)
        ON DELETE CASCADE,
    CONSTRAINT mensaje_reenviado_ok     CHECK (reenviado IN ('SI', 'NO')),
    CONSTRAINT mensaje_fk_msj_original
        FOREIGN KEY(msj_original)   REFERENCES MENSAJE(mensaje_id)
        ON DELETE CASCADE,
    CONSTRAINT mensaje_msj_original_ok      CHECK (msj_original != mensaje_id)
);

CREATE TABLE MENSAJE_TEXTO (
    mensaje         CHAR(10)        NOT NULL,
    texto           VARCHAR(1024)   NOT NULL,
    CONSTRAINT mensaje_texto_pk     PRIMARY KEY(mensaje),
    CONSTRAINT mensaje_texto_fk_mensaje
        FOREIGN KEY(mensaje) REFERENCES MENSAJE(mensaje_id)
        ON DELETE CASCADE
);

CREATE TABLE MENSAJE_IMAGEN (
    mensaje         CHAR(10)        NOT NULL,
    ubicacion       VARCHAR(30)     NOT NULL,
    tamano          NUMBER(12)      NOT NULL,
    formato         VARCHAR(4)      NOT NULL,
    comentario      VARCHAR(255),
    CONSTRAINT mensaje_imagen_pk     PRIMARY KEY(mensaje),
    CONSTRAINT mensaje_imagen_fk_mensaje
        FOREIGN KEY(mensaje) REFERENCES MENSAJE(mensaje_id)
        ON DELETE CASCADE,
    CONSTRAINT mensaje_tamano_nocero CHECK (tamano != 0),
    CONSTRAINT mensaje_formato_ok   CHECK (formato IN ('JPG', 'PNG', 'BMP', 'TIFF', 'HEIF', 'RAW'))
);

CREATE TABLE CHAT_GRUPO (
    codigo          CHAR(4)     NOT NULL,
    nombre          VARCHAR(30) NOT NULL,
    fecha_creacion  DATE        NOT NULL,
    administrador   NUMBER(9)   NOT NULL,
    msj_anclado     CHAR(10)    NOT NULL,
    miembros        NUMBER(3)   DEFAULT 0 NOT NULL,
    CONSTRAINT chat_grupo_pk    PRIMARY KEY(codigo),
    UNIQUE(msj_anclado),
    CONSTRAINT chat_grupo_fk_administrador
        FOREIGN KEY(administrador)  REFERENCES MIUSUARIO(telefono)
        ON DELETE CASCADE,
    CONSTRAINT chat_grupo_fk_msj_anclado
        FOREIGN KEY(msj_anclado)    REFERENCES MENSAJE(mensaje_id)
        ON DELETE CASCADE
);

ALTER TABLE MENSAJE ADD
    CONSTRAINT mensaje_fk_grupo
    FOREIGN KEY(chat_grupo)      REFERENCES CHAT_GRUPO(codigo)
        ON DELETE CASCADE;

CREATE TABLE PARTICIPACION (
    usuario         NUMBER(9)   NOT NULL,
    chat_grupo      CHAR(4)     NOT NULL,
    fecha_inicio    DATE        NOT NULL,
    CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
    CONSTRAINT participacion_fk_usuario
        FOREIGN KEY(usuario)    REFERENCES MIUSUARIO(telefono)
        ON DELETE CASCADE,
    CONSTRAINT participacion_fk_chat_grupo
        FOREIGN KEY(chat_grupo) REFERENCES CHAT_GRUPO(codigo)
        ON DELETE CASCADE
);



