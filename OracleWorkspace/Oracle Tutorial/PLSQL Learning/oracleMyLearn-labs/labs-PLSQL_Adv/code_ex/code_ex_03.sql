--This is the SQL Script to run the code_examples for Lesson 3
--Use OE as the default connection if the connection name is not mentioned.

-- Associative array example-1
--Uncomment the code below to execute the code on slide 03_11sa 

--Execute as oe/oe
CREATE OR REPLACE PROCEDURE report_credit
  (p_last_name    customers.cust_last_name%TYPE,
   p_credit_limit customers.credit_limit%TYPE)
IS
  TYPE  typ_name IS TABLE OF customers%ROWTYPE 
    INDEX BY customers.cust_email%TYPE;
  v_by_cust_email   typ_name;
  i VARCHAR2(50);

  PROCEDURE load_arrays IS
  BEGIN
    FOR rec IN  (SELECT * FROM customers WHERE cust_email IS NOT NULL)
      LOOP
        -- Load up the array in single pass to database table.
         v_by_cust_email (rec.cust_email) := rec;
      END LOOP;
  END;

BEGIN
  load_arrays;
  i:= v_by_cust_email.FIRST;
  dbms_output.put_line ('For credit amount of: ' || p_credit_limit);
  WHILE i IS NOT NULL LOOP    
    --dbms_output.put_line(i);
    IF (v_by_cust_email(i).cust_last_name = p_last_name 
    AND v_by_cust_email(i).credit_limit > p_credit_limit) or i = 'Dom.Hoskins@AVOCET.EXAMPLE.COM'
      THEN dbms_output.put_line ( 'Customer '|| 
        v_by_cust_email(i).cust_last_name || ': ' || 
        v_by_cust_email(i).cust_email || ' has credit limit of: ' ||
        v_by_cust_email(i).credit_limit);
    END IF;
    i := v_by_cust_email.NEXT(i);
  END LOOP;
END report_credit;
/

--Uncomment the code below to execute the code on slide 03_12sb


--You may get a different output if you have the practices
--Of this lesson before executing this script
SET SERVEROUTPUT ON

EXECUTE report_credit('Walken', 1200)

/*
Old Output:
For credit amount of: 1200
Customer Walken: Emmet.Walken@LIMPKIN.EXAMPLE.COM has credit limit of: 3600
Customer Walken: Prem.Walken@BRANT.EXAMPLE.COM has credit limit of: 3700
*/

-- Testing for duplicate key, run customers_insert.sql
SELECT * FROM customers WHERE cust_email IS NOT NULL;
SELECT cust_email, count(*)
FROM customers 
WHERE cust_email IS NOT NULL
group by cust_email
having count(*) > 1;

/*
New Output: Here you can see Customer P has overwritten the old record.
For credit amount of: 1200
Customer P: Dom.Hoskins@AVOCET.EXAMPLE.COM has credit limit of: 5000 
Customer Walken: Emmet.Walken@LIMPKIN.EXAMPLE.COM has credit limit of: 3600
Customer Walken: Prem.Walken@BRANT.EXAMPLE.COM has credit limit of: 3700
*/

-- Cleanup
delete from customers where customer_id = 999;

--  Associative array example-2
--Uncomment the code below to execute the code on slide 03_13na 

--Execute as oe/oe
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE report_credit
  (p_email    customers.cust_email%TYPE,
   p_credit_limit customers.credit_limit%TYPE)
IS
  TYPE  typ_name IS TABLE OF customers%ROWTYPE 
    INDEX BY customers.cust_email%TYPE;
  v_by_cust_email   typ_name;
  i VARCHAR2(50);

  PROCEDURE load_arrays IS
  BEGIN
    FOR rec IN  (SELECT * FROM customers 
                 WHERE cust_email IS NOT NULL) LOOP
        v_by_cust_email (rec.cust_email) := rec;
    END LOOP;
  END;

