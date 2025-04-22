




CREATE TABLE CONTACTO(
telefono NUMBER(9) NOT NULL,
nombre char(9) NOT NULL,
apellido char(9) NOT NULL,
cumpleanos date  NULL,
dia date  NULL,
mes date  NULL,
propietario char(9) NOT NULL,
CONSTRAINT cont_pk PRIMARY KEY( telefono ),
CONSTRAINT cont_fk FOREIGN KEY (propietario) REFERENCES USUARIO(telefono)

);

CREATE TABLE CHAT_GRUPO(
	codigo NUMBER(4) NOT NULL,
	nombre char(9) NOT NULL,
	fecha_creacion date NOT NULL,
    miembro char(9) NOT NULL,
	administrador char(9) NOT NULL,
    mensaje_anclado char(10) NOT NULL,
	CONSTRAINT chat_pk PRIMARY KEY(codigo),
	CONSTRAINT chat_fk FOREIGN KEY (administrador) REFERENCES USUARIO(telefono),
    CONSTRAINT chat_fk FOREIGN KEY (participante) REFERENCES USUARIO(telefono)
);

CREATE TABLE EMAIL_CONTACTO (
    telefono NUMBER(9) NOT NULL,
    email char(9) NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY(telefono,email),

);


CREATE TABLE MENSAJE (
    mensaje_id CHAR(4) NOT NULL,
    reenviado CHAR(10) NULL,
    dia_hora DATE NOT NULL,
    chat CHAR(10) NOT NULL,
    usuario CHAR(10) NOT NULL,
    msj_original CHAR(10) NOT NULL,
    CONSTRAINT mens_pk PRIMARY KEY(mensaje_id),
    CONSTRAINT mens_fk FOREIGN KEY (chat) REFERENCES CHAT_GRUPO(codigo),
    CONSTRAINT mens_fk FOREIGN KEY (usuario) REFERENCES USUARIO(telefono),
    CONSTRAINT mens_fk FOREIGN KEY (msj_original) REFERENCES MENSAJE(mensaje_id)
);

CREATE TABLE USUARIO(
telefono NUMBER(9) NOT NULL,
nombre char(9) NOT NULL,
fecha_registro date NOT NULL,
idioma  char(9) NOT NULL,
descripcion char(9) NULL,
CONSTRAINT usu_pk PRIMARY KEY(telefono)

);