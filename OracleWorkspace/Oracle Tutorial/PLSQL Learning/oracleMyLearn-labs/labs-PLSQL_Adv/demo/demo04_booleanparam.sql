-- Use oe connection
-- This code demonstrates the usage of boolean parameter
-- Expected output in this case is 'the string: x is false'

create or replace function y(x boolean) return varchar2
is
begin
if x then   return 'x is true';
     else   return 'x is false'; 
end if;
end;
/
set serveroutput on
declare
 l boolean:=5=6;
 s varchar2(30);
 begin
 select y(l) into s from dual;
 dbms_output.put_line('the string: '||s);
  end;
 /

