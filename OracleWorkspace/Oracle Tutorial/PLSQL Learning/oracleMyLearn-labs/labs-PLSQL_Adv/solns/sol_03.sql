-- Use OE Connection

--Uncomment code below to run the solution for Task 2 of Practice 03

TRUNCATE TABLE pOrder;

-- A better approach is to avoid setting the table 
-- column to NULL, and instead, use a nested table's
-- default constructor to initialize
BEGIN
  -- Insert an order
  INSERT INTO pOrder
    (ordid, supplier, requester, ordered, items)
    VALUES (1000, 12345, 9876, SYSDATE,
            typ_item_nst(typ_item(99, 129.00)));
END;
/

-- However, if the nested table is set to NULL, you can
-- use an UPDATE statement to set its value.
-- This is another alternative. Run either the block above,
-- or the block below to insert an order.

BEGIN
  -- Insert an order
  INSERT INTO pOrder
    (ordid, supplier, requester, ordered, items)
    VALUES (1000, 12345, 9876, SYSDATE, null);
  -- Once the nested table is set to null, use the update
  -- update statement
  UPDATE pOrder
    SET items = typ_item_nst(typ_item(99, 129.00))
    WHERE ordid = 1000;
END;
/

*/

--Uncomment code below to run the solution for Task 3 of Practice 03


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