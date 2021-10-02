 create or replace package pkg_test as
   function area (a in number) return number;
   function area (a in number, b in number) return number;
 end;


 create or replace package body pkg_test as
   function area(a in number)
   return number is
   begin
       return a*a;
   end;
   function area(a in number, b in number)
   return number is
   begin
       return a*b;
   end;
 end;

set SERVEROUTPUT ON

 begin
     dbms_output.put_line(pkg_test.area(3, 4));
     dbms_output.put_line(pkg_test.area(5));
     dbms_output.put_line(pkg_test.area('5'));
 end;

