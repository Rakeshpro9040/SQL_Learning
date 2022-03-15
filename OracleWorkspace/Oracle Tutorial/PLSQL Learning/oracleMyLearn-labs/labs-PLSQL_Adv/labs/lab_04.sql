-- Use OE Connection to complete the lab 04.

--Uncomment code below to run Task 2 of Practice 04

-- Create the below package from sol_04.sql
/*

CREATE OR REPLACE PACKAGE credit_card_pkg
IS
  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2);
  
  PROCEDURE display_card_info
    (p_cust_id NUMBER);
END credit_card_pkg;  -- package spec
/

CREATE OR REPLACE PACKAGE BODY credit_card_pkg
IS

  PROCEDURE update_card_info
    (p_cust_id NUMBER, p_card_type VARCHAR2, p_card_no VARCHAR2)
  IS
    v_card_info typ_cr_card_nst;
    i INTEGER;
  BEGIN
    SELECT credit_cards
      INTO v_card_info
      FROM customers
      WHERE customer_id = p_cust_id;
    IF v_card_info.EXISTS(1) THEN  
 -- cards exist, add more
  
 -- fill in code here

    ELSE -- no cards for this customer, construct one

 -- fill in code here 

    END IF;
  END update_card_info;


  PROCEDURE display_card_info
    (p_cust_id NUMBER)
  IS
    v_card_info typ_cr_card_nst;
    i INTEGER;
  BEGIN
    SELECT credit_cards
      INTO v_card_info
      FROM customers
      WHERE customer_id = p_cust_id;

 -- fill in code here to display the nested table
 -- contents

  END display_card_info;  
END credit_card_pkg;  -- package body
/

*/

--Uncomment code below to run the Task 3 of Practice 04

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.display_card_info(120)

/*
Customer has no credit cards.
*/

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.update_card_info(120, 'Visa', 11111111)

EXECUTE credit_card_pkg.display_card_info(120)

/*
Card Type: Visa / Card No: 11111111
*/

SELECT  c1.* 
FROM   customers,TABLE(customers.credit_cards) c1
WHERE  customer_id = 120;

/*
CARD_TYPE                   CARD_NUM
------------------------- ----------
Visa                        11111111
*/

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.display_card_info(120)

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.update_card_info(120, 'MC', 2323232323)

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.update_card_info (120, 'DC', 4444444)

SET SERVEROUTPUT ON

EXECUTE credit_card_pkg.display_card_info(120)

/*
Card Type: Visa / Card No: 11111111
Card Type: MC / Card No: 2323232323
Card Type: DC / Card No: 4444444
*/

--Uncomment code below to run task 4 of Practice 04

SELECT c1.customer_id, c1.cust_last_name, c2.*
FROM   customers c1, TABLE(c1.credit_cards) c2
WHERE  customer_id = 120;
/*
CUSTOMER_ID CUST_LAST_NAME       CARD_TYPE                   CARD_NUM
----------- -------------------- ------------------------- ----------
        120 Higgins              Visa                        11111111
        120 Higgins              MC                        2323232323
        120 Higgins              DC                           4444444
*/