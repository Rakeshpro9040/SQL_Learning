*****************************************

Instructions:

*****************************************

Oracle livesql:
https://livesql.oracle.com/apex/f?p=590:1:1254310546419::NO:::

Schema ER Diagrams:
https://docs.oracle.com/en/database/oracle/oracle-database/19/comsc/schema-diagrams.html

*****************************************

examtopics Questions

*****************************************

/*** Qn-7 ***/
CREATE TABLE table1(
numberval number(8),
charval varchar2(20));

CREATE TABLE table2(
numberval number(8),
charval varchar2(20));

CREATE TABLE table3(
numberval number(8),
charval varchar2(20));

INSERT ALL
WHEN salary < 3000 THEN
INTO table1
WHEN salary > 3000 AND salary < 8000 THEN
INTO table2
WHEN salary > 8000 AND salary < 30000 THEN
INTO table3
SELECT salary, first_name
FROM employees;

select * from table1;
select * from table2;
select * from table3;

drop table table1 cascade constraints;
drop table table2 cascade constraints;
drop table table3 cascade constraints;

/*** Qn-13 ***/
CREATE TABLE table1(
numberval number(8),
charval varchar2(20));

select * from table1;

insert into table1
values
(1, 'ABC');

delete from table1;

/*** Qn-14 ***/
select NVL (TO_CHAR(e.commission_pct * .15), 'Not Available') "NEW CREDIT" from employees e;

/*** Qn-20 ***/
select to_date('01-JAN-2000','DD-MON-YYYY')+5 from dual;
select trunc(sysdate)+5 from dual;
select MONTHS_BETWEEN(trunc(sysdate),to_date('01-JAN-2000','DD-MON-RRRR')) from dual;
select concat ('ABC'||','| |'XYZ'| |', ', 'PPP') from dual;
select 'ABC'||', '||'XYZ'||', '||'PPP' from dual;

/*** Qn-68 ***/
select count(*)
from hr.employees e
left outer join hr.departments d
on e.department_id = d.department_id;

select count(*)
from hr.employees e
left outer join hr.departments d
using (department_id);

/*** Qn-78 ***/
select distinct c.CUST_INCOME_LEVEL, c.cust_credit_limit*0.50 
from sh.customers c 
order by 1;

/*** Qn-79 ***/
select e.DEPARTMENT_ID, sum(e.SALARY) SALARY_TOT
from hr.employees e
group by e.DEPARTMENT_ID
having sum(e.SALARY) > 100;

/*** Qn-87 ***/
create table TAB1
(col1 char(3) default 'ABC' NOT NULL);

desc TAB1;

insert into TAB1(COL1) values ('XYZ');
commit;

select * from TAB1;

drop table TAB1 PURGE;

/*** Qn-88 ***/
CREATE TABLE orders
(
    ord_no NUMBER(2) CONSTRAINT ord_pk PRIMARY KEY,
    ord_date DATE,
    cust_id NUMBER(4)
);

drop table orders purge;

CREATE TABLE ord_items
(
    ord_no NUMBER(2),
    item_no NUMBER(3),
    qty NUMBER(3) CHECK (qty BETWEEN 100 AND 200),
    expiry_date date CHECK (expiry_date > SYSDATE),
    --ORA-02436: date or system variable wrongly specified in CHECK constraint
    CONSTRAINT it_pk PRIMARY KEY(ord_no, item_no),
    CONSTRAINT ord_fk FOREIGN KEY(ord_no) REFERENCES orders(ord_no)
);

drop table ord_items purge;

/*** Qn-89 ***/
select to_date(HIRE_DATE+1) from hr.employees;
desc hr.employees;

/*** Qn-90 ***/
SELECT NVL(TO_CHAR(cust_credit_limit*.15), 'Not Available') "NEW CREDIT" FROM SH.customers;

/*** Qn-93 ***/
select * from SH.SALES;

