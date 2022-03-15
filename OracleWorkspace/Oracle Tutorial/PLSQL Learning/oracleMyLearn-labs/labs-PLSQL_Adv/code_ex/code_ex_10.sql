--This is the SQL Script to run the code_examples for Lesson 10

--Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 10_8sa 

SELECT NAME, line, text
FROM         user_source
WHERE        INSTR (UPPER(text), ' CHAR') > 0
             OR INSTR (UPPER(text), ' CHAR(') > 0
             OR INSTR (UPPER(text), ' CHAR (') > 0;


--Uncomment the code below to execute the code on slide 10_09sa
CREATE OR REPLACE PACKAGE query_code_pkg
AUTHID CURRENT_USER
IS
  PROCEDURE find_text_in_code (str IN VARCHAR2);
  PROCEDURE encap_compliance ;
END query_code_pkg;
/

--Uncomment the code below to execute the code on slide 10_10na
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

--Uncomment the code below to execute the code on slide 10_11sa
SET SERVEROUTPUT ON

EXECUTE query_code_pkg.encap_compliance
/

--Uncomment the code below to execute the code on slide 10_12sa
SET SERVEROUTPUT ON

EXECUTE query_code_pkg.find_text_in_code('BEGIN')

--Uncomment the code below to execute the code on slide 10_15sa
-- You should have executed the practice 4 to see output for the following code
COL object_name format a18
COL argument_name format a15
COL in_out format a8
COL data_type format a14

SELECT object_name, argument_name, in_out, position, data_type
FROM   all_arguments
WHERE  package_name = 'CREDIT_CARD_PKG';

--Uncomment the code below to execute the code on slide 10_15na and 10_16na 

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

--Uncomment the code below to execute the code on slide 10_25sa

ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL';

DESCRIBE USER_IDENTIFIERS;

--Uncomment the code below to execute the code on slide 10_27sa

ALTER PACKAGE credit_card_pkg COMPILE;


--Uncomment the code below to execute the code on slide 10_28sa

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


--Uncomment the code below to execute the code on slide 10_30sa

SELECT NAME, SIGNATURE, TYPE
FROM USER_IDENTIFIERS
WHERE  USAGE='DECLARATION'
ORDER BY OBJECT_TYPE, USAGE_ID;

--Uncomment the code below to execute the code on slide 10_31sa

SELECT a.NAME variable_name, b.NAME context_name, a.SIGNATURE
FROM USER_IDENTIFIERS a, USER_IDENTIFIERS b
WHERE a.USAGE_CONTEXT_ID = b.USAGE_ID
  AND a.TYPE = 'VARIABLE'
  AND a.USAGE = 'DECLARATION'
  AND a.OBJECT_NAME = 'CREDIT_CARD_PKG'
  AND a.OBJECT_NAME = b.OBJECT_NAME
  AND a.OBJECT_TYPE =  b.OBJECT_TYPE
  AND (b.TYPE = 'FUNCTION' or b.TYPE = 'PROCEDURE')
ORDER BY a.OBJECT_TYPE, a.USAGE_ID;

--Uncomment the code below to execute the code on slide 10_32sa

--Replace the value of the "SIGNATURE" with the value of the 
--signature of V_CARD_INFO obtained by executing the code on 10_31as
SELECT USAGE, USAGE_ID, OBJECT_NAME, OBJECT_TYPE
FROM USER_IDENTIFIERS
WHERE SIGNATURE='5FE3409B23709E61A12314F2667949CA'
ORDER BY OBJECT_TYPE, USAGE_ID;

--Uncomment the code below to execute the code on slide 10_33sa

SELECT LINE, COL, OBJECT_NAME, OBJECT_TYPE
FROM USER_IDENTIFIERS
WHERE SIGNATURE='5FE3409B23709E61A12314F2667949CA'
AND USAGE='ASSIGNMENT';

--Uncomment the code below to execute the code on slide 10_37sa

CREATE OR REPLACE PACKAGE use_dbms_describe
IS
  PROCEDURE get_data (p_obj_name VARCHAR2);
END use_dbms_describe;
/

--Uncomment the code below to execute the code on slide 10_37sb

-- NOTE: You need to run the package body shown on slide 10-38na before
-- this example will work!
SET SERVEROUTPUT ON
EXEC use_dbms_describe.get_data('query_code_pkg.find_text_in_code')

--Uncomment the code below to execute the code on slide 10_38na

CREATE OR REPLACE PACKAGE use_dbms_describe IS
  PROCEDURE get_data (p_obj_name VARCHAR2);
