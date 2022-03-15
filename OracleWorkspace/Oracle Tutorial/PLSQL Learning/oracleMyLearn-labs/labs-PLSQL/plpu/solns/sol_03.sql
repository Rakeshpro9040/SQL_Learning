--The SQL Script to run the solution for Practice 12

--Run cleanup_12.sql script from /home/oracle/labs/plpu/code_ex/cleanup_scripts directory before executing the solutions.
--Uncomment code below to run the solution for Task 1_a of Practice 12

/*

CREATE OR REPLACE FUNCTION get_job (p_jobid IN jobs.job_id%type)
 RETURN jobs.job_title%type IS
  v_title jobs.job_title%type;
BEGIN
  SELECT job_title
  INTO v_title
  FROM jobs
  WHERE job_id = p_jobid;
  RETURN v_title;
END get_job;
/

*/

--Uncomment code below to run the solution for Task 1_b of Practice 12
/*

VARIABLE b_title VARCHAR2(35)
EXECUTE :b_title := get_job ('SA_REP');
PRINT b_title

*/

--Uncomment code below to run the solution for Task 2_a of Practice 12

/*

CREATE OR REPLACE FUNCTION get_annual_comp(
  p_sal  IN employees.salary%TYPE,
  p_comm IN employees.commission_pct%TYPE)
 RETURN NUMBER IS
BEGIN
  RETURN (NVL(p_sal,0) * 12 + (NVL(p_comm,0) * nvl(p_sal,0) * 12));
END get_annual_comp;
/
*/

--Uncomment code below to run the solution for Task 2_b of Practice 12

/*

SELECT employee_id, last_name,
       get_annual_comp(salary,commission_pct) "Annual Compensation"
FROM   employees
WHERE department_id=30
/
 
*/

--Uncomment code below to run the solution for Task 3_a of Practice 12

/*

CREATE OR REPLACE FUNCTION valid_deptid(
  p_deptid IN departments.department_id%TYPE)
  RETURN BOOLEAN IS
  v_dummy  PLS_INTEGER;

BEGIN
  SELECT  1
  INTO    v_dummy
  FROM    departments
  WHERE   department_id = p_deptid;
  RETURN  TRUE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END valid_deptid;
/

*/

--Uncomment code below to run the solution for Task 3_b of Practice 12

/*

CREATE OR REPLACE PROCEDURE add_employee(
   p_first_name employees.first_name%TYPE,
   p_last_name  employees.last_name%TYPE,
   p_email      employees.email%TYPE,
   p_job        employees.job_id%TYPE         DEFAULT 'SA_REP',
   p_mgr        employees.manager_id%TYPE     DEFAULT 145,
   p_sal        employees.salary%TYPE         DEFAULT 1000,
   p_comm       employees.commission_pct%TYPE DEFAULT 0,
   p_deptid     employees.department_id%TYPE  DEFAULT 30) IS
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
/

*/

--Uncomment code below to run the solution for Task 3_c of Practice 12

/*

 EXECUTE add_employee('Jane', 'Harris', 'JAHARRIS', p_deptid=> 15)

*/

--Uncomment code below to run the solution for Task 3_d of Practice 12

/* 

EXECUTE add_employee('Joe', 'Harris', 'JOHARRIS', p_deptid=> 80)

*/

