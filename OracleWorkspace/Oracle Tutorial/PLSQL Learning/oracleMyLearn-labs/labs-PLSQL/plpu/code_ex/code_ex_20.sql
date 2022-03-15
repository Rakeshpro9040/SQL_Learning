--This is the SQL Script to run the code_examples for Lesson 20

--Uncomment the code below to execute the code on slide 06_sa 
/*

CREATE OR REPLACE PACKAGE error_pkg IS
  e_fk_err	     EXCEPTION;
  e_seq_nbr_err	EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_fk_err, -2292);
  PRAGMA EXCEPTION_INIT (e_seq_nbr_err, -2277);
  -- Partial code.
END error_pkg;
/

*/

--Uncomment the code below to execute the code on slide 08_sa 
/*

CREATE OR REPLACE PACKAGE constant_pkg IS
  c_order_received CONSTANT VARCHAR(2) := 'OR';
  c_order_shipped  CONSTANT VARCHAR(2) := 'OS';
  c_min_sal        CONSTANT NUMBER(3)  := 900;
END constant_pkg;
/

*/

--Uncomment the code below to execute the code on slide 08_na 
-- Run the code under slide 08_sa before running this code example. 
/*
BEGIN
  UPDATE employees
     SET salary  = salary + 200
  WHERE salary <= constant_pkg.c_min_sal;
END;
/

*/

--Uncomment the code below to execute the code on slide 09_sa 
/*
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE employee_sal(p_id NUMBER) IS
   v_emp employees%ROWTYPE;
   FUNCTION tax(p_salary VARCHAR2) RETURN NUMBER IS
   BEGIN
     RETURN p_salary * 0.825;
   END tax;
BEGIN
   SELECT * INTO v_emp
   FROM EMPLOYEES WHERE employee_id = p_id;
   DBMS_OUTPUT.PUT_LINE('Tax: '||tax(v_emp.salary));
END;
/
EXECUTE employee_sal(100)

*/

--Uncomment the code below to execute the code on slide 12_sa 
/*

CREATE OR REPLACE PROCEDURE add_dept(
  p_id NUMBER, p_name VARCHAR2)  AUTHID CURRENT_USER IS
BEGIN
  INSERT INTO departments
  VALUES (p_id, p_name, NULL, NULL);
END;
/

*/

--Uncomment the code below to execute the code on slide 17_sa 
/*
CREATE TABLE usage (card_id NUMBER, loc NUMBER)
/
CREATE TABLE txn (acc_id NUMBER, amount NUMBER)
/

CREATE OR REPLACE PROCEDURE log_usage (p_card_id NUMBER, p_loc NUMBER) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO usage
  VALUES (p_card_id, p_loc);
  COMMIT;
END log_usage;
/

CREATE OR REPLACE PROCEDURE bank_trans(p_cardnbr NUMBER,p_loc NUMBER) IS
BEGIN
   INSERT INTO txn VALUES (9001, 1000);
   log_usage (p_cardnbr, p_loc);
END bank_trans;
/
EXECUTE bank_trans(50, 2000)

*/
--Uncomment the code below to execute the code on slide 20_sa 
/*
DECLARE
  TYPE 		 rec_emp_type IS TABLE OF employees%ROWTYPE;
  rec_emp  rec_emp_type;
  PROCEDURE populate(p_tab IN OUT NOCOPY emptabtype)IS
    BEGIN
	 . . Partial code
    END;
BEGIN
  populate(rec_emp);
END;
/
*/

--Uncomment the code below to execute the code on slide 23_sa 
/*
CREATE OR REPLACE FUNCTION f2 (p_p1 NUMBER) 
  RETURN NUMBER PARALLEL_ENABLE IS 
BEGIN 
  RETURN p_p1 * 2; 
END f2;
/


--Uncomment the code below to execute the code on slide 25_sa 
/*

CREATE OR REPLACE FUNCTION get_hire_date (emp_id NUMBER)
 RETURN VARCHAR
 RESULT_CACHE
 AUTHID CURRENT_USER
IS
  date_hired DATE;
BEGIN
  SELECT hire_date INTO date_hired
  from employees
  WHERE employee_id = emp_id;
  RETURN TO_CHAR(date_hired);
END;
/
SELECT get_hire_date(206) from DUAL;   

*/

--Uncomment the code below to execute the code on slide 27_sa 
--Run the following ALTER TRIGGER command with appropriate trigger name, if
--any of them interfere with the execution of the procedure
/*
ALTER TRIGGER check_salary DISABLE;
*/
/*

CREATE OR REPLACE PROCEDURE update_salary(p_emp_id NUMBER) IS
  v_name    employees.last_name%TYPE;
  v_new_sal employees.salary%TYPE;
BEGIN
  UPDATE employees 
    SET salary = salary * 1.1
  WHERE employee_id = p_emp_id
  RETURNING last_name, salary INTO v_name, v_new_sal;
DBMS_OUTPUT.PUT_LINE(v_name || ' new salary is ' || v_new_sal);
END update_salary;
/


*/

