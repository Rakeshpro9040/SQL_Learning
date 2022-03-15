-- Use OE Connection

-- Example for calling C from PL/SQL
--Uncomment code below to run the solution for Task 2 of Practice 07

-- Copy the calc_tax.so from labs folder into below folder
--Execute as PDB1-sys
CREATE OR REPLACE LIBRARY c_code 
AS '/u01/app/oracle/product/19.3.0/dbhome_1/bin/calc_tax.so';
/

--Uncomment code below to run the solution for Task 3 of Practice 07

--Execute as PDB1-sys
GRANT EXECUTE ON c_code TO OE;

--Uncomment code below to run the solution for Task 4 of Practice 07

CREATE OR REPLACE FUNCTION call_c
(x BINARY_INTEGER)
RETURN BINARY_INTEGER
AS LANGUAGE C
LIBRARY sys.c_code
NAME "calc_tax";
/

--Uncomment code below to run the solution for Task 5 of Practice 07
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE c_output
  (p_in IN BINARY_INTEGER)
  
IS
  i BINARY_INTEGER;
BEGIN
  i := call_c(p_in);
  DBMS_OUTPUT.PUT_LINE('The total tax is: ' || i);
END c_output;
/

--Uncomment code below to run the solution for Task 6 of Practice 07

SET SERVEROUTPUT ON

EXECUTE c_output(1000000)
-- The total tax is: 80000

-- Example for calling Java from PL/SQL
--Uncomment code below to run the solution for Task 7 of Practice 07

-- note: You need to execute the following three commands at the OS level from the Linux terminal.
-- you need to change to the directory where the Factorial.java lives.
-- to change the directory, execute the following command:
cd /home/oracle/labs/labs

loadjava -user oe/cloud_4U@orclpdb1 FormatCreditCardNo.java

exit

--Uncomment code below to run the solution for Task 8 of Practice 07

CREATE OR REPLACE PROCEDURE ccformat
(x IN OUT VARCHAR2)
AS LANGUAGE JAVA
NAME 'FormatCreditCardNo.formatCard(java.lang.String[])';
/

--Uncomment code below to run the solution for Task 9 of Practice 07
VARIABLE x VARCHAR2(20)
EXECUTE :x := '1234567887654321'

EXECUTE ccformat(:x)

PRINT x
/*
Output:

X
--------------------------------------------------------------------------------
1234 5678 8765 4321 
*/