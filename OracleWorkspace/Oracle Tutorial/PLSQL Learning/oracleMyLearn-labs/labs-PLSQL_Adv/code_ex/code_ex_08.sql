--This is the SQL Script to run the code_examples for Lesson 8
-- Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 08_09sa
DESCRIBE ALL_PLSQL_OBJECT_SETTINGS
/*
Name                 Null?    Type           
-------------------- -------- -------------- 
OWNER                NOT NULL VARCHAR2(128)  
NAME                 NOT NULL VARCHAR2(128)  
TYPE                          VARCHAR2(12)   
PLSQL_OPTIMIZE_LEVEL          NUMBER         
PLSQL_CODE_TYPE               VARCHAR2(4000) 
PLSQL_DEBUG                   VARCHAR2(4000) 
PLSQL_WARNINGS                VARCHAR2(4000) 
NLS_LENGTH_SEMANTICS          VARCHAR2(4000) 
PLSQL_CCFLAGS                 VARCHAR2(4000) 
PLSCOPE_SETTINGS              VARCHAR2(4000) 
ORIGIN_CON_ID                 NUMBER         
*/

--Uncomment the code below to execute the code on slide 08_10sa 
SELECT name, plsql_code_type, plsql_optimize_level
FROM   user_plsql_object_settings;
/*
ACTIONS_T	INTERPRETED	2
ACTION_T	INTERPRETED	2
ACTION_V	INTERPRETED	2
ADD_ORDER_ITEMS	INTERPRETED	2
*/

--Uncomment the code below to execute the code on slide 08_11sa 
SELECT name, plsql_code_type, plsql_optimize_level
FROM   user_plsql_object_settings
WHERE  name = 'ADD_ORDER_ITEMS';
/*
ADD_ORDER_ITEMS	INTERPRETED	2
*/

--Uncomment the code below to execute the code on slide 08_12sa 
-- you need dba privs to issue the statement below.
-- if you want to run the command, connect as PDB1-sys.

ALTER SYSTEM SET PLSQL_CODE_TYPE = NATIVE;

--Uncomment the code below to execute the code on slide 08_12sb
--Execute as OE
ALTER PROCEDURE add_order_items COMPILE;

SELECT name, plsql_code_type, plsql_optimize_level
FROM   user_plsql_object_settings
WHERE  name = 'ADD_ORDER_ITEMS';
-- ADD_ORDER_ITEMS	NATIVE	2

-- Enable the warnings to see the warnings while executing.

ALTER SESSION SET PLSQL_WARNINGS='ENABLE:ALL';

-- Subprogram Inlining Example (without Inlining)
--Uncomment the code below to execute the code on slide 08_17sa 
CREATE OR REPLACE PROCEDURE small_pgm
IS
  a NUMBER;
  b NUMBER := 2;

 PROCEDURE touch(x IN OUT NUMBER, y NUMBER) 
  IS
  BEGIN
    IF y > 0 THEN
      x := x+1;
    END IF;
    --DBMS_OUTPUT.PUT_LINE(x);
  END;

BEGIN
  a := b;
  FOR I IN 1..10 LOOP
  touch(a, 7);
  END LOOP;
  a := a*b;
  DBMS_OUTPUT.PUT_LINE(a);
END small_pgm;
/
/*
LINE/COL  ERROR
--------- -------------------------------------------------------------
1/1       PLW-05018: unit SMALL_PGM omitted optional AUTHID clause; default value DEFINER used
*/

--Uncomment the code below to execute the code on slide 08_20sa 

ALTER PROCEDURE small_pgm COMPILE 
  PLSQL_OPTIMIZE_LEVEL = 3 REUSE SETTINGS;

-- With Inlining
--Uncomment the code below to execute the code on slide 08_21sa
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE small_pgm
IS
  a PLS_INTEGER;
  FUNCTION add_it(a PLS_INTEGER, b PLS_INTEGER) 
  RETURN PLS_INTEGER 
  IS
  BEGIN
    RETURN a + b;
  END;
BEGIN
  pragma INLINE (add_it, 'YES');
  a := add_it(3, 4) + 6;
END small_pgm;
/
/*
Warning(1,1): PLW-05018: unit SMALL_PGM omitted optional AUTHID clause; default value DEFINER used
Warning(4,3): PLW-06027: procedure "ADD_IT" is removed after inlining
Warning(12,3): PLW-06005: inlining of call of procedure 'ADD_IT' was done
Warning(12,3): PLW-06004: inlining of call of procedure 'ADD_IT' requested
*/

-- BULK Binding Example
--Uncomment the code below to execute the code on slide 08_32na
CREATE TABLE bulk_bind_example_tbl (
  num_col NUMBER,
  date_col DATE,
  char_col VARCHAR2(40));
/

SET TIMING ON 

-- Using FOR Loop (Slow)
DECLARE
  TYPE typ_numlist IS TABLE OF NUMBER;
  TYPE typ_datelist IS TABLE OF DATE;
  TYPE typ_charlist IS TABLE OF VARCHAR2(40)
    INDEX BY PLS_INTEGER;
  n typ_numlist  := typ_numlist();
  d typ_datelist := typ_datelist();
  c typ_charlist;

