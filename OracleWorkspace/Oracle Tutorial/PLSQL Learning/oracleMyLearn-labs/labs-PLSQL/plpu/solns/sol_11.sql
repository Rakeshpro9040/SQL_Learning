--The SQL Script to run the solution for Practice 20
--Run cleanup_20.sql script from /home/oracle/labs/plpu/code_ex/cleanup_scripts directory before executing the solutions.
--Uncomment code below to run the solution for Task 1_a of Practice 20

/*

CREATE OR REPLACE PACKAGE emp_pkg IS

  TYPE emp_tab_type IS TABLE OF employees%ROWTYPE;

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30);

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE);

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE);

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype;
  
  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype;

  PROCEDURE get_employees(p_dept_id employees.department_id%type);

  PROCEDURE init_departments;

  PROCEDURE print_employee(p_rec_emp employees%rowtype);

END emp_pkg;
/
SHOW ERRORS

*/

--Uncomment code below to run the solution for Task 1_b of Practice 20

/*

CREATE OR REPLACE PACKAGE BODY emp_pkg IS
  TYPE boolean_tab_type IS TABLE OF BOOLEAN
     INDEX BY BINARY_INTEGER;
  valid_departments boolean_tab_type;
  emp_table         emp_tab_type;

FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE) RETURN BOOLEAN IS 
    v_dummy PLS_INTEGER; 
  BEGIN 
    RETURN valid_departments.exists(p_deptid);  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    RETURN FALSE; 
END valid_deptid; 

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30) IS 
  BEGIN 
    IF valid_deptid(p_deptid) THEN 

      INSERT INTO employees(employee_id, first_name, last_name, email, 
        job_id, manager_id, hire_date, salary, commission_pct, department_id) 
      VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_email, 
        p_job, p_mgr, TRUNC(SYSDATE), p_sal, p_comm, p_deptid); 
    ELSE 
      RAISE_APPLICATION_ERROR (-20204, 'Invalid department ID. Try again.'); 
    END IF; 
  END add_employee; 
  
  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE) IS
    p_email employees.email%type;
  BEGIN
    p_email := UPPER(SUBSTR(p_first_name, 1, 1)||SUBSTR(p_last_name, 1, 7));
    add_employee(p_first_name, p_last_name, p_email, p_deptid => p_deptid);
  END;

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE) IS 
  BEGIN 
    SELECT salary, job_id 
    INTO p_sal, p_job 
    FROM employees 
    WHERE employee_id = p_empid; 
  END get_employee; 

FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE employee_id = p_emp_id;
    RETURN rec_emp;
  END;

  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype IS
    
rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE last_name = p_family_name;
    RETURN rec_emp;  
END;

-- New get_employees procedure. 

PROCEDURE get_employees(p_dept_id employees.department_id%type) IS
  BEGIN
    SELECT * BULK COLLECT INTO emp_table
    FROM EMPLOYEES
    WHERE department_id = p_dept_id;
  END;

PROCEDURE init_departments IS
  BEGIN
    FOR rec IN (SELECT department_id FROM departments)
    LOOP
      valid_departments(rec.department_id) := TRUE;
    END LOOP;
  END;

PROCEDURE print_employee(p_rec_emp employees%rowtype) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_rec_emp.department_id ||' '|| 
                         p_rec_emp.employee_id||' '||
                         p_rec_emp.first_name||' '||
                         p_rec_emp.last_name||' '||
                         p_rec_emp.job_id||' '||
                         p_rec_emp.salary);
  END;



BEGIN
  init_departments;

END emp_pkg;
/
SHOW ERRORS

*/

--Uncomment code below to run the solution for Task 1_c of Practice 20

