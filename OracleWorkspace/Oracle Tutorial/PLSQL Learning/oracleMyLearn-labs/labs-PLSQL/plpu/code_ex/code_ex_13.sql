--This is the SQL Script to run the code_examples for Lesson 13

--Please perform the following code as SYSDBA before executing other code examples.
--This is a work around, if you encounter an “access control list (ACL) error”.



--Uncomment the code below to execute the code on slide 6_sa
/*

SELECT * from user_sys_privs;

*/
--Uncomment the code below to execute the code on slide 6_sb
/*
GRANT DEBUG ANY PROCEDURE TO ora61;
GRANT DEBUG CONNECT SESSION TO ora61;
-- Login as ora61
select * from user_sys_privs;

*/
--Uncomment the code below to execute the code on slide 8_sa

/*
/*
BEGIN
DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
host => '127.0.0.1',
lower_port => null,
upper_port => null,
ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
principal_name => 'ora61',
principal_type => xs_acl.ptype_db));
END;
/

*/

--Uncomment the code below to execute the code on slide 17_sa 
-- The emp_list procedure this code example creates, invokes the get_location function 
-- that is created using the code under slide 18_sa. This is why a warning message is displayed. Simply 
-- re-compile emp_list after creating get_location. 

/*
CREATE OR REPLACE PROCEDURE emp_list 
(p_maxrows IN NUMBER) 
IS
CURSOR cur_emp IS
  SELECT d.department_name, e.employee_id, e.last_name,
         e.salary, e.commission_pct
  FROM  departments d, employees e
  WHERE d.department_id = e.department_id;
  rec_emp cur_emp%ROWTYPE;
  TYPE emp_tab_type IS TABLE OF cur_emp%ROWTYPE INDEX BY BINARY_INTEGER;
  emp_tab emp_tab_type;
i NUMBER := 1;
v_city VARCHAR2(30); 
BEGIN
  OPEN cur_emp;
  FETCH cur_emp INTO rec_emp;
  emp_tab(i) := rec_emp;
  WHILE (cur_emp%FOUND) AND (i <= p_maxrows) LOOP
     i := i + 1;
     FETCH cur_emp INTO rec_emp;
     emp_tab(i) := rec_emp;
     v_city := get_location (rec_emp.department_name);
     dbms_output.put_line('Employee ' || rec_emp.last_name ||
       ' works in ' || v_city );
  END LOOP;
  CLOSE cur_emp;
  FOR j IN REVERSE 1..i LOOP
     DBMS_OUTPUT.PUT_LINE(emp_tab(j).last_name);
  END LOOP;
END emp_list; 
/

*/

--Uncomment the code below to execute the code on slide 18_sa 
/*

CREATE OR REPLACE FUNCTION get_location
( p_deptname IN VARCHAR2) RETURN VARCHAR2 
AS
  v_loc_id NUMBER;
  v_city   VARCHAR2(30);
BEGIN
  SELECT d.location_id, l.city INTO v_loc_id, v_city
  FROM departments d, locations l
  WHERE upper(department_name) = upper(p_deptname)
  and d.location_id = l.location_id;
  RETURN v_city;
END GET_LOCATION;
/

*/
