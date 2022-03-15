--   Use oe connection
-- This script demonstrates the usage of FIRST, LAST and EXISTS methods
-- Expected output here is displaying the elements of the collection in the order of the index
SET SERVEROUTPUT ON
CLEAR SCREEN
/*
*********************************************
Courtesy of: David Jacob-Daub
PURPOSE: To demonstrate sparse ASSOCIATIVE ARRAY
navigation using FIRST, LAST AND EXISTS methods.
Note that the array is ordered by min to max by Oracle. If
you fail to use the EXISTS method in the loop you will fail
due to NO DATA FOUND error on the second iteration of 
the loop.
*********************************************
*/

DECLARE
  TYPE pltab_typ is table of employees.last_name%type
    INDEX BY PLS_INTEGER;
  dem_tab pltab_typ;
BEGIN
  dem_tab(9) := 'NINE';
  dem_tab(4) := 'FOUR';
  dem_tab(6) := 'SIX';
  dem_tab(14) := 'FOURTEEN';
  dem_tab(100) := 'HUNDRED';
  FOR i IN dem_tab.FIRST..dem_tab.LAST LOOP
    IF  dem_tab.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE('Value at iteration is: '||dem_tab(i));
    END IF;
  END LOOP;
END;
/
