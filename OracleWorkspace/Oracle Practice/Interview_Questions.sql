/*********** Misc ***********/
-- is there any Oracle dictionary view to fetch all the prcoedures in a Packages?
select *
from all_procedures
where object_name = 'PKG_COMMON';

-- Extract first name, last_name, domain from a mail id

/*********** IBM - Aug 2023 ***********/


/*
Oracle:
-- Lets say we have two tables A and B; A has 4 rows 1 1 1 1 and B has 3 rows 1 1 null, what will be the output of all joins
-- Write a SQL to print 99 96 93 .. 3 (multiple of 3 in reverse order)
-- Write a Procedure which takes table name as input and drop the table.
-- Write a block which copies the data from emp table to emp_bkp [using collection, bulk-collect and forall]
-- What is compound trigger?
-- What are the different Trigger timings?
-- Can we update a table via a View [View is created by joining multiple tables]
-- How can we give a name to an unnamed exception?
--  In Oracle what is a btree index, how it works under the hood.
--  How you load a CSV file into an oracle table?
--  Lets say in the CSV file you have 10 fields, and your table has only 6 cols, how you will be able to load the 6 fields.
--  Difference between disc and bad file in sqlldr.
--  Can a Oracle function return more than 1 values.
--  What is REF cursor and where/why we should use it.
--  Can we use DML operations in a Function, if yes then how?
--  Connect Oracle database from Unix.

UNIX:
-- Lets say we have a file sample.txt. Write a shell command to replace keyword "UNIX" with "LINUX"
    sed -i 's/UNIX/LINUX/g' sample.txt
    sed -i -e 's/UNIX/LINUX/g' sample.txt
--  Delete first 20 lines from this file.
    sed -i '1,20d' sample.txt
--  Count the keyword "UNIX" inside this file.
    grep -o 'UNIX' sample.txt | wc -l
--  Lets a we have a file with fields: address name ph_no [TAB separated]. Command to fetch the ph_no field.
    cut -f3 employee.txt
--  Merge two files f1, f2 into f3.
    cat f1.txt f2.txt > f3.txt
--  Delete all the files/folders recusively from a given folder.
    rm -r Misc_1

*/

----------------------------------

drop table t;
drop table t1;

create table t (c1 varchar2(50));
create table t1 (c1 varchar2(50));

insert into t values (1);
insert into t values (1);
insert into t values (1);
insert into t values (1);

insert into t1 values (1);
insert into t1 values (1);
insert into t1 values (null);

commit;

select * from t;
select * from t1;

select *
from t inner join t1
on t.c1 = t1.c1;
-- 4*2=8

select *
from t left join t1
on t.c1 = t1.c1;
-- 8

select *
from t right join t1
on t.c1 = t1.c1;
-- 9

select *
from t full join t1
on t.c1 = t1.c1;
-- 9

select *
from t cross join t1;
-- 4*3 = 12

----------------------------------

select listagg(list_no, ',') within group(order by list_no desc) as list
from
(
select 102-(3*level) as list_no
from dual
connect by level <= 33
);

select 99 - (3 * (rownum - 1)) as value
from dual
connect by rownum <= 34;

select 99 - (3 * (level - 1)) as value
from dual
connect by level <= 34;

----------------------------------
drop procedure p1;

create or replace procedure p1 (i_tab_name in varchar2) is
    v_sql varchar2(100);
begin
    v_sql := 'drop table ' || i_tab_name;
    execute immediate v_sql;
    dbms_output.put_line
end;
/

exec p1('t1');

select * from t1;

----------------------------------

select * from emp;
create table emp_bkp as select * from emp where 1 = 0;
select * from emp_bkp;
delete from emp_bkp;
commit;

declare
    cursor emp_cur is select * from emp;
    type emp_type is table of emp_cur%rowtype;
    emp_tb emp_type;
begin
    select *
    bulk collect into emp_tb
    from emp;

    forall i in emp_tb.first..emp_tb.last
        insert into emp_bkp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        values (emp_tb(i).empno, emp_tb(i).ename, emp_tb(i).job, 
                emp_tb(i).mgr, emp_tb(i).hiredate, emp_tb(i).sal, emp_tb(i).comm, emp_tb(i).deptno);
    commit;
end;
/

declare
    cursor emp_cur is select * from emp;
    type emp_type is table of emp_cur%rowtype;
    emp_tb emp_type;    