BEGIN
  FOR i IN 1 .. 50000 LOOP
    n.extend;
    n(i) := i;
    d.extend;
    d(i) := sysdate + 1;
    c(i) := lpad(1, 40);
  END LOOP;
  FOR I in 1 .. 50000 LOOP
    INSERT INTO bulk_bind_example_tbl 
      VALUES (n(i), d(i), c(i));
  END LOOP;
END;
/
-- Elapsed: 00:00:03.032

-- Using FORALL Loop (Fast)
--Uncomment the code below to execute the code on slide 08_33na 
DECLARE
  TYPE typ_numlist IS TABLE OF NUMBER;
  TYPE typ_datelist IS TABLE OF DATE;
  TYPE typ_charlist IS TABLE OF VARCHAR2(40)
    INDEX BY PLS_INTEGER;

  n typ_numlist  := typ_numlist();
  d typ_datelist := typ_datelist();
  c typ_charlist;

BEGIN
  FOR i IN 1 .. 50000 LOOP
    n.extend;
    n(i) := i;
    d.extend;
    d(i) := sysdate + 1;
    c(i) := lpad(1, 40);
  END LOOP;
  FORALL I in 1 .. 50000
    INSERT INTO bulk_bind_example_tbl 
      VALUES (n(i), d(i), c(i));
END;
/
-- Elapsed: 00:00:00.228
set timing off

select * from bulk_bind_example_tbl;

--Uncomment the code below to execute the code on slide 08_34sa
CREATE OR REPLACE PROCEDURE process_customers
  (p_account_mgr customers.account_mgr_id%TYPE)
IS
  TYPE typ_numtab IS TABLE OF 
    customers.customer_id%TYPE;
  TYPE typ_chartab IS TABLE OF 
    customers.cust_last_name%TYPE;
  TYPE typ_emailtab IS TABLE OF 
    customers.cust_email%TYPE;
  v_custnos    typ_numtab;
  v_last_names typ_chartab;
  v_emails     typ_emailtab;
BEGIN
  SELECT customer_id, cust_last_name, cust_email
    BULK COLLECT INTO v_custnos, v_last_names, v_emails
    FROM customers
    WHERE account_mgr_id = p_account_mgr;
 -- ...
END process_customers;
/

-- RETURNING Clause Example
--Uncomment the code below to execute the code on slide 08_35sa
DECLARE
  TYPE      typ_replist IS VARRAY(100) OF NUMBER;
  TYPE      typ_numlist IS TABLE OF 
              orders.order_total%TYPE;
  repids    typ_replist := 
              typ_replist(153, 155, 156, 161);
  totlist   typ_numlist;
  c_big_total CONSTANT NUMBER := 60000;
BEGIN
  FORALL i IN repids.FIRST..repids.LAST
    UPDATE  orders
    SET     order_total = .95 * order_total
    WHERE   sales_rep_id = repids(i)
    AND     order_total > c_big_total
    RETURNING order_total BULK COLLECT INTO Totlist;
    
 END;
/

--Uncomment the code below to execute the code on slide 08_36na

CREATE OR REPLACE PROCEDURE change_credit
   (p_in_id   IN   customers.customer_id%TYPE, 
    o_credit OUT NUMBER)
   IS
   BEGIN
    UPDATE customers
    SET    credit_limit = credit_limit * 1.10 
    WHERE  customer_id = p_in_id
    RETURNING credit_limit INTO o_credit;
END change_credit;
/

VARIABLE g_credit NUMBER
EXECUTE change_credit(109, :g_credit)
PRINT g_credit
/*
  G_CREDIT
----------
       110
*/

-- SAVE EXCEPTION
--Uncomment the code below to execute the code on slide 08_38sa 
SET SERVEROUTPUT ON
DECLARE
  TYPE NumList IS TABLE OF NUMBER;
  num_tab   NumList := 
            NumList(100,0,110,300,0,199,200,0,400);
  bulk_errors EXCEPTION;
  PRAGMA      EXCEPTION_INIT (bulk_errors, -24381 );
BEGIN
  FORALL i IN num_tab.FIRST..num_tab.LAST
  SAVE EXCEPTIONS
  DELETE FROM orders WHERE order_total < 500000/num_tab(i);
EXCEPTION WHEN bulk_errors THEN
  DBMS_OUTPUT.PUT_LINE('Number of errors is: '
                        || SQL%BULK_EXCEPTIONS.COUNT);
  FOR j in 1..SQL%BULK_EXCEPTIONS.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SQL%BULK_EXCEPTIONS(j).error_index) || 
      ' / ' ||
      SQLERRM(-SQL%BULK_EXCEPTIONS(j).error_code) );
  END LOOP;
END;
/
/*
Number of errors is: 3
2 / ORA-01476: divisor is equal to zero
5 / ORA-01476: divisor is equal to zero
8 / ORA-01476: divisor is equal to zero
*/