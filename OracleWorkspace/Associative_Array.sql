--SET SERVEROUTPUT ON
DECLARE
  -- declare an associative array type
  TYPE t_capital_type IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(50);
  -- declare a variable of the t_capital_type
  t_capital t_capital_type;
  -- local variable
  l_country VARCHAR2(50);
BEGIN

  t_capital('USA') := 'Washington, D.C.';
  t_capital('United Kingdom') := 'London';
  t_capital('Japan') := 'Tokyo';

  l_country := t_capital.FIRST;

  WHILE l_country IS NOT NULL LOOP
    dbms_output.put_line('The capital of ' || l_country || ' is ' ||
                         t_capital(l_country));
    l_country := t_capital.NEXT(l_country);
  END LOOP;
END;