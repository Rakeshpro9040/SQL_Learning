--This is the SQL Script to run the code_examples for Lesson 12

--Uncomment the code below to execute the code on slide 11_sa 
/*

CREATE OR REPLACE FUNCTION get_sal
 (p_id  employees.employee_id%TYPE) RETURN NUMBER IS

v_sal employees.salary%TYPE := 0;

BEGIN
  SELECT salary
  INTO   v_sal
  FROM   employees         
  WHERE  employee_id = p_id;
  RETURN v_sal;
END get_sal;
/

*/

--Uncomment the code below to execute the code on slide 11_sb 
-- You must run the code under slide 11_sa before running this code example. 
/*

SET SERVEROUTPUT ON

EXECUTE DBMS_OUTPUT.PUT_LINE(get_sal(100))

*/

--Uncomment the code below to execute the code on slide 12_sa 
-- You must run the code under slide 11_sa before running this code example. 

/*
VARIABLE b_salary NUMBER
EXECUTE :b_salary := get_sal(100)
PRINT b_salary

*/
-- Uncomment the code below to execute the code on slide 12_sb 
-- You must run the code under slide 11_sa before running this code example. 
/*

SET SERVEROUTPUT ON

DECLARE
  sal employees.salary%type;
BEGIN
  sal := get_sal(100);
  DBMS_OUTPUT.PUT_LINE('The salary is: '|| sal);
END;
/

*/

--Uncomment the code below to execute the code on slide 13_sa 
-- You must run the code under slide 11_sa before running this code example. 
/*
SET SERVEROUTPUT ON

EXECUTE DBMS_OUTPUT.PUT_LINE(get_sal(100))

*/

--Uncomment the code below to execute the code on slide 13_sb 
-- You must run the code under slide 08_sa before running this code example.

/*
SELECT job_id, get_sal(employee_id)
FROM employees
WHERE department_id = 60;

*/
--Uncomment the code below to execute the code on slide 16_sa 
/*
CREATE OR REPLACE FUNCTION tax(p_id IN employees.employee_id%type)
 RETURN NUMBER IS
 v_sal employees.salary%type;
BEGIN
   select salary into v_sal 
   from employees 
   where employee_id = p_id;
   RETURN (v_sal * 0.08);
END tax;
/

SELECT employee_id, last_name, salary, tax(employee_id)
FROM   employees
WHERE  department_id = 100;
*/

--Uncomment the code below to execute the code on slide 17_na 
-- You must run the code under slide 16_sa before running this code example.
/*

SELECT employee_id, tax(employee_id)
FROM   employees
WHERE  tax(employee_id) > (SELECT MAX(tax(employee_id))
                      FROM employees
                      WHERE department_id = 30)
ORDER BY tax(employee_id) DESC;

*/

--Uncomment the code below to execute the code on slide 20_sa 
/*

CREATE OR REPLACE FUNCTION dml_call_sql(p_sal NUMBER)
   RETURN NUMBER IS
BEGIN
  INSERT INTO employees(employee_id, last_name, email,
                        hire_date, job_id, salary)
  VALUES(1, 'Frost', 'jfrost@company.com',
         SYSDATE, 'SA_MAN', p_sal);
  RETURN (p_sal + 100);
END;
/

*/

--Uncomment the code below to execute the code on slide 20_sb 
-- You must run the code under slide 20_sa before attempting to run this code example.
-- This code example generates an expected error message. 
/*

UPDATE employees
 SET salary = dml_call_sql(2000)
WHERE employee_id = 170;

*/

--Uncomment the code below to execute the code on slide 24_sa
/*
CREATE OR REPLACE FUNCTION tax_new(p_id IN employees.employee_id%type,
p_allowances NUMBER default 500)
 RETURN NUMBER IS
 v_sal employees.salary%type;
BEGIN
   select salary into v_sal 
   from employees 
   where employee_id = p_id;
   v_sal := v_sal-p_allowances;
   RETURN (v_sal * 0.08);
END tax_new;
*/


--Uncomment the code below to execute the code on slide 24_sb 
-- You must run the code under slide 24_sa before attempting to run this code example.
/*
EXECUTE DBMS_OUTPUT.PUT_LINE(tax_new(100));
EXECUTE DBMS_OUTPUT.PUT_LINE(tax_new(100,1500));
EXECUTE DBMS_OUTPUT.PUT_LINE(tax_new(p_allowances =>1500, p_id=>100));
EXECUTE DBMS_OUTPUT.PUT_LINE(tax_new(p_id=>100));

*/

--Uncomment the code below to execute the code on slide 25_sa 
/*
DESCRIBE user_source

*/

--Uncomment the code below to execute the code on slide 25_sb 
/*
SELECT text
FROM   user_source
WHERE  type = 'FUNCTION'
ORDER BY line; 

*/

--Uncomment the code below to execute the code on slide 28_sa 
/*
DROP FUNCTION f;

*/
