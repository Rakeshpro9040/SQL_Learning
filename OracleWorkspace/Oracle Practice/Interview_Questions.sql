/*********** Misc ***********/
-- is there any Oracle dictionary view to fetch all the prcoedures in a Packages?
select *
from all_procedures
where object_name = 'PKG_COMMON';

-- Extract first name, last_name, domain from a mail id


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
