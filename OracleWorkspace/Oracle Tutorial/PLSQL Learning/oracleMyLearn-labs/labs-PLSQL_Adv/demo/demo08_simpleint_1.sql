-- Use OE connection

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE p 
IS
  t0       NUMBER :=0;  
  t1       NUMBER :=0;

 $IF $$Simple $THEN
  SUBTYPE My_Integer_t IS                     SIMPLE_INTEGER;
  My_Integer_t_Name CONSTANT VARCHAR2(30) := 'SIMPLE_INTEGER';
 $ELSE
  SUBTYPE My_Integer_t IS                     PLS_INTEGER;
  My_Integer_t_Name CONSTANT VARCHAR2(30) := 'PLS_INTEGER';
 $END

 v00  My_Integer_t := 0;     v01  My_Integer_t := 0;
 v02  My_Integer_t := 0;     v03  My_Integer_t := 0;
 v04  My_Integer_t := 0;     v05  My_Integer_t := 0;

 two      CONSTANT My_Integer_t := 2;
 lmt      CONSTANT My_Integer_t := 100000000;

BEGIN
  t0 := DBMS_UTILITY.GET_CPU_TIME();
  WHILE v01 < lmt LOOP
    v00 := v00 + Two;     
    v01 := v01 + Two;
    v02 := v02 + Two;    
    v03 := v03 + Two;
    v04 := v04 + Two;     
    v05 := v05 + Two;
  END LOOP;

  IF v01 <> lmt OR v01 IS NULL THEN
    RAISE Program_Error;
  END IF;

  t1 := DBMS_UTILITY.GET_CPU_TIME();
  DBMS_OUTPUT.PUT_LINE(
    RPAD(LOWER($$PLSQL_Code_Type), 15)||
    RPAD(LOWER(My_Integer_t_Name), 15)||
    TO_CHAR((t1-t0), '9999')||' centiseconds');
END p;
/


