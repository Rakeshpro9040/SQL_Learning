*****************************************
Instructions:
*****************************************
Links:
https://www.oracletutorial.com/
https://www.techonthenet.com/oracle/index.php

Connect to OT Database.

*****************************************

SYS Query

*****************************************

SELECT DF.TABLESPACE_NAME "TABLESPACE",
TOTALUSEDSPACE "USED MB",
(DF.TOTALSPACE - TU.TOTALUSEDSPACE) "FREE MB",
DF.TOTALSPACE "TOTAL MB",
ROUND(100 * ( (DF.TOTALSPACE - TU.TOTALUSEDSPACE)/ DF.TOTALSPACE))
"PCT. FREE"
FROM
(SELECT TABLESPACE_NAME,
ROUND(SUM(BYTES) / 1048576) TOTALSPACE
FROM DBA_DATA_FILES
GROUP BY TABLESPACE_NAME) DF,
(SELECT OWNER, ROUND(SUM(BYTES)/(1024*1024)) TOTALUSEDSPACE, TABLESPACE_NAME
FROM DBA_SEGMENTS
GROUP BY OWNER, TABLESPACE_NAME) TU
WHERE DF.TABLESPACE_NAME = TU.TABLESPACE_NAME
AND TU.OWNER = 'OT';

select * from v$version;

*****************************************

FETCH

*****************************************
SELECT
	product_name,
	quantity
FROM
	inventories
INNER JOIN products
		USING(product_id)
ORDER BY
	quantity DESC 
FETCH NEXT 5 ROWS ONLY;

SELECT
	product_name,
	quantity
FROM
	inventories
INNER JOIN products
		USING(product_id)
ORDER BY
	quantity DESC 
OFFSET 2 ROWS 
FETCH NEXT 5 ROWS ONLY;

SELECT
    product_name,
    quantity
FROM
    inventories
INNER JOIN products
        USING(product_id)
ORDER BY
    quantity DESC 
FETCH FIRST 5 PERCENT ROWS ONLY;
*****************************************

LIKE

*****************************************
SELECT
    first_name,
    last_name,
    email,
    phone
FROM
    contacts
WHERE
    first_name LIKE 'Je_i'
ORDER BY 
    first_name;

SELECT
    first_name,
    last_name,
    email,
    phone
FROM
    contacts
WHERE
    first_name LIKE 'Je_%';
    
SELECT
	product_id,
	discount_message
FROM
	discounts
WHERE
	discount_message LIKE '%25!%%' ESCAPE '!';
*****************************************

NULL

*****************************************
SELECT count(*) FROM orders 
WHERE salesman_id = NULL
ORDER BY order_date DESC;

SELECT count(*) FROM orders 
WHERE salesman_id IS NULL
ORDER BY order_date DESC;

SELECT
    country_id,
    city,
    state
FROM
    locations
ORDER BY
    state ASC NULLS FIRST;
*****************************************

Join

*****************************************
SELECT
    *
FROM
    orders
INNER JOIN order_items ON
    order_items.order_id = orders.order_id
ORDER BY
    order_date DESC;

SELECT
  *
FROM
  orders
INNER JOIN order_items USING( order_id )
ORDER BY
  order_date DESC;

SELECT
    product_id,
    warehouse_id,
    ROUND( dbms_random.value( 10, 100 )) quantity
FROM
    products 
CROSS JOIN warehouses;

SELECT
    (e.first_name || '  ' || e.last_name) employee,
    (m.first_name || '  ' || m.last_name) manager,
    e.job_title
FROM
    employees e
LEFT JOIN employees m ON
    m.employee_id = e.manager_id
ORDER BY
    manager;

--finds all employees who have the same hire dates:
SELECT
   e1.hire_date,
  (e1.first_name || ' ' || e1.last_name) employee1,
  (e2.first_name || ' ' || e2.last_name) employee2  
FROM
    employees e1
INNER JOIN employees e2 ON
    e1.employee_id > e2.employee_id
    AND e1.hire_date = e2.hire_date
ORDER BY  
   e1.hire_date DESC,
   employee1, 
   employee2;

select hire_date, employee
from
(select e.hire_date, (e.first_name || ' ' || e.last_name) employee,
count(*) OVER (PARTITION BY e.hire_date) cnt
from employees e)
where cnt > 1
order by 1 desc;

*****************************************

GROUP BY

*****************************************
SELECT
    order_id,
    COUNT( item_id ) item_count,
    SUM( unit_price * quantity ) total