/*** Qn-94 ***/
select sysdate from dual;
select TO_CHAR(sysdate,'MON DD YYYY') from dual;
select TO_DATE('JUL 10 2006','MON DD YYYY') from dual;

/*** Qn-97 ***/
create table TAB1
(col1 date default sysdate);

desc TAB1;

drop table TAB1;

/*** Qn-98 ***/
SELECT list_price, TO_CHAR(list_price, '$9,999'),
TO_CHAR('11235.90', '$9,999'), TO_CHAR('9999', '$9,999'),
TO_CHAR('11111', '$9,999'), TO_CHAR('1123.90', '$9,999')
From oe.product_information;

select to_char(1234, '999999') from dual; -- 1234
select to_char(1234, '099999') from dual; -- 001234
select to_char(1234, '$99999') from dual; -- $1234
select to_char(1234, 'L99999') from dual; -- $1234 (Column right aligned)
select to_char(1234, '9999D99') from dual; -- 1234.00
select to_char(1234, '9999.99') from dual; -- 1234.00
select to_char(1234, '9999,99') from dual; -- 12,34 (Comma in position specified)
select to_char(1234, '999G999') from dual; -- 1,234 (Group separator)
select to_char(1234, '999G9G99') from dual; -- 1,2,34 (Group separator)
select to_char(-1234, '999999MI') from dual; -- 1234-
select to_char(-1234, '999999PR') from dual; -- <1234> (Paranthesize negative numbers)
select to_char(1234, '99.999EEEE') from dual; -- 1.234E+03
select to_char(1234, '9999V99') from dual; -- 123400 (Multiply by 10 n times, n = number of 9s after V)
select to_char(1234, 'S9999') from dual; -- +1234 (Returns the negative or positive value)

/*** Qn-100 ***/
SELECT TO_CHAR(order_date,'rr'), SUM(order_total) 
FROM oe.orders
GROUP BY TO_CHAR(order_date, 'yyyy');
--ORA-00979: not a GROUP BY expression

/*** Qn-101 ***/
SELECT order_id
FROM oe.order_items
GROUP BY order_id
HAVING SUM(unit_price*quantity) = 
    (SELECT MAX(SUM(unit_price*quantity)) FROM oe.order_items GROUP BY order_id);

/*** Qn-101 ***/
CREATE TABLE zweipk (a number ,b number ,c number );
ALTER TABLE zweipk ADD CONSTRAINT zweipk_pk PRIMARY KEY (a, b) ;

INSERT INTO zweipk VALUES (1,1,1) ;
INSERT INTO zweipk VALUES (2,2,2) ;
INSERT INTO zweipk VALUES (2,1,1) ;
INSERT INTO zweipk VALUES (1,2,1) ;

SELECT * FROM zweipk;
SELECT constraint_name, table_name, column_name, position FROM user_cons_columns WHERE table_name ='ZWEIPK';

ALTER TABLE zweipk DROP COLUMN b;
--ORA-12991: column is referenced in a multi-column constraint 
ALTER TABLE zweipk DROP COLUMN b CASCADE CONSTRAINTS;

drop table zweipk PURGE;

/*** Qn-103 ***/
select avg(sysdate-hire_date) col_days from hr.employees;
--It works, as the it returns the number of days

select sum(avg(sysdate-hire_date)) col_days from hr.employees;
--ORA-00978: nested group function without GROUP BY

select avg(hire_date) col_days from hr.employees;
--ORA-00932: inconsistent datatypes: expected NUMBER got DATE

/*** Qn-108 ***/
CREATE TABLE DUMMY(NAME VARCHAR2(20));

INSERT INTO DUMMY VALUES ('JOHN');
INSERT INTO DUMMY VALUES ('ADCH_NIG');
INSERT INTO DUMMY VALUES ('ADCHNIG');
INSERT INTO DUMMY VALUES ('ADCH');
INSERT INTO DUMMY VALUES ('ADCH_');
INSERT INTO DUMMY VALUES ('ALEX');
COMMIT;

SELECT * FROM DUMMY;

