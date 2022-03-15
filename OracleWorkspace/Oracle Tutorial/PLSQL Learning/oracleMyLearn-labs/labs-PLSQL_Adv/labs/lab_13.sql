-- Use OE Connection

--Uncomment code below to run the lab script for Task 06 of Practice 13

CREATE OR REPLACE PROCEDURE get_income_level (p_email VARCHAR2 DEFAULT NULL)
IS
  TYPE      cv_custtyp IS REF CURSOR;
  cv        cv_custtyp;
  v_income  customers.income_level%TYPE;
  v_stmt    VARCHAR2(400);
BEGIN
  v_stmt := 'SELECT income_level FROM customers WHERE cust_email = ''' 
            || p_email || '''';
            
  DBMS_OUTPUT.PUT_LINE('SQL statement: ' || v_stmt);
  OPEN cv FOR v_stmt;
  LOOP
      FETCH cv INTO v_income;
      EXIT WHEN cv%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Income level is: '||v_income);
  END LOOP;
  CLOSE cv;

EXCEPTION WHEN OTHERS THEN
   dbms_output.PUT_LINE(sqlerrm);
   dbms_output.PUT_LINE('SQL statement: ' || v_stmt);
END get_income_level;
/
--Uncomment code below to run the lab script for Task 07 of Practice 13
-- This is the procedure with static SQL
-- Safe from SQL injection!!

CREATE OR REPLACE
PROCEDURE get_income_level (p_email VARCHAR2 DEFAULT NULL)
AS

BEGIN

FOR i IN
  (SELECT income_level 
   FROM customers 
   WHERE cust_email = p_email)
  LOOP
      DBMS_OUTPUT.PUT_LINE('Income level is: '||i.income_level);
  END LOOP;

END get_income_level;
/