FROM
    order_items
GROUP BY
    order_id
HAVING
    SUM( unit_price * quantity ) > 500000 AND
    COUNT( item_id ) BETWEEN 10 AND 12
ORDER BY
    total DESC,
    item_count DESC;

SELECT 
    DECODE(GROUPING(customer),1,'ALL customers', customer) customer,
    DECODE(GROUPING(category),1,'ALL categories', category) category,
    GROUPING_ID(customer,category) grouping,
    SUM(sales_amount) 
FROM 
    customer_category_sales
GROUP BY 
    GROUPING SETS(
        (customer,category),
        (customer),
        (CATEGORY),
        ()
    )
ORDER BY 
    customer, 
    category;

SELECT
    category,
    customer,
    SUM(sales_amount) 
FROM 
    customer_category_sales
GROUP BY 
    CUBE(category,customer)
ORDER BY 
    category NULLS LAST, 
    customer NULLS LAST;

SELECT
   salesman_id,
   customer_id,
   SUM(quantity * unit_price) amount
FROM
   orders
INNER JOIN order_items USING (order_id)
WHERE
   status      = 'Shipped' AND 
   salesman_id IS NOT NULL AND 
   EXTRACT(YEAR FROM order_date) = 2017
GROUP BY
   ROLLUP(salesman_id,customer_id);
*****************************************

Subquery

*****************************************
--subquery
--subqyery executes first, then outer query (as a whole)
SELECT
    product_id,
    product_name,
    list_price
FROM
    products
WHERE
    list_price > (
        SELECT
            AVG( list_price )
        FROM
            products
    )
ORDER BY
    product_name;

--correlated subquery
--outer query excutes first, then subquery (row by row)
SELECT
    customer_id,
    name
FROM
    customers
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            orders
        WHERE
            orders.customer_id = customers.customer_id
    )
ORDER BY
    name;
    
--Inline View
SELECT
    category_name,
    max_list_price
FROM
    product_categories a,
    (
        SELECT
            category_id,
            MAX( list_price ) max_list_price
        FROM
            products
        GROUP BY
            category_id
    ) b
WHERE
    a.category_id = b.category_id
ORDER BY
    category_name;

SELECT
    product_name,
    category_name
FROM
    products p,
    LATERAL(
        SELECT
            *
        FROM
            product_categories c
        WHERE
            c.category_id = p.category_id
    )
ORDER BY
    product_name;
*****************************************

EXISTS

*****************************************
SELECT
    name
FROM
    customers c
WHERE
    EXISTS (
        SELECT
            1
        FROM
            orders
        WHERE
            customer_id = c.customer_id
    )
ORDER BY
    name;

SELECT
    name
FROM
    customers
WHERE
    NOT EXISTS (
        SELECT
            NULL
        FROM
            orders
        WHERE
            orders.customer_id = customers.customer_id
    )
ORDER BY
    name;
    
SELECT
    *
FROM
    customers
WHERE
    customer_id IN(NULL);
    
SELECT
    *
FROM
    customers
WHERE
    EXISTS (
        SELECT
            NULL
        FROM
            dual
    );

*****************************************

ALL & ANY

*****************************************
SELECT
    product_name,
    list_price
FROM
    products
WHERE
    list_price > ANY(
        SELECT
            list_price
        FROM
            products
        WHERE
            category_id = 1
    )
ORDER BY
    product_name;

SELECT
    product_name,
    list_price
FROM
    products
WHERE
    list_price >= ALL(
        1000,
        1500,
        2200
    )
    AND category_id = 1
ORDER BY
    list_price DESC;
*****************************************

Set Operators

*****************************************

SELECT
    first_name || ' ' || last_name name1,
    email,
    'contact'
FROM
    contacts
UNION
SELECT
    first_name || ' ' || last_name name2,
    email,
    'employee'
FROM
    employees
group by first_name || ' ' || last_name,
    email
ORDER BY
    name1 DESC;

SELECT
    first_name || ' ' || last_name name1,
    email,
    'contact'
FROM
    contacts
UNION ALL
SELECT
    first_name || ' ' || last_name name2,
    email,
    'employee'
FROM
    employees
group by first_name || ' ' || last_name,
    email
ORDER BY
    name1 DESC;

SELECT
    last_name
FROM
    contacts
INTERSECT 
SELECT
    last_name
FROM
    employees
ORDER BY
    last_name desc;

