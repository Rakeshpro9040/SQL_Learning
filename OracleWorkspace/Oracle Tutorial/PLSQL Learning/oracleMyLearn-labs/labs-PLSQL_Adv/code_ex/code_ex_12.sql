--This is the SQL Script to run the code_examples for Lesson 12
-- Use OE as the default connection if the connection name is not mentioned.
--Uncomment the code below to execute the code on slide 12_10sa
CREATE OR REPLACE PROCEDURE top_protected_proc
  ACCESSIBLE BY (PROCEDURE top_trusted_proc)
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Executed top_protected_proc.');
END;

CREATE OR REPLACE PROCEDURE top_trusted_proc AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls top_protected_proc');
  top_protected_proc;
END;

SET SERVEROUTPUT ON;

EXECUTE top_trusted_proc;

EXEC top_protected_proc;
--Uncomment the code below to execute the code on slide 12_11sa
CREATE OR REPLACE PACKAGE protected_pkg ACCESSIBLE BY (PROCEDURE top_trusted_proc)
AS
  PROCEDURE public_proc;
  PROCEDURE private_proc;
END;

CREATE OR REPLACE PACKAGE BODY protected_pkg 
AS
  PROCEDURE public_proc AS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Executed protected_pkg.public_proc');
  END;
  PROCEDURE private_proc  AS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Executed protected_pkg.private_proc');
  END;
END;

--Uncomment the code below to execute the code on slide 12_11na
CREATE OR REPLACE PROCEDURE top_trusted_proc 
AS
  BEGIN
     DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls protected_pkg.private_proc ');
     protected_pkg.private_proc;
     protected_pkg.public_proc;
  END;

EXEC top_trusted_proc;

EXEC protected_pkg.public_proc;
--Uncomment the code below to execute the code on slide 12_17sa
CREATE OR REPLACE FUNCTION auth_orders( 
  schema_var IN VARCHAR2,
  table_var  IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  return_val VARCHAR2 (400);
 BEGIN
  return_val := 'SALES_REP_ID = 159';
  RETURN return_val;
 END auth_orders;
/

--Uncomment the code below to execute the code on slide 12_18sa
BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema    => 'oe',
    object_name      => 'orders',
    policy_name      => 'orders_policy',
    function_schema  => 'sys',
    policy_function  => 'auth_orders',
    statement_types  => 'select'
   );
 END;
/

--Uncomment the code below to execute the code on slide 12_18na
SELECT COUNT(*) FROM ORDERS;

SELECT COUNT(*) FROM ORDERS WHERE SALES_REP_ID = 159;
--Uncomment the code below to execute the code on slide 12_22sa 
SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') 
FROM DUAL; 
SELECT SYS_CONTEXT ('USERENV', 'DB_NAME') 
FROM DUAL;

--Uncomment the code below to execute the code on slide 12_23sa
--Execute as PDB1-sys

CREATE or REPLACE CONTEXT order_ctx USING oe.orders_app_pkg;

--Uncomment the code below to execute the code on slide 12_24na
CREATE OR REPLACE PACKAGE orders_app_pkg
IS
 PROCEDURE set_app_context;
END;
/
CREATE OR REPLACE PACKAGE BODY orders_app_pkg
IS
 c_context CONSTANT VARCHAR2(30) := 'ORDER_CTX';
 PROCEDURE set_app_context 
 IS
    v_user VARCHAR2(30);
 BEGIN
  SELECT user INTO v_user FROM dual;
  DBMS_SESSION.SET_CONTEXT
   (c_context, 'ACCOUNT_MGR', v_user);
 END;
END;
/
--Execute the code as a PDB1-sys user before executing the code in slide 25_na 

-- Complete code added
--Execute as PDB1-sys

DROP USER AM145;
CREATE USER am145 IDENTIFIED BY oracle
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 QUOTA UNLIMITED ON USERS;

DROP USER AM147;
CREATE USER am147 IDENTIFIED BY oracle
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 QUOTA UNLIMITED ON USERS;

DROP USER AM148;
CREATE USER am148 IDENTIFIED BY oracle
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 QUOTA UNLIMITED ON USERS;

