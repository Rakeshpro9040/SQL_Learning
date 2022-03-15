--This is the SQL Script to run the code_examples for Lesson 6
--Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 06_15sa
-- To drop the customer_followup table
DROP TABLE customer_followup;

CREATE TABLE customer_followup AS (SELECT customer_id, cust_first_name,
                                        cust_last_name, cust_address,
                                        cust_email, account_mgr_id
                                        FROM customers);
/

--Uncomment the code below to execute the code on slide 06_15sb
ALTER TABLE customer_followup ADD(order_history VARCHAR2(4000));

--Uncomment the code below to execute the code on slide 06_16sa
ALTER TABLE customer_followup ADD CONSTRAINT json_check CHECK(order_history IS JSON);

SELECT * FROM CUSTOMER_FOLLOWUP;

--execute this statement to enable insertion
DELETE FROM customer_followup WHERE CUSTOMER_ID = 120;

--Uncomment the code below to execute the code on slide 06_17sa
insert into customer_followup (customer_id, cust_first_name,cust_last_name,
                              cust_address, cust_email, account_mgr_id, order_history) 
                              select customer_id, cust_first_name, 
                              cust_last_name,cust_address,cust_email, account_mgr_id,
                              (select JSON_OBJECT('id' VALUE o.order_id,
                                                  'orderTotal' VALUE o.order_total,
                                                  'sales_rep_id' VALUE o.sales_rep_id)
                                              FROM orders o where o.customer_id = co.customer_id)
                              from customers co 
                              where
                              co.customer_id = 120;
                              
--Uncomment the code below to execute the code on slide 06_20sa
select * from orders;

SELECT JSON_OBJECT('id' VALUE o.order_id,
                   'orderTotal' VALUE o.order_total,
                   'sales_rep_id' VALUE o.sales_rep_id)
FROM orders o;
/*
{"id":2458,"orderTotal":78279.6,"sales_rep_id":153}
{"id":2397,"orderTotal":42283.2,"sales_rep_id":154}
{"id":2454,"orderTotal":6653.4,"sales_rep_id":154}
{"id":2354,"orderTotal":46257,"sales_rep_id":155}
{"id":2358,"orderTotal":7826,"sales_rep_id":155}
*/

--Uncomment the code below to execute the code on slide 06_21sa
SELECT JSON_ARRAY(customer_id,sales_rep_id,order_total) FROM orders;
/*
[101,153,78279.6]
[102,154,42283.2]
[103,154,6653.4]
[104,155,46257]
[105,155,7826]
*/
                            
--Uncomment the code below to execute the code on slide 06_22sa
SELECT JSON_OBJECTAGG(product_name VALUE product_status) FROM product_information WHERE min_price>2200;
/*
{
   "Laptop 128/12/56/v90/110":"orderable",
   "Laptop 64/10/56/220":"orderable",
   "Desk - W/48/R":"orderable",
   "Desk - OS/O/F":"orderable"
}
*/

--Uncomment the code below to execute the code on slide 06_23sa
SELECT JSON_ARRAYAGG(order_total) FROM orders WHERE sales_rep_id = 161;
/*
[17848.2,34930,2854.2,268651.8,6394.8,103679.3,33893.6,26632,23431.9,25270.3,69286.4,48552,310]
*/


--Uncomment the code below to execute the code on slide 06_24sa
SELECT JSON_OBJECT('customer_id' VALUE customer_id,                 
                   'number_of_orders' VALUE count(customer_id),
                   'orders' VALUE json_arrayagg(order_total)
                   )
FROM orders
WHERE customer_id = 106 GROUP BY customer_id;
/*
{
   "customer_id":106,
   "number_of_orders":4,
   "orders":[
      23034.6,
      2075.2,
      5546.6,
      5543.1
   ]
}
*/

--Uncomment the code below to execute the code on slide 06_27sa
SELECT cf.order_history.id FROM customer_followup cf WHERE customer_id = 120;
-- 2373

--Uncomment the code below to execute the code on slide 06_29sa
SELECT JSON_VALUE(order_history,'$.orderTotal')
FROM customer_followup 
WHERE customer_id = 120;
-- 416

--Uncomment the code below to execute the code on slide 06_30sa
CREATE OR REPLACE FUNCTION get_order_value(ord_his VARCHAR2) return number as
begin
    RETURN JSON_VALUE(ord_his,'$.orderTotal' returning number);
end;

--Uncomment the code below to execute the code on slide 06_30sb
DECLARE
  jsonData VARCHAR2(4000);
  ord_val number;
BEGIN
  select order_history into jsonData from customer_followup 
  where customer_id = 120;
  ord_val := get_order_value(jsonData);
  DBMS_OUTPUT.PUT_LINE('The old order value was: '|| ord_val);
  ord_val := ord_val+ (0.1*ord_val);
  DBMS_OUTPUT.PUT_LINE('The new order value will be: '|| ord_val);
END;

--Uncomment the code below to execute the code on slide 06_36sa
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE json_put_method AS
je JSON_ELEMENT_T;
jo JSON_OBJECT_T;
BEGIN
je := JSON_ELEMENT_T.parse('{"product_name": "GP 1280x1024"}');
IF(je.is_Object) THEN
  jo := treat(je AS JSON_OBJECT_T);
  jo.put('price', 149.99);
END IF;
DBMS_OUTPUT.PUT_LINE(je.to_string);
END json_put_method;
/

EXECUTE json_put_method;
/*
{"product_name":"GP 1280x1024","price":149.99}
*/

--Uncomment the code below to execute the code on slide 06_37sa
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE json_get_methods AS
in_data JSON_OBJECT_T;
address JSON_OBJECT_T;
zip NUMBER;
BEGIN
in_data := new JSON_OBJECT_T('{"first_name" : "John",
                                "last_name" : "Doe",
                                "address"   : {"country" : "USA",
                                "zip" : "94065"} }');
address := in_data.get_object('address');
DBMS_OUTPUT.PUT_LINE(address.to_string);
zip := address.get_number('zip');
DBMS_OUTPUT.PUT_LINE(zip);
DBMS_OUTPUT.PUT_LINE(address.to_string);
address.PUT('zip', 12345);
address.PUT('street','Detour Road');
DBMS_OUTPUT.PUT_LINE(address.to_string);
END json_get_methods;
/

EXECUTE json_get_methods;
/*
{"country":"USA","zip":"94065"}
94065
{"country":"USA","zip":"94065"}
{"country":"USA","zip":12345,"street":"Detour Road"}
*/
