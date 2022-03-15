-- Use OE Connection

--Uncomment code below to run the solution for Task 1 of Practice 06-1
DROP TABLE sales_report
/

CREATE TABLE sales_report(sales_rep_id number(6,0) PRIMARY KEY,
                          sales_rep_fname VARCHAR2(20) ,
                          sales_rep_lname VARCHAR2(20),
                          order_details VARCHAR2(4000));
/

--Uncomment code below to run the solution for Task 2 of Practice 06-1
ALTER TABLE sales_report ADD CONSTRAINT ensure_json CHECK(order_details IS JSON);

-- Use OE Connection
--Uncomment code below to run the solution for Task 3 of Practice 06-1
INSERT INTO sales_report(sales_rep_id, sales_rep_fname, sales_rep_lname)
SELECT DISTINCT o.sales_rep_id, emp.first_name, emp.last_name
       FROM hr.employees emp, oe.orders o
       WHERE emp.employee_id = o.sales_rep_id;
       
--Uncomment code below to run the solution for Task 4 of Practice 06-1
SELECT * FROM sales_report;
/*
155	Oliver	Tuvault	
159	Lindsey	Smith	
160	Louise	Doran	
153	Christopher	Olsen	
*/

UPDATE sales_report sr
SET order_details = (SELECT JSON_ARRAYAGG(JSON_OBJECT('order_id' VALUE o.order_id,
                                                      'customer_id' VALUE o.customer_id,
                                                      'order_value' VALUE o.order_total))
                     FROM  orders o
                     WHERE o.sales_rep_id = sr.sales_rep_id
                     group by sales_rep_id)

SELECT * FROM sales_report;
/*
155	Oliver	Tuvault	json_rec(refer to below)
[
   {
      "order_id":2354,
      "customer_id":104,
      "order_value":46257
   },
   {
      "order_id":2449,
      "customer_id":146,
      "order_value":86
   },
   {
      "order_id":2444,
      "customer_id":109,
      "order_value":77727.2
   },
   {
      "order_id":2407,
      "customer_id":165,
      "order_value":2519
   },
   {
      "order_id":2358,
      "customer_id":105,
      "order_value":7826
   }
]
*/

--Uncomment code below to run the solution for Practice 06-2
SET SERVEROUTPUT ON;                                 
CREATE OR REPLACE PROCEDURE sales_data AS
input_data JSON_OBJECT_T;
ord_det JSON_OBJECT_T;
o_val NUMBER;
BEGIN
input_data := new JSON_OBJECT_T('{"sales_rep_fname" : "Janette",
                                "sales_rep_lname" : "King",
                                "order_details" : { "customer_id" : "106","order_value" : "23034.6"}}');
                                
ord_det := input_data.get_object('order_details');
o_val := ord_det.get_number('order_value');
DBMS_OUTPUT.PUT_LINE(o_val);
END sales_data;

EXECUTE sales_data;
-- 23034.6