SELECT NAME FROM DUMMY WHERE NAME LIKE '%CH_%';
--Failed, it is detecting "ADCHNIG" as well
--SELECT NAME FROM DUMMY WHERE NAME LIKE '%CH\_%'ESCAPE'\';
--Works perfectly

DROP table DUMMY PURGE;

/*** Qn-110 ***/
select count(*) from hr.employees where commission_pct <> '';
--Wrong, returns 0
select count(*) from hr.employees where commission_pct is not null;
--Correct, returns 35

/*** Qn-112 ***/
select * 
from hr.employees e1
where e1.employee_id =
(select min(e2.employee_id)
from hr.employees e2);

select * 
from hr.employees e1
where
(select min(e2.employee_id)
from hr.employees e2) =
e1.employee_id;

/*** Qn-118 ***/
select first_name,department_id,salary from hr.employees order by 2,1,3 desc;

/*** Qn-120 ***/
select * from all_constraints where owner = 'HR';

/*** Qn-122 ***/
select to_char(to_date('2051-05-04','rr-mm-dd'), 'CC') as "Century" from dual
union all
select to_char(to_date('51-05-04','rr-mm-dd'), 'CC') as "Century" from dual;

/*** Qn-123 ***/
create table EMPLOYEES
as select * from hr.EMPLOYEES;

UPDATE
(SELECT HIRE_DATE, SALARY, EMPLOYEE_ID FROM EMPLOYEES)
SET HIRE_DATE = '22-MAR-2007'
WHERE EMPLOYEE_ID IN
(SELECT EMPLOYEE_ID FROM EMPLOYEES
WHERE LAST_NAME = 'Kochhar' AND SALARY = 17000);

select * from EMPLOYEES;

drop table EMPLOYEES purge;

/*** Qn-124 ***/
SELECT COUNT(*), prod_category_id
FROM SH.PRODUCTS
GROUP BY prod_category_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM SH.products);
--ORA-00978: nested group function without GROUP BY

SELECT COUNT(*), prod_category_id
FROM SH.PRODUCTS
GROUP BY prod_category_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM SH.products GROUP BY prod_Category_id);
--This will work

/*** Qn-126 ***/
select concat(e.salary,e.hire_date) from hr.employees e;

/*** Qn-133 ***/
SELECT TO_CHAR (1890.55, '$99G999D00') FROM DUAL; 
--$1,890.55
SELECT TO_CHAR (1890.55, '$9,999V99') FROM DUAL; 
--$1,89055
SELECT TO_CHAR (1890.55, '$0G000D00') FROM DUAL; 
--$1,890.55
SELECT TO_CHAR (1890.55, '$99,999D99') FROM DUAL;
--ORA-01481: invalid number format model
SELECT TO_CHAR (1890.55, '$99G999D99') FROM DUAL;
--$1,890.55

/*** Qn-136 ***/
select employee_id, first_name from employees;

SELECT &col1, '&col2' FROM &table WHERE &&condition = '&cond';
--col1 = employee_id
--col2 = first_name
--table = employees
--condition = employee_id
--cond = 100
SELECT &col1, &col2 FROM "&table" WHERE &condition = &cond;
SELECT &col1, &col2 FROM &&table WHERE &condition = &cond;
SELECT &col1, &col2 FROM &&table WHERE &condition = &&cond;

/*** Qn-137 ***/
SELECT department_id "DEPT_ID", department_name, 'b'
FROM hr.departments
WHERE department_id = 90
UNION
SELECT department_id, department_name DEPT_NAME, 'a'
FROM hr.departments
WHERE department_id = 10
order by DEPT_ID;

select employee_id, 'b' from employees order by 'b';
--Stops working with union

/*** Qn-138 ***/
select e.salary
from employees e
where e.first_name = 'Steven'
group by e.salary
having min(e.employee_id) = 100;
--only the columns present in GROUP BY needs to present in SELECT

