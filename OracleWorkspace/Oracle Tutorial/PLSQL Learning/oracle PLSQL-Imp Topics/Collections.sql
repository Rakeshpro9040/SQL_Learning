/*
https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-collections-and-records.html
https://oracle-base.com/articles/8i/collections-8i
*/

-- Index-By Tables (Associative Arrays)
SET SERVEROUTPUT ON
DECLARE
  TYPE table_type IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
  v_tab  table_type;
  v_idx  NUMBER;
BEGIN
  -- Initialise the collection.
  << load_loop >>
  FOR i IN 1 .. 5 LOOP
    v_tab(i) := i*2;
  END LOOP load_loop;
  
  -- Delete the third item of the collection.
  v_tab.DELETE(3);
  
  -- Traverse sparse collection
  v_idx := v_tab.FIRST;
  << display_loop >>
  WHILE v_idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('The number ' || v_tab(v_idx));
    v_idx := v_tab.NEXT(v_idx);
  END LOOP display_loop;

  -- Using for loop
  for i in v_tab.first .. v_tab.last loop
    --dbms_output.put_line(i);
    --dbms_output.put_line('The number ' || v_tab(i)); -- This will result in error due to index 3 has been deleted
    if v_tab.exists(i) then 
        dbms_output.put_line('The number ' || v_tab(i)); 
    else 
        dbms_output.put_line('The number does not exist for index ' || i); 
    end if;
END;
/

SET SERVEROUTPUT ON
DECLARE
  TYPE country_tab IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(5);
  t_country country_tab;
BEGIN

  -- Populate lookup
  t_country('UK') := 'United Kingdom';
  t_country('US') := 'United States of America';
  t_country('FR') := 'France';
  t_country('DE') := 'Germany';
  
  -- Find country name for ISO code "DE"
  DBMS_OUTPUT.PUT_LINE('ISO code "DE" = ' || t_country('DE'));

END;
/

-- Nested Table Collections
SET SERVEROUTPUT ON
DECLARE
  TYPE table_type IS TABLE OF NUMBER(10);
  v_tab  table_type;
  v_idx  NUMBER;
BEGIN

  -- Initialise the collection with two values.
  v_tab := table_type(1, 2);

  -- Extend the collection with extra values.
  << load_loop >>
  FOR i IN 3 .. 5 LOOP
    v_tab.extend;
    v_tab(v_tab.last) := i;
  END LOOP load_loop;
  
  -- Delete the third item of the collection.
  v_tab.DELETE(3);
  
  -- Traverse sparse collection
  v_idx := v_tab.FIRST;
  << display_loop >>
  WHILE v_idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('The number ' || v_tab(v_idx));
    v_idx := v_tab.NEXT(v_idx);
  END LOOP display_loop;

  -- Using for loop
  for i in v_tab.first .. v_tab.last loop
    --dbms_output.put_line(i);
    --dbms_output.put_line('The number ' || v_tab(i)); -- This will result in error due to index 3 has been deleted
    if v_tab.exists(i) then 
        dbms_output.put_line('The number ' || v_tab(i)); 
    else 
        dbms_output.put_line('The number does not exist for index ' || i); 
    end if;
  end loop;
END;
/

-- Varray Collections
SET SERVEROUTPUT ON
DECLARE
  TYPE table_type IS VARRAY(5) OF NUMBER(10);
  v_tab  table_type;
  v_idx  NUMBER;
BEGIN
  -- Initialise the collection with two values.
  v_tab := table_type(1, 2);

  -- Extend the collection with extra values.
  << load_loop >>
  FOR i IN 3 .. 5 LOOP
    v_tab.extend;
    v_tab(v_tab.last) := i;
  END LOOP load_loop;
  
  -- Can't delete from a VARRAY.
  -- v_tab.DELETE(3);

  -- Traverse collection
  v_idx := v_tab.FIRST;
  << display_loop >>
  WHILE v_idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('The number ' || v_tab(v_idx));
    v_idx := v_tab.NEXT(v_idx);
  END LOOP display_loop;
