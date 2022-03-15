-- Use OE Connection

--Uncomment code below to run Task 1 of Practice 03

--If already created, creation of typ_item and typ_item_nst
-- may raise ORA-00955: name is already used by an existing object". 

CREATE TYPE typ_item AS OBJECT  --create object
 (prodid  NUMBER(5),
  price   NUMBER(7,2) )
/
DROP TYPE type_item_nst;
CREATE TYPE typ_item_nst -- define nested table type
  AS TABLE OF typ_item
/
DROP TABLE pOrder
/
CREATE TABLE pOrder (  -- create database table
     ordid	NUMBER(5),
     supplier	NUMBER(5),
     requester	NUMBER(4),
     ordered	DATE,
     items	typ_item_nst)
     NESTED TABLE items STORE AS item_stor_tab
/

--Uncomment code below to run Task 2 of Practice 03

BEGIN
  -- Insert an order
  INSERT INTO pOrder
    (ordid, supplier, requester, ordered, items)
    VALUES (1000, 12345, 9876, SYSDATE, NULL);
  -- insert the items for the order created
  INSERT INTO TABLE (SELECT items
                   FROM   pOrder
                   WHERE  ordid = 1000)
    VALUES(typ_item(99, 129.00));
END;
/

/*
Output:
22908. 00000 -  "reference to NULL table value"
*/

-- You should always use a nested table's default constrcutor to initialize it (Check sol_03.sql)
-- A better approach is to avoid setting the table 
-- column to NULL, and instead, use a nested table's
-- default constructor to initialize
TRUNCATE TABLE pOrder;

BEGIN
  -- Insert an order
  INSERT INTO pOrder
    (ordid, supplier, requester, ordered, items)
    VALUES (1000, 12345, 9876, SYSDATE,
            typ_item_nst(typ_item(99, 129.00)));
END;
/

select * from porder, table(porder.items);

--Uncomment code below to run Task 3 of Practice 03

DECLARE
  TYPE credit_card_typ
  IS VARRAY(100) OF VARCHAR2(30);

  v_mc   credit_card_typ := credit_card_typ();
  v_visa credit_card_typ := credit_card_typ();
  v_am   credit_card_typ;
  v_disc credit_card_typ := credit_card_typ();
  v_dc   credit_card_typ := credit_card_typ();

BEGIN
  v_mc.EXTEND;
  v_visa.EXTEND;
  v_am.EXTEND;
  v_disc.EXTEND;
  v_dc.EXTEND;
END;
/

/*
output:
Error report -
ORA-06531: Reference to uninitialized collection
*/

-- To fix it, initialize the v_am variable.
DECLARE
  TYPE credit_card_typ
  IS VARRAY(100) OF VARCHAR2(30);

  v_mc   credit_card_typ := credit_card_typ();
  v_visa credit_card_typ := credit_card_typ();
  v_am   credit_card_typ := credit_card_typ();
  v_disc credit_card_typ := credit_card_typ();
  v_dc   credit_card_typ := credit_card_typ();

BEGIN
  v_mc.EXTEND;
  v_visa.EXTEND;
  v_am.EXTEND;
  v_disc.EXTEND;
  v_dc.EXTEND;
END;
/