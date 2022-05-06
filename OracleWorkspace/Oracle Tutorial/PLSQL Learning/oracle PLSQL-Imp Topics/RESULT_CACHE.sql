create or replace function get_hire_date (
    emp_id number
)
return varchar
RESULT_CACHE
AUTHID CURRENT_USER
is
    date_hired date;
begin
    select hire_date INTO date_hired
    from employees
    WHERE employee_id = emp_id;
    
    RETURN TO_CHAR(date_hired);
end get_hire_date;
/

select get_hire_date(206) from dual;

-- https://oracle-base.com/articles/misc/efficient-function-calls-from-sql#oracle-11g-caching
-- Check DTERMINISTIC code for prerequisites and comparing with slow_function1
CREATE OR REPLACE FUNCTION slow_function3 (p_in IN NUMBER)
  RETURN NUMBER
  RESULT_CACHE
AS
BEGIN
  DBMS_LOCK.sleep(1);
  RETURN p_in;
END;
/

SET TIMING ON
SELECT slow_function3(id) FROM func_test;

/*
The advantage of this method is the cached information can be reused by 
any session and dependencies are managed automatically. 
If we run the query again we get even better performance because 
we can used the cached values without calling the function at all.
Shared across PGA.
*/











