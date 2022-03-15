--This is the SQL Script to run the code_examples for Lesson 4
--Use OE as the default connection if the connection name is not mentioned.

-- Using Collection in PL/SQL Block Example
-- The types TYP_PROJECT  and  TYPE_PROJECTLIST are already present in the OE schema
--Uncomment the code below to execute the code on slide 04_06sa

CREATE OR REPLACE PACKAGE manage_dept_proj
AS
  PROCEDURE allocate_new_proj_list
    (p_dept_id NUMBER, p_name VARCHAR2, p_budget NUMBER);
  FUNCTION get_dept_project (p_dept_id NUMBER)
    RETURN typ_projectlist;
  PROCEDURE update_a_project 
    (p_deptno NUMBER, p_new_project typ_Project,
     p_position NUMBER);
  FUNCTION manipulate_project (p_dept_id NUMBER)
    RETURN typ_projectlist;
  FUNCTION check_costs (p_project_list typ_projectlist)
    RETURN boolean;
END manage_dept_proj;
/

--Uncomment the code below to execute the code on slide 04_07na,04_08na

CREATE OR REPLACE PACKAGE BODY manage_dept_proj
AS
  PROCEDURE allocate_new_proj_list
    (p_dept_id NUMBER, p_name VARCHAR2, p_budget NUMBER)
  IS
    v_accounting_project typ_projectlist; 
  BEGIN   -- this example uses a constructor
    v_accounting_project :=
      typ_ProjectList
        (typ_Project (1, 'Dsgn New Expense Rpt', 3250),
         typ_Project (2, 'Outsource Payroll', 12350),
         typ_Project (3, 'Audit Accounts Payable',1425));
    INSERT INTO department VALUES
      (p_dept_id, p_name, p_budget, v_accounting_project);
  END allocate_new_proj_list;

  FUNCTION get_dept_project (p_dept_id NUMBER)
    RETURN typ_projectlist
  IS
    v_accounting_project typ_projectlist;
  BEGIN
   -- this example uses a fetch from the database
     SELECT  projects
       INTO  v_accounting_project
       FROM  department
       WHERE dept_id = p_dept_id;
     RETURN v_accounting_project;
  END get_dept_project;

PROCEDURE update_a_project 
    (p_deptno NUMBER, p_new_project typ_Project, 
     p_position NUMBER)
  IS
     v_my_projects typ_ProjectList;
  BEGIN
    v_my_projects := get_dept_project (p_deptno);
    v_my_projects.EXTEND;   --make room for new project
    -- Move varray elements forward 
    FOR i IN REVERSE p_position..v_my_projects.LAST - 1 LOOP
      v_my_projects(i + 1) := v_my_projects(i);
    END LOOP;
    v_my_projects(p_position) := p_new_project; -- add new
                                                -- project
    UPDATE department SET projects = v_my_projects
      WHERE dept_id = p_deptno;
  END update_a_project;
  
  FUNCTION manipulate_project (p_dept_id NUMBER)
    RETURN typ_projectlist
  IS
    v_accounting_project typ_projectlist;
    v_changed_list typ_projectlist;
  BEGIN
    SELECT  projects
       INTO  v_accounting_project
       FROM  department
       WHERE dept_id = p_dept_id; 
  -- this example assigns one collection to another
    v_changed_list := v_accounting_project;
    RETURN v_changed_list;
  END manipulate_project;

  FUNCTION check_costs (p_project_list typ_projectlist)
    RETURN boolean
  IS
    c_max_allowed        NUMBER := 10000000;
    i                    INTEGER;
    v_flag               BOOLEAN := FALSE;
  BEGIN
    i := p_project_list.FIRST ; 
    WHILE i IS NOT NULL LOOP
      IF p_project_list(i).cost > c_max_allowed then
        v_flag := TRUE;
        dbms_output.put_line (p_project_list(i).title ||
                         ' exceeded allowable budget.');
        RETURN TRUE;
      END IF;
    i := p_project_list.NEXT(i); 
    END LOOP;
    RETURN null;
  END check_costs;

END manage_dept_proj;
/

-- No Need to run these individual blocks as these are part of the above Package
--Uncomment the code below to execute the code on slide 04_10sa 