begin
    open emp_cur;
    loop
        fetch emp_cur bulk collect into emp_tb limit 100;
        exit when emp_tb.count = 0;

        forall i in emp_tb.first..emp_tb.last
            insert into emp_bkp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
            values (emp_tb(i).empno, emp_tb(i).ename, emp_tb(i).job, 
                    emp_tb(i).mgr, emp_tb(i).hiredate, emp_tb(i).sal, emp_tb(i).comm, emp_tb(i).deptno);
        commit;        
    end loop;
    close emp_cur;
end;
/

select dbms_utility.get_time() from dual;

----------------------------------



----------------------------------

/*********** Infosys - April 2023 ***********/
---- What will be the output from below query?
select 1 from dual
union all
select '1' from dual;
-- ORA-01790: expression must have same datatype as corresponding expression

-- Query to list table created today so that you can give that to DBA for cleanup
select object_name
from all_objects
where object_type = 'TABLE'
and trunc(created) = trunc(sysdate);

-- How can you troubleshoot performance of a long running SQL query

-- How can you ftech rows from a table not availbel in another table
select table1.*
from table1
left join table2 on table1.column1 = table2.column2
where table2.column2 is null;

-- List the Oracle cursor attributes
-- How can you explain Implicit cursor to a fresher
-- What is Bulk collect, how it can be used
-- Can you define expection in declaration part
-- If a PLSQL job has failed in between, how can you reume that after fixing the issue
DBMS_APPLICATION_INFO.SET_MODULE
-- What is Fragmented Space in Oracle

/*********** Infosys - 14th May ***********/
--Validate the Email Id
create table email_validation_temp
as
select email from employees;

select * from email_validation_temp;

insert into email_validation_temp values ('abc.@example.com');
insert into email_validation_temp values ('123@example.com');
insert into email_validation_temp values ('1123.ppp@gmail.com');

select * 
from email_validation_temp et
where regexp_like(et.email, '\.*@', 'i');

select * 
from email_validation_temp et
where regexp_like(et.email, '[a-z]+\.[a-z]+@[a-z]+\.com', 'i');

select * 
from email_validation_temp et
where not regexp_like(et.email, '[a-z]+\.[a-z]+@[a-z]+\.com', 'i');

select * 
from email_validation_temp et
where regexp_like(et.email, '[^a-z]+\.[a-z]+@[a-z]+\.com', 'i');

not regexp_like(email, '[^a-z]+\.[a-z]+@[a-z]+\.com', 'i')

/*
Test in regex:
summer.payne@example.com
rose.stephens@example.com
annabelle.dunn@example.com
tommy.bailey@example.com
blake.cooper@example.com
jude.rivera@example.com
tyler.ramirez@example.com
ryan.gray@example.com
elliot.brooks@example.com
elliott.james@example.com
123@gmail.com
123.ppp@gmail.com
abc.p@p.com
*/

--Find the position of special character in string "Lak$hmi"
with temp AS
(
    select 'Lak$shmi' col from dual
    union all
    select 'Laks@hmi' from dual
    union all
    select 'Ra#kesh' from dual     
    union all
    select '1#456' from dual
    union all
    select 'P6#456Z' from dual
)
--select instr(col,'$') from temp
select REGEXP_INSTR(col /*SOURCE_CHAR*/,
                       '[^a-z | ^0-9]' /*PATTERN*/,
                       1 /*POSITION*/,
                       1 /*OCCURRENCE*/,
                       0 /*RETURN_OPT*/,
                       'i' /*MATCH_PARAM*/,
                       0 /*SUBEXPR*/) test from temp
--select REGEXP_INSTR(col ,'[^a-z | ^0-9]', 'i') from temp -- This does not work                
;

select regexp_instr(col, '[^a-z | ^0-9]', 1, 1, 0, 'i') from temp;

--Find the largest character and number from sring "abc001295z9e"
--Find the maximum value
/*
https://stackoverflow.com/questions/51250440/oracle-find-the-largest-number-within-one-string
*/
select level
from dual
connect by level  <= 100;

with temp as
(
    select 'abc' col from dual
    union
    select 'z' from dual
)
select 
    chr(97) col1, 
    ascii('a') col2,
    max(col) col3
from temp;

select to_number(regexp_substr('abc001295z9e', '[0-9]', 1, level)) as max_value
from dual
connect by regexp_substr('abc001295z9e', '[0-9]', 1, level) is not null;