SELECT
  product_id
FROM
  products
MINUS
SELECT
  product_id
FROM
  inventories;
*****************************************

PIVOT

*****************************************
select * from order_stats;

SELECT * 
FROM order_stats
PIVOT
(
    COUNT(order_id) order_count, -- pivot clause
    SUM(order_value) sales
    FOR category_name -- pivot_for_clause
    IN ('CPU' CPU,'Video Card' VideoCard,
        'Mother Board' MotherBoard,'Storage' Storage) -- pivot_in_clause
)
ORDER BY status;

SELECT * 
FROM order_stats
PIVOT
(
    COUNT(order_id) order_count,
    SUM(order_value) sales
    FOR status IN ('Canceled' Canceled, 'Pending' Pending, 'Shipped' Shipped)
)
ORDER BY category_name;

SELECT * 
FROM order_stats
PIVOT XML
(
    COUNT(order_id) order_count,
    SUM(order_value) sales
    FOR status IN (select distinct status from order_stats)
)
ORDER BY category_name;

SELECT * FROM sale_stats;

SELECT * FROM sale_stats
UNPIVOT INCLUDE NULLS
(
    quantity  -- unpivot_clause
    FOR product_code --  unpivot_for_clause
    IN (product_a AS 'A', 
        product_b AS 'B', 
        product_c AS 'C') -- unpivot_in_clause
);

*****************************************

INSERT

*****************************************
INSERT INTO discounts(discount_name, amount, start_date, expired_date)
VALUES('Winter Promotion 2017',  10.5, CURRENT_DATE, DATE '2017-12-31');

INSERT INTO  sales(customer_id, product_id, order_date, total)
SELECT customer_id,
       product_id,
       order_date,
       SUM(quantity * unit_price) amount
FROM orders
INNER JOIN order_items USING(order_id)
WHERE status = 'Shipped'
GROUP BY customer_id,
         product_id,
         order_date;

INSERT ALL 
    INTO fruits(fruit_name, color)
    VALUES ('Apple','Red') 

    INTO fruits(fruit_name, color)
    VALUES ('Orange','Orange') 

    INTO fruits(fruit_name, color)
    VALUES ('Banana','Yellow')
SELECT 1 FROM dual;

select * from fruits;

INSERT ALL
   WHEN amount < 10000 THEN
      INTO small_orders
   WHEN amount >= 10000 AND amount <= 30000 THEN
      INTO medium_orders
   WHEN amount >= 20000 THEN -- You can use ELSE here as well
      INTO big_orders
      
  SELECT order_id,
         customer_id,
         (quantity * unit_price) amount
  FROM orders
  INNER JOIN order_items USING(order_id);

INSERT FIRST
   WHEN amount < 10000 THEN
      INTO small_orders
   WHEN amount >= 10000 AND amount <= 30000 THEN
      INTO medium_orders
   WHEN amount >= 20000 THEN -- You can use ELSE here as well
      INTO big_orders
      
  SELECT order_id,
         customer_id,
         (quantity * unit_price) amount
  FROM orders
  INNER JOIN order_items USING(order_id);

select count(*) from small_orders;
select count(*) from medium_orders;
select count(*) from big_orders;

delete from small_orders;
delete from medium_orders;
delete from big_orders;
*****************************************

UPDATE DELETE

*****************************************

UPDATE
    parts
SET
    cost = 130
WHERE
    part_id = 1;

DELETE
FROM
    orders
WHERE
    order_id = 1;

MERGE INTO member_staging x
USING (SELECT member_id, first_name, last_name, rank FROM members) y
ON (x.member_id  = y.member_id)
WHEN MATCHED THEN
    UPDATE SET x.first_name = y.first_name, 
                        x.last_name = y.last_name, 
                        x.rank = y.rank
    WHERE x.first_name <> y.first_name OR 
           x.last_name <> y.last_name OR 
           x.rank <> y.rank 
WHEN NOT MATCHED THEN
    INSERT(x.member_id, x.first_name, x.last_name, x.rank)  
    VALUES(y.member_id, y.first_name, y.last_name, y.rank);

*****************************************

DDL

*****************************************

CREATE TABLE ot.persons(
    person_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    PRIMARY KEY(person_id)
);

drop table ot.persons;

CREATE  TABLE identity_demo(
    id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    description VARCHAR2(100) not null
);

CREATE  TABLE identity_demo(
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 10 INCREMENT BY 10,
    description VARCHAR2(100) not null
);