/*

-- this is a code snippet from the manage_dept_proj shown on pages 7 and 8. 
-- this code is not complete and it won't compile. Run the code from the step 04_07na instead.

CREATE OR REPLACE PROCEDURE allocate_new_proj_list
    (p_dept_id NUMBER, p_name VARCHAR2, p_budget NUMBER)
IS
    v_accounting_project typ_projectlist; 
BEGIN
  -- this example uses a constructor
  v_accounting_project :=
    typ_ProjectList
      (typ_Project (1, 'Dsgn New Expense Rpt', 3250),
       typ_Project (2, 'Outsource Payroll', 12350),
       typ_Project (3, 'Audit Accounts Payable',1425));
  INSERT INTO department
    VALUES(p_dept_id, p_name, p_budget, v_accounting_project);
END allocate_new_proj_list;

*/

--Uncomment the code below to execute the code on slide 04_11sa 

/*

-- this is a code snippet from the manage_dept_proj shown on the notes pages 4-7 and 4-8. 
-- this code is not complete and it won't compile. Run the code on step 04_07na instead.

FUNCTION get_dept_project (p_dept_id NUMBER)
    RETURN typ_projectlist
  IS
    v_accounting_project typ_projectlist;
  BEGIN  -- this example uses a fetch from the database
     SELECT  projects INTO  v_accounting_project
       FROM  department WHERE dept_id = p_dept_id;
     RETURN v_accounting_project;
  END get_dept_project;

*/

--Uncomment the code below to execute the code on slide 04_11sb

/*

-- this is a code snippet from the manage_dept_proj shown on the notes pages 4-7 and 4-8. 
-- this code is not complete and it won't compile. Run the code on step 04-07na instead.

FUNCTION manipulate_project (p_dept_id NUMBER)
    RETURN typ_projectlist
  IS
    v_accounting_project typ_projectlist;
    v_changed_list typ_projectlist;
  BEGIN
    SELECT  projects INTO  v_accounting_project
       FROM  department WHERE dept_id = p_dept_id; 
  -- this example assigns one collection to another
    v_changed_list := v_accounting_project;
    RETURN v_changed_list;
  END manipulate_project;

*/

-- Test the Package
--Uncomment the code below to execute the code on slide 04_12sa 
-- sample caller program to the manipulate_project function

-- Pre-Output
set SERVEROUTPUT ON
DECLARE
  v_result_list typ_projectlist;
BEGIN
  v_result_list := manage_dept_proj.manipulate_project(10);
  DBMS_OUTPUT.PUT_LINE(v_result_list.count); --2
  FOR i IN 1..v_result_list.COUNT LOOP
    dbms_output.put_line('Project #: ' 
                                  ||v_result_list(i).project_no);
    dbms_output.put_line('Title: '||v_result_list(i).title);
    dbms_output.put_line('Cost: ' ||v_result_list(i).cost);
  END LOOP;

END;
/

/*
Output:
Project #: 1001
Title: Travel Monitor
Cost: 400000
Project #: 1002
Title: Open World
Cost: 10000000
*/

--Uncomment the code below to execute the code on slide 04_14sa 
/*

-- this is a code snippet from the manage_dept_proj shown on the notes pages 4-7 and 4-8. 
-- this code is not complete and it won't compile. Run the code in step 04-07na instead.

FUNCTION check_costs (p_project_list typ_projectlist)
    RETURN boolean
  IS
    c_max_allowed        NUMBER := 10000000;
    i                    INTEGER;
    v_flag               BOOLEAN := FALSE;
  BEGIN
    i := p_project_list.FIRST ; 
    WHILE i IS NOT NULL LOOP
      IF p_project_list(i).cost > c_max_allowed then
        v_flag := TRUE;
        dbms_output.put_line (p_project_list(i).title || ' 
                              exceeded allowable budget.');
        RETURN TRUE;
      END IF;
    i := p_project_list.NEXT(i); 
    END LOOP;
    RETURN null;
  END check_costs;
*/

--Uncomment the code below to execute the code on slide 04_15sa

-- sample caller program to check_costs
set serveroutput on
DECLARE
  v_project_list typ_projectlist;