END;
/

-- Assignments and Equality Tests
SET SERVEROUTPUT ON
DECLARE
  TYPE table_type IS TABLE OF NUMBER(10);
  TYPE table_typex IS TABLE OF NUMBER(10);
  v_tab_1  table_type;
  v_tab_2  table_type;
  v_tab_3  table_typex;
  v_tab_4  table_type;  
BEGIN
  -- Initialise the collection with two values.
  v_tab_1 := table_type(1, 2);
  v_tab_2 := v_tab_1;
  --v_tab_3 := v_tab_1; -- Though similar structure, but not same type, hence fails

  IF v_tab_1 = v_tab_2 THEN
    DBMS_OUTPUT.put_line('1: v_tab_1 = v_tab_2');
  END IF;

  v_tab_1 := table_type(1, 2, 3);

  IF v_tab_1 != v_tab_2 THEN
    DBMS_OUTPUT.put_line('2: v_tab_1 != v_tab_2');
  END IF;

  v_tab_4 := table_type();
END;
/

-- Collection Methods
/*
    EXISTS(n) - Returns TRUE if the specified element exists.
    COUNT - Returns the number of elements in the collection.
    LIMIT - Returns the maximum number of elements for a VARRAY, or NULL for nested tables.
    FIRST - Returns the index of the first element in the collection.
    LAST - Returns the index of the last element in the collection.
    PRIOR(n) - Returns the index of the element prior to the specified element.
    NEXT(n) - Returns the index of the next element after the specified element.
    EXTEND - Appends a single null element to the collection.
    EXTEND(n) - Appends n null elements to the collection.
    EXTEND(n1,n2) - Appends n1 copies of the n2th element to the collection.
    TRIM - Removes a single element from the end of the collection.
    TRIM(n) - Removes n elements from the end of the collection.
    DELETE - Removes all elements from the collection.
    DELETE(n) - Removes element n from the collection.
    DELETE(n1,n2) - Removes all elements from n1 to n2 from the collection.
*/

-- MULTISET Operations
-- MULTISET operations/conditions are not applicable for associative arrays
DECLARE
  TYPE t_tab IS TABLE OF NUMBER(10) index by pls_integer;
  l_tab1 t_tab;
  l_tab2 t_tab;
BEGIN
  for i in 1 .. 5 loop
    l_tab1(i) := i*2;
    l_tab2(i) := I*3;
  end loop;

  /*
  l_tab1 := l_tab1 MULTISET UNION l_tab2; -- PLS-00306: wrong number or types of arguments in call to 'MULTISET_UNION_ALL'

  if 8 MEMBER OF l_tab1 then
    dbms_output.put_line('TRUE'); -- PLS-00306: wrong number or types of arguments in call to 'MEMBER OF'
  else
    dbms_output.put_line('FALSE');
  end if;
  */
  
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;

END;
/

-- MULTISET operations/conditions are not applicable for VARRAYs
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS VARRAY(5) OF VARCHAR2(2);
  l_tab1 t_tab := t_tab(1,2,3,4,'A');
BEGIN
  DBMS_OUTPUT.put('Is A MEMBER OF l_tab1? ');
  IF 'A' MEMBER OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- TRUE
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;
END;
/

-- The MULTISET UNION and MULTISET UNION ALL operators are functionally equivalent (same as sql UNION ALL)
    -- The DISTINCT keyword can be added to any of the multiset operations to removes the duplicates (same as sql UNION)
    -- The NOT keyword can be included to get the inverse
-- The MULTISET EXCEPT operator returns the elements of the first set that are not present in the second set (same as sql MINUS)
-- The MULTISET INTERSECT operator returns the elements that are present in both sets (same as sql INTERSECT )
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab t_tab := t_tab(1,2,3,4,5,6,7,8,9,10);
  l_tab1 t_tab := t_tab(1,2,3,4,5,6,7,8,9,10);
  l_tab2 t_tab := t_tab(6,7,8,9,10);
  l_tabx t_tab;  
