-- Use OE Connection

--Uncomment code below to complete Task 1_a of Practice 10

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

--Uncomment code below  to complete Task 2_d of Practice 10
WITH v AS
 (SELECT    Line,
            Col,
            INITCAP(NAME) Name,
            LOWER(TYPE)   Type,
            LOWER(USAGE)  Usage,
            USAGE_ID, USAGE_CONTEXT_ID
  FROM USER_IDENTIFIERS
  WHERE Object_Name = 'CREDIT_CARD_PKG'
    AND Object_Type = 'PACKAGE BODY'  )
    SELECT RPAD(LPAD(' ', 2*(Level-1)) ||
                 Name, 20, '.')||' '||
                 RPAD(Type, 20)|| RPAD(Usage, 20)
                 IDENTIFIER_USAGE_CONTEXTS
    FROM v
    START WITH USAGE_CONTEXT_ID = 0
    CONNECT BY PRIOR USAGE_ID = USAGE_CONTEXT_ID
    ORDER SIBLINGS BY Line, Col;

--Uncomment code below to complete Task 3_a of Practice 10
CREATE OR REPLACE FUNCTION get_table_md RETURN CLOB IS
 v_hdl  NUMBER; -- returned by 'OPEN'
 v_th   NUMBER; -- returned by 'ADD_TRANSFORM'
 v_doc  CLOB;
BEGIN
 -- specify the OBJECT TYPE 
 v_hdl := DBMS_METADATA.OPEN('TABLE');
 -- use FILTERS to specify the objects desired
 DBMS_METADATA.SET_FILTER(v_hdl ,'SCHEMA','OE');
 DBMS_METADATA.SET_FILTER
                      (v_hdl ,'NAME','ORDER_ITEMS');
 -- request to be TRANSFORMED into creation DDL
 v_th := DBMS_METADATA.ADD_TRANSFORM(v_hdl,'DDL');
 -- FETCH the object
 v_doc := DBMS_METADATA.FETCH_CLOB(v_hdl);
 -- release resources
 DBMS_METADATA.CLOSE(v_hdl);
 RETURN v_doc;
END;
/

--Uncomment code below to run Task 3_b of Practice 10

set pagesize 0
set long  1000000

SELECT get_table_md FROM dual;