/*** Qn-144 ***/
with t as (
    select 1 c, 9 d from dual union
    select 21, 10 from dual union
    select 2, 3 from dual union
    select null, null from dual
)
select sum(case when c < 5 then c else null end) c_sum,
    sum(case when d > 5 then d else null end) d_sum,
    count(c) c_cnt,
    count(case when c is not null then 1 else 0 end) c_cnt_null
from t;

/*** Qn-145 ***/
-- option E
select * from employees where employee_id not in (select null from dual);
-- This returns no rows, but we were expecting all rows

/*** Qn-147 ***/
SELECT p.product_name, i.item_cnt
FROM (SELECT product_id, COUNT (*) item_cnt
FROM co.order_items
GROUP BY product_id) i RIGHT OUTER JOIN co.products p
ON i.product_id = p.product_id
order by 1;

/*** Qn-148 ***/
SELECT 1 FROM DUAL
UNION
SELECT 2 FROM DUAL
UNION
SELECT NULL FROM DUAL
UNION
SELECT 3 FROM DUAL
UNION
SELECT 1 FROM DUAL
UNION
SELECT NULL FROM DUAL
UNION
SELECT 2 FROM DUAL;

SELECT 1 FROM DUAL
UNION ALL
SELECT 2 FROM DUAL
UNION ALL
SELECT NULL FROM DUAL
UNION ALL
SELECT 3 FROM DUAL
UNION ALL
SELECT 1 FROM DUAL
UNION ALL
SELECT NULL FROM DUAL
UNION ALL
SELECT 2 FROM DUAL;

/*** Qn-151 ***/
select initcap('Abigail' || ' ' || upper(substr('Paris', -length('Paris'), 2))) from dual;
select initcap('abigail'|| ' ' || substr('Paris', 0, 2)) from dual;

/*** Qn-159 ***/
SELECT first_name, to_char(ROUND(ROUND(sysdate-hire_date)/365 *salary+commission_pct) ) "comp"
FROM employees;

SELECT first_name, to_char(ROUND(ROUND(sysdate-hire_date)/365 *salary+ nvl(commission_pct,0)) ) "comp"
FROM employees;
-- need to use nvl() to handle NULL commission_pct values

/*** Qn-160 ***/
SELECT INTERVAL '300' month,
   INTERVAL '54-2' year to month,
   INTERVAL ' 11:12:10.1234567' hour to second 
FROM DUAL;

/*** Qn-162 ***/
select * from hr.departments;

select * from hr.employees;

select distinct d.department_id
from hr.employees e 
inner join hr.departments d
on e.department_id <> d.department_id
order by 1;

select distinct department_id 
from hr.departments
order by 1;

select distinct d.department_id
from hr.employees e 
inner join hr.departments d
on e.department_id = d.department_id
order by 1;

-- Correct answer
select department_id from hr.departments
minus
select department_id from hr.employees;

/*** Qn-164 ***/
SELECT cust_last_name AS "Name", cust_credit_limit + 1000 AS "New Credit Limit" FROM SH.customers;

/*** Qn-165 ***/
select to_number(NULL) from dual;


/*** Qn-168 ***/
select NVL2(NULL,1,2) from dual;

-- This should be the correct answer for option A
SELECT first_name, salary, ((salary + NVL2 (commission_pct,( commission_pct * salary),0)) * 12) "Total" FROM employees;
SELECT first_name, salary, (salary + NVL (commission_pct, 0)*salary)*12 "Total" FROM EMPLOYEES;

/*** Qn-171 ***/
create table t
(v varchar2);

create table t
(v varchar2(10));

drop table t;

/*** Qn-172 ***/
CREATE TABLE marks (
student_id VARCHAR2(4) NOT NULL,
student_name VARCHAR(25),
subject1 NUMBER(3),
subject2 NUMBER(3),
subject3 NUMBER(3)
);

SELECT SUM(DISTINCT NVL(subject1,0)), MAX(subject1) FROM marks WHERE subject1 > subject2;
SELECT SUM(subject1+subject2+subject3) FROM marks WHERE student_name IS NULL;

