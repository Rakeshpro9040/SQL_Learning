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

UPDATE

*****************************************


*****************************************