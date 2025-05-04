/*
Asignatura: Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd2109
 Integrante 1:Frabcisco Tornell Mingot
 Integrante 2: Abelwancheng JiangWan
*/

-- EJERCICIO 0. Corregir/mejorar el script de creacion de  tablas 
-- entregado en la Practica P1 Sesion 4 Disenno Logico Especifico

-- Eliminacion de tablas, para ejecucion repetida


/******************************************************************
Tablas MIUSUARIO, CONTACTO, EMAIL_CONTACTO, CHAT_GRUPO, MENSAJE
y luego la tabla PARTICIPACION 
               (copy&paste de "bd-p3ej0-esquema-mastablas.sql")
******************************************************************/

DROP TABLE PARTICIPACION;
DROP TABLE CHAT_GRUPO CASCADE CONSTRAINTS;
DROP TABLE MENSAJE CASCADE CONSTRAINTS;
DROP TABLE EMAIL_CONTACTO;
DROP TABLE CONTACTO;
DROP TABLE MIUSUARIO;

CREATE TABLE MIUSUARIO(
    telefono        NUMBER(9)       NOT NULL,    
    nombre          VARCHAR(30)     NOT NULL,
    fecha_registro  DATE            NOT NULL,
    idioma          VARCHAR(10)     NOT NULL,
    descripcion     VARCHAR(30),
    CONSTRAINT usuario_pk PRIMARY KEY(telefono)
);

CREATE TABLE CONTACTO(
    telefono    NUMBER(9)       NOT NULL,
    nombre      VARCHAR(30)     NOT NULL,
    apellidos   VARCHAR(30),
    dia         NUMBER(2), 
    mes         NUMBER(2),
    usuario     NUMBER(9),
    CONSTRAINT contacto_pk      PRIMARY KEY(telefono, usuario),
    CONSTRAINT contacto_fk      FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono),
        
    CHECK (dia BETWEEN 1 AND 31), 
    CHECK (mes BETWEEN 1 AND 12),
    CHECK ((dia is NULL AND mes is NULL) OR ((dia is NOT NULL AND mes is NOT NULL)))
);

CREATE TABLE EMAIL_CONTACTO(
    usuario     NUMBER(9)       NOT NULL,
    contacto    NUMBER(9)       NOT NULL,
    email       VARCHAR(30)     NOT NULL,
    CONSTRAINT email_contacto_pk     PRIMARY KEY(usuario, contacto, email),
    CONSTRAINT email_contacto_fk     FOREIGN KEY (contacto, usuario) REFERENCES CONTACTO(telefono, usuario)
        ON DELETE CASCADE
        
);

CREATE TABLE MENSAJE(
    mensaje_id      CHAR(10)        NOT NULL,
    diahora         DATE            DEFAULT sysdate NOT NULL,
    reenviado       CHAR(2)         DEFAULT 'NO' NOT NULL,
    usuario         NUMBER(9)       NOT NULL,
    chat_grupo      CHAR(4)         NOT NULL,
    msj_original    CHAR(10),
    CONSTRAINT mensaje_pk   PRIMARY KEY(mensaje_id),
    CONSTRAINT mensaje_fk   FOREIGN KEY(usuario) REFERENCES MIUSUARIO(telefono),
        
    CONSTRAINT mensaje_mensaje_fk   FOREIGN KEY(msj_original) REFERENCES MENSAJE(mensaje_id),
       
    CHECK (reenviado IN ('SI', 'NO')),
    CHECK (mensaje_id != msj_original)
);

CREATE TABLE CHAT_GRUPO(
    codigo          CHAR(4)        NOT NULL,
    nombre          VARCHAR(30)    NOT NULL,
    fecha_creacion  DATE           NOT NULL,
    administrador   NUMBER(9),
    msj_anclado     CHAR(10)       NOT NULL,
    miembros        NUMBER(3)      DEFAULT 0 NOT NULL,
    CONSTRAINT chat_pk  PRIMARY KEY(codigo),
    UNIQUE (msj_anclado),
    CONSTRAINT chat_grupo_fk  FOREIGN KEY (administrador) REFERENCES MIUSUARIO(telefono),
        
    CONSTRAINT chat_ms_fk     FOREIGN KEY (msj_anclado) REFERENCES MENSAJE(mensaje_id)
        ON DELETE CASCADE
        -- ON UPDATE [CASCADE]
);

ALTER TABLE MENSAJE ADD CONSTRAINT mensaje_grupo_fk
FOREIGN KEY (chat_grupo) REFERENCES CHAT_GRUPO(codigo); 


CREATE TABLE PARTICIPACION (
   usuario      NUMBER(9)   NOT NULL, 
   chat_grupo   CHAR(4)   NOT NULL,  
   fecha_inicio DATE        NOT NULL,
   CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
   CONSTRAINT participacion_usuario_fk
      FOREIGN KEY(usuario) REFERENCES MIUSUARIO(telefono),
     
   CONSTRAINT participacion_chatgrupo_fk
      FOREIGN KEY(chat_grupo) REFERENCES CHAT_GRUPO(codigo) 
      
);