BEGIN
  v_project_list := typ_ProjectList(
    typ_Project (1,'Dsgn New Expense Rpt', 3250),
    typ_Project (2, 'Outsource Payroll', 120000),
    typ_Project (3, 'Audit Accounts Payable',14250000));
  IF manage_dept_proj.check_costs(v_project_list) THEN
    dbms_output.put_line('Atleast one project exceeded budget');
  ELSE
    dbms_output.put_line('All projects accepted, fill out forms.');
  END IF;
END;
/

/*
output:
Audit Accounts Payable exceeded allowable budget.
Atleast one project exceeded budget
*/

--Uncomment the code below to execute the code on slide 04_16sa 

/*

-- this is a code snippet from the manage_dept_proj shown on the notes pages 4-7 and 4-8
-- this code is not complete and it won't compile. Run the code in step 04-07na instead.

PROCEDURE update_a_project 
    (p_deptno NUMBER, p_new_project typ_Project, p_position NUMBER)
  IS
     v_my_projects typ_ProjectList;
  BEGIN
    v_my_projects := get_dept_project (p_deptno);
    v_my_projects.EXTEND;   --make room for new project
    --Move varray elements forward 
    FOR i IN REVERSE p_position..v_my_projects.LAST - 1 LOOP
      v_my_projects(i + 1) := v_my_projects(i);
    END LOOP;
    v_my_projects(p_position) := p_new_project; -- insert new one
   UPDATE department SET projects = v_my_projects
     WHERE dept_id = p_deptno;
  END update_a_project;

*/

--Uncomment the code below to execute the code on slide 04_17sa 


-- check the table prior to the update:
SELECT d2.dept_id, d2.name, d1.*
FROM department d2, TABLE(d2.projects) d1;

/*
Output:

   DEPT_ID NAME                      PROJECT_NO TITLE                                     COST
---------- ------------------------- ---------- ----------------------------------- ----------
        10 Executive Administration        1001 Travel Monitor                          400000
        10 Executive Administration        1002 Open World                            10000000
        20 Information Technology          2001 DB11gR2                                 900000
*/

-- Add a new project
--Uncomment the code below to execute the code on slide 04_17sb
-- caller program to update_a_project
BEGIN
  manage_dept_proj.update_a_project(20,
    typ_Project(2002, 'AQM', 80000), 2);
END;
/

--Uncomment the code below to execute the code on slide 04_17sc
-- check the table after the update:
SELECT d2.dept_id, d2.name, d1.*
FROM department d2, TABLE(d2.projects) d1;

/*
output:

   DEPT_ID NAME                      PROJECT_NO TITLE                                     COST
---------- ------------------------- ---------- ----------------------------------- ----------
        10 Executive Administration        1001 Travel Monitor                          400000
        10 Executive Administration        1002 Open World                            10000000
        20 Information Technology          2001 DB11gR2                                 900000
        20 Information Technology          2002 AQM                                      80000
*/

--Uncomment the code below to execute the code on slide 04_17na 

BEGIN
  manage_dept_proj.update_a_project(20,
    typ_Project(2003, 'CQN', 85000), 2);
END;

--Uncomment the code below to execute the code on slide 04_20na 

DROP TYPE EMP_TYPE;
DROP TYPE EMP_TYPE_LIST;
CREATE OR REPLACE TYPE EMP_TYPE AS OBJECT
(
DEPARTMENT_ID NUMBER(6),
LAST_NAME VARCHAR2(25),
SALARY NUMBER(8,2),
JOB_ID VARCHAR2(25),
JOB_TITLE VARCHAR2(30));

/
CREATE OR REPLACE TYPE EMP_TYPE_LIST AS TABLE OF EMP_TYPE;
/
CREATE OR REPLACE function GET_EMPS(P_JOB_ID JOBS.JOB_ID%TYPE)
RETURN EMP_TYPE_LIST 
IS 
EMPS EMP_TYPE_LIST:=EMP_TYPE_LIST();
R EMP_TYPE:=EMP_TYPE(NULL,NULL,NULL,NULL,NULL); --Constructor call
i pls_integer:=0;
CURSOR C_EMP(C_JOB_ID JOBS.JOB_ID%TYPE) IS
SELECT DEPARTMENT_ID,LAST_NAME,SALARY,J.JOB_ID,JOB_TITLE FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID=J.JOB_ID AND J.JOB_ID=C_JOB_ID;
BEGIN
OPEN C_EMP(P_JOB_ID);
LOOP
FETCH C_EMP INTO R.DEPARTMENT_ID,R.LAST_NAME,R.SALARY,R.JOB_ID,R.JOB_TITLE;
EXIT WHEN C_EMP%NOTFOUND;
i:=i+1;
emps.extend;
EMPS(I):=R;
END LOOP;
RETURN EMPS;
END;
/