/*

-- Package SPECIFICATION

CREATE OR REPLACE PACKAGE emp_pkg IS
  TYPE emp_tab_type IS TABLE OF employees%ROWTYPE;

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30);

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE);

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE);

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype;
  
  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype;

  PROCEDURE get_employees(p_dept_id employees.department_id%type);

  PROCEDURE init_departments;

  PROCEDURE print_employee(p_rec_emp employees%rowtype);

  PROCEDURE show_employees;

END emp_pkg;
/
SHOW ERRORS

-- Package BODY

CREATE OR REPLACE PACKAGE BODY emp_pkg IS
  TYPE boolean_tab_type IS TABLE OF BOOLEAN
     INDEX BY BINARY_INTEGER;
  
  valid_departments boolean_tab_type;
  emp_table         emp_tab_type;
  FUNCTION valid_deptid(p_deptid IN    
   departments.department_id%TYPE)
    RETURN BOOLEAN; 

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30) IS 
  BEGIN 
    IF valid_deptid(p_deptid) THEN 
      INSERT INTO employees(employee_id, first_name, last_name, email, 
        job_id, manager_id, hire_date, salary, commission_pct, department_id) 
      VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_email, 
        p_job, p_mgr, TRUNC(SYSDATE), p_sal, p_comm, p_deptid); 
    ELSE 
      RAISE_APPLICATION_ERROR (-20204, 'Invalid department ID. Try again.'); 
    END IF; 
  END add_employee; 
  
  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE) IS
    p_email employees.email%type;
  BEGIN
    p_email := UPPER(SUBSTR(p_first_name, 1, 1)||SUBSTR(p_last_name, 1, 7));
    add_employee(p_first_name, p_last_name, p_email, p_deptid => p_deptid);
  END;

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE) IS 
  BEGIN 
    SELECT salary, job_id 
    INTO p_sal, p_job 
    FROM employees 
    WHERE employee_id = p_empid; 
  END get_employee; 

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE employee_id = p_emp_id;
    RETURN rec_emp;
  END;

  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE last_name = p_family_name;
    RETURN rec_emp;
  END;

  PROCEDURE get_employees(p_dept_id employees.department_id%type) IS
  BEGIN
    SELECT * BULK COLLECT INTO emp_table
    FROM EMPLOYEES
    WHERE department_id = p_dept_id;
  END;

  PROCEDURE init_departments IS
  BEGIN
    FOR rec IN (SELECT department_id FROM departments)
    LOOP
      valid_departments(rec.department_id) := TRUE;
    END LOOP;
  END;

  PROCEDURE print_employee(p_rec_emp employees%rowtype) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_rec_emp.department_id ||' '|| 
                         p_rec_emp.employee_id||' '||
                         p_rec_emp.first_name||' '||
                         p_rec_emp.last_name||' '||
                         p_rec_emp.job_id||' '||
                         p_rec_emp.salary);
  END;

  PROCEDURE show_employees IS
  BEGIN
    IF emp_table IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Employees in Package table');
      FOR i IN 1 .. emp_table.COUNT
      LOOP
        print_employee(emp_table(i));
      END LOOP;
    END IF;
  END show_employees;

  FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE) 
   RETURN BOOLEAN IS 
    v_dummy PLS_INTEGER; 
  BEGIN 
    RETURN valid_departments.exists(p_deptid);  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    RETURN FALSE; 
END valid_deptid; 


BEGIN
  init_departments;
END emp_pkg;

/
SHOW ERRORS


*/

--Uncomment code below to run the solution for Task 1_d of Practice 20

/*

SET SERVEROUTPUT ON

EXECUTE emp_pkg.get_employees(30)
EXECUTE emp_pkg.show_employees

EXECUTE emp_pkg.get_employees(60)
EXECUTE emp_pkg.show_employees


*/

--Uncomment code below to run the solution for Task 2_a of Practice 20

/*

CREATE TABLE log_newemp (
  entry_id  NUMBER(6) CONSTRAINT log_newemp_pk PRIMARY KEY,
  user_id   VARCHAR2(30),
  log_time  DATE,
  name      VARCHAR2(60)
);

CREATE SEQUENCE log_newemp_seq;



*/

--Uncomment code below to run the solution for Task 2_b of Practice 20

