-- Use OE Connection

--Uncomment code below to run Task 1 of Practice 09

SELECT count(*),   
       round(avg(quantity_on_hand)) AVG_AMT, 
       product_id, product_name 
FROM inventories natural join product_information
GROUP BY product_id, product_name;
--Uncomment code below to run  Task 2 of Practice 09

SELECT + result_cache 
       count(*),   
       round(avg(quantity_on_hand)) AVG_AMT, 
       product_id, product_name 
FROM inventories natural join product_information
GROUP BY product_id, product_name;
--Uncomment code below to run Task 3 of Practice 09

CREATE OR REPLACE TYPE list_typ IS TABLE OF VARCHAR2(35);
/

CREATE OR REPLACE FUNCTION get_warehouse_names
RETURN list_typ
IS
  v_wh_names list_typ;
BEGIN
  SELECT warehouse_name
  BULK COLLECT INTO v_wh_names
  FROM   warehouses;
  RETURN v_wh_names;
  END get_warehouse_names;
/