select regexp_substr('zzabcy001295zz9e', '[a-z]', 1, level) as max_value
from dual
connect by regexp_substr('zzabcy001295zz9e', '[a-z]', 1, level) is not null;

select max(to_number(regexp_substr('abc001295z9e', '[0-9]', 1, level))) as max_value
from dual
connect by regexp_substr('abc001295z9e', '[0-9]', 1, level) is not null;

select max(to_number(regexp_substr('abc001295z9e', '[0-9]+', 1, level))) as max_value
from dual
connect by regexp_substr('abc001295z9e', '[0-9]+', 1, level) is not null;

select max(regexp_substr('zzabcy001295zz9e', '[a-z]', 1, level)) as max_value
from dual
connect by regexp_substr('zzabcy001295zz9e', '[a-z]', 1, level) is not null;

select max(regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level)) as max_value
from dual
connect by regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level) is not null;


/*********** FIS - 15th June ***********/
/*
Is it possible to have procedure and trigger with same name in same schema -- YES
*/
create or replace procedure test_proc is begin null; end;
show err;

create or replace trigger test_proc before insert on dummy begin null; end;
show err;

/*
Is it possible to view the Sub programs under a package in Data Dictionary View --
*/
select * from user_objects where object_name = 'ORDER_MGMT';
select * from DICTIONARY where regexp_like(table_name, '.PACKAGE.');
select * from DICTIONARY where regexp_like(table_name, '.PROCEDURE.');
select * from user_source where name = 'ORDER_MGMT' and type = 'PACKAGE' order by line;

select * 
from USER_IDENTIFIERS 
where object_name = 'ORDER_MGMT' 
and object_type = 'PACKAGE' 
and type in ('FUNCTION', 'PROCEDURE') order by line;

/*
A Sequence is associated with a Table's column, if the column is now dropped,
what will happen to that sequence -- No Effect, it will be still valid
*/

--Create a new Sequence
CREATE SEQUENCE test_seq START WITH 1 CACHE 20;

select test_seq.currval from dual;
select test_seq.nextval from dual;
select status from user_objects where object_name = 'TEST_SEQ';

create TABLE test_tab
(
    test_col1 integer default test_seq.nextval,
    test_col2 integer
);

insert into test_tab(test_col2) values (100);

select * from test_tab;

alter table test_tab drop column test_col1;

select status from user_objects where object_name = 'TEST_SEQ'; --Still valid

/*
Extract last name, domain from email ids:
    rakesh.panigrahi@gmail.com
    rakesh.roshan.panigrahi@gmail.com
    rakesh.panigrahi@gmail.co.in
    rakesh.roshan.panigrahi@gmail.co.in

*/
with cte as 
(
    select 'rakesh.panigrahi@gmail.com' email from dual
    union all
    select 'rakesh.roshan.panigrahi@gmail.com' from dual
    union all
    select 'rakesh.panigrahi@gmail.co.in' from dual
    union all
    select 'rakesh.roshan.panigrahi@gmail.co.in' from dual    
)
select
    substr(substr(email, 1, (instr(email, '@')-1)), (instr(substr(email, 1, (instr(email, '@')-1)),'.',-1))+1) last_name,
    substr(email, 1, (instr(email, '@')-1)) full_name,
    instr(substr(email, 1, (instr(email, '@')-1)),'.',-1) last_dot,
    substr(email, -1*(length(email)-instr(email, '@'))) domain,
    substr(email, instr(email, '@')+1) domain,
    ltrim(regexp_substr(email, '@.*'),'@') domain,
    ltrim(rtrim(regexp_substr(email, '(\.\w+)@(.*)\2'),'@'),'.') lastname,
    

from cte;
--regexp_substr(email, '.*(?=@)') firstname : This does not work as oracle regexp does not support lookahead



/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.
*/

select 
    case when ((A+B) <= C) OR ((A+C) <= B) OR ((B+C) <= A) then
            'Not A Triangle'
        when (A = B) AND (A = C) AND (B = C) then
            'Equilateral'
        when (A = B) OR (A = C) OR (B = C) then
            'Isosceles'
        else
            'Scalene'
    end as output
from TRIANGLES;

/*
HackerRank Report:
sql query to list down the names who have collected more that 2000 hackos under 10 months time (asc order of Hacker_id)
*/