BEGIN
  dbms_output.put_line('******* MULTISET UNION *******');
  l_tab1 := l_tab1 MULTISET UNION l_tab2;
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;

  dbms_output.put_line(chr(10) || '******* MULTISET UNION DISTINCT *******');
  l_tab1 := l_tab1 MULTISET UNION DISTINCT l_tab2;
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;  

  dbms_output.put_line(chr(10) || '******* MULTISET EXCEPT *******');
  l_tab1 := l_tab1 MULTISET EXCEPT l_tab2;
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;  

  dbms_output.put_line(chr(10) || '******* MULTISET INTERSECT *******');
  l_tab1 := l_tab;
  l_tab1 := l_tab1 MULTISET INTERSECT l_tab2;
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;  

  dbms_output.put_line(chr(10) || '******* MULTISET INTERSECT *******');
  l_tab1 := l_tab;
  l_tabx := l_tab1 MULTISET INTERSECT l_tab2;
  FOR i IN l_tabx.first .. l_tabx.last LOOP
    DBMS_OUTPUT.put_line(l_tabx(i));
  END LOOP;    
END;
/

-- The IS {NOT} A SET condition is used to test if a collection is populated by unique elements, or not
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_null_tab      t_tab := NULL;
  l_empty_tab     t_tab := t_tab();
  l_set_tab       t_tab := t_tab(1,2,3,4);
  l_not_set_tab   t_tab := t_tab(1,2,3,4,4,4);

  FUNCTION display (p_in BOOLEAN) RETURN VARCHAR2 AS
  BEGIN
    IF p_in IS NULL THEN
      RETURN 'NULL';
    ELSIF p_in THEN
      RETURN 'TRUE';
    ELSE
      RETURN 'FALSE';
    END IF;
  END;
BEGIN
  DBMS_OUTPUT.put_line('l_null_tab IS A SET          = ' || display(l_null_tab IS A SET)); -- NULL
  DBMS_OUTPUT.put_line('l_null_tab IS NOT A SET      = ' || display(l_null_tab IS NOT A SET)); -- NULL
  DBMS_OUTPUT.put_line('l_empty_tab IS A SET         = ' || display(l_empty_tab IS A SET)); -- TRUE
  DBMS_OUTPUT.put_line('l_empty_tab IS NOT A SET     = ' || display(l_empty_tab IS NOT A SET));
  DBMS_OUTPUT.put_line('l_set_tab IS A SET           = ' || display(l_set_tab IS A SET)); -- TRUE
  DBMS_OUTPUT.put_line('l_set_tab IS NOT A SET       = ' || display(l_set_tab IS NOT A SET));
  DBMS_OUTPUT.put_line('l_not_set_tab IS A SET       = ' || display(l_not_set_tab IS A SET)); --FALSE
  DBMS_OUTPUT.put_line('l_not_set_tab IS NOT A SET   = ' || display(l_not_set_tab IS NOT A SET));
END;
/

-- The IS {NOT} EMPTY condition is used to test if a collection is empty, or not
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_null_tab      t_tab := NULL;
  l_empty_tab     t_tab := t_tab();
  l_not_empty_tab t_tab := t_tab(1,2,3,4,4,4);

  FUNCTION display (p_in BOOLEAN) RETURN VARCHAR2 AS
  BEGIN
    IF p_in IS NULL THEN
      RETURN 'NULL';
    ELSIF p_in THEN
      RETURN 'TRUE';
    ELSE
      RETURN 'FALSE';
    END IF;
  END;
