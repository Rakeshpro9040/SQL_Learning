--This is the SQL Script to run the code_examples for Lesson 13

--Uncomment the code below to execute the code on slide 13_06as 

-- First order attack
CREATE OR REPLACE PROCEDURE GET_EMAIL
  (p_last_name VARCHAR2 DEFAULT NULL)
AS
  TYPE    cv_custtyp IS REF CURSOR;
  cv      cv_custtyp;
  v_email customers.cust_email%TYPE;
  v_stmt  VARCHAR2(400);
BEGIN
  v_stmt := 'SELECT cust_email FROM customers 
             WHERE cust_last_name = '''|| p_last_name || '''';
  DBMS_OUTPUT.PUT_LINE('SQL statement: ' || v_stmt);  
  OPEN cv FOR v_stmt;
  LOOP
    FETCH cv INTO v_email;
    EXIT WHEN cv%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Email: '||v_email);
  END LOOP;
  CLOSE cv;
EXCEPTION WHEN OTHERS THEN
  dbms_output.PUT_LINE(sqlerrm);
  dbms_output.PUT_LINE('SQL statement: ' || v_stmt);
END;
/
--Uncomment the code below to execute the code on slide 13_07na 

SET SERVEROUTPUT ON
/

EXECUTE get_email('Andrews')

SET SERVEROUTPUT ON
/

EXECUTE get_email('x'' union select username from all_users where ''x''=''x')
--Uncomment the code below to execute the code on slide 13_10sa

CREATE OR REPLACE PROCEDURE GET_EMAIL 
  (p_last_name VARCHAR2 DEFAULT NULL)
AS
BEGIN
  FOR i IN
    (SELECT cust_email
     FROM customers
     WHERE cust_last_name = p_last_name)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Email: '||i.cust_email);
  END LOOP;
END;
/
--Uncomment the code below to execute the code on slide 13_10sb 

SET SERVEROUTPUT ON
/
EXECUTE get_email('Andrews')
--Uncomment the code below to execute the code on slide 13_10sc

SET SERVEROUTPUT ON
/
EXECUTE get_email('x'' union select username from all_users where ''x''=''x')

--Uncomment the code below to execute the code on slide 13_15sa

--Execute as PDB1-sys

CREATE OR REPLACE
PROCEDURE drop_user(p_username VARCHAR2 DEFAULT NULL)
IS
  v_sql_stmt VARCHAR2(500);
BEGIN
  v_sql_stmt := 'DROP USER '||p_username;
  EXECUTE IMMEDIATE v_sql_stmt;
END drop_user;
/

--Uncomment the code below to execute the code on slide 13_15sb 
--Execute as PDB1-sys
GRANT EXECUTE ON drop_user to OE, HR, SH ;
--Uncomment the code below to execute the code on slide 13_16sa 
--Execute as OE
EXECUTE sys.drop_user ('AM147');
-- To check the drop_user function execution 

SELECT * FROM ALL_USERS WHERE USERNAME = 'AM147';

--Uncomment the code below to execute the code on slide 13_16sb 

--Execute as PDB1-sys

CREATE OR REPLACE
PROCEDURE drop_user(p_username VARCHAR2 DEFAULT NULL,
                          p_new_password VARCHAR2 DEFAULT NULL)
AUTHID CURRENT_USER
IS
  v_sql_stmt VARCHAR2(500);
BEGIN
  v_sql_stmt := 'DROP USER '||p_username;
  EXECUTE IMMEDIATE v_sql_stmt;
END drop_user;
/
--Execute as PDB1-sys
GRANT EXECUTE ON drop_user to OE, HR, SH ;

--Execute as OE

EXECUTE sys.drop_user ('AM148')

/
--Create the users you have dropped by executing the code in code_ex_12, slide 12_25na
--Uncomment the code below to execute the code on slide 13_20sa

CREATE OR REPLACE PROCEDURE list_products_dynamic 
(p_product_name VARCHAR2 DEFAULT NULL) 
AS
  TYPE cv_prodtyp IS REF CURSOR;
  cv   cv_prodtyp;
  v_prodname product_information.product_name%TYPE;
  v_minprice product_information.min_price%TYPE;
  v_listprice product_information.list_price%TYPE;
  v_stmt  VARCHAR2(400);
