create or replace function deterministic_func (
    i_mile in number
)
return number
DETERMINISTIC
is
begin
    RETURN i_mile*5280;
end deterministic_func;
/

-- Returns same result everytime for same arguments
select deterministic_func(1) from dual; --5280
select deterministic_func(2) from dual; --10560

-- https://oracle-base.com/articles/misc/efficient-function-calls-from-sql#deterministic-hint
-- The example below creates a test table with 10 rows, of 3 distinct values. 
-- Prerequisites
CREATE TABLE func_test (
  id NUMBER
);
/

INSERT INTO func_test
SELECT CASE
         WHEN level = 10 THEN 3
         WHEN MOD(level, 2) = 0 THEN 2
         ELSE 1
       END
FROM   dual
CONNECT BY level <= 10;
COMMIT;
/

select * from func_test;

-- Slow Function
CREATE OR REPLACE FUNCTION slow_function1 (p_in IN NUMBER)
  RETURN NUMBER
AS
BEGIN
  DBMS_LOCK.sleep(1);
  RETURN p_in;
END;
/

grant execute on SYS.DBMS_LOCK to HR;

SET TIMING ON
SELECT slow_function1(id) FROM func_test;

-- DETERMINISTIC
CREATE OR REPLACE FUNCTION slow_function2 (p_in IN NUMBER)
  RETURN NUMBER
  DETERMINISTIC
AS
BEGIN
  DBMS_LOCK.sleep(1);
  RETURN p_in;
END;
/

SET TIMING ON
SELECT slow_function2(id) FROM func_test;
/*
For a singel fetch this will work and will be able to fetch values 
for the duplicate records. For large array set use RESULT_CACHE.
*/






































