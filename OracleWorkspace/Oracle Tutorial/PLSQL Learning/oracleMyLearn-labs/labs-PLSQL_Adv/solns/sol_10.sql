-- Use OE Connection

--Uncomment code below to run the solution for Task 1_a of Practice 10

CREATE OR REPLACE PACKAGE query_code_pkg
AUTHID CURRENT_USER
IS
  PROCEDURE find_text_in_code (str IN VARCHAR2);
  PROCEDURE encap_compliance ;
END query_code_pkg;
/

CREATE OR REPLACE PACKAGE BODY query_code_pkg IS
  PROCEDURE find_text_in_code (str IN VARCHAR2)
  IS
    TYPE info_rt IS RECORD (NAME user_source.NAME%TYPE,
      text user_source.text%TYPE );
    TYPE info_aat IS TABLE OF info_rt INDEX BY PLS_INTEGER;
    info_aa info_aat;
  BEGIN
    SELECT NAME || '-' || line, text
    BULK COLLECT INTO info_aa FROM user_source
      WHERE UPPER (text) LIKE '%' || UPPER (str) || '%'
      AND NAME != 'VALSTD' AND NAME != 'ERRNUMS';
    DBMS_OUTPUT.PUT_LINE ('Checking for presence of '|| 
                          str || ':');
    FOR indx IN info_aa.FIRST .. info_aa.LAST LOOP
      DBMS_OUTPUT.PUT_LINE (
          info_aa (indx).NAME|| ',' || info_aa (indx).text);
    END LOOP;
  END find_text_in_code;

  PROCEDURE encap_compliance IS
    SUBTYPE qualified_name_t IS VARCHAR2 (200);
    TYPE refby_rt IS RECORD (NAME qualified_name_t, 
         referenced_by qualified_name_t );
    TYPE refby_aat IS TABLE OF refby_rt INDEX BY PLS_INTEGER;
    refby_aa refby_aat;
  BEGIN
    SELECT owner || '.' || NAME refs_table
          , referenced_owner || '.' || referenced_name
          AS table_referenced
    BULK COLLECT INTO refby_aa
      FROM all_dependencies
      WHERE owner = USER
      AND TYPE IN ('PACKAGE', 'PACKAGE BODY',
                   'PROCEDURE', 'FUNCTION')
      AND referenced_type IN ('TABLE', 'VIEW')
      AND referenced_owner NOT IN ('SYS', 'SYSTEM')
     ORDER BY owner, NAME, referenced_owner, referenced_name;
    DBMS_OUTPUT.PUT_LINE ('Programs that reference tables or views');
    FOR indx IN refby_aa.FIRST .. refby_aa.LAST LOOP
      DBMS_OUTPUT.PUT_LINE (refby_aa (indx).NAME || ',' ||
            refby_aa (indx).referenced_by);
    END LOOP;
 END encap_compliance; 
END query_code_pkg;
/

--Uncomment code below to run the solution for Task 1_b of Practice 10

SET SERVEROUTPUT ON

EXECUTE query_code_pkg.encap_compliance


--Uncomment code below to run the solution for Task 1_c of Practice 10

SET SERVEROUTPUT ON

EXECUTE query_code_pkg.find_text_in_code ('ORDERS')

--Uncomment code below to run the solution for Task 2_a of Practice 10

ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL';

--Uncomment code below to run the solution for Task 2_b of Practice 10

ALTER PACKAGE credit_card_pkg COMPILE;

--Uncomment code below to run the solution for Task 2_c of Practice 10

SELECT PLSCOPE_SETTINGS
FROM USER_PLSQL_OBJECT_SETTINGS
WHERE NAME='CREDIT_CARD_PKG' AND TYPE='PACKAGE BODY';


--Uncomment code below to run the solution for Task 3_c of Practice 10
-- Execute in SQLPLus
SPOOL /home/oracle/labs/ORDER_ITEMS_XML.txt

SET pagesize 0
SET LONG 2000000

SELECT DBMS_METADATA.GET_XML
      ('TABLE', 'ORDER_ITEMS', 'OE')
FROM   dual; 

SPOOL OFF
/


