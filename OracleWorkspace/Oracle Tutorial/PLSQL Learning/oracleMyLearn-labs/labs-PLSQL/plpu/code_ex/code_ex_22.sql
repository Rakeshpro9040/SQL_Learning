--This is the SQL Script to run the code_examples for Lesson 22

--Uncomment the code below to execute the code on slide 06_sa 

/*

CREATE OR REPLACE VIEW commissioned AS SELECT first_name, last_name, commission_pct
FROM employees WHERE commission_pct > 0.00;

CREATE OR REPLACE VIEW emp_mails AS SELECT first_name, last_name, email FROM employees;
*/

--Uncomment the code below to execute the code on slide 06_sb

/*
SELECT object_name, status
FROM user_objects
WHERE object_type = 'VIEW'
ORDER BY object_name;

*/

--Uncomment the code below to execute the code on slide 07_sa
/*

ALTER TABLE employees MODIFY email VARCHAR2(100);

*/

--Uncomment the code below to execute the code on slide 07_sb

/*

SELECT object_name, status
FROM user_objects
WHERE object_type = 'VIEW'
ORDER BY object_name;
*/

--Uncomment the code below to execute the code on slide 10_sa 
/*

desc user_dependencies

*/

--Uncomment the code below to execute the code on slide 10_sb 
/*

SELECT name, type, referenced_name, referenced_type
FROM   user_dependencies
WHERE  referenced_name IN ('EMPLOYEES','EMP_VW' ); 

*/

--Uncomment the code below to execute the code on slide 16_sa 
/*
@/home/oracle/labs/plpu/labs/utldtree.sql  
*/


--Uncomment the code below to execute the code on slide 17_sa 
/*

EXECUTE deptree_fill('TABLE', 'ORA61', 'EMPLOYEES')

*/

--Uncomment the code below to execute the code on slide 17_sb
/*

-- Run the code under slide 16_sa before this code example. 

SELECT   nested_level, type, name
FROM     deptree
ORDER BY seq#;

*/


--Uncomment the code below to execute the code on slide 17_na 
/*
-- Run the code under slide 17_sb before this code example. 

SELECT * 
FROM   ideptree;

*/

--Uncomment the code below to execute the code on slide 19_sa

/*
CREATE OR REPLACE VIEW commissioned AS SELECT first_name, last_name, commission_pct 
FROM employees WHERE commission_pct > 0.00;
CREATE OR REPLACE VIEW emp_mails AS SELECT first_name, last_name, email FROM employees;

*/

--Uncomment the code below to execute the code on slide 19_sb
/*
SELECT object_name, status
FROM user_objects
WHERE object_type = 'VIEW'
ORDER BY object_name;
*/

--Uncomment the code below to execute the code on slide 19_sc

/*
ALTER TABLE employees MODIFY email VARCHAR2(100);

*/

--Uncomment the code below to execute the code on slide 19_sd
/*
SELECT object_name, status
FROM user_objects
WHERE object_type = 'VIEW'
ORDER BY object_name;

*/

--Uncomment the code below to execute the code on slide 21_sa 
/*

CREATE TABLE t2 (col_a NUMBER, col_b NUMBER, col_c NUMBER);
CREATE VIEW v AS SELECT col_a, col_b FROM T2; 

*/

--Uncomment the code below to execute the code on slide 21_sb 
-- Run the code under slide 21_sa before running this code example. 
/*

SELECT ud.name, ud.type, ud.referenced_name, 
       ud.referenced_type, uo.status
FROM user_dependencies ud, user_objects uo
WHERE ud.name = uo.object_name AND ud.name = 'V';

*/

--Uncomment the code below to execute the code on slide 21_sc 
-- Run the code under slide 21_sa before running this code example
/*

ALTER TABLE t2 ADD (col_d VARCHAR2(20));

*/

--Uncomment the code below to execute the code on slide 21_sd 
/*

-- Run the code under slide 21_sa before running this code example. 

SELECT ud.name, ud.type, ud.referenced_name, 
       ud.referenced_type, uo.status
FROM user_dependencies ud, user_objects uo
WHERE ud.name = uo.object_name AND ud.name = 'V';

*/

--Uncomment the code below to execute the code on slide 22_sa 
-- Run the code under slide 21_sa before running this code example. 
/*

ALTER TABLE t2 MODIFY (col_a VARCHAR2(20))
/
SELECT ud.name, ud.referenced_name, ud.referenced_type, uo.status
FROM user_dependencies ud, user_objects uo
WHERE ud.name = uo.object_name AND ud.name = 'V'
/

*/

--Uncomment the code below to execute the code on slide 23_sa 
/*

CREATE or replace PACKAGE pkg 
IS
  PROCEDURE proc_1;
END pkg;
/
CREATE OR REPLACE PROCEDURE p 
IS 
BEGIN 
  pkg.proc_1(); 
END;
/
CREATE OR REPLACE PACKAGE pkg 
IS
  PROCEDURE proc_1;
  PROCEDURE unheard_of;
END pkg;
/

*/

--Uncomment the code below to execute the code on slide 23_na 
/*

SELECT status FROM user_objects
  WHERE object_name = 'P';

*/
