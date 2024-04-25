CREATE TABLE gerente(
    idGerente NUMBER PRIMARY KEY,
    desGerente VARCHAR2(255), 
    fechaRegistro DATE
    );


INSERT INTO gerente (idGerente, desGerente, fechaRegistro)
VALUES (1, 'pepito',to_date('2018-01-10','YYYY-MM-DD'));

INSERT INTO gerente (idGerente, desGerente, fechaRegistro)
VALUES (2, 'María ', to_date('2018-02-11','YYYY-MM-DD'));

INSERT INTO gerente (idGerente, desGerente, fechaRegistro)
VALUES (3, 'jose García',to_date( '2018-03-12','YYYY-MM-DD'));



create table condicion(
idCondicion number primary key,
descCondicion VARCHAR2(300),
fechaReistro Date);

INSERT INTO condicion (idCondicion, descCondicion, fechaReistro)
VALUES (1, 'regular',to_date( '2019-03-10','YYYY-MM-DD'));

INSERT INTO condicion (idCondicion, descCondicion, fechaReistro)
VALUES (2, 'Regular',to_date( '2019-03-11','YYYY-MM-DD'));

INSERT INTO condicion (idCondicion, descCondicion, fechaReistro)
VALUES (3, 'dosil', to_date('2018-03-15','YYYY-MM-DD'));

create table Provincia(
idProvincia number primary key,
desProvincia varchar(200),
fechaRegistro Date);

INSERT INTO provincia (idProvincia, desProvincia, fechaRegistro)
VALUES (1, 'tumbes',to_date ('2018-04-17','YYYY-MM-DD'));

INSERT INTO provincia (idProvincia, desProvincia, fechaRegistro)
VALUES (2, 'piura',to_date ('2018-04-18','YYYY-MM-DD'));

INSERT INTO provincia (idProvincia, desProvincia, fechaRegistro)
VALUES (3, 'moquegua',to_date('2018-04-19','YYYY-MM-DD'));



create table distrito (
idDistrito number primary key,
idProvincia number,
desDistrito VARCHAR2(200),
fechaRegistro Date,
CONSTRAINT fk_Provincia FOREIGN KEY (idProvincia) REFERENCES Provincia(idProvincia)
)

INSERT INTO distrito (idDistrito, idProvincia, desDistrito, fechaRegistro)
VALUES (1, 1, 'jesus maria', to_date('2018-04-20','YYYY-MM-DD'));

INSERT INTO distrito (idDistrito, idProvincia, desDistrito, fechaRegistro)
VALUES (2, 2, 'San Isidro', to_date('2018-04-21','YYYY-MM-DD'));

INSERT INTO distrito (idDistrito, idProvincia, desDistrito, fechaRegistro)
VALUES (3, 2, 'Cayma',to_date( '2018-04-22','YYYY-MM-DD'));

create table sede(
idSede number primary key,
desSede varchar2(50) not null,
fechaRegistro Date );
 
INSERT INTO sede (idsede, desSede, fechaRegistro)
VALUES (1, 'Las palmas', to_date('2018-05-17','YYYY-MM-DD'));

INSERT INTO sede (idSede, desSede, fechaRegistro)
VALUES (2, 'San marcos', to_date('2018-05-18','YYYY-MM-DD'));

INSERT INTO sede (idSede, desSede, fechaRegistro)
VALUES (3, 'Aramburu', to_date('2018-05-19','YYYY-MM-DD'));



create table Hospital(
idHospital number primary key,
idDistrito number unique,
nombre VARCHAR2(200),
antiguedad number,
area number,
idSede number unique,
idGerente number unique,
idCondicion number unique,
fechaRegistro Date,
   CONSTRAINT fk_Distrito FOREIGN KEY (idDistrito) REFERENCES distrito(idDistrito),
    CONSTRAINT fk_Gerente FOREIGN KEY (idGerente) REFERENCES gerente(idGerente),
     CONSTRAINT fk_Condicion FOREIGN KEY (idCondicion) REFERENCES condicion(idCondicion),
      CONSTRAINT fk_Sede FOREIGN KEY (idSede) REFERENCES sede(idSede));
  
  
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_REGISTRAR (
  p_idHospital IN NUMBER,
  p_nombre IN VARCHAR2,
  p_antiguedad IN NUMBER,
  p_area IN NUMBER,
  p_idSede IN NUMBER,
  p_idGerente IN NUMBER,
  p_idCondicion IN NUMBER,
  p_idDistrito IN NUMBER
)
IS
  v_veri NUMBER;
  v_sede_existe NUMBER;