INSERT INTO identity_demo(id, description)
VALUES(4, 'Oracle identity column example with GENERATED BY DEFAULT');

INSERT INTO identity_demo(description)
VALUES('Oracle identity column example with GENERATED BY DEFAULT');

select * from identity_demo;

drop table identity_demo;

SELECT * FROM DBA_UNUSED_COL_TABS;

-- To drop the foreign key from dependent tables as well
DROP TABLE brands CASCADE CONSTRAINTS; 

-- To re-claim the tablespace consumed by cars table
DROP TABLE cars purge;

-- recursively truncates down the associated tables in the chain
-- The dependent table should have the column defined as ON DELETE CASCADE
TRUNCATE TABLE table_name CASCADE;

*****************************************

Data types

*****************************************

-- returns a VARCHAR2 value containing the datatype code
SELECT DUMP('abc', 1016) FROM DUAL;

-- negative sclae will round the number from right to left
select cast('127.56' AS NUMBER(5,-2)) dummy_col from dual;
select cast('127.56' AS NUMBER(5,-1)) dummy_col from dual;

select cast('10000' AS NUMBER(6,2)) dummy_col from dual;
select cast('9999.999' AS NUMBER(6,2)) dummy_col from dual;
select cast('9999.99' AS NUMBER(6,2)) dummy_col from dual;
select cast('999.999' AS NUMBER(6,2)) from dual;

-- CHAR pads blanks to right, but VARCHAR2 does not
-- due to Variable in nature
CREATE TABLE t (
    x CHAR(10),
    y VARCHAR2(10)
);

INSERT INTO t(x, y )
VALUES('Oracle', 'Oracle');

select lengthb(x), lengthb(y) from t;

-- Run both the blocks at once
variable v varchar2(10)
exec :v := 'Oracle';

-- To run the below use "Run Script"
-- non-blank-padding semantics comparison
select * from t where x = :v;
select * from t where rtrim(x) = :v;
select * from t where y = :v;

drop table t;

-- AL16UTF16 or UTF-16 uses 2 bytes to store a character
-- NVARCHAR2 can only store data in char not bytes
SELECT *
FROM nls_database_parameters
WHERE PARAMETER in ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET');

SET SERVEROUTPUT ON;

declare
    v varchar2(32767 char);
    v1 varchar2(4 byte);
    v2 nvarchar2(4 char);
    --v2 nvarchar2(4 byte); -- Error
begin
    DBMS_OUTPUT.PUT_LINE('Success!');
end;

-- If "STANDARD" then VARCHAR2 max length = 4000
-- If "EXTENDED" then VARCHAR2 max length = 32767
SELECT
    name,
    value
FROM
    v$parameter
WHERE
    name = 'max_string_size';
    
SHOW PARAMETER max_string_size;

declare
    v date;
begin
    v := '31-DEC-9999';
    v := v-1;
    --v := v+1; -- Error
    v := '28-FEB-2016'; -- leap year as per Gregorian calendar
    v := v+1;
    DBMS_OUTPUT.PUT_LINE(v);
end;

select sysdate from dual;
select localtimestamp from dual;
select localtimestamp(2) from dual;

SELECT value FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_DATE_FORMAT';
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR'; -- Default

SELECT value FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_DATE_LANGUAGE';
ALTER SESSION SET NLS_DATE_LANGUAGE = 'FRENCH';

-- Convert date to string (human-readable)
-- FM - Format Model, SP - Spell 
-- FM removes padded blanks or supress leading zeros
-- Check: https://www.oracletutorial.com/oracle-basics/oracle-date-format/
SELECT TO_CHAR(SYSDATE, 'Month DD, YYYY')FROM dual;
SELECT TO_CHAR(SYSDATE, 'FMMonth DD, YYYY')FROM dual;
SELECT TO_CHAR(SYSDATE, 'DD "of" MONTH, YEAR A.D.') FROM dual;
SELECT TO_CHAR(SYSDATE, 'DDSP "of" MONTH, YEAR A.D.') FROM dual;
SELECT TO_CHAR(SYSDATE, 'DDSPTH "of" MONTH, YEAR A.D.') FROM dual;
SELECT TO_CHAR(localtimestamp, 'fmMONTH DD, YYYY "at" HH24:MI:SS:FF') "logged_at" from dual;
SELECT EXTRACT(year from sysdate) "year" from dual;

