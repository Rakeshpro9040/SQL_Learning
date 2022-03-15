--This is the SQL Script to run the code_examples for Lesson 7
-- Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 07_13na
--Execute as PDB1-sys
--copy the /home/oracle/labs/labs/calc_tax.so to $ORACLE_HOME/bin
--/u01/app/oracle/product/19.3.0/dbhome_1//bin
CREATE OR REPLACE LIBRARY c_utility
AS '$ORACLE_HOME/bin/calc_tax.so';
/

GRANT EXECUTE ON c_utility TO OE;
-- Execute as OE
--Uncomment the code below to execute the code on slide 07_18sa
CREATE OR REPLACE FUNCTION tax_amt(x BINARY_INTEGER)
RETURN BINARY_INTEGER
AS LANGUAGE C
LIBRARY sys.c_utility
NAME "calc_tax";
/
--Uncomment the code below to execute the code on slide 07_19na 

set serveroutput on

-- here is a simple example:
BEGIN
  DBMS_OUTPUT.PUT_LINE(tax_amt(1000));
END;
/
--Uncomment the code below to execute the code on slide 07_19nb
DECLARE
CURSOR cur_orders is 
  SELECT order_id, order_total
  FROM orders;
  v_tax NUMBER(8,2);
BEGIN
  FOR order_record IN cur_orders
  LOOP
    v_tax := tax_amt(order_record.order_total);
    DBMS_OUTPUT.PUT_LINE('Total tax: ' ||v_tax);
  END LOOP;
END;

--Uncomment the code below to execute the code on slide 07_20sa 
-- note: You need to do this command at the OS level
-- you need to change to the directory where the Factorial.java lives.
-- to change the directory, issue this statment at the OS:
cd /home/oracle/labs/code_ex
loadjava -user oe/oe@pdborcl Factorial.java

exit
--Uncomment the code below to execute the code on slide 07_20bn 
SELECT object_name, object_type FROM   user_objects
WHERE  object_type like 'J%';

SELECT text FROM   user_source WHERE name = 'Factorial';

--Uncomment the code below to execute the code on slide 07_25sa

CREATE OR REPLACE FUNCTION plstojavafac_fun
  (N NUMBER) 
  RETURN NUMBER
  AS
    LANGUAGE JAVA
    NAME 'Factorial.calcFactorial
      (int) return int';
/

--Uncomment the code below to execute the code on slide 07_22bn 

create or replace function dept_sal(p_deptno VARCHAR2) 
return VARCHAR2
AS
  LANGUAGE JAVA
  NAME 'dept.sal(java.lang.String) return java.lang.String';

--Uncomment the code below to execute the code on slide 07_27sa

set serveroutput on

EXECUTE DBMS_OUTPUT.PUT_LINE(plstojavafac_fun (5));

--Uncomment the code below to execute the code on slide 07_27sb

SELECT plstojavafac_fun (5)FROM dual;
--Uncomment the code below to execute the code on slide 07_28sa
CREATE OR REPLACE PACKAGE Demo_pack
AUTHID DEFINER
AS
  PROCEDURE plsToJ_InSpec_proc 
   (x BINARY_INTEGER, y VARCHAR2, z DATE);
END;
/
CREATE OR REPLACE PACKAGE BODY Demo_pack
AS
  PROCEDURE plsToJ_InSpec_proc 
   (x BINARY_INTEGER, y VARCHAR2, z DATE)
  IS LANGUAGE JAVA
  NAME 'pkg1.class4.J_InSpec_meth
         (int, java.lang.String, java.sql.Date)';
END;
/
