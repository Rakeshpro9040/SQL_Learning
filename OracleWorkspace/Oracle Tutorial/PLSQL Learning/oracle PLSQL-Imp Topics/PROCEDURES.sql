-- Create a procedure without any paramter
create or replace procedure proc_dummy
is
begin
    dbms_output.put_line('From proc_dummy!');
end;
/

begin
    proc_dummy;
end;
/

EXEC proc_dummy;

-- Create a procedure with OUT parameter
create or replace procedure proc_dummy1 (
    o_n1 out number
)
is
begin
    o_n1 := 100;
end;
/

VARIABLE n1 number
EXEC proc_dummy1(:n1)
PRINT n1
/

-- Create a procedure with IN parameter
create or replace procedure proc_dummy2 (
    i_n1 in number
)
is
begin
    i_n1 := 100;
    dbms_output.put_line('From proc_dummy2:' || i_n1);
end;
/

--PLS-00363: expression 'I_N1' cannot be used as an assignment target

-- Create a procedure with IN OUT parameter
create or replace procedure proc_dummy3 (
    i_n1 in out number
)
is
begin
    i_n1 := 100;
    dbms_output.put_line('From proc_dummy2:' || i_n1);
end;
/

VARIABLE n1 number
EXEC :n1 := 200
PRINT n1
EXEC proc_dummy1(:n1)
PRINT n1
/












