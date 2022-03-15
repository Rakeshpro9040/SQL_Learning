--Use OE connection
--Purpose: demonstrate the time difference with using a BULK BIND
--Steps:   Run the script below. 
--         The first FOR LOOP doesn't use bulk binding.
--         The second FOR LOOP does use bulk binding. So the second loop should execute in lesser time
--         Also point out the use of a subprogram in the declarative section of
--         this program.

DROP TABLE parts
/
set serveroutput on
CREATE TABLE parts (pnum NUMBER(8), pname CHAR(15))
/

DECLARE
  TYPE NumTab IS TABLE OF NUMBER(8) 
    INDEX BY BINARY_INTEGER;
  TYPE NameTab IS TABLE OF CHAR(15) 
    INDEX BY BINARY_INTEGER;
  pnums  NumTab;
  pnames NameTab;
  t1 CHAR(5);
  t2 CHAR(5);
  t3 CHAR(5);
  PROCEDURE get_time (t OUT NUMBER) IS
  BEGIN 
    t := DBMS_UTILITY.GET_CPU_TIME();
  END;
  BEGIN
    FOR j IN 1..20000 LOOP  -- load index-by tables
      pnums(j) := j;
      pnames(j) := 'Part No. ' || TO_CHAR(j); 
    END LOOP;
    get_time(t1);
    FOR i IN 1..20000 LOOP  -- use FOR loop
      INSERT INTO parts 
        VALUES (pnums(i), pnames(i));
    END LOOP;
    get_time(t2);
    FORALL i IN 1..5000  -- use FORALL statement
      INSERT INTO parts 
        VALUES (pnums(i), pnames(i)); 
    get_time(t3);
    DBMS_OUTPUT.PUT_LINE('Execution Time (secs)');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('FOR loop: ' || TO_CHAR(t2 - t1));
    DBMS_OUTPUT.PUT_LINE('FORALL:   ' || TO_CHAR(t3 - t2));
 END;
/
