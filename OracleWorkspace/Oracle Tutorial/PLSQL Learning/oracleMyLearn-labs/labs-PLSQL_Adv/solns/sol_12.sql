-- Use OE Connection

-- Note: Use SQL Plus to complete this practice

--Verifying the ORDERS table

DESCRIBE ORDERS;

SELECT sales_rep_id, count(*) 
FROM orders
GROUP BY sales_rep_id
order by sales_rep_id;

--Uncomment code below to run the solution for Task 2 of Practice 12

--Execute as PDB1-sys
CREATE CONTEXT sales_orders_ctx USING oe.sales_orders_pkg;

--Uncomment code below to run the solution for Task 3 of Practice 12

CREATE OR REPLACE PACKAGE sales_orders_pkg
IS
 PROCEDURE set_app_context;
 FUNCTION the_predicate
  (p_schema VARCHAR2, p_name VARCHAR2)
   RETURN VARCHAR2;
END sales_orders_pkg;    -- package spec
/

CREATE OR REPLACE PACKAGE BODY sales_orders_pkg
IS
  c_context CONSTANT VARCHAR2(30) := 'SALES_ORDERS_CTX';
  c_attrib  CONSTANT VARCHAR2(30) := 'SALES_REP';

PROCEDURE set_app_context 
  IS
    v_user VARCHAR2(30);
BEGIN
  SELECT user INTO v_user FROM dual;
  DBMS_SESSION.SET_CONTEXT
    (c_context, c_attrib, v_user);
END set_app_context;

FUNCTION the_predicate 
(p_schema VARCHAR2, p_name VARCHAR2) 
RETURN VARCHAR2
IS
  v_context_value VARCHAR2(100) := 
     SYS_CONTEXT(c_context, c_attrib);
  v_restriction VARCHAR2(2000);
BEGIN
  IF v_context_value LIKE 'SR%'  THEN
    v_restriction := 
     'SALES_REP_ID = 
      SUBSTR(''' || v_context_value || ''', 3, 3)'; 
  ELSE 
    v_restriction := null;
  END IF;
  RETURN v_restriction;
END the_predicate;  
 
END sales_orders_pkg; -- package body
/

--Uncomment code below to run the solution for Task 4 of Practice 12

--Execute as PDB1-sys

DECLARE
BEGIN
  DBMS_RLS.ADD_POLICY (
   'OE', 
   'ORDERS', 
   'OE_ORDERS_ACCESS_POLICY', 
   'OE', 
   'SALES_ORDERS_PKG.THE_PREDICATE', 
   'SELECT, UPDATE, DELETE', 
   FALSE, 
   TRUE);
END;
/

--Uncomment code below to run the solution for Task 5 of Practice 12

--Execute as PDB1-sys

CREATE OR REPLACE TRIGGER set_id_on_logon
AFTER logon on DATABASE
BEGIN
  oe.sales_orders_pkg.set_app_context;
END;
/

--Uncomment code below to run the solution for Task 6 of Practice 12
-- Use SQL Plus
CONNECT sr153/oracle@pdborcl

SELECT sales_rep_id, COUNT(*)
FROM   orders
GROUP BY sales_rep_id;

CONNECT sr154/oracle

SELECT sales_rep_id, COUNT(*)
FROM   orders
GROUP BY sales_rep_id;

CONNECT oe/oe@pdborcl

