-- Use OE Connection

--Uncomment code below to run the solution for Task 1_b of Practice 11

--Execute as PDB1-sys
CREATE OR REPLACE DIRECTORY profile_data AS '/home/oracle/labs/labs';
GRANT READ, WRITE, EXECUTE ON DIRECTORY profile_data TO OE;
GRANT EXECUTE ON DBMS_HPROF TO OE;
--Uncomment code below to run the solution for Task 1_c of Practice 11

--EXECUTE AS OE
BEGIN
-- start profiling
  DBMS_HPROF.START_PROFILING('PROFILE_DATA', 'pd_cc_pkg.txt');
END;
/

--Uncomment code below to run the solution for Task 1_d of Practice 11

--Execute as OE
DECLARE
  v_card_info typ_cr_card_nst;
BEGIN
-- run application
  credit_card_pkg.update_card_info
    (154, 'Discover', '123456789');
END;
/
--Uncomment code below to run the solution for Task 1_e of Practice 11

--Execute as OE
BEGIN
  DBMS_HPROF.STOP_PROFILING;
END;
/

--Uncomment code below to run the solution for Task 2 of Practice 11

--Execute as OE
@/u01/app/oracle/product/12.2.0/dbhome_1/rdbms/admin/dbmshptab.sql

--Uncomment code below to run the solution for Task 3_a of Practice 11

--Execute as OE
SET SERVEROUTPUT ON 
DECLARE
  v_runid NUMBER;
BEGIN
  v_runid := DBMS_HPROF.ANALYZE (LOCATION => 'PROFILE_DATA', 
                                 FILENAME => 'pd_cc_pkg.txt');
  DBMS_OUTPUT.PUT_LINE('Run ID: ' || v_runid);
END;
/

--Uncomment code below to run the solution for Task 3_b of Practice 11

--Execute as OE
SET VERIFY OFF

SELECT runid, run_timestamp, total_elapsed_time
FROM dbmshp_runs 
WHERE runid = &your_run_id; 

--Uncomment code below to run the solution for Task 3_c of Practice 11

--Execute as OE
SELECT owner, module, type, function line#, namespace, 
       calls, function_elapsed_time
FROM   dbmshp_function_info
WHERE  runid = 1; 
--Uncomment code below to run the solution for Task 4 of Practice 11

--at your linux command window, change your working directory to /home/oracle/labs/labs
cd /home/oracle/labs/labs
plshprof  -output pd_cc_pkg  pd_cc_pkg.txt
                                                               