-- Convert string to date
SELECT TO_DATE('August 01, 2017', 'MONTH DD, YYYY') FROM dual;
SELECT (DATE '2017-09-25') FROM dual;

SELECT value FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_TIMESTAMP_FORMAT';

-- INTERVAL - allows to store period of time
-- INTERVAL YEAR TO MONTH - store a period of time using the YEAR and MONTH fields
select (INTERVAL '10-2' YEAR TO MONTH) from dual; -- This results 10 years 2 months
select (INTERVAL '200' YEAR()) from dual; 

-- INTERVAL DAY TO SECOND - stores a period of time in terms of days, hours, minutes, and seconds
select (INTERVAL '10 2' DAY TO HOUR) from dual; -- This results 10 days 2 hours

-- TIMESTAMP WITH TIME ZONE - stores both time stamp and time zone data

SELECT value FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_TIMESTAMP_TZ_FORMAT';
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MON-RR HH.MI.SSXFF AM TZH';
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MON-RR HH.MI.SSXFF AM TZR'; -- default

SELECT SESSIONTIMEZONE FROM dual;

SET SERVEROUTPUT ON;

declare
    v TIMESTAMP WITH TIME ZONE;
begin
    v := TIMESTAMP '2017-08-08 2:00:00';
    DBMS_OUTPUT.PUT_LINE(v);
end;

*****************************************

Constraints

*****************************************
-- Add and Drop constraint
ALTER TABLE tab_name DROP CONSTRAINT constraint_name;

-- Enable and disbale contraint
ALTER TABLE tab_name DISABLE CONSTRAINT constraint_name;

-- Primary Key
-- Inline constraint (column level declaration)
CREATE TABLE purchase_orders (
    po_nr NUMBER PRIMARY KEY,
    vendor_id NUMBER NOT NULL,
    po_status NUMBER(1,0) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL 
);

-- table constraint (table level declaration)
CREATE TABLE purchase_orders (
    po_nr NUMBER,
    vendor_id NUMBER NOT NULL,
    po_status NUMBER(1,0) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT pk_purchase_orders PRIMARY KEY(po_nr)
);

ALTER TABLE vendors ADD CONSTRAINT pk_vendors PRIMARY KEY (vendor_id);

-- Foreign Key
CREATE TABLE supplier_groups(
    group_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    group_name VARCHAR2(255) NOT NULL,
    PRIMARY KEY (group_id)  
);

CREATE TABLE suppliers (
    supplier_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    supplier_name VARCHAR2(255) NOT NULL,
    group_id NUMBER NOT NULL,
    PRIMARY KEY(supplier_id),
    FOREIGN KEY(group_id) REFERENCES supplier_groups(group_id) 
);

FOREIGN KEY(group_id) REFERENCES supplier_groups(group_id) ON DELETE CASCADE
FOREIGN KEY(group_id) REFERENCES supplier_groups(group_id) ON DELETE SET NULL

-- NOT NULL
ALTER TABLE table_name MODIFY ( column_name NOT NULL);

-- UNIQUE
-- Inline
CREATE TABLE table_name (
    ...
    column_name data_type CONSTRAINT unique_constraint_name UNIQUE
    ...
);

-- Table
CREATE TABLE table_name (
    ...
    column_name data_type,
    ...,
    CONSTRAINT unique_constraint_name UNIQUE(column_name)
);

-- CHECK
-- Check constraint expressions can only have static values for comparison
-- not dynamic values like SYSDAT, ROWID, etc.
-- Inline
CREATE TABLE parts (
    part_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    part_name VARCHAR2(255) NOT NULL,
    buy_price NUMBER(9,2) CONSTRAINT check_positive_buy_price CHECK(buy_price > 0),
    PRIMARY KEY(part_id)
);

-- Table
CREATE TABLE table_name (
    ...,
    CONSTRAINT check_constraint_name CHECK (expresssion)
);

-- private temporary table
-- Table name starts with ora$ppt_
*****************************************

Views

*****************************************
-- Creating a View
CREATE [OR REPLACE] VIEW view_name [(column_aliases)] AS
    defining-query
[WITH READ ONLY]
[WITH CHECK OPTION]
;

-- Drop a View
DROP VIEW schema_name.view_name 
[CASCADE CONSTRAINT];
-- Dropping uderlying table will make the View Invalid
SELECT object_name, status
FROM user_objects
WHERE object_type = 'VIEW' AND object_name = 'SALESMAN_CONTACTS';

*****************************************
































































































































































































