drop function func_dummy;
select * from t1;

-- Create a Function with DML

create or replace function func_dummy
return number
is
begin
    insert into t1(v1) values(1);
    commit;
    return 1;
end;
/

select func_dummy from dual; 
-- ORA-14551: cannot perform a DML operation inside a query

declare
    n number;
begin
   n := func_dummy();
   dbms_output.put_line(n);
end;
/
-- This inserts record into t1

-- Create a Function without return
create or replace function func_dummy
return number
is
begin
    null;
end;
/

select func_dummy from dual; 
-- ORA-06503: PL/SQL: Function returned without value

-- Create a Function without any Parameter
create or replace function func_dummy
return number
is
begin
    return 100;
end;
/

select func_dummy from dual; 
--100
select func_dummy() from dual; 
--100

-- Create a Function with OUT paramter
create or replace function func_dummy (
    o_n1 out number
)
return number
is
begin
    o_n1 := 200;
    return 100;
end;
/
-- we can't call with OUT or IN OUT param in SQL

declare
    n1 number;
    n2 number;
begin
   n2 := func_dummy(n1);
   dbms_output.put_line(n1);
   dbms_output.put_line(n2);
end;
/