END use_dbms_describe;
/
CREATE OR REPLACE PACKAGE BODY use_dbms_describe IS
  PROCEDURE get_data (p_obj_name VARCHAR2)
  IS
    v_overload     DBMS_DESCRIBE.NUMBER_TABLE;
    v_position     DBMS_DESCRIBE.NUMBER_TABLE;
    v_level        DBMS_DESCRIBE.NUMBER_TABLE;
    v_arg_name     DBMS_DESCRIBE.VARCHAR2_TABLE;
    v_datatype     DBMS_DESCRIBE.NUMBER_TABLE;
    v_def_value    DBMS_DESCRIBE.NUMBER_TABLE;
    v_in_out       DBMS_DESCRIBE.NUMBER_TABLE;
    v_length       DBMS_DESCRIBE.NUMBER_TABLE;
    v_precision    DBMS_DESCRIBE.NUMBER_TABLE;
    v_scale        DBMS_DESCRIBE.NUMBER_TABLE;
    v_radix        DBMS_DESCRIBE.NUMBER_TABLE;
    v_spare        DBMS_DESCRIBE.NUMBER_TABLE;
  BEGIN
    DBMS_DESCRIBE.DESCRIBE_PROCEDURE
    (p_obj_name, null, null, -- these are the 3 in parameters 
     v_overload, v_position, v_level, v_arg_name,
     v_datatype, v_def_value, v_in_out, v_length, 
     v_precision, v_scale, v_radix, v_spare, null);
    IF v_in_out.FIRST IS NULL THEN
      DBMS_OUTPUT.PUT_LINE ('No arguments to report.');
    ELSE 
      DBMS_OUTPUT.PUT
      ('Name                                        Mode'); 
      DBMS_OUTPUT.PUT_LINE('  Position    Datatype ');
      FOR i IN v_arg_name.FIRST .. v_arg_name.LAST LOOP
        IF v_position(i) = 0 THEN   
          DBMS_OUTPUT.PUT('This is the RETURN data for 
          the function: ');
        ELSE 
          DBMS_OUTPUT.PUT ( 
            rpad(v_arg_name(i), LENGTH(v_arg_name(i)) +  
                 42-LENGTH(v_arg_name(i)), ' '));
        END IF;
        DBMS_OUTPUT.PUT( '     ' ||
          v_in_out(i) || '         ' || v_position(i) ||
          '           ' || v_datatype(i) );
        DBMS_OUTPUT.NEW_LINE;
      END LOOP;
    END IF;
  END get_data;
END use_dbms_describe;
/

--Uncomment the code below to execute the code on slide 10_40na
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE first_one 
IS
BEGIN
  dbms_output.put_line(
    substr(dbms_utility.format_call_Stack, 1, 255));
END;
/

CREATE OR REPLACE PROCEDURE second_one 
IS
BEGIN
  null;
  first_one;
END;
/


CREATE OR REPLACE PROCEDURE third_one 
IS
BEGIN
  null;
  null;
  second_one;
END;
/

--Uncomment the code below to execute the code on slide 10_41sa

SET SERVEROUTPUT ON
EXECUTE third_one

--Uncomment the code below to execute the code on slide 10_43sa

-- NOTE: You must run the next 2 examples 
-- (step 10_44sa and 10_45na) first.

CREATE OR REPLACE PROCEDURE top_with_logging IS
  -- NOTE: SQLERRM in principle gives the same info 
  -- as format_error_stack.
  -- But SQLERRM is subject to some length limits,
  -- while format_error_stack is not.
BEGIN
  P5(); -- this procedure, in turn, calls others, 
        -- building a stack. P0 contains the exception
EXCEPTION
  WHEN OTHERS THEN
    log_errors ( 'Error_Stack...' || CHR(10) ||
      DBMS_UTILITY.FORMAT_ERROR_STACK() );
    log_errors ( 'Error_Backtrace...' || CHR(10) ||
      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() );
    DBMS_OUTPUT.PUT_LINE ( '----------' );
END top_with_logging;
/

--Uncomment the code below to execute the code on slide 10_44sa

CREATE OR REPLACE PROCEDURE log_errors ( i_buff IN VARCHAR2 ) IS
  g_start_pos PLS_INTEGER := 1;
  g_end_pos   PLS_INTEGER;
  FUNCTION output_one_line RETURN BOOLEAN IS
  BEGIN
    g_end_pos := INSTR ( i_buff, CHR(10), g_start_pos );
    CASE g_end_pos > 0
      WHEN TRUE THEN
        DBMS_OUTPUT.PUT_LINE ( SUBSTR ( i_buff, 
                               g_start_pos, g_end_pos-g_start_pos ));
        g_start_pos := g_end_pos+1;
        RETURN TRUE;
      WHEN FALSE THEN
        DBMS_OUTPUT.PUT_LINE ( SUBSTR ( i_buff, g_start_pos,
                              (LENGTH(i_buff)-g_start_pos)+1 ));
        RETURN FALSE;
    END CASE;
  END output_one_line;
BEGIN
  WHILE output_one_line() LOOP NULL; 
  END LOOP;
END log_errors;
/

--Uncomment the code below to execute the code on slide 10_45na

SET FEEDBACK OFF
SET ECHO OFF

CREATE OR REPLACE PROCEDURE P0 IS
  e_01476 EXCEPTION; 
  pragma exception_init ( e_01476, -1476 );
BEGIN
  RAISE e_01476;  -- this is a zero divide error
END P0;
/
CREATE OR REPLACE PROCEDURE P1 IS
BEGIN
  P0();
END P1;
/
CREATE OR REPLACE PROCEDURE P2 IS
BEGIN
  P1();
END P2;
/
CREATE OR REPLACE PROCEDURE P3 IS
BEGIN
  P2();
END P3;
/
CREATE OR REPLACE PROCEDURE P4 IS
  BEGIN P3(); 
END P4;
/
CREATE OR REPLACE PROCEDURE P5 IS
  BEGIN P4(); 
END P5;
/
CREATE OR REPLACE PROCEDURE top IS
BEGIN
  P5(); -- this procedure is used to show the results
        -- without using the TOP_WITH_LOGGING routine.
END top;
/
SET FEEDBACK ON

--Execute the procedure to see the output in slide 46

SET SERVEROUTPUT ON
EXECUTE top_with_logging

-- executing the TOP procedure without using the TOP_WITH_LOGGING procedure
SET SERVEROUTPUT ON
EXECUTE top

--Uncomment the code below to execute the code on slide 10_53sa

-- NOTE: This code is not complete and will not run.

DBMS_METADATA.SET_FILTER(handle, 'SCHEMA_EXPR', 
  'IN (''PAYROLL'', ''OE'')');
DBMS_METADATA.SET_FILTER(handle, 'EXCLUDE_PATH_EXPR',
  '=''FUNCTION''');
DBMS_METADATA.SET_FILTER(handle, 'EXCLUDE_PATH_EXPR',
  '=''PROCEDURE''');
DBMS_METADATA.SET_FILTER(handle, 'EXCLUDE_PATH_EXPR',
  '=''PACKAGE''');
DBMS_METADATA.SET_FILTER(handle, 'EXCLUDE_NAME_EXPR',
  'LIKE ''PAYROLL%''', 'VIEW');


--Uncomment the code below to execute the code on slide 10_54sa 

CREATE OR REPLACE PROCEDURE example_one IS
  v_hdl    NUMBER; v_th1  NUMBER; v_th2  NUMBER;
  v_doc  sys.ku$_ddls;
BEGIN
  v_hdl := DBMS_METADATA.OPEN('SCHEMA_EXPORT');
  DBMS_METADATA.SET_FILTER (v_hdl,'SCHEMA','OE');
  v_th1 := DBMS_METADATA.ADD_TRANSFORM (v_hdl,
    'MODIFY', NULL, 'TABLE');
  DBMS_METADATA.SET_REMAP_PARAM(v_th1,
    'REMAP_TABLESPACE', 'SYSTEM', 'TBS1');
  v_th2 :=DBMS_METADATA.ADD_TRANSFORM(v_hdl,'DDL');
  DBMS_METADATA.SET_TRANSFORM_PARAM(v_th2,
    'SQLTERMINATOR', TRUE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(v_th2,
    'REF_CONSTRAINTS', FALSE, 'TABLE');
  LOOP
    v_doc := DBMS_METADATA.FETCH_DDL(v_hdl);
    EXIT WHEN v_doc IS NULL;
  END LOOP;
  DBMS_METADATA.CLOSE(v_hdl);
END;
/

--Uncomment the code below to execute the code on slide 10_56sa 

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
                      (v_hdl ,'NAME','ORDERS');
 -- request to be TRANSFORMED into creation DDL
 v_th := DBMS_METADATA.ADD_TRANSFORM(v_hdl,'DDL');
 -- FETCH the object
 v_doc := DBMS_METADATA.FETCH_CLOB(v_hdl);
 -- release resources
 DBMS_METADATA.CLOSE(v_hdl);
 RETURN v_doc;
END;
/

--Uncomment the code below to execute the code on slide 10_56na 

set pagesize 0
set long  1000000
SELECT get_table_md FROM dual;


--You can accomplish the same effect with the browsing interface:
SELECT dbms_metadata.get_ddl
      ('TABLE','ORDERS','OE') 
FROM dual;