BEGIN
  DBMS_OUTPUT.put_line('l_null_tab IS EMPTY          = ' || display(l_null_tab IS EMPTY)); --NULL
  DBMS_OUTPUT.put_line('l_null_tab IS NOT EMPTY      = ' || display(l_null_tab IS NOT EMPTY)); --NULL
  DBMS_OUTPUT.put_line('l_empty_tab IS EMPTY         = ' || display(l_empty_tab IS EMPTY)); --TRUE
  DBMS_OUTPUT.put_line('l_empty_tab IS NOT EMPTY     = ' || display(l_empty_tab IS NOT EMPTY));
  DBMS_OUTPUT.put_line('l_not_empty_tab IS EMPTY     = ' || display(l_not_empty_tab IS EMPTY)); --FALSE
  DBMS_OUTPUT.put_line('l_not_empty_tab IS NOT EMPTY = ' || display(l_not_empty_tab IS NOT EMPTY));
END;
/

-- The MEMBER condition allows you to test if an element is member of a collection
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF VARCHAR2(2);
  l_tab1 t_tab := t_tab(1,2,3,4,'A');
BEGIN
  DBMS_OUTPUT.put('Is A MEMBER OF l_tab1? ');
  IF 'A' MEMBER OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- TRUE
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;
END;
/

-- The SUBMULTISET condition returns true if the first collection is a subset of the second.
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab1 t_tab := t_tab(1,2,3,4,5);
  l_tab2 t_tab := t_tab(1,3,2);
  l_tab3 t_tab := t_tab(1,2,3,7);
  l_tab4 t_tab := t_tab(1,2,3,3);
BEGIN
  DBMS_OUTPUT.put('Is l_tab2 SUBMULTISET OF l_tab1? ');
  IF l_tab2 SUBMULTISET OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- TRUE
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;

  DBMS_OUTPUT.put('Is l_tab3 SUBMULTISET OF l_tab1? ');
  IF l_tab3 SUBMULTISET OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- FALSE
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;

  DBMS_OUTPUT.put('Is l_tab3 SUBMULTISET OF l_tab1? ');
  IF l_tab3 NOT SUBMULTISET OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- TRUE, due to the NOT operator
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;

  DBMS_OUTPUT.put('Is l_tab4 SUBMULTISET OF l_tab1? ');
  IF l_tab4 SUBMULTISET OF l_tab1 THEN
    DBMS_OUTPUT.put_line('TRUE'); -- FALSE, due to duplicate 3
  ELSE
    DBMS_OUTPUT.put_line('FALSE');  
  END IF;
END;
/

-- MULTISET Functions (for SQL)
CREATE OR REPLACE TYPE t_number_tab AS TABLE OF NUMBER(10);
/

-- The CARDINALITY function returns the number of elements in the collection (similar to COUNT collection method)
select tab1, CARDINALITY(tab1)
from 
(
  select t_number_tab(1,2,3,4) AS tab1
  from dual
);

select * from TABLE(t_number_tab(1,2,3,4)) order by 1 desc;

select CAST(MULTISET(select * from TABLE(t_number_tab(1,2,3,4)) order by 1 desc) AS t_number_tab) cast_to_collection
from dual;

SET SERVEROUTPUT ON
DECLARE
  l_tab1 t_number_tab := t_number_tab(1,2,3,4,5);
BEGIN
  DBMS_OUTPUT.put_line('COUNT       = ' || l_tab1.COUNT);
  DBMS_OUTPUT.put_line('CARDINALITY = ' || CARDINALITY(l_tab1));
END;
/

-- The POWERMULTISET function accepts a nested table and returns a "nested table of nested tables" containing all the possible subsets from the original nested table
SELECT * FROM TABLE(POWERMULTISET(t_number_tab (1,2,3,4)));

-- The POWERMULTISET_BY_CARDINALITY function is similar to the POWERMULTISET function, but it allows us to limit the output to just those subsets that have the specified cardinality
SELECT * FROM TABLE(POWERMULTISET_BY_CARDINALITY(t_number_tab (1,2,3,4),3));

-- The SET function returns a collection containing the distinct values from a collection
SELECT tab1 AS basic_out,
       SET(tab1) AS set_out,
       CARDINALITY(tab1) AS card_out,
       CARDINALITY(SET(tab1)) AS card_set
FROM (SELECT t_number_tab (1, 2, 3, 4, 4, 4) AS tab1 FROM dual);
