--Improve SQL Query Performance by Using Bind Variables
/* No bind variables */
declare
 order_rec orders%rowtype;
begin
 for i in 1 .. 50000 loop
   begin
     execute immediate
       'select * from orders where order_id = ' || i
       into order_rec;
   exception
     when no_data_found then null;
   end;
 end loop;
end; --1:29 MIN

/* Bind variables */
declare
 order_rec orders%rowtype;
begin
 for i in 1 .. 50000 loop
   begin
     execute immediate
       'select * from orders where order_id = :i'
       into order_rec
       using i;
   exception
     when no_data_found then null;
   end;
 end loop;
end; --02 SEC

--The advantage of using PL/SQL
declare
 order_rec orders%rowtype;
begin
 for i in 1 .. 50000 loop
   begin
     select *
     into   order_rec
     from   orders
     where  order_id = i;
   exception
     when no_data_found then null;
   end;
 end loop;
end; --02 SEC


select tablespace_name from dba_tablespaces;
select count(1) from students;
CREATE PUBLIC SYNONYM applications FOR RAKESH.applications;

SELECT * FROM RAKESH.APPLICATIONS A
WHERE A.ZIP_CODE = '11201'
AND A.LAST_NAME = 'Rivera';

select count(1)
from (SELECT A.LAST_NAME, A.First_Name FROM RAKESH.APPLICATIONS A where A.LAST_NAME = 'Rivera');