BEGIN
  load_arrays;
  dbms_output.put_line 
    ('For credit amount of: ' || p_credit_limit);
  IF v_by_cust_email(p_email).credit_limit > p_credit_limit
        THEN dbms_output.put_line ( 'Customer '|| 
          v_by_cust_email(p_email).cust_last_name || 
          ': ' || v_by_cust_email(p_email).cust_email ||
          ' has credit limit of: ' ||
          v_by_cust_email(p_email).credit_limit);
  END IF;
END report_credit;
/
SET SERVEROUTPUT ON;
EXECUTE report_credit('Prem.Walken@BRANT.EXAMPLE.COM', 100)
/*
output:

For credit amount of: 100
Customer Hoskins: Dom.Hoskins@AVOCET.EXAMPLE.COM has credit limit of: 5000
*/

-- Nested table example-1
--Uncomment the code below to execute the code on slide 03_18sa 

DECLARE
  TYPE names IS TABLE OF VARCHAR2(15);
  v_names  names := names('Kelly','Ken', 'Prem', 'Farrah'); -- Single column of same datatype
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Values in the nested table');
    FOR i IN v_names.FIRST .. v_names.LAST LOOP  -- For first to last element
      DBMS_OUTPUT.PUT_LINE('v_names('|| i ||') - '||v_names(i));
    END LOOP;
 END;

-- Nested table example-2 (nested table stored in database)
--Uncomment the code below to execute the code on slide 03_20sa 

--Execute as oe/oe
SET SERVEROUTPUT ON
CREATE TYPE typ_item AS OBJECT  --create object
 (prodid  NUMBER(5),
  price   NUMBER(7,2) )
/
CREATE TYPE typ_item_nst -- define nested table type
  AS TABLE OF typ_item
/
DROP TABLE pOrder;
CREATE TABLE pOrder (  -- create database table
     ordid	NUMBER(5),
     supplier	NUMBER(5),
     requester	NUMBER(4),
     ordered	DATE,
     items	typ_item_nst)
     NESTED TABLE items STORE AS item_stor_tab
/

--Uncomment the code below to execute the code on slide 03_21sa

--Execute as oe/oe
SET SERVEROUTPUT ON
INSERT INTO pOrder
  VALUES (500, 50, 5000, sysdate, typ_item_nst(
     typ_item(55, 555),
     typ_item(56, 566), 
     typ_item(57, 577)));

INSERT INTO pOrder
  VALUES (800, 80, 8000, sysdate,
    typ_item_nst (typ_item (88, 888)));

--Uncomment the code below to execute the code on slide 03_22sa 

--Execute as oe/oe
SELECT * FROM porder;
/*
Ouput:
     ORDID   SUPPLIER  REQUESTER ORDERED   ITEMS(PRODID, PRICE)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
---------- ---------- ---------- --------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       500         50       5000 18-FEB-22 TYP_ITEM_NST(TYP_ITEM(55, 555), TYP_ITEM(56, 566), TYP_ITEM(57, 577))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
       800         80       8000 18-FEB-22 TYP_ITEM_NST(TYP_ITEM(1804, 61.75), TYP_ITEM(3172, 39.9), TYP_ITEM(3337, 760), TYP_ITEM(2144, 13.3))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

*/

--Uncomment the code below to execute the code on slide 03_22sb

--Execute as oe/oe
SELECT p2.ordid, p2.supplier, p2.requester, p2.ordered, p1.*
FROM porder p2, TABLE(p2.items) p1;

/*
Output:
    ORDID   SUPPLIER  REQUESTER ORDERED       PRODID      PRICE
---------- ---------- ---------- --------- ---------- ----------
       500         50       5000 18-FEB-22         55        555
       500         50       5000 18-FEB-22         56        566
       500         50       5000 18-FEB-22         57        577
       800         80       8000 18-FEB-22       1804      61.75
       800         80       8000 18-FEB-22       3172       39.9
       800         80       8000 18-FEB-22       3337        760
       800         80       8000 18-FEB-22       2144       13.3
*/

