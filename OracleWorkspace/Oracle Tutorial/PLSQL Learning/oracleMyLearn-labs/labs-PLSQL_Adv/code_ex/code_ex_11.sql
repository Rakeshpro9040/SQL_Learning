--This is the SQL Script to run the code_examples for Lesson 11
--Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 11_13na 
--Execute as PDB1-sys
@/u01/app/oracle/product/19.3.0/dbhome_1/rdbms/admin/tracetab
GRANT SELECT ON plsql_trace_runs TO OE;
GRANT SELECT ON plsql_trace_events TO OE;

--Uncomment the code below to execute the code on slide 11_14sa 
--Execute as OE
-- make sure you have run the tracetab.sql script first.
-- it is located under: /u01/app/oracle/product/19.3.0/dbhome_1/rdbms/admin/
-- You also need to run a code example from the previous lesson to create the P5 procedure.
-- The P5 definition is found in the step 10_44na in lesson 10.

ALTER SESSION SET PLSQL_DEBUG=true;
ALTER PROCEDURE P5 COMPILE DEBUG;
EXECUTE DBMS_TRACE.SET_PLSQL_TRACE(DBMS_TRACE.trace_all_calls)
EXECUTE p5
EXECUTE DBMS_TRACE.CLEAR_PLSQL_TRACE

SELECT proc_name, proc_line, 
       event_proc_name, event_comment  
FROM sys.plsql_trace_events
WHERE event_proc_name = 'P5'
OR PROC_NAME = 'P5';
--Uncomment the code below to execute the code on slide 11_21na  and 11_22na
-- create the type first - if you already created it, this will give an error.
CREATE OR REPLACE TYPE typ_cr_card AS OBJECT  --create object
 (card_type  VARCHAR2(25),
  card_num   NUMBER);
/

CREATE OR REPLACE TYPE typ_cr_card_nst -- define nested table type
  AS TABLE OF typ_cr_card;
/

-- if the customers table already has this column, this statement will fail. 
-- if the customers table does not have this column, you need to add it with this statement.
ALTER TABLE customers ADD
  credit_cards typ_cr_card_nst
   NESTED TABLE credit_cards STORE AS c_c_store_tab;
CREATE OR REPLACE PACKAGE credit_card_pkg
IS
  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2);
  
  PROCEDURE display_card_info
    (p_cust_id NUMBER);
END credit_card_pkg;  -- package spec
/

CREATE OR REPLACE PACKAGE BODY credit_card_pkg
IS
  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2)
  IS
    v_card_info typ_cr_card_nst;
    i INTEGER;
  BEGIN
    SELECT credit_cards
      INTO v_card_info
      FROM customers
      WHERE customer_id = p_cust_id;
    IF v_card_info.EXISTS(1) THEN  -- cards exist, add more
      i := v_card_info.LAST;
      v_card_info.EXTEND(1);
      v_card_info(i+1) := typ_cr_card(p_card_type, p_card_no);
      UPDATE customers
        SET  credit_cards = v_card_info
        WHERE customer_id = p_cust_id;
    ELSE   -- no cards for this customer yet, construct one
      UPDATE customers
        SET  credit_cards = typ_cr_card_nst
            (typ_cr_card(p_card_type, p_card_no))
        WHERE customer_id = p_cust_id;
    END IF;
  END update_card_info;

  PROCEDURE display_card_info
    (p_cust_id NUMBER)
  IS
    v_card_info typ_cr_card_nst;
    i INTEGER;
  BEGIN
    SELECT credit_cards
      INTO v_card_info
      FROM customers
      WHERE customer_id = p_cust_id;
    IF v_card_info.EXISTS(1) THEN
      FOR idx IN v_card_info.FIRST..v_card_info.LAST LOOP
          DBMS_OUTPUT.PUT('Card Type: ' || v_card_info(idx).card_type 
                                        || ' ');
        DBMS_OUTPUT.PUT_LINE('/ Card No: ' || v_card_info(idx).card_num );
      END LOOP;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Customer has no credit cards.');
    END IF;
  END display_card_info;  
END credit_card_pkg;  -- package body
/
--Uncomment the code below to execute the code on slide 11_23na 
--Execute as PDB1-sys 
CREATE OR REPLACE DIRECTORY profile_data AS '/home/oracle/labs/labs';
GRANT READ, WRITE, EXECUTE ON DIRECTORY profile_data TO OE;
GRANT EXECUTE ON DBMS_HPROF TO OE;
--Uncomment the code below to execute the code on slide 11_23sa 
BEGIN
-- start profiling
  DBMS_HPROF.START_PROFILING('PROFILE_DATA', 'pd_cc_pkg.txt');
END;
/
--Uncomment the code below to execute the code on slide 11_23sb
DECLARE
  v_card_info typ_cr_card_nst;
BEGIN
-- run application
  credit_card_pkg.update_card_info
    (154, 'Discover', '123456789');
END;
/

--Uncomment the code below to execute the code on slide 11_23sc 
BEGIN
  DBMS_HPROF.STOP_PROFILING;
END;
/
--Uncomment the code below to execute the code on slide 11_24na 

 
EXECUTE dbms_hprof.stop_profiling

--Uncomment the code below to execute the code on slide 11_26sa 
-- In the Oracle classroom setup, this path is correct.
-- If you are at an onsite, you may need to change the path below.

@/u01/app/oracle/product/19.3.0/dbhome_1/rdbms/admin/dbmshptab.sql

--Uncomment the code below to execute the code on slide 11_28sa 
SET SERVEROUTPUT ON
DECLARE
  v_runid NUMBER;
BEGIN
  v_runid := DBMS_HPROF.ANALYZE (LOCATION => 'PROFILE_DATA', 
                                 FILENAME => 'pd_cc_pkg.txt');
  DBMS_OUTPUT.PUT_LINE('Run ID: ' || v_runid);
END;
/
--Uncomment the code below to execute the code on slide 11_29sa 
-- The run id value might not be the same always. 
-- You would get a different number based on the order of execution.
SELECT runid, run_timestamp, total_elapsed_time
FROM dbmshp_runs 
WHERE runid = 1; 
--Uncomment the code below to execute the code on slide 11_30sa 
-- The run id value might not be the same always. 
-- You would get a different number based on the order of execution.
SELECT owner, module, type, function line#, namespace, 
       calls, function_elapsed_time
FROM   dbmshp_function_info
WHERE  runid = 1;

--Uncomment the code below to execute the code on slide 11_31sa
-- these commands are run at the OS level
--NOTE: change your directory to: /home/oracle/labs/labs

-- now change to that directory.
cd /home/oracle/labs/labs

plshprof -output pd_cc_pkg pd_cc_pkg.txt
