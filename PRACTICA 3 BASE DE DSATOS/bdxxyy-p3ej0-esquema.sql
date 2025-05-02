/*
Asignatura: Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bdxxyy
 Integrante 1:
 Integrante 2: 
*/

-- EJERCICIO 0. Corregir/mejorar el script de creacion de  tablas 
-- entregado en la Practica P1 Sesion 4 Disenno Logico Especifico

-- Eliminacion de tablas, para ejecucion repetida


/******************************************************************
Tablas MIUSUARIO, CONTACTO, EMAIL_CONTACTO, CHAT_GRUPO, MENSAJE
y luego la tabla PARTICIPACION 
               (copy&paste de "bd-p3ej0-esquema-mastablas.sql")
******************************************************************/

drop table MIUSUARIO ; 
drop table CONTACTO ; 
drop table EMAIL_CONTACTO ;
drop table CHAT_GRUPO ; 
drop table MENSAJE ; 
drop table PARTICIPACION; 


CREATE TABLE MIUSUARIO (
    telefono         NUMBER(9)    NOT NULL,
    nombre           VARCHAR2(20) NOT NULL,
    fecha_registro   DATE           NOT NULL,
    idioma           VARCHAR2(15)NOT NULL,
    descripcion      VARCHAR2(30),
    CONSTRAINT usuario_pk PRIMARY KEY(telefono)
); 


CREATE TABLE CONTACTO (
    telefono    NUMBER(9)    NOT NULL,
    nombre      VARCHAR2(20) NOT NULL,
    apellidos   VARCHAR2(30) NULL,
    dia         CHAR(2)      NULL,
    mes         CHAR(3)      NULL,
    usuario     NUMBER(9)    NOT NULL, 
    CONSTRAINT contacto_pk PRIMARY KEY(usuario,telefono),
    CONSTRAINT num_usuario_fk FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono),
    --CHECK(dia BETWEEN 1 AND 31),
    --CHECK(mes BETWEEN 1 AND 12),
    --CHECK((mes IS NULL AND dia IS NULL) OR (mes IS NOT NULL AND dia IS NOT NULL))
            --ON UPDATE CASCADE --ON DELETE CASCADE
); 



CREATE TABLE EMAIL_CONTACTO(
    usuario     NUMBER(9)    NOT NULL,
    contacto    NUMBER(9)    NOT NULL,
    email       VARCHAR2(30) NOT NULL,
    CONSTRAINT email_contacto_pk PRIMARY KEY(usuario,contacto, email),
    CONSTRAINT telefono_email_fk FOREIGN KEY(usuario,contacto) REFERENCES CONTACTO(usuario, telefono)
        --ON UPDATE CASCADE --ON DELETE CASCADE
);


CREATE TABLE CHAT_GRUPO(
    codigo              CHAR(4)     NOT NULL,
    nombre              VARCHAR2(20)NOT NULL,
    fecha_creacion      DATE        NOT NULL,
    miembros            NUMBER(3)   NOT NULL,
    administrador       NUMBER(9)   NOT NULL,
    msj_anclado  CHAR(4) NOT NULL,
    
   CONSTRAINT chat_grupo_pk PRIMARY KEY(codigo),
   UNIQUE (msj_anclado),
   CONSTRAINT admin_chat_grupo_fk FOREIGN KEY(administrador)REFERENCES miusuario(telefono)
   
);




CREATE TABLE MENSAJE(
    mensaje_id      CHAR(10) NOT NULL,
    diahora         DATE     NOT NULL,
    reenviado       CHAR(10) NOT NULL,
    usuario         NUMBER(9) NOT NULL,
    chat_grupo      CHAR(4) NOT NULL,
    msj_original    CHAR(10),
    CONSTRAINT mensaje_pk PRIMARY KEY(mensaje_id),
    CONSTRAINT msg_original_fk FOREIGN KEY (msj_original) REFERENCES MENSAJE(mensaje_id),
        --ON UPDATE CASCADE --ON DELETE NO ACION
    CONSTRAINT tlf_usuario_fk FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono),
        --ON UPDATE CASCADE --ON DELETE NO ACION

    CONSTRAINT mensaje_grupo_fk
    FOREIGN KEY (chat_grupo) REFERENCES CHAT_GRUPO(codigo),
    CHECK(mensaje_id != msj_original),
    CHECK(reenviado IN ('SI','NO'))
);

ALTER TABLE CHAT_GRUPO ADD CONSTRAINT msj_anclado_chat_grupo_fk FOREIGN KEY(msj_anclado)REFERENCES mensaje(mensaje_id);


CREATE TABLE PARTICIPACION (
   usuario      NUMBER(9) NOT NULL, 
   chat_grupo   CHAR(4)   NOT NULL,  
   fecha_inicio DATE      NOT NULL,
   CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
   --
   CONSTRAINT participacion_usuario_fk
      FOREIGN KEY(usuario) REFERENCES miusuario(telefono),
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
   CONSTRAINT participacion_chatgrupo_fk
      FOREIGN KEY(chat_grupo) REFERENCES chat_grupo(codigo) 
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
);