/*** Qn-173 ***/
CREATE TABLE CUSTOMERS(
CUSTNO NUMBER PRIMARY KEY,
CUSTNAME VARCHAR2(20),
CITY VARCHAR2(20));

INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(1,'KING','SEATTLE');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(2,'GREEN','BOSTON');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(3,'KOCHAR','SEATTLE');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(4,'SMITH','NEW YORK');

select * from customers;

SELECT c1.custname, c1.city, c2.custname, c2.city
FROM CUSTOMERS c1 FULL OUTER JOIN CUSTOMERS C2
ON (c1.city = c2.city AND c1.custname<>c2.custname);

SELECT c1.custname, c1.city, c2.custname, c2.city
FROM CUSTOMERS c1 JOIN CUSTOMERS C2
ON (c1.city = c2.city AND c1.custname<>c2.custname);

SELECT c1.custname, c1.city, c2.custname, c2.city
FROM CUSTOMERS c1 RIGHT OUTER JOIN CUSTOMERS C2
ON (c1.city = c2.city AND c1.custname<>c2.custname);
-- Here the c1 columns will be NULL as c2 is the driving table

SELECT c1.custname, c1.city, c2.custname, c2.city
FROM CUSTOMERS c1 LEFT OUTER JOIN CUSTOMERS C2
ON (c1.city = c2.city AND c1.custname<>c2.custname);

drop table rakesh.customers;

/*** Qn-174 ***/
create table t
(v varchar2(1),
c char,
n number);

insert into t values (1, 22, 2.2);

insert into t values (1, 22, 2.2);
-- Error

select * from t;

drop table t;

/*** Qn-177 ***/
create table t
(n number);

insert into t values (1);

ALTER TABLE T ADD n1 NUMBER NOT NULL;
-- ORA-01758: table must be empty to add mandatory (NOT NULL) column

alter table t add n1 number default 0 not null;

select * from t;

drop table t;

/*** Qn-178 ***/
SELECT promo_name, promo_cost, promo_begin_date 
FROM SH.promotions 
WHERE promo_category = 'post' AND promo_begin_date < '01-01-00';
-- ORA-01843: not a valid month

SELECT promo_name, promo_cost, promo_begin_date 
FROM SH.promotions 
WHERE promo_category LIKE 'P%' AND promo_begin_date < '1-JANUARY-00';
-- no data found

SELECT promo_name, promo_cost, promo_begin_date 
FROM SH.promotions 
WHERE promo_cost LIKE 'post%' AND promo_begin_date < '01-01-2000';
-- no data found

SELECT promo_name, promo_cost, promo_begin_date 
FROM SH.promotions 
WHERE promo_category LIKE '%post%' AND promo_begin_date < '1-JAN-00';

/*** Qn-179 ***/
CREATE OR REPLACE VIEW TESTDELETE AS SELECT DISTINCT FIRST_NAME FROM EMPLOYEES;
DELETE FROM TESTDELETE;
-- ORA-01732: data manipulation operation not legal on this view

drop view TESTDELETE;

/*** Qn-181 ***/
CREATE SEQUENCE seq1
START WITH 100
INCREMENT BY 10
MAXVALUE 200
CYCLE
NOCACHE;

-- After Sequce reaches it MAX value it will restart from 1, due to absence of MINVALUE

SELECT seq1.nextval FROM dual;
SELECT seq1.currval FROM dual;

drop sequence seq1;

CREATE SEQUENCE seq1
START WITH 100
MINVALUE 12
INCREMENT BY 10
MAXVALUE 200
CYCLE
NOCACHE;
-- After Sequce reaches it MAXVALUE it will restart from 12

/*** Qn-182 ***/
select * from SESSION_PRIVS;
select * from USER_TAB_PRIVS;

/*** Qn-186 ***/
SELECT 'PROMO_NAME' || q'{'s start date was \}' || SYSDATE AS "Promotion Launches" FROM Dual;


