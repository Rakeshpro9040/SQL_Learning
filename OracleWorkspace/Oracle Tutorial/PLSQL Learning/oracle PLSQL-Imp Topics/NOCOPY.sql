set serveroutput on;
declare
    --n1 number(10) := 100; --as limit is applied on number, so nocopy does not work
    n1 number := 100;
    procedure nocopy_proc (
        i_n1 in out NOCOPY number --formal parameter (copy-1)
        --pass value by reference, rather than by copying
    )
    is
    begin
        i_n1 := i_n1 + 1;
        raise_application_error(-20999, 'Some error!');
    end;
begin
    nocopy_proc(n1); --actual paramter (copy-2)
    --dbms_output.put_line(n1);
exception
    when others then
        dbms_output.put_line(n1);
end;
/

/*
Due to pass by reference only both actual and formal paramteres share same memory location,
hence modifying one reflects the other immidiately. The exception has now occured in the subprogram,
in case of pass by value the changes rollback on exception occurs, but here in case of 
pass by reference the changes performed on formal parameter immidiately reflects on the actual param
though there is an exceptrion raised.
*/

/*
Note that in case of NOCOPY copy-1 and copy-2 does not apply as the vlaue is passed by
reference, but by default (without NOCOPY) oracle creates 2 copies.
*/

/*
Pass by value:
copy-2 >> [COPY value] >> copy-1 (Temporary buffer)
copy-1 (Temporary buffer) >> [COPY value] >> copy-2  <-- When exception occurs, this does not happens

Pass by reference:
actual paramter <---> [Single COPY] formal parameter  <-- Modification in one affects the other,
    also when exception occurs the modified value is reflected in the actual parameter.
*/

--https://www.complexsql.com/what-is-nocopy-hint-with-real-examples-nocopy-hint-examples/
create or replace procedure P_pass_by_value1
( P_id IN out number)
is
begin
    P_id:=P_id*10;
    if P_id>100 then
        raise VALUE_ERROR;
    end if;
end;
/

declare
    v number:=20;
begin
    p_pass_by_value1(V);
    dbms_output.put_line('NO ISSUE '||v);
EXCEPTION
WHEN VALUE_ERROR THEN
    dbms_output.put_line('EXCEPTION '||v);
end;
/

create or replace procedure P_pass_by_ref
(P_id IN out nocopy number)
is
begin
    P_id:=P_id*10;
    if P_id>100 then
        raise VALUE_ERROR;
    end if;
end;
/

set serveroutput on;
declare
    v number:=20;
begin
    p_pass_by_ref(V);
    dbms_output.put_line('NO ISSUE '||v);
EXCEPTION
WHEN VALUE_ERROR THEN
    dbms_output.put_line('EXCEPTION '||v);
end;
/
























