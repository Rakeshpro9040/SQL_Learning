SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME FROM EMPLOYEES E;
SELECT * FROM EMPLOYEES;

SELECT * FROM STUDENTS;

SELECT * FROM EMPLOYEES_BKP;

SELECT * FROM STUDENTS_BKP;

CREATE TABLE STUDENTS_BKP
AS SELECT * FROM STUDENTS
WHERE 1 = 0;

CREATE TABLE EMPLOYEES_BKP
AS SELECT * FROM EMPLOYEES
WHERE 1 = 0;


BEGIN
DBMS_OUTPUT.PUT_LINE('Hi');
END;

BEGIN
DBMS_OUTPUT.PUT_LINE('Started');
SELECT * FROM EMPLOYEES;
DBMS_OUTPUT.PUT_LINE('Ended');
END;

SELECT * FROM V$INSTANCE;
--INSTANCE_NAME	ORCL	

CREATE TABLE REGISTRATION(
ROLL_NO NUMBER(10),
NAME VARCHAR(50) ,
CLASS VARCHAR(50),
SEX VARCHAR(50) ,
EMAIL VARCHAR(50));

SELECT * FROM REGISTRATION;

CREATE TABLE PEOPLE(
NAME VARCHAR2(100),
AGE NUMBER(3));

SELECT * FROM PEOPLE;