/*** Qn-189 ***/
SELECT MAX(unit_price*quantity) "Maximum Order"
FROM OE.order_items;
-- Single row

SELECT MAX(unit_price*quantity) "Maximum Order"
FROM OE.order_items
GROUP BY order_id;
-- Multi Rows due to the presence of group by

/*** Qn-191 ***/
create table t (id number,fname varchar2(20),test long);
alter table t modify test not null;
-- but if the table contains data, then this will fail
drop table t;

/*** Qn-192 ***/
CREATE TABLE t_a (x INT PRIMARY KEY);
CREATE TABLE t_b (x INT, FOREIGN KEY(x) REFERENCES t_a(X));

INSERT INTO t_a VALUES (1);
INSERT INTO t_a VALUES (2);
INSERT INTO t_b VALUES (1);

DELETE (SELECT * FROM t_a tab1 JOIN t_b tab2 ON tab1.x=tab2.x);
-- DELETE on Inner Join Table, deletes the content from Child Table.

SELECT * FROM t_a;
SELECT * FROM t_b;

drop table t_a;
drop table t_b;

/*** Qn-193 ***/
SELECT NVL2 (hire_date, hire_date + 15,'') FROM employees;
SELECT NVL (hire_date, hire_date + 15) FROM employees;

/*** Qn-195 ***/
SELECT cust_last_name--, cust_credit_limit 
FROM sh.customers
WHERE (UPPER(cust_last_name) LIKE 'A%'OR UPPER (cust_last_name) LIKE 'B%' OR UPPER (cust_last_name) LIKE 'C%')
AND cust_credit_limit < 10000
group by cust_last_name
order by 1 desc;

SELECT cust_last_name--, cust_credit_limit 
FROM 
    (select cust_last_name, cust_credit_limit from sh.customers union
    select 'C', 10 from dual union
    select 'Ca', 10 from dual)
WHERE (UPPER(cust_last_name) BETWEEN 'A' AND 'C')
AND cust_credit_limit < 10000
group by cust_last_name
order by 1 desc;
-- This will include rows whose cust_last_name = 'C'
-- anything greater than that will not be considered
-- Greater than 'C' means 'Ca', 'Cabc', .. etc

/*** Qn-200 ***/
select * from USER_RECYCLEBIN;

/*** Qn-204 ***/
SELECT supplier_name,
DECODE(supplier_id, 10000, 'IBM',
                    10001, 'Microsoft',
                    10002, 'Hewlett Packard',
                    'Gateway') result
FROM suppliers;
-- If supplier_id = 10000, then IBM
-- If supplier_id = 10001, then Microsoft
-- Gateway is the ELSE part

select months_between(sysdate, hire_date) from employees;

/*** Qn-205 ***/
CREATE TABLE price_list (
PROD_ID NUMBER(3) NOT NULL,
PROD_PRICE VARCHAR2(10));

INSERT INTO price_list VALUES (100, '$234.55');
INSERT INTO price_list VALUES (101, '$6,509.75');
INSERT INTO price_list VALUES (102, '$1,234');

select to_char(prod_price*.25, '$99,999.99') FROM price_list;
-- ORA-01722: invalid number

select to_char(to_number(prod_price)*.25, '$99,999.00') FROM price_list;
-- ORA-01722: invalid number

select to_char(to_number(prod_price, '$99,999.99')*.25, '99,999.00') FROM price_list;

select to_number(to_number(prod_price, '$99,999.99') *.25, '$99,999.00') FROM price_list;
-- ORA-01722: invalid number

/*** Qn-210 ***/
select lpad('kesh', 6, '*') from dual;

/*** Qn-211 ***/
create table t
(n number);

insert into t values (1);
insert into t values (2);
commit;

select * from t;

insert into t values (3);

savepoint a;

delete from t;

rollback to savepoint a;

rollback;

drop table t;

