--This is the SQL Script to run the code_examples for Lesson 11

--Uncomment the code below to execute the code on slide 15_sa
/*
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE hello AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello Class');
END HELLO;
*/

--Uncomment the code below to execute the code on slide 16_sa
/*
--invoking procedure from anonymous block
BEGIN
	hello;
END;
/
*/

--Uncomment the code below to execute the code on slide 16_sb
/*

--invoking procedure in another procedure
CREATE OR REPLACE PROCEDURE greet IS
BEGIN
	hello;
END greet;
/
*/

--Uncomment the code below to execute the code on slide 16_sc
/*

--invoking procedure with EXECUTE
EXECUTE greet;

*/

--Uncomment the code below to execute the code on slide 18_sa
/*
CREATE OR REPLACE PROCEDURE raise_sal AS
v_raise_percent NUMBER := 10;
BEGIN
UPDATE employees 
SET 
salary = salary *(1+1/v_raise_percent);
END raise_sal;

*/

--Uncomment the code below to execute the code on slide 23_sa
/*
CREATE OR REPLACE PROCEDURE query_emp 
(p_id IN employees.employee_id%TYPE) AS
		v_name employees.last_name%TYPE;
		v_salary employees.salary%TYPE;
	 BEGIN 
  SELECT last_name, salary INTO v_name,v_salary
  FROM employees 
  WHERE employee_id = p_id;
  DBMS_OUTPUT.PUT_LINE(' Current Salary of '||v_name || ' is '|| v_salary);
 END query_emp;
/

*/
--Uncomment the code below to execute the code on slide 23_sb
/*

EXECUTE query_emp(176)

*/
--Uncomment the code below to execute the code on slide 24_sa 
/*
CREATE OR REPLACE PROCEDURE query_emp
 (p_id     IN  employees.employee_id%TYPE,
  p_name   OUT employees.last_name%TYPE,
  p_salary OUT employees.salary%TYPE) IS
BEGIN
  SELECT  last_name, salary INTO p_name, p_salary
  FROM    employees
  WHERE   employee_id = p_id;
END query_emp;
/
*/
--Uncomment the code below to execute the code on slide 24_sb

/*

CREATE OR REPLACE PROCEDURE display AS
  v_emp_name employees.last_name%TYPE;
  v_emp_sal  employees.salary%TYPE;
BEGIN
  query_emp(171, v_emp_name, v_emp_sal);
  DBMS_OUTPUT.PUT_LINE(v_emp_name||' earns '|| to_char(v_emp_sal, '$999,999.00'));
END display;
/

EXECUTE display;

*/

--Uncomment the code below to execute the code on slide 25_sa 
/*
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE format_phone
  (p_phone_no IN OUT VARCHAR2) IS

BEGIN
  p_phone_no := '('  || SUBSTR(p_phone_no,1,3) ||
                ') ' || SUBSTR(p_phone_no,4,3) ||
                '-'  || SUBSTR(p_phone_no,7);
END format_phone;
/
*/
--Uncomment the code below to execute the code on slide 25_na 

-- You must run the code under slide 25_na before running this code example.
/*

VARIABLE  b_phone_no VARCHAR2(15)
EXECUTE  :b_phone_no := '8006330575' 
PRINT   b_phone_no
EXECUTE  format_phone (:b_phone_no)
PRINT b_phone_no

*/

--Uncomment the code below to execute the code on slide 27_sa 
/*
CREATE OR REPLACE PROCEDURE raise_sal
(p_id IN employees.employee_id%TYPE,
 p_percent IN NUMBER) AS
BEGIN
 	UPDATE employees
 SET salary = salary * (1 + p_percent/100)
 WHERE employee_id = p_id;
END raise_sal;

*/

--Uncomment the code below to execute the code on slide 28_sa 
/*
-- Passing parameters using the positional notation.
SELECT * FROM EMPLOYEES WHERE employee_id = 176;
EXECUTE raise_sal ('176', 10)
SELECT * FROM EMPLOYEES WHERE employee_id = 176;
*/
--Uncomment the code below to execute the code on slide 28_sb
/*

-- Passing parameters using the named notation.
EXECUTE raise_sal( p_percent =>10,p_id => 176)
*/

--Uncomment the code below to execute the code on slide 29_sa 
/*
CREATE OR REPLACE PROCEDURE raise_sal
(p_id IN employees.employee_id%TYPE,
 p_percent IN NUMBER DEFAULT 10) AS
BEGIN
 	UPDATE employees
 SET salary = salary * (1 + p_percent/100)
 WHERE employee_id = p_id;
END raise_sal;
*/
--Uncomment the code below to execute the code on slide 29_sb
/*
EXECUTE raise_sal(176) 
EXECUTE raise_sal(176,10)
EXECUTE raise_sal (p_id => 176)
*/

--Uncomment the code below to execute the code on slide 32_sa 

/*
CREATE PROCEDURE add_department(
    p_name VARCHAR2, p_mgr NUMBER, p_loc NUMBER) IS

BEGIN
  INSERT INTO departments (department_id,
    department_name, manager_id, location_id)
  VALUES (DEPARTMENTS_SEQ.NEXTVAL, p_name, p_mgr, p_loc);
  DBMS_OUTPUT.PUT_LINE('Added Dept: '|| p_name);

EXCEPTION
 WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Err: adding dept: '|| p_name);
END;
/

*/

--Uncomment the code below to execute the code on slide 32_sb 
-- You must run the code under slide 32_sa before running this code example.   
/*

CREATE PROCEDURE create_departments IS
BEGIN
  add_department('Media', 100, 1800);
  add_department('Editing', 99, 1800);
  add_department('Advertising', 101, 1800);
END;
/

*/

--Uncomment the code below to execute the code on slide 34_sa 
/*

CREATE PROCEDURE add_department_noex(
    p_name VARCHAR2, p_mgr NUMBER, p_loc NUMBER) IS
BEGIN
  INSERT INTO DEPARTMENTS (department_id,
    department_name, manager_id, location_id)
  VALUES (DEPARTMENTS_SEQ.NEXTVAL, p_name, p_mgr, p_loc);
  DBMS_OUTPUT.PUT_LINE('Added Dept: '||p_name);
END;
/
*/

--Uncomment the code below to execute the code on slide 34_sb
-- You must run the code under slide 34_sa before running this code example. 
/*

CREATE PROCEDURE create_departments_noex IS
BEGIN
  add_department_noex('Media', 100, 1800);
  add_department_noex('Editing', 99, 1800);
  add_department_noex('Advertising', 101, 1800);
END;
/
EXECUTE create_departments_noex

*/

--Uncomment the code below to execute the code on slide 35_sa 
-- You must run the code under slide 27_sa before running this code example. 


/* DROP PROCEDURE raise_sal;


--Uncomment the code below to execute the code on slide 36_sa 


/* DESCRIBE user_source



--Uncomment the code below to execute the code on slide 36_sb 

-- You must run the code under slide 27_sa before running this code example. 

/*

SELECT text
FROM   user_source
WHERE  name = 'RAISE_SAL' AND type = 'PROCEDURE'
ORDER BY line; 
