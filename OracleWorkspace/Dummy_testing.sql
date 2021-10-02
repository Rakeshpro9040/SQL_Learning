SET SERVEROUTPUT ON
cl scr
--<< main_prog >>
--declare
--  x number(4) := 1;
--begin
-- dbms_output.put_line(x);
-- << sub_prog >>
-- declare
--   x number(4) := 2;
-- begin
--   dbms_output.put_line(x);
--   dbms_output.put_line(main_prog.x);
-- end;
-- dbms_output.put_line(x);
-- --dbms_output.put_line(sub_prog.x);
--end;

--declare
-- x number(4) := 1;
--begin
-- loop
--  dbms_output.put_line(x);
--  exit when x = 2;
--  x := x +1;
-- end loop;
--end;

--declare
--begin
-- for i in 1..4 loop
--  for j in 1..i loop
--   dbms_output.put_line(j);
--  end loop;
-- end loop;
--end;

-- select * from employees;
-- BULK COLLECT Example
--declare
--TYPE emp_rec is record (empno number, ename varchar2(100));
--TYPE emp_rec_tab is TABLE OF emp_rec INDEX BY BINARY_INTEGER;
--emp emp_rec_tab;
--
--TYPE emp_rec_1 is record (empno number);
--TYPE emp_rec_1_tab is TABLE OF emp_rec_1 INDEX BY VARCHAR2(50);
--emp_1 emp_rec_1_tab;
--
--cnt number;
--begin
-- select e.employee_id, e.first_name
-- BULK COLLECT INTO emp
-- from employees e;
--
-- select e.employee_id
-- BULK COLLECT INTO emp_1
-- from employees e;
-- 
-- for rec in (select e.employee_id from employees e) loop
--  emp_1()
-- end loop;
-- 
---- FOR i IN 1 .. emp.count loop
----  dbms_output.put_line(emp(i).empno || ' - ' || emp(i).ename || ' - ' || emp.NEXT(emp(i).empno));
---- end loop;
--
-- cnt := emp.COUNT();
-- dbms_output.put_line(cnt);
--end;

--DECLARE
--    -- declare an associative array type
--    TYPE t_capital_type 
--        IS TABLE OF VARCHAR2(100) 
--        INDEX BY VARCHAR2(50);
--    -- declare a variable of the t_capital_type
--    t_capital t_capital_type;
--    -- local variable
--    l_country VARCHAR2(50);
--BEGIN
--    
--    t_capital('USA')            := 'Washington, D.C.';
--    t_capital('United Kingdom') := 'London';
--    t_capital('Japan')          := 'Tokyo';
--    
--    l_country := t_capital.FIRST;
--    
--    WHILE l_country IS NOT NULL LOOP
--        dbms_output.put_line('The capital of ' || 
--            l_country || 
--            ' is ' || 
--            t_capital(l_country) || ' - ' || t_capital.NEXT(l_country));
--        l_country := t_capital.NEXT(l_country);
--    END LOOP;
--END;

--declare
-- cursor c1 is select * from emp;
-- e emp%ROWTYPE;
-- z number;
--begin
-- open c1; 
-- loop
-- fetch c1 into e;
--  dbms_output.put_line(c1%rowcount);
--  exit when c1%notfound;
--  dbms_output.put_line(e.emp_no);
--  --open c1;
-- end loop;
-- if c1%isopen then
--  dbms_output.put_line('Yes');
--  close c1;
-- end if;
-- --fetch c1 into e;
--end;

--select * from user_errors;
--SHOW ERRORS
--SHO ERR

--declare
-- x constant number(4) := 100;
-- y number(4) := 0;
--begin
-- y := y+x;
-- --x := x+y;
-- dbms_output.put_line(y);
--end;

--select sysdate, systimestamp from dual;
--
--begin
-- execute deptree_fill('TABLE', 'RAKESH', 'EMP');
--end;
--select * from ideptree;

--select * from user_objects;
--select a.status, a.* from user_indexes a;

--select mod(1600,10)from dual;
--
--select e.*, 
--TO_CHAR(sysdate, 'FMMON DDth, YYYY') "DUMMY_1" 
--from emp e
--order by "DUMMY_1";
--
----alter table emp move online;
----select * from emp;
--
--explain plan for
--select * from emp;
--
--select * from table(dbms_xplan.display);
--
--select * from table(dbms_xplan.display_cursor);
--
--select case when null=null then 'Amit' else 'Rahul' end from dual;
--
----https://www.complexsql.com/email-validation-in-sql/
--WITH T_validate AS
--(SELECT 'amiets@gmail.com' email FROM dual)
--SELECT * FROM T_validate WHERE REGEXP_LIKE (EMAIL, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
--
--set serveroutput on;
--declare
-- a number;
-- b pls_integer;
-- c number;
--begin
-- b := 2147483647;
-- a := 1000000000;
-- c := b;
-- dbms_output.put_line(a);
-- dbms_output.put_line(b);
-- dbms_output.put_line(c);
--end;

--SELECT REGEXP_COUNT ('Rakesh Panigrahi', 'a|e|i|o|u') FROM dual;
--SELECT REGEXP_COUNT ('Rakesh Panigrahi', '[aeiou]', 1, 'i') FROM dual;


-- Hackerank
/*CREATE TABLE STATION
(ID NUMBER PRIMARY KEY,
CITY VARCHAR2(21),
STATE VARCHAR2(2),
LAT_N NUMBER,
LONG_W NUMBER);*/

/*
INSERT INTO STATION VALUES (13, 'Phoenix', 'AZ', 33, 112);
INSERT INTO STATION VALUES (44, 'Denver', 'CO', 40, 105);
INSERT INTO STATION VALUES (66, 'Caribou', 'ME', 47, 68);
INSERT INTO STATION VALUES (69, 'Phoenio', 'ME', 47, 68);
INSERT INTO STATION VALUES (70, 'Amo', 'ME', 47, 68);
INSERT INTO STATION VALUES (71, 'Amx', 'ME', 47, 68);
*/

select s.*, length(city), s.rowid from station s;

select a.city, a.len_city
from
    (
        select CITY, LENGTH(CITY) len_city, row_number() over(partition by LENGTH(CITY) order by CITY) rowno_city
        from station
        where LENGTH(CITY) in
        (select min(length(CITY)) from station
        union all
        select max(length(CITY)) from station)
    ) a
where a.rowno_city = 1;

SELECT * FROM (SELECT DISTINCT city, LENGTH(city) FROM station ORDER BY LENGTH(city) ASC, city ASC) WHERE ROWNUM = 1
 UNION
SELECT * FROM (SELECT DISTINCT city, LENGTH(city) FROM station ORDER BY LENGTH(city) DESC, city ASC) WHERE ROWNUM = 1;

create table tax_rates
(
activation_dt date,
deactivation_dt date,
tax number
);

select * from tax_rates;

insert into tax_rates
(
activation_dt,
deactivation_dt,
tax
)
values
(
'01-MAR-2020',
'20-MAR-2020',
2
);
commit;

select txo.date1, txo.tax,
case when exists (select null from tax_rates tx1 where tx1.activation_dt-1 = txo.date1) or exists (select null from tax_rates tx1 where tx1.deactivation_dt+1 = txo.date1)
then 'modified'
when exists (select null from tax_rates tx1 where tx1.activation_dt = txo.date1) then 'added'
else 'removed' end "TYPE"
from
(select tx.activation_dt date1, tx.tax
from tax_rates tx
union
select tx.deactivation_dt, tx.tax
from tax_rates tx) txo;