/*** Qn-213 ***/
select next_day(trunc(sysdate), 1) from dual;
select next_day(trunc(sysdate), 'Sunday') from dual;
select next_day(trunc(sysdate), 'Sun') from dual;

select *
from nls_database_parameters
where parameter in ('NLS_TERRITORY');
-- For the America territory: 1 = SUNDAY
-- For the Europian territory: 1 = MONDAY

/*** Qn-214 ***/
create table customers 
(customer_id number(6) not null,
cust_name varchar(20),
cust_email varchar(30),
income_level varchar(20));  

create table customers_vu as select * from customers;  

merge into customers c 
using customers_vu cv 
on (c.customer_id=cv.customer_id)  
when matched then 
update set c.customer_id=cv.customer_id, c.cust_name=cv.cust_name, 
c.cust_email=cv.cust_email, c.income_level=cv.income_level 
when not matched then  
insert values(cv.customer_id,cv.cust_name,cv.cust_email,cv.income_level) 
where cv.income_level>100000;
-- SQL Error: ORA-38104: Columns referenced in the ON Clause cannot be updated: "C"."CUSTOMER_ID"

merge into customers c 
using customers_vu cv 
on (c.customer_id=cv.customer_id)  
when matched then 
update set c.cust_name=cv.cust_name, 
c.cust_email=cv.cust_email, c.income_level=cv.income_level 
when not matched then
insert values(cv.customer_id,cv.cust_name,cv.cust_email,cv.income_level) 
where cv.income_level>100000;

drop table customers;
drop table customers_vu;

/*** Qn-217 ***/
select * from USER_SYNONYMS;
select * from USER_OBJECTS where OBJECT_TYPE = 'VIEW';
select * from dictionary;

/*** Qn-220 ***/
-- The following single-set aggregate example lists all of the employees 
-- in Department 30 in the hr.employees table, 
-- ordered by hire date and last name.
SELECT LISTAGG(last_name, '; ')
   WITHIN GROUP (ORDER BY hire_date) "Emp_list",
   MIN(hire_date) "Earliest"
FROM employees
WHERE department_id = 30;

/*** Qn-224 ***/
-- Both returns same result
-- If the aggregation is not done at SELECT level, 
-- then it will ba calculated as a whole not columnwise
select product_id, avg(quantity)
from co.order_items
having avg(quantity) > min(quantity) * 2
group by product_id
order by 1;

select product_id, avg(quantity)
from co.order_items
having avg(quantity) > (select min(quantity) from co.order_items) * 2
group by product_id
order by 1;

/*** Qn-226 ***/
create table t (pcode number(2),  pname varchar(10));
select * from t;
insert into t values (1,'pen');   
insert into t values (2, 'pencil');  
savepoint a;  
update t set pcode=10 where pcode = 1;  
savepoint b;  
delete from t where pcode=2;  
commit;
delete from t where pcode=10; 
rollback to savepoint a;
--ORA-01086: savepoint 'A' never established in this session or is invalid

drop table t;

/*** Qn-229 ***/
select trunc(sysdate) + 1 from dual;
select trunc(sysdate) * 1 from dual; --Error

/*** Qn- 230***/
select * from sys.user_indexes;
desc 

/*** Qn-237 ***/
create table t
as
select employee_id from employees
where 1 = 1;

select count(*) from t;
-- returned 107 rows

drop table t;

/*** Qn-239 ***/
SELECT COL1 FROM 
(SELECT 1 COL1 FROM DUAL 
UNION ALL   
SELECT 1 FROM DUAL 
UNION ALL   
SELECT NULL FROM DUAL)   
INTERSECT   
SELECT COL2 FROM 
(SELECT NULL COL2 FROM DUAL 
UNION ALL   
SELECT 1 FROM DUAL 
UNION ALL   
SELECT NULL FROM DUAL)   
ORDER BY 1 NULLS FIRST;  

/*** Qn-240 ***/
-- You can use SELF-JOIN, example: 
SELECT * 
FROM 
    customers ctmr1  
