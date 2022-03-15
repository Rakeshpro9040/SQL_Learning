-- Use OE Connection
--Uncomment code below to run the solution for Task 3_a of Practice 09

CREATE OR REPLACE TYPE list_typ IS TABLE OF VARCHAR2(35);
/

CREATE OR REPLACE FUNCTION get_warehouse_names
RETURN list_typ
IS
  v_count BINARY_INTEGER;
  v_wh_names list_typ;
BEGIN
  SELECT count(*) 
    INTO v_count
    FROM warehouses;
  FOR i in 1..v_count LOOP
    SELECT warehouse_name
    INTO v_wh_names(i)
    FROM warehouses;
  END LOOP;
  RETURN v_wh_names;
END get_warehouse_names;  
/

--Uncomment code below to run the solution for Task 4 of Practice 09

CREATE OR REPLACE FUNCTION get_warehouse_names
RETURN list_typ
RESULT_CACHE RELIES_ON (warehouses)
IS
  v_count BINARY_INTEGER;
  v_wh_names list_typ:=list_typ();
BEGIN
  SELECT count(*) 
    INTO v_count
    FROM warehouses;
  v_wh_names.extend(v_count);
  FOR i in 1..v_count LOOP
    SELECT warehouse_name
    INTO v_wh_names(i)
    FROM warehouses
     WHERE warehouse_id=i;
  END LOOP;
  RETURN v_wh_names;
END get_warehouse_names;
/

select * from table(get_warehouse_names)
/

