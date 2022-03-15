--This is the SQL Script to run the code_examples for Lesson 21

--Uncomment the code below to execute the code on slide 09_sa 

/*

DESCRIBE USER_PLSQL_OBJECT_SETTINGS;

*/
--Uncomment the code below to execute the code on slide 10_sa 
/*

SELECT name, type, plsql_code_type, 
       plsql_optimize_level
FROM   user_plsql_object_settings;
*/

--Uncomment the code below to execute the code on slide 10_na
/*
ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL=1;
*/

--Uncomment the code below to execute the code on slide 11_sa 

/*

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 1;
ALTER SESSION SET PLSQL_CODE_TYPE = 'NATIVE';

*/


--Uncomment the code below to execute the code on slide 11_sc 

/*

--Execute the code under slide 10_na before executing this code
@code_21_09_sa.sql

*/

--Uncomment the code below to execute the code on slide 11_na 

/*

CREATE OR REPLACE PROCEDURE add_job_history
 (  p_emp_id  job_history.employee_id%type, 
    p_start_date  job_history.start_date%type, 
    p_end_date job_history.end_date%type, 
    p_job_id  job_history.job_id%type, 
    p_department_id   job_history.department_id%type ) IS
   
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
  VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history; 
/

*/


--Uncomment the code below to execute the code on slide 18_sa 

/*

ALTER SESSION 
SET plsql_warnings =	'enable:severe', 'enable:performance', 'disable:informational';

*/

--Uncomment the code below to execute the code on slide 18_sb 

/*

ALTER SESSION 
SET plsql_warnings = 'enable:severe';

*/

--Uncomment the code below to execute the code on slide 18_sc 

/*

ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:SEVERE','DISABLE:PERFORMANCE' , 'ERROR:05003';

*/

--Uncomment the code below to execute the code on slide 20_sa 

/*
ALTER SESSION SET plsql_warnings = 'enable:severe', 'enable:performance', 'enable:informational';
SELECT value FROM v$parameter WHERE name='plsql_warnings';

*/

--Uncomment the code below to execute the code on slide 20_na 

/*

SET SERVEROUTPUT ON

DECLARE s VARCHAR2(1000);
BEGIN
   s := dbms_warning.get_warning_setting_string();
   dbms_output.put_line (s);
END;
/

*/

--Uncomment the code below to execute the code on slide 22_sa 
/*

CREATE OR REPLACE PROCEDURE bad_proc(p_out ?) IS 
   BEGIN 
   . . .; 
   END;
   /

--SP2-0804: Procedure created with compilation warnings.
*/

--Uncomment the code below to execute the code on slide 22_sb
/*
SHOW ERRORS;

*/

--Uncomment the code below to execute the code on slide 28_sa 

/*

-- Establish the following warning setting string in the
-- current session:
-- ENABLE:INFORMATIONAL,
-- DISABLE:PERFORMANCE,
-- ENABLE:SEVERE


EXECUTE DBMS_WARNING.SET_WARNING_SETTING_STRING('ENABLE:ALL', 'SESSION');

EXECUTE DBMS_WARNING.ADD_WARNING_SETTING_CAT('PERFORMANCE','DISABLE', 'SESSION');

*/

--Uncomment the code below to execute the code on slide 30_sa 

/*

SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE(DBMS_WARNING.GET_WARNING_SETTING_STRING);

*/

--Uncomment the code below to execute the code on slide 30_sb 

/*

SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE(DBMS_WARNING.GET_CATEGORY(7203));

*/
--Uncomment the code below to execute the code on slide 31_sa
/*
CREATE OR REPLACE PROCEDURE compile_code(p_pkg_name VARCHAR2) IS
  v_warn_value   VARCHAR2(200);
  v_compile_stmt VARCHAR2(200) := 
    'ALTER PACKAGE '|| p_pkg_name ||' COMPILE';

BEGIN
   v_warn_value := DBMS_WARNING.GET_WARNING_SETTING_STRING; 
   DBMS_OUTPUT.PUT_LINE('Current warning settings: '|| 
      v_warn_value); 
   DBMS_WARNING.ADD_WARNING_SETTING_CAT(
      'PERFORMANCE', 'DISABLE', 'SESSION');
   DBMS_OUTPUT.PUT_LINE('Modified warning settings: '|| 
      DBMS_WARNING.GET_WARNING_SETTING_STRING); 
   EXECUTE IMMEDIATE v_compile_stmt;
   DBMS_WARNING.SET_WARNING_SETTING_STRING(v_warn_value,     
      'SESSION'); 
   DBMS_OUTPUT.PUT_LINE('Restored warning settings: '|| 
      DBMS_WARNING.GET_WARNING_SETTING_STRING);
END;
/
*/

--Uncomment the code below to execute the code on slide 32_sa 

/*

-- Test the compile_code procedure from code_12_33_s.sql

EXECUTE DBMS_WARNING.SET_WARNING_SETTING_STRING('ENABLE:ALL', 'SESSION');


*/

--Uncomment the code below to execute the code on slide 32_sb 

/*

@code_21_33_s.sql

*/

--Uncomment the code below to execute the code on slide 32_sc 

/*

SET SERVEROUTPUT ON

EXECUTE compile_code('DEPT_PKG'); 

*/