BEGIN

  SELECT COUNT(*)
  INTO v_veri
  FROM Hospital
  WHERE idHospital = p_idHospital;


  SELECT COUNT(*)
  INTO v_sede_existe
  FROM Sede
  WHERE idSede = p_idSede;

  IF v_veri = 0 THEN
    IF v_sede_existe = 1 THEN

      INSERT INTO Hospital (idHospital, nombre, antiguedad, area, idSede, idGerente, idCondicion, idDistrito, fechaRegistro)
      VALUES (p_idHospital, p_nombre, p_antiguedad, p_area, p_idSede, p_idGerente, p_idCondicion, p_idDistrito, SYSDATE);

      DBMS_OUTPUT.PUT_LINE('Hospital registrado correctamente');
    ELSE
      DBMS_OUTPUT.PUT_LINE('La sede con ID ' || p_idSede || ' no existe');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('El hospital con ID ' || p_idHospital || ' ya existe');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al registrar el hospital: ' || SQLERRM);
END SP_HOSPITAL_REGISTRAR;



BEGIN
    SP_HOSPITAL_REGISTRAR(2 , 'Hospital bermudez', 7, 500, 2, 2, 2, 2);
END;

select * from hospital;


CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ACTUALIZAR (
    p_idHospital IN NUMBER,
    p_nombre IN VARCHAR2,
    p_antiguedad IN NUMBER,
    p_area IN NUMBER,
    p_idSede IN NUMBER,
    p_idGerente IN NUMBER,
    p_idCondicion IN NUMBER,
    p_idDistrito IN NUMBER
)
IS
    v_veri NUMBER;
BEGIN
    
    SELECT COUNT(*)
    INTO v_veri
    FROM Hospital
    WHERE idHospital = p_idHospital;
    
    IF v_veri > 0 THEN
       
        UPDATE Hospital
        SET nombre = p_nombre,
            antiguedad = p_antiguedad,
            area = p_area,
            idSede = p_idSede,
            idGerente = p_idGerente,
            idCondicion = p_idCondicion,
            idDistrito = p_idDistrito
        WHERE idHospital = p_idHospital;
        
        DBMS_OUTPUT.PUT_LINE('Hospital actualizado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El hospital con ID ' || p_idHospital || ' no existe.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar el hospital: ' || SQLERRM);
END SP_HOSPITAL_ACTUALIZAR;

BEGIN
    SP_HOSPITAL_ACTUALIZAR(3, 'Hospital viejo', 4, 600, 1, 1, 1, 1);
END;

select * from hospital;



CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ELIMINAR (
    p_idHospital IN NUMBER
)
IS
    v_veri NUMBER;
BEGIN
   
    SELECT COUNT(*)
    INTO v_veri
    FROM Hospital
    WHERE idHospital = p_idHospital;
    
    IF v_veri > 0 THEN
        DELETE FROM Hospital WHERE idHospital = p_idHospital;
        DBMS_OUTPUT.PUT_LINE('Hospital eliminado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El hospital con ID '||p_idHospital||' no existe');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el hospital: '|| SQLERRM);
END SP_HOSPITAL_ELIMINAR;


BEGIN
    SP_HOSPITAL_ELIMINAR(p_idHospital => 1);
END;

select * from Hospital;

CREATE OR REPLACE PROCEDURE SP_HOSPITAL_LISTAR (
    p_nombre_provincia IN VARCHAR2 DEFAULT NULL,
    p_nombre_sede IN VARCHAR2 DEFAULT NULL,
    p_nombre_gerente IN VARCHAR2 DEFAULT NULL,
    p_nombre_condicion IN VARCHAR2 DEFAULT NULL,
    p_cursor OUT SYS_REFCURSOR
) AS
    v_sql VARCHAR2(4000);
BEGIN
    v_sql := 'SELECT h.idHospital, h.nombre, h.antiguedad, h.area,
                      d.desDistrito, p.desProvincia, s.desSede,
                      g.desGerente, c.descCondicion, h.fechaRegistro
               FROM Hospital h
               JOIN Distrito d ON h.idDistrito = d.idDistrito
               JOIN Provincia p ON d.idProvincia = p.idProvincia
               JOIN Sede s ON h.idSede = s.idSede
               JOIN Gerente g ON h.idGerente = g.idGerente
               JOIN Condicion c ON h.idCondicion = c.idCondicion
               WHERE 1=1';

    IF p_nombre_provincia IS NOT NULL THEN
        v_sql := v_sql || ' AND p.desProvincia = :nombre_provincia';
    END IF;

    IF p_nombre_sede IS NOT NULL THEN
        v_sql := v_sql || ' AND s.desSede = :nombre_sede';
    END IF;

    IF p_nombre_gerente IS NOT NULL THEN
        v_sql := v_sql || ' AND g.desGerente = :nombre_gerente';
    END IF;

    IF p_nombre_condicion IS NOT NULL THEN
        v_sql := v_sql || ' AND c.descCondicion = :nombre_condicion';
    END IF;

    BEGIN
        OPEN p_cursor FOR v_sql
        USING p_nombre_provincia, p_nombre_sede, p_nombre_gerente, p_nombre_condicion;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            IF p_cursor IS NOT NULL THEN
                CLOSE p_cursor;
            END IF;
    END;
END SP_HOSPITAL_LISTAR;

EXEC SP_HOSPITAL_LISTAR;

DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    SP_HOSPITAL_LISTAR(NULL, NULL, NULL, NULL, v_cursor);
    
END;

select * from hospital;



set serveroutput on;