BEGIN
  v_stmt := 'SELECT product_name, min_price, list_price 
             FROM product_information WHERE product_name LIKE
             ''%'||p_product_name||'%''';
  OPEN cv FOR v_stmt;
  dbms_output.put_line(v_stmt);
  LOOP
    FETCH cv INTO v_prodname, v_minprice, v_listprice;
    EXIT WHEN cv%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Product Info: '||v_prodname ||', '||
                          v_minprice ||', '|| v_listprice);
  END LOOP;
  CLOSE cv;
END;
/

--Uncomment the code below to execute the code on slide 13_20na 

SET SERVEROUTPUT ON

EXECUTE list_products_dynamic(''' and 1=0 union select cast(username as varchar2(100)), null, null from all_users --')
--Uncomment the code below to execute the code on slide 13_21sa 
CREATE OR REPLACE PROCEDURE list_products_static 
  (p_product_name VARCHAR2 DEFAULT NULL)
AS
  v_bind  VARCHAR2(400);
BEGIN
  v_bind := '%'||p_product_name||'%';
  FOR i in 
    (SELECT product_name, min_price, list_price 
     FROM product_information
     WHERE product_name like v_bind)
  LOOP
      DBMS_OUTPUT.PUT_LINE('Product Info: '||i.product_name ||',
         '|| i.min_price ||', '|| i.list_price);
  END LOOP;
END list_products_static;
/

--Uncomment the code below to execute the code on slide 13_21na 
SET SERVEROUTPUT ON
EXECUTE list_products_static('Laptop')

EXECUTE list_products_static(''' and 1=0 union select cast(username as varchar2(100)), null, null from all_users --')
--Uncomment the code below to execute the code on slide 13_30sa

SELECT count(*) records FROM orders;

SELECT num_rows FROM user_tables
WHERE table_name = 'ORDERS';

--this one generates an error...
SELECT count(*) records FROM "orders";

--Uncomment the code below to execute the code on slide 13_35na

--Execute as hr
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE show_col (p_colname varchar2, p_tablename   varchar2)
AS 
type t is varray(200) of varchar2(25);
Results t;
Stmt CONSTANT VARCHAR2(4000) :=
  'SELECT '|| p_colname || ' FROM '|| p_tablename ;

BEGIN
DBMS_Output.Put_Line ('SQL Stmt: ' || Stmt);
EXECUTE IMMEDIATE Stmt bulk collect into Results;
for j in 1..Results.Count() 
loop
DBMS_Output.Put_Line(Results(j));
end loop;
--EXCEPTION WHEN OTHERS THEN
--Raise_Application_Error(-20000, 'Wrong table name');
END show_col;
/
--Uncomment the code below to execute the code on slide 13_36na
execute show_col('Email','EMPLOYEES');
-- This is an SQL injection query where all the usernames will be displayed instead of email ids of the employees
execute show_col('Email','EMPLOYEES where 1=2 union select Username c1 from All_Users --');
CREATE OR REPLACE PROCEDURE show_col2 (p_colname varchar2, p_tablename   varchar2)
AS
type t is varray(200) of varchar2(25);
Results t; 
Stmt CONSTANT VARCHAR2(4000) :=
'SELECT '||dbms_assert.simple_sql_name( p_colname ) || ' FROM '|| dbms_assert.simple_sql_name( p_tablename ) ;

BEGIN
DBMS_Output.Put_Line ('SQL Stmt: ' || Stmt);
EXECUTE IMMEDIATE Stmt bulk collect into Results;
for j in 1..Results.Count() 
loop
DBMS_Output.Put_Line(Results(j));
end loop;
EXCEPTION WHEN OTHERS THEN
  Raise_Application_Error(-20000, 'Wrong table name');
END show_col2;
/
execute show_col2('Email','EMPLOYEES');
--DBMS_ASSERT.SIMPLE_SQL_NAME function comes into action now to prevent SQL injection.
execute show_col2('Email','EMPLOYEES where 1=2 union select Username c1 from All_Users --');

