--This is the SQL Script to run the code_examples for Lesson 8

--Uncomment the code below to execute the code on slide 13_sa

/*
SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30;
  v_empno employees.employee_id%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp_cursor;
  FETCH c_emp_cursor INTO v_empno, v_lname;
  DBMS_OUTPUT.PUT_LINE( v_empno ||'  '||v_lname);  
END;
/
*/

--Uncomment the code below to execute the code on slide 14_sa

/*
SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30;
  v_empno employees.employee_id%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
    FETCH c_emp_cursor INTO v_empno, v_lname;
    EXIT WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_empno ||'  '||v_lname);  
  END LOOP;
END;
/
*/

--Uncomment the code below to execute the code on slide 16_sa

/*
SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor IS
    SELECT employee_id, last_name FROM employees WHERE department_id =30;
    v_emp_record c_emp_cursor%ROWTYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
    FETCH c_emp_cursor INTO v_emp_record;
    EXIT WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_emp_record.employee_id ||' '||v_emp_record.last_name);
  END LOOP;
  CLOSE c_emp_cursor;
END;
/
*/

--Uncomment the code below to execute the code on slide 18_sa

/*
SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30;
 
BEGIN
   FOR emp_record IN c_emp_cursor 
     LOOP
       DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' '||emp_record.last_name);   
     END LOOP; 
END;
/
*/

--Uncomment the code below to execute the code on slide 21_sa
/*

SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor IS SELECT employee_id, 
    last_name FROM employees;
  v_emp_record	c_emp_cursor%ROWTYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
   FETCH c_emp_cursor INTO v_emp_record;
   EXIT WHEN c_emp_cursor%ROWCOUNT > 10 OR  
                     c_emp_cursor%NOTFOUND;        
   DBMS_OUTPUT.PUT_LINE( v_emp_record.employee_id 
               ||' '||v_emp_record.last_name);
  END LOOP;
  CLOSE c_emp_cursor;
END ;
/
*/

--Uncomment the code below to execute the code on slide 22_sa
/*

SET SERVEROUTPUT ON

BEGIN
  FOR emp_record IN (SELECT employee_id, last_name FROM employees
  WHERE department_id =30)
  LOOP
   DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' '||emp_record.last_name);   
  END LOOP; 
END;
/
*/

--Uncomment the code below to execute the code on slide 25_sa
/*

SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp_cursor (deptno NUMBER)
  IS
     SELECT employee_id, last_name FROM employees WHERE department_id = deptno;
  
  v_empno employees.employee_id%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp_cursor (30);
  LOOP
    FETCH c_emp_cursor INTO v_empno, v_lname;
    EXIT  WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_empno ||' '||v_lname);
  END LOOP;
  CLOSE c_emp_cursor;
  DBMS_OUTPUT.PUT_LINE('Opening the cursor the second time');
  OPEN c_emp_cursor (10);
  LOOP
    FETCH c_emp_cursor INTO v_empno, v_lname;
    EXIT  WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_empno ||' '||v_lname);
  END LOOP;
END;
/
*/
--Uncomment the code below to execute the code on slide 30_sa

/*
SET SERVEROUTPUT ON;
DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, salary FROM employees
   WHERE department_id =30 FOR UPDATE;
 
BEGIN
   FOR emp_record IN c_emp_cursor 
     LOOP
       DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' '||emp_record.salary);   
       UPDATE employees 
       SET salary = 5000
       WHERE CURRENT OF c_emp_cursor; 
     END LOOP; 
END;
/
SELECT employee_id, salary FROM employees
   WHERE department_id =30;
Rollback;
 */  
   