/*

-- Package SPECIFICATION

CREATE OR REPLACE PACKAGE emp_pkg IS


  TYPE emp_tab_type IS TABLE OF employees%ROWTYPE;

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30);

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE);

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE);

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype;
  
  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype;

  PROCEDURE get_employees(p_dept_id employees.department_id%type);

  PROCEDURE init_departments;

  PROCEDURE print_employee(p_rec_emp employees%rowtype);

  PROCEDURE show_employees;

END emp_pkg;
/
SHOW ERRORS


-- Package BODY

CREATE OR REPLACE PACKAGE BODY emp_pkg IS
  TYPE boolean_tab_type IS TABLE OF BOOLEAN
     INDEX BY BINARY_INTEGER;
  
  valid_departments boolean_tab_type;
  emp_table         emp_tab_type;

  FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE)
    RETURN BOOLEAN; 

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30) IS 
 
-- New local procedure

    PROCEDURE audit_newemp IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      user_id VARCHAR2(30) := USER;
    BEGIN
      INSERT INTO log_newemp (entry_id, user_id, log_time, 
                              name)
      VALUES (log_newemp_seq.NEXTVAL, user_id, 
              sysdate,p_first_name||' '||p_last_name);
      COMMIT;
    END audit_newemp;  

  BEGIN -- add_employee
    IF valid_deptid(p_deptid) THEN 
      INSERT INTO employees(employee_id, first_name, last_name, email, 
        job_id, manager_id, hire_date, salary, commission_pct, department_id) 
      VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_email, 
        p_job, p_mgr, TRUNC(SYSDATE), p_sal, p_comm, p_deptid); 
    ELSE 
      RAISE_APPLICATION_ERROR (-20204, 'Invalid department ID. Try again.'); 
    END IF; 
  END add_employee; 
  
  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE) IS
    p_email employees.email%type;
  BEGIN
    p_email := UPPER(SUBSTR(p_first_name, 1, 1)||SUBSTR(p_last_name, 1, 7));
    add_employee(p_first_name, p_last_name, p_email, p_deptid => p_deptid);
  END;

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE) IS 
  BEGIN 
    SELECT salary, job_id 
    INTO p_sal, p_job 
    FROM employees 
    WHERE employee_id = p_empid; 
  END get_employee; 

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE employee_id = p_emp_id;
    RETURN rec_emp;
  END;

  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE last_name = p_family_name;
    RETURN rec_emp;
  END;

--New get_employees procedure. 

  PROCEDURE get_employees(p_dept_id employees.department_id%type) IS
  BEGIN
    SELECT * BULK COLLECT INTO emp_table
    FROM EMPLOYEES
    WHERE department_id = p_dept_id;
  END;

  PROCEDURE init_departments IS
  BEGIN
    FOR rec IN (SELECT department_id FROM departments)
    LOOP
      valid_departments(rec.department_id) := TRUE;
    END LOOP;
  END;

  PROCEDURE print_employee(p_rec_emp employees%rowtype) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_rec_emp.department_id ||' '|| 
                         p_rec_emp.employee_id||' '||
                         p_rec_emp.first_name||' '||
                         p_rec_emp.last_name||' '||
                         p_rec_emp.job_id||' '||
                         p_rec_emp.salary);
  END;

  PROCEDURE show_employees IS
  BEGIN
    IF emp_table IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Employees in Package table');
      FOR i IN 1 .. emp_table.COUNT
      LOOP
        print_employee(emp_table(i));
      END LOOP;
    END IF;
  END show_employees;

  FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE) 
   RETURN BOOLEAN IS 
    v_dummy PLS_INTEGER; 
  BEGIN 
    RETURN valid_departments.exists(p_deptid);  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    RETURN FALSE; 
END valid_deptid; 


BEGIN
  init_departments;
END emp_pkg;
/
SHOW ERRORS

*/

--Uncomment code below to run the solution for Task 2_c of Practice 20