-- Nested table example-3 (nested table stored in database)
--Uncomment the code below to execute the code on slide 03_24sa 

--Execute as oe/oe
CREATE OR REPLACE PROCEDURE add_order_items 
(p_ordid NUMBER, p_new_items typ_item_nst)
IS 
  v_num_items      NUMBER;
  v_with_discount  typ_item_nst;
BEGIN
  v_num_items := p_new_items.COUNT;
  v_with_discount := p_new_items;
  IF v_num_items > 2 THEN 
  --ordering more than 2 items gives a 5% discount
    FOR i IN 1..v_num_items LOOP
      v_with_discount(i) :=  
      typ_item(p_new_items(i).prodid, 
               p_new_items(i).price*.95);
    END LOOP;
  END IF;
  UPDATE pOrder
    SET  items = v_with_discount
    WHERE ordid = p_ordid;
END;
/

--Uncomment the code below to execute the code on slide 03_25sa 

--Execute as oe/oe
SET SERVEROUTPUT ON
DECLARE
  v_form_items  typ_item_nst:= typ_item_nst();
BEGIN
  -- let's say the form holds 4 items
  v_form_items.EXTEND(4);
  v_form_items(1) := typ_item(1804, 65);
  v_form_items(2) := typ_item(3172, 42);
  v_form_items(3) := typ_item(3337, 800);
  v_form_items(4) := typ_item(2144, 14);
  add_order_items(800, v_form_items);
END; 

SELECT p2.ordid, p1.price
FROM porder p2, TABLE(p2.items) p1;

/*
Output:
    ORDID      PRICE
---------- ----------
       500        555
       500        566
       500        577
       800      61.75
       800       39.9
       800        760
       800       13.3
*/

-- Varray example
--Uncomment the code below to execute the code on slide 03_29sa 

--Execute as oe/oe
CREATE TYPE typ_Project AS OBJECT(  --create object
   project_no NUMBER(4), 
   title      VARCHAR2(35),
   cost       NUMBER(12,2))
/
CREATE TYPE typ_ProjectList AS VARRAY (50) OF typ_Project
	  -- define VARRAY type
/
Drop table department
/
CREATE TABLE department (  -- create database table
   dept_id  NUMBER(2),
   name     VARCHAR2(25),
   budget   NUMBER(12,2),
   projects typ_ProjectList)  -- declare varray as column
/

--Uncomment the code below to execute the code on slide 03_30sa 

INSERT INTO department
  VALUES (10, 'Executive Administration', 30000000,
     typ_ProjectList(
     typ_Project(1001, 'Travel Monitor',  400000),
     typ_Project(1002, 'Open World',    10000000)));

INSERT INTO department
  VALUES (20, 'Information Technology', 5000000,
     typ_ProjectList(
     typ_Project(2001, 'DB11gR2', 900000)));

--Uncomment the code below to execute the code on slide 03_31sa

SELECT * FROM department;
/*
Output:
   DEPT_ID NAME                          BUDGET
---------- ------------------------- ----------
PROJECTS(PROJECT_NO, TITLE, COST)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        10 Executive Administration    30000000 
TYP_PROJECTLIST(TYP_PROJECT(1001, 'Travel Monitor', 400000), TYP_PROJECT(1002, 'Open World', 10000000))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

        20 Information Technology       5000000 
TYP_PROJECTLIST(TYP_PROJECT(2001, 'DB11gR2', 900000))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
*/

--Uncomment the code below to execute the code on slide 03_31sb 

SELECT d2.dept_id, d2.name, d1.*
FROM department d2, TABLE(d2.projects) d1;

/*
Output:
   DEPT_ID NAME                      PROJECT_NO TITLE                                     COST
---------- ------------------------- ---------- ----------------------------------- ----------
        10 Executive Administration        1001 Travel Monitor                          400000
        10 Executive Administration        1002 Open World                            10000000
        20 Information Technology          2001 DB11gR2                                 900000
*/
