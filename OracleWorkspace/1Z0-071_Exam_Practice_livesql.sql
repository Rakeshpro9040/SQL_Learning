/*
    Change password, RUn the below command.
    Instead of rakesh3 use a new password.
*/
--ALTER USER rakesh IDENTIFIED BY rakesh3;

/*
    Cleanup-Drop all existing tables.
    Import Sample HR Database. 
    Refer Learning >> Oracle Install >> Create a Sample Database
*/
/*
BEGIN
    FOR c IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE ('DROP TABLE "' || c.table_name || '" CASCADE CONSTRAINTS');
    END LOOP;
    
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
    EXECUTE IMMEDIATE ('DROP SEQUENCE ' || s.sequence_name);
    END LOOP;
END;
*/

/*** Data Dictionary ***/
select * from all_tables where UPPER(table_name) like upper('%course%');
select * from all_tables where owner = 'HR';

/*** Tables schema ***/
SH:
SALES
CUSTOMERS
PRODUCTS
TIMES

HR:
EMPLOYEES

OE:
ORDERS
CUSTOMERS

/*********************/

/*** Misc ***/
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
AND TU.OWNER = 'RAKESH';

select * from DBA_SEGMENTS;

select count(*) from user_objects;
select count(*) from dba_objects;

select distinct do.owner from dba_objects do 
where do.owner not in
('SYS','SYSTEM','DBSNMP','APPQOSSYS','DBSFWUSER','REMOTE_SCHEDULER_AGENT',
'PUBLIC','CTXSYS','AUDSYS','OJVMSYS','SI_INFORMTN_SCHEMA','DVF','DVSYS',
'GSMADMIN_INTERNAL','ORDPLUGINS','ORDDATA','MDSYS','OLAPSYS','LBACSYS',
'OUTLN','ORACLE_OCM','XDB','WMSYS','ORDSYS');

select object_type, count(*) 
from dba_objects where owner = 'RAKESH'
group by object_type;

select * from dba_objects where owner = 'RAKESH' and object_type = 'TABLE PARTITION';

select * from v$version;

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

/*** Qn-141 ***/

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

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/

/*** Qn- ***/












































