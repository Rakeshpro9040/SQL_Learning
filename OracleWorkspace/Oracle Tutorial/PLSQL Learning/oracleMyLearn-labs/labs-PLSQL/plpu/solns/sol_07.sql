--The SQL Script to run the solution for Practice 16
--Run cleanup_16.sql script from /home/oracle/labs/plpu/code_ex/cleanup_scripts directory before executing the solutions.
--Uncomment code below to run the solution for Task 1 of Practice 16

-- The course has a directory alias provided called "REPORTS_DIR" that
-- is associated with the /home/oracle/labs/plpu/reports
-- physical directory. Use the directory alias name
-- in quotes for the first parameter to create a file in the appropriate directory.

/*

CREATE OR REPLACE PROCEDURE employee_report(
  p_dir IN VARCHAR2, p_filename IN VARCHAR2) IS
  f UTL_FILE.FILE_TYPE;
  CURSOR cur_avg IS
    SELECT last_name, department_id, salary
    FROM employees outer
    WHERE salary > (SELECT AVG(salary)
                    FROM  employees inner
                    where department_id=outer.department_id)
    ORDER BY department_id;
BEGIN
  f := UTL_FILE.FOPEN(p_dir, p_filename,'W');
  UTL_FILE.PUT_LINE(f, 'Employees who earn more than average salary: ');
  UTL_FILE.PUT_LINE(f, 'REPORT GENERATED ON ' ||SYSDATE);
  UTL_FILE.NEW_LINE(f);
  FOR emp IN cur_avg
  LOOP
    UTL_FILE.PUT_LINE(f, 
    RPAD(emp.last_name, 30) || ' ' ||
    LPAD(NVL(TO_CHAR(emp.department_id,'9999'),'-'), 5) || ' ' ||
    LPAD(TO_CHAR(emp.salary, '$99,999.00'), 12));
  END LOOP;
  UTL_FILE.NEW_LINE(f);
  UTL_FILE.PUT_LINE(f, '*** END OF REPORT ***');
  UTL_FILE.FCLOSE(f);
END employee_report;
/

*/

--Uncomment code below to run the solution for Task 2 of Practice 16

-- for student ora61, as an example.

/* 

EXECUTE employee_report('REPORTS_DIR','sal_rpt71.txt') 

*/

