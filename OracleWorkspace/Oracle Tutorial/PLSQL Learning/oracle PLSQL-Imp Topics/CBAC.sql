select * from hr.employees;
select * from ot.employees;
select * from hr.emp;

/********* With definer's right *********/
-- create the proc in HR schema
create or replace procedure hr.get_emp_cbac (
    i_empno in emp.empno%type,
    o_ename out emp.ename%type
)
is
begin
    select ename
    into o_ename
    from emp
    where empno = i_empno;
end get_emp_cbac;
/

set serveroutput on;
declare
    v_empno number(10) := 7839;
    v_ename varchar2(30);
begin
    hr.get_emp_cbac(v_empno,v_ename);
    dbms_output.put_line(v_ename);
end;
/

/*
Test
----
login to OT and run:
PLS-00201: identifier 'HR.GET_EMP_CBAC' must be declared
Observation: due to necessary prevelige is not granted OT can't
    execute hr.get_emp_cbac proc.
*/

-- grant execute prevelige to OT
GRANT EXECUTE ON hr.get_emp_cbac to OT;

/*
Test
----
login to OT and run:
KING
Observation: due to necessary prevelige is now granted OT can
    execute hr.get_emp_cbac proc. Here OT does not have SELECT access 
    on hr.emp, still it is able to execute the proc, this is due to
    the proc has been executed based on DEFINER's right (i.e. HR's right).
*/

/********* With invoker's right *********/
-- create the proc in HR schema
create or replace procedure hr.get_emp_cbac1 (
    i_empno in emp.empno%type,
    o_ename out emp.ename%type
)
AUTHID CURRENT_USER
is
begin
    select ename
    into o_ename
    from emp
    where empno = i_empno;
end get_emp_cbac1;
/

set serveroutput on;
declare
    v_empno number(10) := 7839;
    v_ename varchar2(30);
begin
    hr.get_emp_cbac1(v_empno,v_ename);
    dbms_output.put_line(v_ename);
end;
/

/*
Test
----
login to OT and run:
PLS-00201: identifier 'HR.GET_EMP_CBAC1' must be declared
Observation: due to necessary prevelige is not granted OT can't
    execute hr.get_emp_cbac proc.
*/

-- grant execute prevelige to OT
GRANT EXECUTE ON hr.get_emp_cbac1 to OT;

/*
Test
----
login to OT and run:
ORA-00942: table or view does not exist
Observation: due to necessary prevelige is now granted OT can
    execute hr.get_emp_cbac proc. Due to the proc is now executed
    with INVOKER's right (i.e. OT) it is trying to SELECT emp
    table in OT schema, as it is not present, hence it failed to execute.
*/

-- grant select on hr.emp prevelige to OT
GRANT SELECT ON hr.emp to OT;

select * from hr.emp;

/*
Test
----
login to OT and run:
ORA-00942: table or view does not exist
Observation: Still it's failing due to emp table is not present
    in the OT schema.
*/

CREATE table ot.emp as select * from hr.emp;

/*
Test
----
login to OT and run:
KING
Observation: Now we are able to see the result, as proc is now
    fecting data from OT.emp.
*/

/********* With invoker's right(Sub-program inside) *********/
create or replace procedure hr.get_emp_cbac2 (
    i_empno in emp.empno%type,
    o_ename out emp.ename%type,
    o_ename1 out emp.ename%type
)
AUTHID CURRENT_USER
is
begin
    select ename
    into o_ename
    from emp
    where empno = i_empno;
    
    o_ename1 := get_emp(i_empno);
end get_emp_cbac2;
/

set serveroutput on;
declare
    v_empno number(10) := 7839;
    v_ename varchar2(30);
    v_ename1 varchar2(30);
begin
    hr.get_emp_cbac2(v_empno,v_ename,v_ename1);
    dbms_output.put_line(v_ename || '--' || v_ename1);
end;
/

/*
Test
----
login to OT and run:
PLS-00201: identifier 'HR.GET_EMP_CBAC2' must be declared
Observation: due to necessary prevelige is not granted OT can't
    execute hr.get_emp_cbac proc.
*/

-- grant execute prevelige to OT
GRANT EXECUTE ON hr.get_emp_cbac2 to OT;

/*
Test
----
login to OT and run:
KING--Beh
Observation: hr.get_emp_cbac2 ran with INVOKER's right,
    as emp table is present in the OT schema, it fetched the result KING,
    but it does neither has executre prevelige on hr.get_emp nor it is having
    get_emp in its schema, then how it is able to execute the get_emp. This is
    due to in INVOKER's right object names used in DML/SQL(static/dynamic) are resolved
    using INVOKER's right (i.e. OT), but the calls to other packages/functions/procs are
    resolved in the DEFINER's schema (i.e. HR).
*/

declare
    v_ename1 emp.ename%type;
begin
    v_ename1 := get_emp(7839);
    dbms_output.put_line(v_ename1);
end;
/

/*
PLS-00201: identifier 'GET_EMP' must be declared
*/

/********* Code Based Access Control *********/

create or replace procedure hr.get_emp_cbac3 (
    i_empno in emp.empno%type,
    o_ename out emp.ename%type
)
AUTHID CURRENT_USER
is
begin
    select ename
    into o_ename
    from hr.emp
    where empno = i_empno;
end get_emp_cbac3;
/

set serveroutput on;
declare
    v_empno number(10) := 7839;
    v_ename varchar2(30);
begin
    hr.get_emp_cbac3(v_empno,v_ename);
    dbms_output.put_line(v_ename);
end;
/

-- login to ADMIN and create a role
create role cbac_role;
GRANT cbac_role TO HR WITH DELEGATE OPTION;
GRANT cbac_role TO PROCEDURE hr.get_emp_cbac3; -- CBAC implementation
GRANT SELECT ON hr.emp TO cbac_role;

/*
Test
----
login to OT and run:
PLS-00201: identifier 'HR.GET_EMP_CBAC3' must be declared
Observation: due to necessary prevelige is not granted OT can't
    execute hr.get_emp_cbac proc.
*/

-- grant execute prevelige to OT
GRANT EXECUTE ON hr.get_emp_cbac3 to OT;

-- login to OT
select * from hr.emp;
REVOKE SELECT ON emp FROM ot;
-- ORA-00942: table or view does not exist

/*
Test
----
login to OT and run:
KING
Observation: This shows the implementation of CBAC,
    though OT does not have direct access on hr.emp, but 
    due to function hr.get_emp_cbac3 is having SELECT access 
    on the hr.emp via role cbac_role, hence OT is able to fetch the results.
    Prior to CBAC we would need grant SELECT access on hr.emp to OT which could
    have given direct access to OT, which is dangerous in terms of security.
*/

































