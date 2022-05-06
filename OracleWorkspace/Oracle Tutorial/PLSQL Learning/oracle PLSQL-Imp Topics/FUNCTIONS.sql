-- Create a Function without any Parameter
create or replace function func_dummy
return number
is
begin
    return 100;
end;
/

select func_dummy from dual; --100
select func_dummy() from dual; --100

-- Create a Function with OUT paramter
create or replace function func_dummy1 (
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

set serveroutput on;
declare
    n1 number;
    n2 number;
begin
   n2 := func_dummy1(n1);
   dbms_output.put_line(n1);
   dbms_output.put_line(n2);
end;
/