/*

-- Package SPECIFICATION

CREATE OR REPLACE PACKAGE emp_pkg IS


  TYPE emp_tab_type IS TABLE OF employees%ROWTYPE;

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30);

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE);

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE);

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype;
  
  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype;

  PROCEDURE get_employees(p_dept_id employees.department_id%type);

  PROCEDURE init_departments;

  PROCEDURE print_employee(p_rec_emp employees%rowtype);

  PROCEDURE show_employees;

END emp_pkg;
/
SHOW ERRORS

-- Package BODY

CREATE OR REPLACE PACKAGE BODY emp_pkg IS
  TYPE boolean_tab_type IS TABLE OF BOOLEAN
     INDEX BY BINARY_INTEGER;
  
  valid_departments boolean_tab_type;
  emp_table         emp_tab_type;

  FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE)
    RETURN BOOLEAN; 

  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_email employees.email%TYPE, 
    p_job employees.job_id%TYPE DEFAULT 'SA_REP', 
    p_mgr employees.manager_id%TYPE DEFAULT 145, 
    p_sal employees.salary%TYPE DEFAULT 1000, 
    p_comm employees.commission_pct%TYPE DEFAULT 0, 
    p_deptid employees.department_id%TYPE DEFAULT 30) IS 
 
    PROCEDURE audit_newemp IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      user_id VARCHAR2(30) := USER;
    BEGIN
      INSERT INTO log_newemp (entry_id, user_id, log_time, name)
      VALUES (log_newemp_seq.NEXTVAL, user_id, sysdate,p_first_name||' '||p_last_name);
      COMMIT;
    END audit_newemp;  

  BEGIN -- add_employee
    IF valid_deptid(p_deptid) THEN 
      audit_newemp;
      INSERT INTO employees(employee_id, first_name, last_name, email, 
        job_id, manager_id, hire_date, salary, commission_pct, department_id) 
      VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_email, 
        p_job, p_mgr, TRUNC(SYSDATE), p_sal, p_comm, p_deptid); 
    ELSE 
      RAISE_APPLICATION_ERROR (-20204, 'Invalid department ID. Try again.'); 
    END IF; 
  END add_employee; 
  
  PROCEDURE add_employee( 
    p_first_name employees.first_name%TYPE, 
    p_last_name employees.last_name%TYPE, 
    p_deptid employees.department_id%TYPE) IS
    p_email employees.email%type;
  BEGIN
    p_email := UPPER(SUBSTR(p_first_name, 1, 1)||SUBSTR(p_last_name, 1, 7));
    add_employee(p_first_name, p_last_name, p_email, p_deptid => p_deptid);
  END;

  PROCEDURE get_employee(
    p_empid IN employees.employee_id%TYPE, 
    p_sal OUT employees.salary%TYPE, 
    p_job OUT employees.job_id%TYPE) IS 
  BEGIN 
    SELECT salary, job_id 
    INTO p_sal, p_job 
    FROM employees 
    WHERE employee_id = p_empid; 
  END get_employee; 

  FUNCTION get_employee(p_emp_id employees.employee_id%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE employee_id = p_emp_id;
    RETURN rec_emp;
  END;

  FUNCTION get_employee(p_family_name employees.last_name%type)
    return employees%rowtype IS
    rec_emp employees%rowtype;
  BEGIN
    SELECT * INTO rec_emp
    FROM employees
    WHERE last_name = p_family_name;
    RETURN rec_emp;
  
END;

  PROCEDURE get_employees(p_dept_id employees.department_id%type) IS
  BEGIN
    SELECT * BULK COLLECT INTO emp_table
    FROM EMPLOYEES
    WHERE department_id = p_dept_id;
  END;

  PROCEDURE init_departments IS
  BEGIN
    FOR rec IN (SELECT department_id FROM departments)
    LOOP
      valid_departments(rec.department_id) := TRUE;
    END LOOP;
  END;

  PROCEDURE print_employee(p_rec_emp employees%rowtype) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_rec_emp.department_id ||' '|| 
                         p_rec_emp.employee_id||' '||
                         p_rec_emp.first_name||' '||
                         p_rec_emp.last_name||' '||
                         p_rec_emp.job_id||' '||
                         p_rec_emp.salary);
  END;

  PROCEDURE show_employees IS
  BEGIN
    IF emp_table IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Employees in Package table');
      FOR i IN 1 .. emp_table.COUNT
      LOOP
        print_employee(emp_table(i));
      END LOOP;
    END IF;
  END show_employees;

  FUNCTION valid_deptid(p_deptid IN departments.department_id%TYPE) 
   RETURN BOOLEAN IS 
    v_dummy PLS_INTEGER; 
  BEGIN 
    RETURN valid_departments.exists(p_deptid);  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 

    RETURN FALSE; 
END valid_deptid; 
BEGIN
  init_departments;
END emp_pkg;
/
SHOW ERRORS

*/

--Uncomment code below to run the solution for Task 2_d of Practice 20

/*

EXECUTE emp_pkg.add_employee('Max', 'Smart', 20)
EXECUTE emp_pkg.add_employee('Clark', 'Kent', 10)
*/

--Uncomment code below to run the solution for Task 2_e of Practice 20

/*

select department_id, employee_id, last_name, first_name
from employees
where last_name in ('Kent', 'Smart');

select * from log_newemp;



*/

--Uncomment code below to run the solution for Task 2_f of Practice 20

/*
 ROLLBACK;
 select * from log_newemp;


*/

