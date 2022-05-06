declare
    n1 number(10) := 10;
    n2 number(10);
    
    function parallel_enable_func (
        i_n1 number
    )
    return number PARALLEL_ENABLE
    is
    begin
        return i_n1*2;
    end;
begin
    n2 := parallel_enable_func(n1);
    dbms_output.put_line(n1);
end;
/

/*
PLS-00712: illegal option for subprogram PARALLEL_ENABLE_FUNC
*/

create or replace function parallel_enable_func (
    i_n1 number
)
return number PARALLEL_ENABLE
is
begin
    return i_n1*2;
end parallel_enable_func;

set serveroutput on;
declare
    n1 number(10) := 10;
    n2 number(10);
begin
    n2 := parallel_enable_func(n1);
    dbms_output.put_line(n1);
end;
/

/*
10
*/





