SELECT * FROM TABLE(GET_EMPS('IT_PROG'));
/

/*
output:
DEPARTMENT_ID LAST_NAME                     SALARY JOB_ID                    JOB_TITLE                     
------------- ------------------------- ---------- ------------------------- ------------------------------
           60 Hunold                          9000 IT_PROG                   Programmer                    
           60 Ernst                           6000 IT_PROG                   Programmer                    
           60 Austin                          4800 IT_PROG                   Programmer                    
           60 Pataballa                       4800 IT_PROG                   Programmer                    
           60 Lorentz                         4200 IT_PROG                   Programmer                    
*/

SELECT D.DEPARTMENT_NAME,E.*
FROM TABLE(get_emps('IT_PROG')) E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID;
/

/*
DEPARTMENT_NAME                DEPARTMENT_ID LAST_NAME                     SALARY JOB_ID                    JOB_TITLE                     
------------------------------ ------------- ------------------------- ---------- ------------------------- ------------------------------
IT                                        60 Hunold                          9000 IT_PROG                   Programmer                    
IT                                        60 Ernst                           6000 IT_PROG                   Programmer                    
IT                                        60 Austin                          4800 IT_PROG                   Programmer                    
IT                                        60 Pataballa                       4800 IT_PROG                   Programmer                    
IT                                        60 Lorentz                         4200 IT_PROG                   Programmer                    
*/

--Uncomment the code below to execute the code on slide 04_28sa 

CREATE OR REPLACE FUNCTION uc_last_name ( 
   employee_id_in   IN employees.employee_id%TYPE, 
   upper_in         IN BOOLEAN) 
   RETURN employees.last_name%TYPE 
IS 
   l_return   employees.last_name%TYPE; 
BEGIN 
   SELECT last_name 
     INTO l_return 
     FROM employees 
    WHERE employee_id = employee_id_in; 
 
   RETURN CASE WHEN upper_in THEN UPPER (l_return) ELSE l_return END; 
END; 
/

--Uncomment the code below to execute the code on slide 04_29sa 
DECLARE
   b BOOLEAN := TRUE;
BEGIN 
   FOR rec IN (SELECT uc_last_name (employee_id, b) lname 
                 FROM employees 
                WHERE department_id = 10) 
   LOOP 
      DBMS_OUTPUT.put_line (rec.lname); 
   END LOOP; 
END; 
/
--WHALEN

--Uncomment the code below to execute the code on slide 04_29na and 04_30na
--This is additional code to demonstrate passing record parameters in a package function

-- Example of Bind types
CREATE OR REPLACE PACKAGE names_pkg
   AUTHID CURRENT_USER
AS
   TYPE names_t 
   IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   PROCEDURE display_names (
      names_in   IN names_t);
END names_pkg;
/

CREATE OR REPLACE PACKAGE BODY names_pkg
AS
   PROCEDURE display_names (
      names_in   IN names_t)
   IS
   BEGIN
      FOR indx IN 1 .. names_in.COUNT
      LOOP
         DBMS_OUTPUT.put_line (
            names_in (indx));
      END LOOP;
   END;
END names_pkg;
/

DECLARE
   l_names   names_pkg.names_t;
BEGIN
   l_names (1) := 'Loey';
   l_names (2) := 'Dylan';
   l_names (3) := 'Indigo';
   l_names (4) := 'Saul';
   l_names (5) := 'Sally';

   EXECUTE IMMEDIATE
      'BEGIN names_pkg.display_names (:names); END;'
      USING l_names;

   FOR rec
      IN (SELECT * FROM TABLE (l_names))
   LOOP
      DBMS_OUTPUT.put_line (
         rec.COLUMN_VALUE);
   END LOOP;
END;
/ 

/*
Loey
Dylan
Indigo
Saul
Sally
Loey
Dylan
Indigo
Saul
Sally
*/