DROP USER AM149;
CREATE USER am149 IDENTIFIED BY oracle
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 QUOTA UNLIMITED ON USERS;
GRANT create session
    , alter session 
TO am145, am147, am148, am149;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  oe.customers TO AM145, am147, am148, am149;

CREATE PUBLIC SYNONYM customers FOR oe.customers;
/
--Uncomment the code below to execute the code on slide 12_25na 

-- Be sure that you have run the previous step to set up the AM users.
GRANT EXECUTE ON oe.orders_app_pkg 
  TO AM145, AM147, AM148, AM149;

-- Use SQL Plus
CONNECT AM145/oracle

EXECUTE oe.orders_app_pkg.set_app_context

SELECT SYS_CONTEXT('ORDER_CTX', 'ACCOUNT_MGR') FROM dual;

 
-- Use SQL Plus to connect to various users.

CONNECT AM147/oracle

EXECUTE oe.orders_app_pkg.set_app_context

SELECT SYS_CONTEXT('ORDER_CTX', 'ACCOUNT_MGR') FROM dual;

--Uncomment the code below to execute the code on slide 12_30sa 
-- Note: If you have run the code for slide 12_23sa, you do not need to run this script.
--EXECUTE AS PDB1-sys
CREATE OR REPLACE CONTEXT order_ctx USING oe.orders_app_pkg;

--Uncomment the code below to execute the code on slide 12_31sa 

CREATE OR REPLACE PACKAGE orders_app_pkg
IS
 PROCEDURE show_app_context;
 PROCEDURE set_app_context;
 FUNCTION the_predicate
  (p_schema VARCHAR2, p_name VARCHAR2)
   RETURN VARCHAR2;
END orders_app_pkg;    -- package spec
/
--Uncomment the code below to execute the code on slide 12_32na
CREATE OR REPLACE PACKAGE BODY orders_app_pkg
IS
  c_context CONSTANT VARCHAR2(30) := 'ORDER_CTX';
  c_attrib  CONSTANT VARCHAR2(30) := 'ACCOUNT_MGR';

PROCEDURE show_app_context 
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Type: ' || c_attrib || 
   ' - ' || SYS_CONTEXT(c_context, c_attrib));
END show_app_context; 

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
  IF v_context_value LIKE 'AM%'  THEN
    v_restriction := 
     'ACCOUNT_MGR_ID = 
      SUBSTR(''' || v_context_value || ''', 3, 3)'; 
  ELSE 
    v_restriction := null;
  END IF;
  RETURN v_restriction;
END the_predicate;  
 
END orders_app_pkg; -- package body
/

--Uncomment the code below to execute the code on slide 12_33sa

--Execute as PDB1-sys

DECLARE
BEGIN
  DBMS_RLS.ADD_POLICY (
   'OE', 
   'CUSTOMERS', 
   'OE_ACCESS_POLICY', 
   'SYS', 
   'ORDERS_APP_PKG.THE_PREDICATE', 
   'SELECT, UPDATE, DELETE', 
   FALSE, 
   TRUE);
END;

/
begin
dbms_rls.drop_policy('oe','customers','oe_access_policy');
end;
--Uncomment the code below to execute the code on slide 12_34sa 

--Execute as PDB1-sys

CREATE OR REPLACE TRIGGER set_id_on_logon
AFTER logon on DATABASE
BEGIN
  oe.orders_app_pkg.set_app_context;
END;
/

--Uncomment the code below to execute the code on slide 12_35sa

SELECT   COUNT(*), account_mgr_id
FROM     customers
GROUP BY account_mgr_id;
--Uncomment the code below to execute the code on slide 12_35sb
-- Execute using SQL Plus
CONNECT AM148/oracle

SELECT   customer_id, cust_last_name
FROM     oe.customers;

--Uncomment the code below to execute the code on slide 12_37sa 
-- Execute in SQL PLus
CONNECT AM148/oracle

SELECT * 
FROM   all_context;

--Uncomment the code below to execute the code on slide 12_38sa 

SELECT object_name, policy_name, pf_owner, package, function,
       sel, ins, upd, del
FROM all_policies;
