drop table MIUSUARIO CASCADE CONSTRAINT; 
drop table CONTACTO CASCADE CONSTRAINT; 
drop table EMAIL_CONTACTO CASCADE CONSTRAINT;
drop table CHAT_GRUPO CASCADE CONSTRAINT; 
drop table MENSAJE CASCADE CONSTRAINT; 
drop table PARTICIPACION CASCADE CONSTRAINT;


CREATE TABLE MIUSUARIO (
    telefono         NUMBER(9) NOT NULL,
    nombre           VARCHAR2(20)NOT NULL,
    fecha_registro   DATE NOT NULL,
    idioma           VARCHAR2(15)NOT NULL,
    descripcion      VARCHAR2(30),
    PRIMARY KEY(telefono)
); 


CREATE TABLE CONTACTO (
    telefono    NUMBER(9) NOT NULL,
    nombre      VARCHAR2(20)NOT NULL,
    apellidos   VARCHAR2(30),
    dia         CHAR(2),
    mes         CHAR(3),
    usuario     NUMBER(9) NOT NULL, 
    PRIMARY KEY(usuario,telefono),
    CONSTRAINT num_usuario FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono)
            --ON UPDATE CASCADE --ON DELETE CASCADE
); 



CREATE TABLE EMAIL_CONTACTO(
    usuario     NUMBER(9) NOT NULL,
    contacto    NUMBER(9) NOT NULL,
    email       VARCHAR2(30) NOT NULL,
   
    PRIMARY KEY(usuario,contacto, email),
    
    CONSTRAINT telefono_email FOREIGN KEY(usuario,contacto) REFERENCES CONTACTO(usuario, telefono)
        --ON UPDATE CASCADE --ON DELETE CASCADE
);


CREATE TABLE CHAT_GRUPO(
    codigo              CHAR(4) NOT NULL,
    nombre              VARCHAR2(20)NOT NULL,
    fecha_creacion      DATE NOT NULL,
    miembros            NUMBER(3) NOT NULL,
    administrador       NUMBER(9) NOT NULL,
    mensaje_anclado_id  CHAR(4) NOT NULL,
    
    PRIMARY KEY(codigo)    
);


CREATE TABLE MENSAJE(
    mensaje_id      CHAR(10) NOT NULL,
    diahora         CHAR(10)NOT NULL,
    reenviado       CHAR(1) NOT NULL,
    usuario         NUMBER(9) NOT NULL,
    chat_grupo      CHAR(4) NOT NULL,
    msj_original    CHAR(1),
    PRIMARY KEY(mensaje_id),
    CONSTRAINT msg_original FOREIGN KEY (msj_original) REFERENCES MENSAJE(msj_original),
        --ON UPDATE CASCADE --ON DELETE NO ACION
    CONSTRAINT id_chat FOREIGN KEY (chat_grupo) REFERENCES CHAT_GRUPO(chat_grupo),
        --ON UPDATE CASCADE --ON DELETE CASCADE
    CONSTRAINT tlf_usuario FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono)
        --ON UPDATE CASCADE --ON DELETE NO ACION
);


CREATE TABLE PARTICIPACION (
   usuario      NUMBER(9) NOT NULL, 
   chat_grupo   CHAR(4)   NOT NULL,  
   fecha_inicio DATE      NOT NULL,
   CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
   --
   CONSTRAINT participacion_fk_usuario
      FOREIGN KEY(usuario) REFERENCES miusuario(telefono),
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
   CONSTRAINT participacion_fk_chatgrupo
      FOREIGN KEY(chat_grupo) REFERENCES chat_grupo(codigo) 
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
);