JOIN
    (SELECT custno, COUNT(*) 
    FROM customers 
    GROUP BY custno 
    HAVING count(*) > 1 )ctmr2   
ON ctmr1.custno = ctmr2.custno  
ORDER BY ctmr1.custno; 

-- You can use SUBQUERY, example:    
SELECT * FROM customers 
WHERE custno IN 
    (SELECT custno FROM customers GROUP BY custno HAVING COUNT(*)>1)  
ORDER BY custno;

/*** Qn-241 ***/
create table t 
(
    ord_no NUMBER(2),   
    item_no NUMBER(3),   
    --v varchar2(4000) default ROWNUM,
    ord_date DATE DEFAULT SYSDATE NOT NULL,   
    --CONSTRAINT ord_uk UNIQUE (ord_no),   
    CONSTRAINT ord_pk PRIMARY KEY (ord_no)
);
-- UNIQUE & PRIMARY KEY: ORA-02261: such unique or primary key already exists in the table
-- ROWNUM: ORA-00976: Specified pseudocolumn or operator not allowed here

select * from t;

drop table t;

/*** Qn-246 ***/
-- First Monday after 6 months of hire
SELECT employee_id, NEXT_DAY(ADD_MONTHS(hire_date, 6), 'MONDAY') FROM employees;

/*** Qn-247 ***/
select *
from nls_database_parameters
where parameter in ('NLS_DATE_FORMAT');

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR'; -- default
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

select CURRENT_TIMESTAMP, --11-JAN-22 08.29.34.913000000 AM ASIA/CALCUTTA
CURRENT_DATE, --11-JAN-2022 08:29:34
SYSDATE --11-JAN-2022 08:30:29
from dual;

/*** Qn-254 ***/
SELECT * FROM (SELECT * FROM employees);

/*** Qn-256 ***/
select dbms_transaction.step_id from dual;
SELECT dbms_transaction.LOCAL_TRANSACTION_ID FROM DUAL;
select USED_UBLK, USED_UREC from v$transaction;

create table t (n number);
insert into t values (1);
insert into t values (2a);
insert into t values (3);
select * from t;
rollback;
commit;
drop table t;

create table t1 (n number);
insert into t1 values (1);
insert into t1 values (2a);
insert into t1 values (3);
commit;
drop table t1;

/*** Qn-258 ***/
create table t (n number);
insert into t values (1);
insert into t values (null);
insert into t values (3);
insert into t values (3);
commit;

select * from t;
select count(*), count(1), count(n), count(distinct n) from t;

drop table t;

/*** Qn-259 ***/
SELECT 1 AS id, 'John' AS first_name FROM dual   
UNION   
SELECT 1, 'John' AS name FROM dual   
ORDER BY 1;  

/*** Qn-260 ***/
SELECT COUNT(commission_pct) FROM employees WHERE commission_pct IS NULL; -- 0 rows
SELECT COUNT(distinct commission_pct) FROM employees WHERE commission_pct IS NULL; -- 0 rows
SELECT COUNT(NVL(commission_pct, 0)) FROM employees WHERE commission_pct IS NULL; -- 72 rows

/*** Qn-262 ***/
select
    SYSTIMESTAMP, -- 12-JAN-22 09.53.58.204000000 AM +05:30
    SESSIONTIMEZONE, -- Asia/Calcutta
    CURRENT_TIMESTAMP, -- 12-JAN-22 09.51.49.238000000 AM ASIA/CALCUTTA
    DBTIMEZONE, -- +00:00
    CAST(sysdate as TIMESTAMP), -- 12-JAN-22 09.51.49.000000000 AM
    CAST(sysdate as TIMESTAMP WITH LOCAL TIME ZONE) -- 12-JAN-22 09.51.49.000000000 AM
from dual;

/*** Qn-265 ***/
with t as
(select 'a' col from dual
union
select 'A' from dual)
select col col1
from t
order by col1 desc;

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

*****************************************