--Uncomment the code below to execute the code on slide 27_na 
-- Run the code under slide 27_sa before running this code example. 
/*
SET SERVEROUTPUT ON
/
select last_name, salary from employees where employee_id=108;
/
EXECUTE update_salary(108)

*/

--Uncomment the code below to execute the code on slide 31_32_33_sa 
/*

CREATE TABLE parts1 ( pnum INTEGER, pname VARCHAR2(15) );
/
CREATE TABLE parts2 ( pnum INTEGER, pname VARCHAR2(15) );
/
DECLARE 
TYPE NumTab IS TABLE OF parts1.pnum%TYPE INDEX BY PLS_INTEGER; 
TYPE NameTab IS TABLE OF parts1.pname%TYPE INDEX BY PLS_INTEGER; 
pnums NumTab; 
pnames NameTab; 
iterations CONSTANT PLS_INTEGER := 50000; 
t1 INTEGER; 
t2 INTEGER; 
t3 INTEGER; 
BEGIN
 FOR j IN 1..iterations LOOP -- populate collections 
pnums(j) := j;
 pnames(j) := 'Part No. ' || TO_CHAR(j); 
END LOOP; 
t1 := DBMS_UTILITY.get_time; 
FOR i IN 1..iterations LOOP 
INSERT INTO parts1 (pnum, pname) VALUES (pnums(i), pnames(i)); 
END LOOP; 
t2 := DBMS_UTILITY.get_time; 
FORALL i IN 1..iterations 
INSERT INTO parts2 (pnum, pname) VALUES (pnums(i), pnames(i)); 
t3 := DBMS_UTILITY.get_time;
DBMS_OUTPUT.PUT_LINE('Execution Time (secs)'); 
DBMS_OUTPUT.PUT_LINE('---------------------'); 
DBMS_OUTPUT.PUT_LINE('FOR LOOP: ' || TO_CHAR((t2 - t1)/100));
DBMS_OUTPUT.PUT_LINE('FORALL: ' || TO_CHAR((t3 - t2)/100)); 
COMMIT; 
END; 
/
*/

--Uncomment the code below to execute the code on slide 34_sa 
/*

CREATE OR REPLACE PROCEDURE get_departments(p_loc NUMBER) IS
  TYPE dept_tab_type IS
    TABLE OF departments%ROWTYPE;
  v_depts dept_tab_type;
BEGIN
  SELECT * BULK COLLECT INTO v_depts
  FROM departments
  WHERE location_id = p_loc;                         
  FOR i IN 1 .. v_depts.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_depts(i).department_id
     ||' '|| v_depts(i).department_name);
  END LOOP;
END;

*/

--Uncomment the code below to execute the code on slide 35_sa 
/*
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE get_departments(p_loc NUMBER) IS
  CURSOR cur_dept IS 
    SELECT * FROM departments
    WHERE location_id = p_loc;                         
  TYPE dept_tab_type IS TABLE OF cur_dept%ROWTYPE;
  v_depts dept_tab_type;
BEGIN
  OPEN cur_dept;
  FETCH cur_dept BULK COLLECT INTO v_depts;
  CLOSE cur_dept;
 FOR i IN 1 .. v_depts.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_depts(i).department_id
     ||' '|| v_depts(i).department_name);
  END LOOP;
END;
/

*/

--Uncomment the code below to execute the code on slide 35_na 
/*

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE get_departments(p_loc NUMBER,p_nrows NUMBER) IS
  CURSOR dept_csr IS SELECT * 
  FROM departments
  WHERE location_id = p_loc;                         
  TYPE dept_tabtype IS TABLE OF dept_csr%ROWTYPE;
  depts dept_tabtype;
BEGIN
  OPEN dept_csr;
  FETCH dept_csr BULK COLLECT INTO depts LIMIT p_nrows;
  CLOSE dept_csr;
  DBMS_OUTPUT.PUT_LINE(depts.COUNT||' rows read');
END;
/
*/

--Uncomment the code below to execute the code on slide 36_sa 
/*

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE raise_salary(p_rate NUMBER) IS
   TYPE emplist_type IS TABLE OF NUMBER;
   TYPE numlist_type IS TABLE OF employees.salary%TYPE
     INDEX BY BINARY_INTEGER;
   v_emp_ids  emplist_type := emplist_type(100,101,102,104);
   v_new_sals numlist_type;
BEGIN
  FORALL i IN v_emp_ids.FIRST .. v_emp_ids.LAST
    UPDATE employees
      SET commission_pct = p_rate * salary
    WHERE employee_id = v_emp_ids(i)                         
    RETURNING salary BULK COLLECT INTO v_new_sals;
  FOR i IN 1 .. v_new_sals.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_new_sals(i));
  END LOOP;
END;
/

*/

