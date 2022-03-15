-- Use OE Connection
--Uncomment code below to run the solution for Task 2_c of Practice 08
-- note: If you did not complete lesson 5 practice, you will need
--       to run solution scripts for tasks 1_a, 1_b, 1_c from sol_04.sql
--       in order to have the supporting structures in place.
CREATE OR REPLACE PACKAGE credit_card_pkg
IS
  FUNCTION cust_card_info 
    (p_cust_id NUMBER, p_card_info IN OUT typ_cr_card_nst )
    RETURN BOOLEAN;
  
  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2);
  
  PROCEDURE display_card_info
    (p_cust_id NUMBER);

END credit_card_pkg;  -- package spec
/

CREATE OR REPLACE PACKAGE BODY credit_card_pkg
IS

  FUNCTION cust_card_info 
    (p_cust_id NUMBER, p_card_info IN OUT typ_cr_card_nst )
    RETURN BOOLEAN
  IS
    v_card_info_exists BOOLEAN;
  BEGIN
    SELECT credit_cards
      INTO p_card_info
      FROM customers
      WHERE customer_id = p_cust_id;
    IF p_card_info.EXISTS(1) THEN
      v_card_info_exists := TRUE;
    ELSE
      v_card_info_exists := FALSE;
    END IF;

    RETURN v_card_info_exists;

  END cust_card_info;

  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2)
  IS
    v_card_info typ_cr_card_nst;
    i PLS_INTEGER;
  BEGIN
    
    IF cust_card_info(p_cust_id, v_card_info) THEN  -- cards exist, add more
      i := v_card_info.LAST;
      v_card_info.EXTEND(1);
      v_card_info(i+1) := typ_cr_card(p_card_type, p_card_no);
      UPDATE customers
        SET  credit_cards = v_card_info
        WHERE customer_id = p_cust_id;
    ELSE   -- no cards for this customer yet, construct one
      UPDATE customers
        SET  credit_cards = typ_cr_card_nst
            (typ_cr_card(p_card_type, p_card_no))
        WHERE customer_id = p_cust_id;
    END IF;
  END update_card_info;
  PROCEDURE display_card_info
    (p_cust_id NUMBER)
  IS
    v_card_info typ_cr_card_nst;
    i PLS_INTEGER;
  BEGIN
    IF cust_card_info(p_cust_id, v_card_info) THEN
      FOR idx IN v_card_info.FIRST..v_card_info.LAST LOOP
          DBMS_OUTPUT.PUT('Card Type: ' || v_card_info(idx).card_type || ' ');
        DBMS_OUTPUT.PUT_LINE('/ Card No: ' || v_card_info(idx).card_num );
      END LOOP;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Customer has no credit cards.');
    END IF;
  END display_card_info;  
END credit_card_pkg;  -- package body
/

--Uncomment code below to run the solution for Task 3 of Practice 08

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.update_card_info(120, 'AM EX',55555555555)
 
EXECUTE credit_card_pkg.display_card_info(120)

--Uncomment code below to run the solution for Task 4_b of Practice 08

CREATE OR REPLACE PACKAGE credit_card_pkg
IS
  FUNCTION cust_card_info 
    (p_cust_id NUMBER, p_card_info IN OUT typ_cr_card_nst )
    RETURN BOOLEAN;
  
  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, 
     p_card_no VARCHAR2, o_card_info OUT typ_cr_card_nst);
  
  PROCEDURE display_card_info
    (p_cust_id NUMBER);

END credit_card_pkg;  -- package spec
/

-- Compare Package
CREATE OR REPLACE PACKAGE BODY credit_card_pkg
IS

  FUNCTION cust_card_info 
    (p_cust_id NUMBER, p_card_info IN OUT typ_cr_card_nst )
    RETURN BOOLEAN
  IS
    v_card_info_exists BOOLEAN;
  BEGIN
    SELECT credit_cards
      INTO p_card_info
      FROM customers
      WHERE customer_id = p_cust_id;
    IF p_card_info.EXISTS(1) THEN
      v_card_info_exists := TRUE;
    ELSE
      v_card_info_exists := FALSE;
    END IF;

    RETURN v_card_info_exists;

  END cust_card_info;

  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, 
     p_card_no VARCHAR2, o_card_info OUT typ_cr_card_nst)
  IS
    v_card_info typ_cr_card_nst;
    i PLS_INTEGER;
  BEGIN
    
    IF cust_card_info(p_cust_id, v_card_info) THEN  -- cards exist, add more
      i := v_card_info.LAST;
      v_card_info.EXTEND(1);
      v_card_info(i+1) := typ_cr_card(p_card_type, p_card_no);
      UPDATE customers
        SET  credit_cards = v_card_info
        WHERE customer_id = p_cust_id
        RETURNING credit_cards INTO o_card_info;
    ELSE   -- no cards for this customer yet, construct one
      UPDATE customers
        SET  credit_cards = typ_cr_card_nst
            (typ_cr_card(p_card_type, p_card_no))
        WHERE customer_id = p_cust_id
        RETURNING credit_cards INTO o_card_info;
    END IF;
  END update_card_info;
  PROCEDURE display_card_info
    (p_cust_id NUMBER)
  IS
    v_card_info typ_cr_card_nst;
    i PLS_INTEGER;
  BEGIN
    IF cust_card_info(p_cust_id, v_card_info) THEN
      FOR idx IN v_card_info.FIRST..v_card_info.LAST LOOP
          DBMS_OUTPUT.PUT('Card Type: ' || v_card_info(idx).card_type || ' ');
        DBMS_OUTPUT.PUT_LINE('/ Card No: ' || v_card_info(idx).card_num );
      END LOOP;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Customer has no credit cards.');
    END IF;
  END display_card_info;  
END credit_card_pkg;  -- package body
/

--Uncomment code below to run the solution for Task 4_d of Practice 08
  
 

SET SERVEROUTPUT ON

EXECUTE test_credit_update_info(125, 'AM EX', 123456789)

SELECT * FROM TABLE(SELECT credit_cards  FROM customers WHERE customer_id = 125);
