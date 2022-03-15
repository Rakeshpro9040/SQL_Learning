--The SQL Script to run the solution for Practice 21
--Run cleanup_21.sql script from /home/oracle/labs/plpu/code_ex/cleanup_scripts directory before executing the solutions.
--Uncomment code below to run the solution for Task 1 of Practice 21

-- If you have dropped the EMP_PKG or ADD_DEPARTMENT procedure in the clean up scripts
--Uncomment the code below and execute the following code of ADD_DEPARTMENT
/*

CREATE SEQUENCE  DEPARTMENTS_SEQ  
MINVALUE 1 
MAXVALUE 9990 
INCREMENT BY 10 START WITH 100 ;
/

create or replace PROCEDURE add_department(
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

/*

SELECT name, type,plsql_code_type as code_type, 
plsql_optimize_level as opt_lvl
FROM   user_plsql_object_settings;

*/

--Uncomment code below to run the solution for Task 2_a of Practice 21

/* 

ALTER SESSION SET PLSQL_CODE_TYPE = 'NATIVE';

*/

--Uncomment code below to run the solution for Task 2_b of Practice 21

/* 

ALTER PROCEDURE add_department COMPILE;

*/

--Uncomment code below to run the solution for Task 2_c of Practice 21
/*

SELECT name, type, plsql_code_type as code_type, 
plsql_optimize_level as opt_lvl
FROM   user_plsql_object_settings;

*/

--Uncomment code below to run the solution for Task 2_d of Practice 21

/* 

ALTER SESSION SET PLSQL_CODE_TYPE = 'INTERPRETED';
*/

--Uncomment code below to run the solution for Task 4 of Practice 21
/*

CREATE OR REPLACE PROCEDURE unreachable_code AS
  c_x CONSTANT BOOLEAN := TRUE;
BEGIN
  IF c_x THEN
    DBMS_OUTPUT.PUT_LINE('TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('FALSE');
  END IF;
END unreachable_code;
/

*/

--Uncomment code below to run the solution for Task 8 of Practice 21

/*

DESCRIBE user_errors

SELECT *
FROM user_errors;

*/

--Uncomment code below to run the solution for Task 9 of Practice 21
/*

SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE(DBMS_WARNING.GET_CATEGORY(&message));

*/
