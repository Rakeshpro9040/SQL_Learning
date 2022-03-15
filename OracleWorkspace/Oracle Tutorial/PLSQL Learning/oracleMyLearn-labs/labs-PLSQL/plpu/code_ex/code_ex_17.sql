--This is the SQL Script to run the code_examples for Lesson 17

--Uncomment the code below to execute the code on slide 13_sa 

/*

CREATE OR REPLACE PROCEDURE create_table(
  p_table_name VARCHAR2, p_col_specs  VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 
   'CREATE TABLE ' || p_table_name || ' (' || p_col_specs || ')';
END;
/

*/

--Uncomment the code below to execute the code on slide 13_sb 
-- Run the code under slide 11_sa before running this code example. 

/*
BEGIN
  create_table('EMPLOYEE_NAMES',
   'id NUMBER(4) PRIMARY KEY, name VARCHAR2(40)');
END;
/

*/

--Uncomment the code below to execute the code on slide 13_na 
/*

CREATE OR REPLACE PROCEDURE add_col(p_table_name VARCHAR2,
                         p_col_spec VARCHAR2) IS
  v_stmt VARCHAR2(100) := 'ALTER TABLE ' || p_table_name ||
                        ' ADD '|| p_col_spec;
BEGIN
  EXECUTE IMMEDIATE v_stmt;
END;
/

*/
--Uncomment the code below to execute the code on slide 13_nb 


/* 
EXECUTE add_col('employee_names', 'salary number(8,2)')
*/

--Uncomment the code below to execute the code on slide 14_sa 
-- Run the code under slide 11_sb before running this code example which creates the EMPLOYEE_NAMES table.
/*

SET SERVEROUTPUT ON

CREATE FUNCTION del_rows(p_table_name VARCHAR2)
RETURN NUMBER IS
BEGIN
  EXECUTE IMMEDIATE 'DELETE FROM '|| p_table_name;
  RETURN SQL%ROWCOUNT;
END;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(del_rows('EMPLOYEE_NAMES')|| ' rows deleted.');
END;
/

*/

--Uncomment the code below to execute the code on slide 14_sb 
/*

CREATE or REPLACE PROCEDURE add_row(p_table_name VARCHAR2,
   p_id NUMBER, p_name VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'INSERT INTO '|| p_table_name||'(ID,NAME)'||
        ' VALUES (:1, :2)' USING p_id, p_name;
END;
/
*/

--Uncomment the code below to execute the code on slide 14_na
-- Run the code under slide 14_sa and 14_sb before running this code example. 
/*
BEGIN
 add_row('EMPLOYEE_NAMES',100,'KING');
 DBMS_OUTPUT.PUT_LINE(
  del_rows('EMPLOYEE_NAMES')|| ' rows deleted.');
END;
/
*/

--Uncomment the code below to execute the code on slide 16_sa 
/*

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION get_emp(p_emp_id NUMBER)
RETURN employees%ROWTYPE IS
  v_stmt VARCHAR2(200);
  v_emprec employees%ROWTYPE;
BEGIN
  v_stmt := 'SELECT * FROM employees ' ||
          'WHERE employee_id = :id';
  EXECUTE IMMEDIATE v_stmt INTO v_emprec USING p_emp_id;

  RETURN v_emprec;
END;
/
DECLARE
  v_emprec employees%ROWTYPE := get_emp(100);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Emp: '|| v_emprec.last_name);
END;
/

*/

--Uncomment the code below to execute the code on slide 17_sa 
/*

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION annual_sal( p_emp_id NUMBER)
RETURN NUMBER IS
  v_plsql varchar2(200) :=
    'DECLARE '||
    ' rec_emp employees%ROWTYPE; '||
    'BEGIN '||
    ' rec_emp := get_emp(:empid); ' ||
    ' :res := rec_emp.salary  * 12; ' ||
    'END;';
  v_result NUMBER;
BEGIN
 EXECUTE IMMEDIATE v_plsql
         USING IN p_emp_id, OUT v_result;
  RETURN v_result;
END; 
/
EXECUTE DBMS_OUTPUT.PUT_LINE(annual_sal(100))

*/
--Uncomment the code below to execute the code on slide 20_sa 
/*
DECLARE
     TYPE EmpCurTyp IS REF CURSOR;
     TYPE NumList IS TABLE OF NUMBER;
     TYPE NameList IS TABLE OF VARCHAR2(25);
     emp_cv EmpCurTyp;
     empids NumList;
     enames NameList;
     sals   NumList;
  BEGIN
     OPEN emp_cv FOR 'SELECT employee_id, last_name FROM employees';
     FETCH emp_cv BULK COLLECT INTO empids, enames;
     CLOSE emp_cv;
     DBMS_OUTPUT.PUT_LINE(empids.count); 
     END;   
/

*/

--Uncomment the code below to execute the code on slide 28_sa 
/*

CREATE OR REPLACE FUNCTION delete_all_rows
  (p_table_name VARCHAR2) RETURN NUMBER IS
   v_cur_id INTEGER;
   v_rows_del    NUMBER;
BEGIN
  v_cur_id := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cur_id,'DELETE FROM '|| p_table_name, DBMS_SQL.NATIVE);
  v_rows_del := DBMS_SQL.EXECUTE (v_cur_id);
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
  RETURN v_rows_del;
END;
/

*/

--Uncomment the code below to execute the code on slide 28_sb 
-- Run the codeunder slide 20_sa before running this code example. 
/*

SET SERVEROUTPUT ON

CREATE TABLE temp_emp AS SELECT * FROM employees;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Rows Deleted: ' || delete_all_rows('temp_emp')); 
END;
/

*/
--Uncomment the code below to execute the code on slide 30_sa 
/*
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE insert_row (p_table_name VARCHAR2,
  p_id VARCHAR2, p_name VARCHAR2, p_region NUMBER) IS
  v_cur_id     INTEGER;
  v_stmt       VARCHAR2(200);
  v_rows_added NUMBER;

BEGIN
  v_stmt := 'INSERT INTO '|| p_table_name ||
     	    ' VALUES (:cid, :cname, :rid)';
  v_cur_id := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cur_id, v_stmt, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':cid', p_id);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':cname', p_name);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':rid', p_region);
  v_rows_added := DBMS_SQL.EXECUTE(v_cur_id);
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
  DBMS_OUTPUT.PUT_LINE(v_rows_added ||' row added');
END;
/
*/



