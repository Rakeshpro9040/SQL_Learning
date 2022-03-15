--cleanup_11.sql
DROP PROCEDURE create_departments_noex;
DROP PROCEDURE query_emp;
DROP PROCEDURE format_phone;
DROP PROCEDURE add_dept;
DROP PROCEDURE process_employees;
DROP PROCEDURE create_departments;
DROP PROCEDURE add_department_noex;
DROP PROCEDURE p;

--cleanup_12.sql
DROP FUNCTION get_sal;
DROP FUNCTION tax;
DROP FUNCTION dml_call_sql;
DROP FUNCTION query_call_sql;
DROP PROCEDURE emp_list;
DROP FUNCTION get_location;

--cleanup_13.sql
DROP FUNCTION get_sal;
DROP FUNCTION tax;
DROP FUNCTION dml_call_sql;
DROP FUNCTION query_call_sql;
DROP PROCEDURE emp_list;
DROP FUNCTION get_location;

--cleanup_14.sql
drop PACKAGE comm_pkg;
drop PACKAGE global_consts;
drop FUNCTION mtr2yrd;

--cleanup_15.sql
drop PACKAGE dept_pkg;
delete FROM departments
WHERE department_id = 980;
delete FROM departments
WHERE department_name = 'Training' and Location_id = 2400;
drop PACKAGE taxes_pkg;
drop PACKAGE curs_pkg;
drop PACKAGE emp_pkg;

--cleanup_16.sql
drop PROCEDURE read_file;
drop PROCEDURE sal_status;

--cleanup_17.sql
drop PROCEDURE create_table;
drop PROCEDURE add_col;
drop FUNCTION del_rows;
drop PROCEDURE add_row;
drop FUNCTION get_emp;
drop FUNCTION annual_sal;
drop PROCEDURE compile_plsql;
drop FUNCTION delete_all_rows;
drop PROCEDURE insert_row;

--cleanup_18.sql
--Ignore Any error messages while executing this cleanup script.
--The error messages may occur due to the restriction caused by triggers while performing UPDATE, INSERT and DELETE operations during Business hours.

DELETE from departments where department_id = 400;

UPDATE employees
SET salary = salary / 1.1
WHERE department_id = 30;

drop TRIGGER secure_emp;
drop TRIGGER secure_employees ;
drop TRIGGER restrict_salary;
drop TRIGGER audit_emp_values;
drop TRIGGER derive_commission_pct;
drop TRIGGER employee_dept_fk_trg;
drop TRIGGER new_emp_dept;

DELETE from employees where employee_id = 300;

UPDATE employees
SET salary = 14000
WHERE last_name = 'Russell';

DELETE from employees where employee_id = 999;

UPDATE employees 
SET department_id = 80 
WHERE employee_id = 170;
 
DROP table emp_details;
DROP table new_emps;
DROP table audit_emp;

--cleanup_19.sql
DROP TRIGGER check_salary;
DROP TRIGGER logon_trig;
DROP TRIGGER logoff_trig;
DROP TRIGGER log_employee;
DROP TRIGGER salary_check;

UPDATE employees
SET salary = 3200
WHERE last_name = 'Stiles';

DROP TABLE log_trig_table;
DROP PROCEDURE log_execution;

--cleanup_20.sql
drop  PACKAGE error_pkg;
drop PACKAGE constant_pkg;
drop PROCEDURE employee_sal;
drop PROCEDURE add_dept;
drop TABLE usage;
drop TABLE txn;
drop PROCEDURE log_usage;
drop PROCEDURE bank_trans;
drop FUNCTION f2;
drop  FUNCTION get_hire_date;
drop PROCEDURE update_salary;
drop PROCEDURE raise_salary;
drop PROCEDURE get_departments;
ALTER TRIGGER update_job_history DISABLE;
ALTER TRIGGER check_salary DISABLE;
ALTER TRIGGER check_sal_trg DISABLE;
UPDATE employees SET salary= 12008 where employee_id=108;

--cleanup_21.sql
DROP PROCEDURE add_job_history;
DROP PROCEDURE compile_code;
DROP PROCEDURE p;

DROP TABLE t;

DROP package my_pkg;

--cleanup_22.sql
DROP VIEW commissioned;
DROP VIEW six_figure_salary;
DROP VIEW v;

ALTER TABLE employees MODIFY email VARCHAR2(25);

DROP TABLE t2;

DROP PACKAGE pkg ;

DROP PROCEDURE p;

DROP SEQUENCE deptree_seq;
DROP TABLE deptree_temptab;

DROP VIEW deptree;
DROP VIEW ideptree;

DROP TRIGGER update_job_history;