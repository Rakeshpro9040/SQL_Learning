/********** Tips **********/
Select the scripts from bottom to top and execute, This will clear op and display results! 
    ** go to end of the script and HIT Ctrl+Shift+Home, then HIT F5
https://github.com/Rakeshpro9040/SQL_Learning/tree/master/OracleWorkspace/Oracle%20Tutorial/PLSQL%20Learning
/**************************/
set serveroutput on; 
execute dbms_session.reset_package;
select * from user_tables;
select * from user_objects;

-- Dynamic SQL [Query Collection]
CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE rec IS RECORD(f1 NUMBER, f2 VARCHAR2(30));
  TYPE mytab IS TABLE OF rec INDEX BY pls_integer;
END;
/
DECLARE
  v1 pkg.mytab;  -- collection of records
  v2 pkg.rec;
  c1 SYS_REFCURSOR;
BEGIN
  v1(1).f1 := 1; 
  v1(1).f2 := 'Rakesh';
  OPEN c1 FOR 'SELECT * FROM TABLE(:1)' USING v1;
  FETCH c1 INTO v2;
  CLOSE c1;
  DBMS_OUTPUT.PUT_LINE('Values in record are ' || v2.f1 || ' and ' || v2.f2);
END;
/

-- Dynamic SQL [OPEN-FETCH-CLOSE]
DECLARE
  TYPE EmpCurTyp  IS REF CURSOR;
  v_emp_cursor    EmpCurTyp;
  emp_record      employees%ROWTYPE;
  v_stmt_str      VARCHAR2(200);
BEGIN
  -- Dynamic SQL statement with placeholder:
  v_stmt_str := 'SELECT * FROM employees WHERE job_id = :j';

  -- Open cursor & specify bind variable in USING clause:
  OPEN v_emp_cursor FOR v_stmt_str USING 'AD_PRES';

  -- Fetch rows from result set one at a time:
  LOOP
    FETCH v_emp_cursor INTO emp_record;    
    EXIT WHEN v_emp_cursor%NOTFOUND;
    dbms_output.PUT_LINE(emp_record.EMPLOYEE_ID);
  END LOOP;

  -- Close cursor:
  CLOSE v_emp_cursor;
END;
/
-- 100

-- Dynamic SQL [Test with DDL]
create table t (n1 number);
insert into t select level from dual connect by rownum <= 10;
commit;

begin
    --truncate table t; -- Error
    execute immediate 'truncate table t';
end;

select count(*) from t;

-- DBMS_SQL
-- OPEN >> PARSE >> BIND >> DEFINE >> EXECUTE >> CLOSE
declare
    l_smt varchar2(1000);
    l_colnm varchar2(30);
    l_tabnm varchar2(30);
    l_where varchar2(30);
    l_filt varchar2(30);
    
    type t_tb_type is table of varchar2(50);
    l_res t_tb_type;
    n int := 5;
    ret int;
    
    v_cur_id int;
    src_cur SYS_REFCURSOR;
begin
    l_colnm := 'first_name';
    l_tabnm := 'employees';
    l_where := 'employee_id';
    l_filt := 100;
    l_smt := 'select ' || l_colnm ||
             ' from ' || l_tabnm ||
             ' where ' || l_where ||
             ' >= ' || l_filt ||
             ' fetch first :n rows only';
    
    v_cur_id := dbms_sql.open_cursor;
    dbms_output.put_line('v_cur_id: ' || v_cur_id);
    dbms_sql.parse(v_cur_id, l_smt, dbms_sql.native);
    dbms_sql.bind_variable(v_cur_id, ':n', n);
    ret := dbms_sql.execute(v_cur_id);
    dbms_output.put_line('ret: ' || ret);
    -- dbms_sql.close_cursor(v_cur_id);
    
    -- Switch from DBMS_SQL to native dynamic SQL:
    -- Now the sql cursor related functions won't work
    -- like dbms_sql.close_cursor, DBMS_SQL.IS_OPEN etc.
    src_cur := dbms_sql.to_refcursor(v_cur_id);
    fetch src_cur bulk collect into l_res;
    close src_cur;
    
    dbms_output.put_line(l_res.count);
    
    for i in l_res.first .. l_res.last loop
        dbms_output.put_line(l_res(i));
    end loop;
end;
/


-- NDS [Bulk Collect]
declare
    l_smt varchar2(1000);
    l_colnm varchar2(30);
    l_tabnm varchar2(30);
    l_where varchar2(30);
    l_filt varchar2(30);
    
    type t_tb_type is table of varchar2(50);
    l_res t_tb_type;
    n int := 5;
begin
    l_colnm := 'first_name';
    l_tabnm := 'employees';
    l_where := 'employee_id';
    l_filt := 100;
    l_smt := 'select ' || l_colnm ||
             ' from ' || l_tabnm ||
             ' where ' || l_where ||
             ' >= ' || l_filt ||
             ' fetch first :n rows only';
    execute immediate l_smt bulk collect into l_res using n;
    
    dbms_output.put_line(l_res.count);
    
    for i in l_res.first .. l_res.last loop
        dbms_output.put_line(l_res(i));
    end loop;
end;
/

-- SYS_REFCURSOR
create or replace function emp_refcur_func (i_empid in int)
    return sys_refcursor
is
    emp_refcur SYS_REFCURSOR;
begin
    open emp_refcur for
    select employee_id || ':'  || first_name as id
    from EMPLOYEES
    where employee_id = i_empid;
    
    return emp_refcur;
end emp_refcur_func;
/

declare
    emp_refcur SYS_REFCURSOR;
    emp_recid varchar2(50);
begin
    emp_refcur := emp_refcur_func(100);
    loop
        fetch emp_refcur into emp_recid;
        exit when emp_refcur%notfound;
        dbms_output.put_line('emp_recid --> ' || emp_recid);
    end loop;
    if emp_refcur%isopen then
        dbms_output.put_line('emp_refcur is open!');
        close emp_refcur;
    end if;
end;
/


-- Package Hygiene
-- Declare cursor in pkg spec and define it in 
CREATE OR REPLACE PACKAGE emp_stuff AS
  CURSOR c1 RETURN employees%ROWTYPE; -- Declare cursor
END emp_stuff;
/
CREATE OR REPLACE PACKAGE BODY emp_stuff AS
  CURSOR c1 RETURN employees%ROWTYPE IS
    SELECT * FROM employees WHERE salary > 20000; -- Define cursor
END emp_stuff;
/

begin
    for rec in emp_stuff.c1 loop
        dbms_output.put_line(rec.employee_id || ':' || rec.salary);
    end loop;
end;
/
-- 100:24000

-- ACCESSIBLE BY [Package]
CREATE OR REPLACE PACKAGE protected_pkg
AS
  PROCEDURE public_proc;
  PROCEDURE private_proc ACCESSIBLE BY (PROCEDURE top_trusted_proc);
END;
/
-- Package PROTECTED_PKG compiled

CREATE OR REPLACE PACKAGE BODY protected_pkg
AS
  PROCEDURE public_proc AS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Executed protected_pkg.public_proc');
  END;
  PROCEDURE private_proc ACCESSIBLE BY (PROCEDURE top_trusted_proc) AS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Executed protected_pkg.private_proc');
  END;
END;
/
-- Package Body PROTECTED_PKG compiled

CREATE OR REPLACE PROCEDURE top_trusted_proc 
AS
BEGIN
 DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls protected_pkg.private_proc ');
 protected_pkg.private_proc;
END;
/
-- Procedure TOP_TRUSTED_PROC compiled

EXEC top_trusted_proc;
/*
top_trusted_proc calls protected_pkg.private_proc 
Executed protected_pkg.private_proc
*/

EXEC protected_pkg.private_proc;
-- PLS-00904: insufficient privilege to access object PRIVATE_PROC

-- ACCESSIBLE BY [Restricting access to a object type]
CREATE OR REPLACE PROCEDURE top_protected_proc
  ACCESSIBLE BY (PROCEDURE top_trusted_proc)
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Executed top_protected_proc.');
END;
/
-- Procedure TOP_PROTECTED_PROC compiled

CREATE OR REPLACE PROCEDURE top_trusted_proc AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls top_protected_proc');
  top_protected_proc;
END;
/
-- Procedure TOP_TRUSTED_PROC compiled

CREATE OR REPLACE TRIGGER top_trusted_proc
after delete on people
begin
   dbms_output.put_line('DELETED!');
   top_protected_proc;
end;
/
-- PLS-00904: insufficient privilege to access object TOP_PROTECTED_PROC

select * from user_errors;

EXEC top_trusted_proc;
/*
top_trusted_proc calls top_protected_proc
Executed top_protected_proc.
*/

EXEC top_protected_proc;
/*
PLS-00904: insufficient privilege to access object TOP_PROTECTED_PROC
*/

-- ACCESSIBLE BY
CREATE OR REPLACE PROCEDURE top_protected_proc
  ACCESSIBLE BY (top_trusted_proc)
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Executed top_protected_proc.');
END;
/
-- Procedure TOP_PROTECTED_PROC compiled

CREATE OR REPLACE PROCEDURE top_trusted_proc AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls top_protected_proc');
  top_protected_proc;
END;
/
-- Procedure TOP_TRUSTED_PROC compiled

CREATE OR REPLACE FUNCTION top_trusted_proc RETURN NUMBER AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('top_trusted_proc calls top_protected_proc');
  top_protected_proc;
  return 100;
END;
/
-- ORA-00955: name is already used by an existing object

CREATE OR REPLACE TRIGGER people_trig
after delete on people
begin
   dbms_output.put_line('DELETED!');
   top_protected_proc;
end;
/
-- PLS-00904: insufficient privilege to access object TOP_PROTECTED_PROC

CREATE OR REPLACE TRIGGER top_trusted_proc
after delete on people
begin
   dbms_output.put_line('DELETED!');
   top_protected_proc;
end;
/
-- Trigger TOP_TRUSTED_PROC compiled

select * from user_errors;

EXEC top_trusted_proc;
/*
top_trusted_proc calls top_protected_proc
Executed top_protected_proc.
*/

EXEC top_protected_proc;
/*
PLS-00904: insufficient privilege to access object TOP_PROTECTED_PROC
*/

-- SERIALLY_REUSABLE (Cursor)
DROP TABLE people;
CREATE TABLE people (name VARCHAR2(20));
 
INSERT INTO people (name) VALUES ('John Smith');
INSERT INTO people (name) VALUES ('Mary Jones');
INSERT INTO people (name) VALUES ('Joe Brown');
INSERT INTO people (name) VALUES ('Jane White');
COMMIT;

CREATE OR REPLACE PACKAGE sr_pkg IS
  PRAGMA SERIALLY_REUSABLE;
  CURSOR c IS SELECT name FROM people;
END sr_pkg;
/

CREATE OR REPLACE PROCEDURE fetch_from_cursor IS
  v_name  people.name%TYPE;
BEGIN
  IF sr_pkg.c%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Cursor is open.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Cursor is closed; opening now.');
    OPEN sr_pkg.c;
  END IF;
 
  FETCH sr_pkg.c INTO v_name;
  DBMS_OUTPUT.PUT_LINE('Fetched: ' || v_name);
 
  FETCH sr_pkg.c INTO v_name;
    DBMS_OUTPUT.PUT_LINE('Fetched: ' || v_name);
  END fetch_from_cursor;
/

-- Run-1
BEGIN
  fetch_from_cursor;
  fetch_from_cursor;
END;
/

/*
Cursor is closed; opening now.
Fetched: John Smith
Fetched: Mary Jones
Cursor is open.
Fetched: Joe Brown
Fetched: Jane White
*/

BEGIN
  fetch_from_cursor;
  fetch_from_cursor;
END;
/

/*
Cursor is closed; opening now.
Fetched: John Smith
Fetched: Mary Jones
Cursor is open.
Fetched: Joe Brown
Fetched: Jane White
*/

CREATE OR REPLACE PACKAGE pkg IS
  CURSOR c IS SELECT name FROM people;
END pkg;
/

CREATE OR REPLACE PROCEDURE fetch_from_cursor_nonser IS
  v_name  people.name%TYPE;
BEGIN
  IF pkg.c%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Cursor is open.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Cursor is closed; opening now.');
    OPEN pkg.c;
  END IF;
 
  FETCH pkg.c INTO v_name;
  DBMS_OUTPUT.PUT_LINE('Fetched: ' || v_name);
 
  FETCH pkg.c INTO v_name;
    DBMS_OUTPUT.PUT_LINE('Fetched: ' || v_name);
END fetch_from_cursor_nonser;
/

-- Run-1
BEGIN
  fetch_from_cursor_nonser;
  fetch_from_cursor_nonser;
END;
/

/*
Cursor is closed; opening now.
Fetched: John Smith
Fetched: Mary Jones
Cursor is open.
Fetched: Joe Brown
Fetched: Jane White
*/

BEGIN
  fetch_from_cursor_nonser;
  fetch_from_cursor_nonser;
END;
/

/*
Cursor is open.
Fetched: 
Fetched: 
Cursor is open.
Fetched: 
Fetched: 
*/

-- SERIALLY_REUSABLE
select * from user_objects where object_name = 'PKG';
select * from user_source where name = 'PKG';
drop package pkg;
drop package sr_pkg;

CREATE OR REPLACE PACKAGE pkg IS
  n NUMBER := 5;
END pkg;
/

CREATE OR REPLACE PACKAGE sr_pkg IS
  PRAGMA SERIALLY_REUSABLE;
  n NUMBER := 5;
END sr_pkg;
/

BEGIN
  pkg.n := 10;
  sr_pkg.n := 10;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('pkg.n: ' || pkg.n); --10
  DBMS_OUTPUT.PUT_LINE('sr_pkg.n: ' || sr_pkg.n); --5
END;
/


-- Packages Global Variable
drop table t1;

create table t1
(
    v1 number,
    v2 varchar2(10),
    v3 number default 10 not null
);

desc t1;

declare
    v1_test t1.v1%type;
    v3_test t1.v3%type; -- no error
BEGIN
    --v1_test := 'rakesh'; -- error
    v3_test := '';
end;
/

create or replace PACKAGE pkg1 is
    v1_test t1.v1%type;
    v2_test t1.v2%type;
    v3_test t1.v3%type;

    v1 number;
    -- v2 CONSTANT number; -- error due to not initialized
    v2 CONSTANT number := 10;
    -- v1 varchar2(10) := 'ABC';
    -- PLS-00371: at most one declaration for 'V1' is permitted
    v3 varchar2(10) := 'ABC';
    -- v4 number not null; -- error due to not null
    v4 varchar2(10) not null := 'rakesh';
    procedure p1(i_v1 in number);
    procedure p1(i_v1 in varchar2);
    procedure p1(i_v1 in PLS_INTEGER); -- This works
    -- procedure p1(i_v1 in char); 
    -- PLS-00307: too many declarations of 'P1' match this call
    function f1(i_v1 in varchar2) return number;
    function f1(i_v1 in varchar2) return varchar2;
    function f2(i_v1 in number) return number;
    function f2(i_v1 in varchar2) return varchar2;
end pkg1;
/

create or replace PACKAGE BODY pkg1 is
    procedure p1(i_v1 in number) is
    BEGIN
        dbms_output.PUT_LINE('Hi p1_number!');
    end p1;
    procedure p1(i_v1 in varchar2) is
    BEGIN
        dbms_output.PUT_LINE('Hi p1_varchar2!');
    end p1;
    procedure p1(i_v1 in PLS_INTEGER) is
    BEGIN
        dbms_output.PUT_LINE('Hi p1_plsint!');
    end p1;
    procedure p1(i_v1 in char) is
    BEGIN
        dbms_output.PUT_LINE('Hi p1_char!');
    end p1;
    function f1(i_v1 in varchar2) return number is
    BEGIN
        dbms_output.PUT_LINE('Hi f1_num!');
        return 1;
    end f1;
    function f1(i_v1 in varchar2) return varchar2 is
    BEGIN
        dbms_output.PUT_LINE('Hi f1_char!');
        return 'rakesh';
    end f1;
    function f2(i_v1 in number) return number is
    BEGIN
        dbms_output.PUT_LINE('Hi f1_num!');
        return 1;
    end f2;
    function f2(i_v1 in varchar2) return varchar2 is
    BEGIN
        dbms_output.PUT_LINE('Hi f1_char!');
        return ('rakesh' || ' ' || i_v1);
    end f2;
begin
    v1 := 1000;
end pkg1;
/

show error;
select * from user_source where name = 'PKG1';
select * from user_objects where object_name = 'PKG1';
alter package pkg1 compile;
select * from user_errors where attribute = 'ERROR';

-- Oveloading of packaged sub-programs
declare
    v1 number;
    v2 varchar2(50);
begin
    --v1 := pkg1.f1(I_V1=>1);
    --PLS-00307: too many declarations of 'F1' match this call
    v1 := pkg1.f2(I_V1=>1);
    dbms_output.put_line(v1);
    v2 := pkg1.f2(i_v1=>'panigrahi');
    dbms_output.put_line(v2);
end;
/

begin
    pkg1.P1(I_V1=>1);
    pkg1.P1(I_V1=>'1');
    pkg1.P1(I_V1=>200);
    pkg1.P1(I_V1=>'rakesh');
end;
/

begin
    dbms_output.PUT_LINE(pkg1.v1);
    dbms_output.PUT_LINE(pkg1.v2);
    -- pkg1.v2 := 200;
    -- PLS-00363: expression 'PKG1.V2' cannot be used as an assignment target
    -- This is due to CONSTANT
    dbms_output.PUT_LINE(pkg1.v3);
    pkg1.v3 := 'DEF';
    dbms_output.PUT_LINE(pkg1.v3);
    dbms_output.PUT_LINE(pkg1.v4);
    -- pkg1.v4 := '';
    -- ORA-06502: PL/SQL: numeric or value error
end;
/

begin
    pkg1.v1_test := 10;
    pkg1.v2_test := 'rakesh';
    pkg1.v3_test := '';
    dbms_output.PUT_LINE(pkg1.v1_test);
    dbms_output.PUT_LINE(pkg1.v2_test);
    dbms_output.PUT_LINE(pkg1.v3_test);
end;
/

declare
    -- v4_test pkg1.v4%type; 
    -- error as package not null type is inherited unlike table
    v4_test pkg1.v4%type := 10; 
    v2_test pkg1.v2%type;
begin
    v2_test := 2345;
    dbms_output.PUT_LINE(pkg1.v2_test);
    dbms_output.PUT_LINE(v2_test);
end;
/

-- Overloading of standalone sub-program is not allowed
drop PROCEDURE p1;

create procedure p1(i_v1 in number) IS
BEGIN
    null;
end;
/

create procedure p1(i_v1 in varchar2) IS
BEGIN
    null;
end;
/

-- Exception Handling
declare
    v_nbr1 number := 10;
    v_nbr2 number := 10;
    e_exp1 EXCEPTION;
    e_exp2 EXCEPTION;
    INVALID_NUMBER EXCEPTION;
begin
    if (v_nbr1 <> v_nbr2) THEN
        raise e_exp1;
        dbms_output.put_line(v_nbr1);
    end if;

    declare
        v_nbr1 number := 100;
        v_nbr2 number := 200;
    begin
        if (v_nbr1 = v_nbr2) THEN
            raise e_exp2;
        end if;
    exception
        when e_exp2 then 
            dbms_output.put_line('Error from e_exp2!' || v_nbr1 || '~' || v_nbr2);
    end;
    
    select to_number('ABC') into v_nbr1 from dual;
exception
    when e_exp1 then
        dbms_output.put_line('Error from e_exp1!' || v_nbr1 || '~' || v_nbr2);
    when e_exp2 then
        dbms_output.put_line('Error from e_exp2!' || v_nbr1 || '~' || v_nbr2);
    when INVALID_NUMBER then
        dbms_output.put_line('Error from INVALID_NUMBER!' || v_nbr1 || '~' || v_nbr2);
    when others then
        --dbms_output.put_line('Error from others!' || v_nbr1 || '~' || v_nbr2);
        --dbms_output.put_line(sqlerrm);
        dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_STACK');
        dbms_output.put_line ( DBMS_UTILITY.FORMAT_ERROR_STACK() );
        --PL/SQL at ORA-06502: numeric or value error: character to number conversion error
        dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE');
        dbms_output.put_line ( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ); 
        --a at ORA-06512: line 23
        -- dbms_output.put_line ( DBMS_UTILITY.FORMAT_CALL_STACK() );
        /*
        ----- PL/SQL Call Stack -----
        object      line  object
        handle    number  name
        0x48d44fa58        36  anonymous block
        */
end;
/

BEGIN
  DECLARE
    credit_limit CONSTANT NUMBER(3) := 5000;
  BEGIN
    NULL;
  EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Exception raised in declaration-sub');  
  END;
 
EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('Exception raised in declaration-main');
END;
/

-- Named/Positional notation
declare
    v_out number;
    procedure proc1 (v_1 number,v_2 varchar2,v_3 number default 100,v_4 out number) is
    begin v_4 := v_1+v_2+v_3; end proc1;
    procedure proc2 (v_1 number,v_2 varchar2,v_3 out number,v_4 number default 100) is
    begin v_3 := v_1+v_2+v_4; end proc2;
begin
    proc1(4,3,7,v_out); dbms_output.put_line(v_out); --14
    proc1(4,3,'',v_out); dbms_output.put_line(nvl(to_char(v_out),'NULL')); --null
    proc2(4,3,v_out); dbms_output.put_line(v_out); --107
end;
/

variable c number
------ Positional ------
execute add_nbr(:c); -- Error
execute add_nbr(10, 20, :c); --70
execute add_nbr(10, 20, c => :c); --70
execute add_nbr(:c,20); -- Error: Wrong position
------ Named ------
execute add_nbr(i => 20, j => 40, k => :c); -- Error: Wrong Param name
execute add_nbr(a => 20, b => 40, c => :c); --110
execute add_nbr(b => 20, a => 40, c => :c); --130
execute add_nbr(b => 40, c => :c); --90
execute add_nbr(c => :c); --70
------ Mixed ------
execute add_nbr(10, c => :c); -- Error
execute add_nbr(10, 20, c => :c); -- 70
print c

--Testing Function Creation
create or replace function func1 return number is
begin
    null;
end;
/

select func1 from dual; -- ORA-06503: PL/SQL: Function returned without value

var nbr1 number;
exec :nbr1 := func1; -- ORA-06503: PL/SQL: Function returned without value
print nbr1;

create or replace function func1 return number is
begin
    return 1;
end;
/

select func1 from dual; --1

var nbr1 number;
exec :nbr1 := func1;
print nbr1; --1

create or replace function func1 (v_out number default 1) return number is
begin
    null;
end;
/

var nbr1 number;
exec :nbr1 := func1;
print nbr1; --ORA-06503: PL/SQL: Function returned without value

--Testing Procedure Creation

create or replace procedure proc1 (v_out in out number) is
-- Error(8,18): PLS-00230: OUT and IN OUT formal parameters may not have default expressions
begin
    v_out := 10; 
    --Error(10,5): PLS-00363: expression 'V_OUT' cannot be used as an assignment target
    -- This occured when v_out was only in formal parameter
    return;
end;
/

var nbr1 number;
exec proc1(:nbr1);
print nbr1; 

--Qn
DECLARE
  TYPE aa_type IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa aa_type; -- Associative array
  TYPE nt_type IS TABLE OF INTEGER;
  nt  nt_type := nt_type(1,3,5); -- Nested table  
  TYPE va_type IS VARRAY(4) OF INTEGER;
  va  va_type := va_type(2,4); -- Varray
BEGIN
  aa(1):=3; aa(2):=6; aa(3):=9; aa(4):= 12;
  dbms_output.put_line(aa.LIMIT || '~' || aa.COUNT || '~' || aa.LAST); --~4~4
  dbms_output.put_line(nt.LIMIT || '~' || nt.COUNT || '~' || nt.LAST); --~3~3 
  dbms_output.put_line(va.LIMIT || '~' || va.COUNT || '~' || va.LAST); --4~2~2
END;
/

--Qn
declare
    type emptype is VARRAY(10) OF employees.employee_id%type; -- VARRAY
    --emptable emptype;
    -- ORA-06531: Reference to uninitialized collection (works if not referred anywhere)
    emptable emptype := emptype();
    j pls_integer := 100;
    procedure print_tab(i_emptable emptype) is begin 
        for i in i_emptable.first.. i_emptable.last loop
            if i_emptable.exists(i) then dbms_output.put_line(i_emptable(i)); end if;
        end loop; 
        dbms_output.put_line('------------------');
    end print_tab;
begin
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --10~0~
    for i in 1..8 loop
        emptable.EXTEND;
        select employee_id into emptable(i) from employees where employee_id = j;
        j := j+1;
    end loop;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --10~8~8
    print_tab(emptable); --100
    --emptable.DELETE(6); -- Not allowed to delete a specific element
    emptable.DELETE;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --10~0~
end;
/

--Qn
declare
    type emptype is table of employees.employee_id%type; -- Nested Table
    --emptable emptype;
    -- ORA-06531: Reference to uninitialized collection (works if not referred anywhere)
    emptable emptype := emptype();
    emptable1 emptype := emptype(1);
    j pls_integer := 100;
    procedure print_tab(i_emptable emptype) is begin 
        for i in i_emptable.first.. i_emptable.last loop
            if i_emptable.exists(i) then dbms_output.put_line(i_emptable(i)); end if;
        end loop; 
        dbms_output.put_line('------------------');
    end print_tab;
begin
    dbms_output.put_line(emptable1.LIMIT || '~' || emptable1.COUNT); --1
    for i in 1..1 loop
        -- EXTEND not required as Collection is already initialized with some value
        select employee_id into emptable1(i) from employees where employee_id = j;
        j := j+1;
    end loop;
    dbms_output.put_line(emptable1.LIMIT || '~' || emptable1.COUNT); --1
    print_tab(emptable1); --100
    
    j := 100;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT); --0
    for i in 1..8 loop
        emptable.EXTEND; -- EXTEND Must for an empty or null collection
        select employee_id into emptable(i) from employees where employee_id = j;
        j := j+1;
    end loop;
    
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~8~8
    print_tab(emptable); --100 101 102 103 104 105 106 107
    emptable.DELETE(6);
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~7~8
    print_tab(emptable); --100 101 102 103 104 106 107
    emptable.TRIM;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~6~7
    print_tab(emptable); --100 101 102 103 104 106    
    emptable.DELETE(2,4);
    print_tab(emptable); --100 104 106
    emptable.DELETE;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~0~
end;
/

--Qn
declare
    type emptype is table of employees%ROWTYPE INDEX BY pls_integer; -- Associative Array
    emptable emptype;
    procedure print_tab(i_emptable emptype) is begin 
        for i in i_emptable.first.. i_emptable.last loop
            if i_emptable.exists(i) then dbms_output.put_line(i_emptable(i).employee_id); end if;
        end loop; 
        dbms_output.put_line('------------------');
    end print_tab;
begin
    for i in 100..107 loop
        select * into emptable(i) from employees where employee_id = i;
    end loop;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~8~107
    emptable.DELETE(105);
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~7~107
    print_tab(emptable); --100 101 102 103 104 106 107
    --emptable.TRIM; --N/A for INDEX BY table
    emptable.DELETE(101,106);
    print_tab(emptable); --100 107
    emptable.DELETE;
    dbms_output.put_line(emptable.LIMIT || '~' || emptable.COUNT || '~' || emptable.LAST); --~0~
end;
/

--Qn
declare
    type t_rec is record ( v_employee_id employees.employee_id%type,
        v_first_name employees.first_name%type, v_deflt pls_integer default 100 );   
    v_rec t_rec;
    v_emprec employees%rowtype;
    v_rec1 t_rec;
begin
    select employee_id,first_name,'' into v_rec from employees where employee_id = 1; 
    dbms_output.put_line(v_rec.v_employee_id || '~' || v_rec.v_first_name); -- 1~Tommy
    select * into v_emprec from employees where employee_id = 1; 
    v_emprec.employee_id := 1000;
    insert into employees values v_emprec returning employee_id,first_name,'' into v_rec1;
    dbms_output.put_line(v_rec1.v_employee_id || '~' || v_rec1.v_first_name); -- 1000~Tommy
    v_emprec.employee_id := 2000;
    update employees set ROW = v_emprec where employee_id = 1000 
        returning employee_id,first_name,'' into v_rec1;
    dbms_output.put_line(v_rec1.v_employee_id || '~' || v_rec1.v_first_name); -- 2000~Tommy
    rollback;
end;
/

select * from employees order by 1;

--Qn
<<outer>>
declare
    v_outer pls_integer := 1;
begin
    declare
        v_inner pls_integer := 1;
        v_outer pls_integer := 2;
    begin
        dbms_output.put_line(v_inner); --1
        dbms_output.put_line(v_outer); --2
        dbms_output.put_line(outer.v_outer); --1
        outer.v_outer := 1000; -- overrides global variable
        dbms_output.put_line(outer.v_outer); --1000
    end;
    --dbms_output.put_line(v_inner); --Error
    -- Inner block variable, not accessible to outer block
    dbms_output.put_line(v_outer); --1000
end;
/

--Qn
create sequence my_seq
nominvalue
nomaxvalue;

select my_seq.currval from dual; --Error
/*
ORA-08002: sequence MY_SEQ.CURRVAL is not yet defined in this session
*Cause: sequence CURRVAL has been selected before sequence NEXTVAL
*Action: select NEXTVAL from the sequence before selecting CURRVAL
*/

select my_seq.nextval from dual;

select my_seq.currval from dual; -- No Error

declare
    v_nbr pls_integer;
begin
    --v_nbr := my_seq.currval; --Error
    v_nbr := my_seq.nextval;
    dbms_output.put_line(v_nbr); --3
    dbms_output.put_line(my_seq.currval); --3
end;
/

--Qn
declare
    --var1 varchar2(50) not null; -- Error
    var1 varchar2(50) NOT NULL := 'Rakesh';
    var1 number NOT NULL := 1;
    --var1 CONSTANT number; -- Error
    --var1 number CONSTANT := 1; -- Error
    var1 CONSTANT number := 1;
    --var1 CONSTANT varchar2(50) := 1; -- Error (due to CONSTANT)
    var3 CONSTANT number NOT NULL := 1;
    --var3 number := 1; -- Error (due to CONSTANT)
    var5 number DEFAULT 1;
begin
    dbms_output.put_line(var3);
end;
/

--Qn
declare
    --2_mile number; -- Can't start with a number
    --$mile number; -- Can't start with $, system variable
    --mile,nbr number; -- Can't have ,
    varchar2 number; 
    -- in 19c this is working
    mile_integer number;
    mile#_nbr number; -- Can have # or _
    mile_2 number; -- Can have number
    this_is_a_user_defined_variable number;  -- 31 char
    -- in 19c this is working
begin
    varchar2 := 5;
    dbms_output.put_line(varchar2);
end;
/

------------- 01-Oct-2022 -------------

--Qn
CREATE OR REPLACE package pkg as
--type tab_typ is table of varchar2(10) index by VARCHAR2;
type tab_typ is table of varchar2(10) index by VARCHAR2(1);
-- String length constraints must be in range (1 .. 32767)
--type tab_typ is table of varchar2(10) index by PLS_INTEGER;
--function tab_end (p_tab in tab_typ) return varchar2;
function tab_end (p_tab in tab_typ) return integer;
end pkg;
/

CREATE OR REPLACE package body pkg as
--function tab_end(p_tab in tab_typ) return varchar2 is
function tab_end(p_tab in tab_typ) return integer is
begin
return p_tab.last;
end;
end pkg;
/

declare
    l_stmt varchar2(100);
    l_list pkg.tab_typ;
    l_result varchar2(10);
begin
    l_list(1) := 'Mon';
    l_list(2) := 'Tue';
    l_stmt := 'SELECT pkg.tab_end(:l_list) into :i_result from dual';
    execute immediate l_stmt into l_result using l_list;
    -- PLS-00457: expressions have to be of SQL types
    dbms_output.put_line(l_result);
end;
/

--Qn
DECLARE
    TYPE emp_info IS RECORD (emp_id NUMBER(3), expr_summary CLOB);
    TYPE emp_typ IS TABLE OF emp_info;
    l_emp emp_typ;
    l_emp1 emp_typ;
    l_rec emp_info;
begin 
    l_rec.emp_id := 1; 
    l_rec.expr_summary := NULL; 
    l_emp := emp_typ(l_rec); 
    IF l_emp(1).expr_summary IS NULL then 
        dbms_output.put_line('Summary IS NULL');
        dbms_output.put_line(l_emp(1).emp_id);
    end if; 
    l_emp1 := emp_typ();
    --l_emp1.extend();
    if not l_emp1.EXISTS(1) then dbms_output.put_line('Extended'); end if;
    dbms_output.put_line(l_emp1.COUNT);
END;
/

--Qn
CREATE OR REPLACE FUNCTION update_salary (
    p_nm  VARCHAR2,
    p_sal NUMBER
) RETURN PLS_INTEGER AS 
LANGUAGE JAVA NAME "Employee.updateSalary" (java.lang.String, float) RETURN INT;

--Qn
CREATE OR REPLACE FUNCTION OT.invoice_date 
    RETURN VARCHAR2
    --RETURN DATE --Fix-1
    RESULT_CACHE
    AUTHID definer
IS
    l_date VARCHAR2(50);
BEGIN
    --l_date := to_char(sysdate); --Fix-2
    l_date := sysdate;
    RETURN l_date;
END;
/

grant execute on invoice_date to hr;

-- run in unshared worksheet
alter session set nls_date_format = 'DD-MON-RRRR HH24.MI.SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY MM DD';
select ot.invoice_date() from dual;

--Qn
DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type; BEGIN my_tab(1):= 1; END;
-- Reference to uninitialized collection

DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type := tab_type(2); 
BEGIN 
    dbms_output.put_line(my_tab(1)); --2
    my_tab(1) :=55; 
    dbms_output.put_line(my_tab(1)); --55
END;
-- Executes successfully

DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type; BEGIN my_tab. EXTEND(2); my_tab(1) := 55; END;
-- Reference to uninitialized collection

DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type; BEGIN my_tab := tab_type(); my_tab(1) := 55; END;
-- Subscript beyond count

DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type; 
BEGIN 
    my_tab := tab_type(); 
    --dbms_output.put_line(my_tab(1)); -- Subscript beyond count
    my_tab.EXTEND; 
    my_tab(1) := 55; 
    dbms_output.put_line(my_tab(1)); --55
END;
-- Executes successfully

DECLARE TYPE tab_type IS TABLE OF NUMBER; my_tab tab_type := tab_type(2, NULL, 50); 
BEGIN
    dbms_output.put_line(my_tab(1) || ':' || my_tab(2) || ':' || my_tab(3));
    my_tab.EXTEND(3,2); -- Append three copies of second element, here NULL value
    dbms_output.put_line(my_tab(1) || ':' || my_tab(2) || ':' || my_tab(3) || ':' || my_tab(4) || ':' || my_tab(5));
END;
-- Executes successfully

--Qn
--select * from EMPLOYEES;

DECLARE
    CURSOR l_name_cur IS
        SELECT LAST_NAME 
        FROM EMPLOYEES 
        FETCH NEXT 25 ROWS ONLY;
    TYPE l_name_type IS VARRAY(25) OF EMPLOYEES.last_name%type;
    --names_array l_name_type; --WRONG --Reference to uninitialized collection
    names_array l_name_type := l_name_type();
    v_index INTEGER := 0;
BEGIN
    FOR name_rec IN l_name_cur LOOP
        names_array.EXTEND(); -- DONT OMIT IT, Or will get ERROR: Subscript beyond count
        v_index := v_index + 1;
        names_array(v_index) := name_rec.last_name;
        DBMS_OUTPUT.PUT_LINE(names_array(v_index));
    END LOOP;
END;
/

--Qn
DECLARE
    TYPE ntbl IS TABLE OF VARCHAR2(20);
    v1 ntbl := ntbl('hello', 'world', 'test');
    TYPE ntb2 IS TABLE OF ntbl INDEX BY PLS_INTEGER;
    v3 ntb2;
BEGIN
    dbms_output.put_line(v1.count); --3
    dbms_output.put_line(v3.count); --0
    v3(31) := ntbl(4, 5, 6);
    dbms_output.put_line(v3.count); --1
    dbms_output.put_line(v3(31)(1) || ' ' || v3(31)(2) || ' ' || v3(31)(3)); --4 5 6
    v3(32) := v1;
    dbms_output.put_line(v3.count); --2
    dbms_output.put_line('Test: ' || v3(32)(1) || ' ' || v3(32)(2) || ' ' || v3(32)(3)); --hello world test
    v3(33) := ntbl(2,5,1);
    dbms_output.put_line(v3.count); --3
    dbms_output.put_line(v3(33)(1) || ' ' || v3(33)(2) || ' ' || v3(33)(3)); --2 5 1
    v3(31) := ntbl(1,1);
    dbms_output.put_line(v3.count); --3
    dbms_output.put_line(v3(31)(1) || ' ' || v3(31)(2)); --1 1
    v3.DELETE; --DELETE all elements
    dbms_output.put_line(v3.count); --0
END;
/

--Qn
CREATE FUNCTION emp_policy_fn (v_schema IN VARCHAR2, v_objname IN VARCHAR2)
RETURN VARCHAR2 AS
    con VARCHAR2 (200);
BEGIN
    con:= 'deptno= 30';
    RETURN con;
END emp_policy_fn;
/

BEGIN
    DBMS_RLS.ADD_POLICY 
    (
        object_schema =>'scott' ,
        object_name=> 'emp',
        policy_name=> 'emp_policy',
        policy_function=>'emp_policy_fn',
        update_check=> TRUE,
        statement_types => 'SELECT, UPDATE',
        sec_relevant_cols=> 'sal, comm'
    );
END;
/

--Qn
CREATE OR REPLACE CONTEXT ORDER_CTX USING orders_app_pkg;

CREATE OR REPLACE PACKAGE orders_app_pkg IS
    PROCEDURE set_app_context;
END;
/

CREATE OR REPLACE PACKAGE BODY orders_app_pkg IS
    c_context CONSTANT VARCHAR2(30) := 'ORDER_CTX';
    PROCEDURE set_app_context IS
        v_user VARCHAR2(30);
    BEGIN
        SELECT user INTO v_user FROM dual;
        DBMS_SESSION.SET_CONTEXT(c_context, 'ACCOUNT_MGR', v_user);
        DBMS_OUTPUT.PUT_LINE(v_user);
    END;
END;
/

declare
    var varchar2(2000);
begin
    orders_app_pkg.set_app_context;
    SELECT SYS_CONTEXT('ORDER_CTX', 'ACCOUNT_MGR') into var FROM dual;
    DBMS_OUTPUT.PUT_LINE(var);
end;
/

--Qn
CREATE OR REPLACE PACKAGE yearly_list IS
    TYPE list1 IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
    FUNCTION init_list1 RETURN list1;
END yearly_list;
/

CREATE OR REPLACE PACKAGE BODY yearly_list IS
    FUNCTION init_list1 RETURN list1 IS
        create_list list1;
    BEGIN
        create_list(1) := 'Jan';
        create_list(3) := 'Feb';
        create_list(6) := 'Mar';
        create_list(8) := 'Apr';
        RETURN create_list;
    END init_list1;
END yearly_list;
/

DECLARE
    --v_yrl yearly_list.create_list(); --ERROR --line2
    v_yrl yearly_list.list1 := yearly_list.init_list1(); --CORRECT
    location NUMBER := 1;
BEGIN
    WHILE location IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(v_yrl(location) || ' ' || v_yrl.NEXT(location));
        --location := v_yrl.NEXT; --ERROR --line7
        -- PLS-00306: wrong number or types of arguments in call to 'NEXT'
        location := v_yrl.NEXT(location); --CORRECT
    END LOOP;
END;
/
--Qn
--http://www.dba-oracle.com/t_adv_plsql_next_prior_methofs.htm
DECLARE
    TYPE va$ IS VARRAY(200) OF NUMBER;
    va va$ := va$();
BEGIN
    va.EXTEND(100);
    DBMS_OUTPUT.PUT_LINE('count: ' || va.count); --100
    DBMS_OUTPUT.PUT_LINE('limit: ' || va.limit); --200
    DBMS_OUTPUT.PUT_LINE('first: ' || va.first); --1
    DBMS_OUTPUT.PUT_LINE('last: ' || va.last); --100
    DBMS_OUTPUT.PUT_LINE('va(1): ' || va(1)); --null
    DBMS_OUTPUT.PUT_LINE('va(100): ' || va(100)); --null
    --DBMS_OUTPUT.PUT_LINE('va(101): ' || va(101)); --ORA-06533: Subscript beyond count
    DBMS_OUTPUT.PUT_LINE('va.next(1): ' || va.next(1)); --2
    DBMS_OUTPUT.PUT_LINE('va.next(99): ' || va.next(99)); --100
    DBMS_OUTPUT.PUT_LINE('va.next(100): ' || va.next(100)); --null
END;
/

--Qn
ALTER PLUGGABLE DATABASE ORCLPDB OPEN;
Login as OT@orclpdb

CREATE OR REPLACE PACKAGE pkg AS
    TYPE rec_typ IS RECORD (
        price   NUMBER,
        inc_pct NUMBER
    );
    PROCEDURE calc_price (
        price_rec IN OUT rec_typ
    );

END pkg;
/ 
CREATE OR REPLACE PACKAGE BODY pkg AS 
    PROCEDURE calc_price (
        price_rec IN OUT rec_typ
    ) AS
    BEGIN
        price_rec.price := price_rec.price + ( price_rec.price * price_rec.inc_pct ) / 100;
    END calc_price; 
END pkg; 
/ 

DECLARE 
    rec pkg.rec_typ; 
BEGIN 
    rec.price := 100; 
    rec.inc_pct := 50; 
    execute immediate 'BEGIN pkg.calc_price(:rec); END;' using in out rec; 
    DBMS_OUTPUT.PUT_LINE('rec.price: ' || rec.price);

    rec.price := 1000; 
    rec.inc_pct := 50;     
    begin
        pkg.calc_price(rec);
    end;
    DBMS_OUTPUT.PUT_LINE('rec.price: ' || rec.price);
    
    --execute immediate 'BEGIN pkg.calc_price(:rec); END;' using in out rec(100,50); 
    -- PLS-00308: this construct is not allowed as the origin of an assignment
    
    --execute immediate 'BEGIN pkg.calc_price(:rec); END;'; 
    -- ORA-01008: not all variables bound
END;
/

--Qn
select * from user$ where name = 'RAKESH';
select * from dba_role_privs where grantee = 'RAKESH';

--Qn
SET SERVEROUTPUT ON;
declare
    TYPE nbrLst IS TABLE OF INTEGER;
    N NbrLst := NbrLst (1,2,3,4,5);
begin
    --N.DELETE(1,5); --0
    --N.TRIM(); --4
    --N.DELETE(5); --4
    --N.DELETE(); --0
    dbms_output.put_line(N.COUNT());    
end;

--Qn
DECLARE
  x NUMBER := 5;
  y NUMBER := NULL;
BEGIN
  IF x != y THEN  -- yields NULL, not TRUE
    DBMS_OUTPUT.PUT_LINE('x != y');  -- not run
  ELSIF x = y THEN -- also yields NULL
    DBMS_OUTPUT.PUT_LINE('x = y');
  ELSE
    DBMS_OUTPUT.PUT_LINE
      ('Can''t tell if x and y are equal or not.');
  END IF;
END;
/
--Can't tell if x and y are equal or not.

--Qn
set serveroutput on;
declare
    "New" number := 1;
    --_a number; --Error
    a$ number;
    timestamp_dummy timestamp := systimestamp;
begin
    dbms_output.put_line('A quoted identifier New ['||"New"||']');
    dbms_output.put_line('timestamp_dummy: ' || timestamp_dummy);
end; 
/
--A quoted identifier New [1]
--timestamp_dummy: 27-FEB-22 02.50.41.542461 PM

--Qn
set SERVEROUTPUT ON
declare
    v_sal number(10,2) := 1000;
begin
    dbms_output.put_line('Salary is: ' || v_sal);
    declare
        v_sal number;
    begin
        select salary into v_sal from employees where employee_id = 195;
        dbms_output.put_line('Salary is: ' || v_sal);
        declare
            v_sal number := 5000;
        begin <<b3>>
            dbms_output.put_line('Salary is: ' || v_sal);
        end b3;
        dbms_output.put_line('Salary is: ' || v_sal);
    end;
end;
/
/*
Salary is: 1000
Salary is: 2800
Salary is: 5000
Salary is: 2800
*/

set SERVEROUTPUT ON
declare
    v_sal number(10,2) := 1000;
begin
    dbms_output.put_line('Salary is: ' || v_sal);
    --declare
        --v_sal number;
    begin
        select salary into v_sal from employees where employee_id = 195;
        dbms_output.put_line('Salary is: ' || v_sal);
        --declare
            --v_sal number;
        begin <<b3>>
            v_sal := 5000;
            dbms_output.put_line('Salary is: ' || v_sal);
        end b3;
        dbms_output.put_line('Salary is: ' || v_sal);
    end;
    dbms_output.put_line('Salary is: ' || v_sal);
end;
/

/*
Salary is: 1000
Salary is: 2800
Salary is: 5000
Salary is: 5000
Salary is: 5000
*/
-- without declare the v_sal global variable is getting overwiritten 
-- by the local variable

--Qn
SET SERVEROUTPUT ON
declare
    --date1 DATE := 'January 10, 2008';
    --ORA-01858: a non-numeric character was found where a numeric was expected
    date1 DATE := to_date('January 10, 2008', 'Month DD, YYYY');
    --Difference in dates is: 5162.570752314814814814814814814814814815
    date2 DATE := SYSDATE;
    date_diff number;
begin
    date_diff := date2-date1;
    dbms_output.put_line('Difference in dates is: ' || date_diff);
end;
/

--Qn
create table Audit_Records
(
    Sequence NUMBER, 
    User_Name VARCHAR2 (25),
    Login_Time DATE, 
    Job VARCHAR2(25), 
    Emp_ID NUMBER
);
/

CREATE OR REPLACE PROCEDURE Login_Pro (Name VARCHAR2) 
AS 
BEGIN 
    INSERT INTO Audit_Records (User_Name) VALUES (Name);
END Login_Pro;
/

CREATE OR REPLACE TRIGGER Logon_Trig 
AFTER LOGON ON DATABASE 
CALL Login_Pro (ORA_LOGIN_USER);
/
/*
It invokes the Login_Pro procedure after a database user logs on to the database 
and records the username of the database user in the Audit_Records table.
*/


--Qn
select ename, dname, job, empno, hiredate, loc  
from emp, dept  
where emp.deptno = dept.deptno  
order by ename;

create or replace trigger dept_restrict
    before delete or update of deptno on dept
declare
    dummy integer;
    employees_present exception;
    employees_not_present exception;
    cursor dummy_cursor(dn number) is 
        select deptno from emp where deptno = dn;
begin
    open dummy_cursor(:OLD.deptno);
    fetch dummy_cursor into dummy;
    if dummy_cursor%found then
        raise employees_present;
    else
        raise employees_not_present;
    end if;
    close dummy_cursor;
    
    exception
    when employees_present then
        close dummy_cursor;
        RAISE_APPLICATION_ERROR(-20001, 'Employees present in' || ' department '
                                        || to_char(:OLD.deptno));
    when employees_not_present then
        close dummy_cursor;
end;
/
-- ORA-04082: NEW or OLD references not allowed in table level triggers
-- It gives an error on compilation because it is not a row-level trigger.

--Qn
SET SERVEROUTPUT ON
declare
    type population is table of number index by varchar2(64);
    city_population population;
    i varchar2(64);
begin
    city_population('Smallville') := 2000;
    city_population('Midland') := 750000;
    city_population('Megalopolis') := 100000;
    city_population('AA') := 5;
    city_population('Smallville') := 2001;
    
    dbms_output.put_line('Total elements: ' || city_population.COUNT);
    
    i := city_population.FIRST;
    while i  is not null loop
        dbms_output.put_line('Population of ' || i  || ' is '
                            || to_char(city_population(i)));
        i := city_population.NEXT(i);
    end loop;
end;
/

/*
Total elements: 4
Population of AA is 5
Population of Megalopolis is 100000
Population of Midland is 750000
Population of Smallville is 2001
*/

SET SERVEROUTPUT ON
declare
    type population is table of varchar2(10) index by PLS_INTEGER;
    city_population population;
    i PLS_INTEGER;
begin
    city_population(2) := 'A';
    city_population(101) := 'B';
    city_population(100) := 'C';
    city_population(1) := 'D';
    city_population(2) := 'Z';
    
    dbms_output.put_line('Total elements: ' || city_population.COUNT);
    
    i := city_population.FIRST;
    while i  is not null loop
        dbms_output.put_line('Population of ' || i  || ' is '
                            || city_population(i));
        i := city_population.NEXT(i);
    end loop;
end;
/

/*
Total elements: 4
Population of 1 is D
Population of 2 is Z
Population of 100 is C
Population of 101 is B
*/

--Qn
SET SERVEROUTPUT ON
variable n1 number
variable n2 number
create or replace procedure proc1 (:n1 in out number) is
begin
    :n1 := 10;
    dbms_output.put_line(:n1);
end;
/
-- host variables cannot be referenced in stored proc

--Qn
CREATE OR REPLACE PROCEDURE wording IS 
    TYPE Definition IS RECORD ( word VARCHAR2(20), meaning VARCHAR2(200)); 
    lexicon Definition;
    PROCEDURE add_entry (word_list in out Definition) IS
    BEGIN
        word_list.word := 'aardvark'; 
        lexicon.word := 'aardwolf';
    End add_entry;
BEGIN
    add_entry(lexicon);
    dbms_output.put_line(word_list.word); 
    dbms_output.put_line(lexicon.word);
END wording;
/
-- Compilation Error: because the WORD_LIST variable is not visible in procedure wording

--Qn 
create or replace type string_typ
    as object
    (
        string1 VARCHAR2(100)
    );
/

create or replace type string_tab
    as table of string_typ;
/

desc string_typ
SET SERVEROUTPUT ON
declare
    in_string varchar2(25) := 'This is my test string.';
    out_string varchar2(25);
    procedure double(original in varchar2, new_string out varchar2) is
    begin
        new_string := original || ' + ' || original;
    exception
        when value_error then
            dbms_output.put_line('Output buffer not long enough.');
            commit;
    end;
begin
    double(in_string, out_string);
    dbms_output.put_line(in_string || '-' || out_string);
end;
/
/*
Output buffer not long enough.
This is my test string.-
*/

--Qn
create or replace procedure raise_salary
    (
        emp_id in number,
        amount in number,
        extra in number default 50
    )
is
begin
    update emp 
    set sal = sal + nvl(amount,0) + extra
    where empno=emp_id;
end raise_salary;
/

declare
    emp_num number(6) := 7900;
    bonus number(6);
    merit number(4);
begin
    --raise_salary(7845);
    --PLS-00306: wrong number or types of arguments in call to 'RAISE_SALARY'
    --raise_salary(emp_num, extra => 25);
    --PLS-00306: wrong number or types of arguments in call to 'RAISE_SALARY'
    raise_salary(7845, null, 25); --OK
    raise_salary(emp_num, extra => 25, amount => null); --OK
end;
/

--Qn
DECLARE
    Cust_name varchar2(20) NOT NULL := 'tom jones';
    Same_name cust_name%TYPE;
    --PLS-00218: a variable declared NOT NULL must have an initialization assignment
begin
    null;
end;
/

select * from USER_STATUS;

--Qn
create table emp_temp(deptno number(2), job varchar2(18));
/

SET SERVEROUTPUT ON
declare
    type numlist is table of number;
    depts numlist := numlist(10,20,30);
begin
    insert into emp_temp values(10, 'Clerk');
    insert into emp_temp values(20, 'Bookkeeper');
    insert into emp_temp values(30, 'Analyst');
    
    FORALL j in depts.FIRST..depts.LAST
        update emp_temp
        set job = job || ' (Senior) '
        where deptno = depts(j);
exception
    when others then 
        dbms_output.put_line('Problem in the forall statement!');
        dbms_output.put_line('Error: ' || SQLERRM);
        commit;
end;
/

/*
It gives an error but saves the inserted rows and the update to the first row.
Problem in the forall statement!
Error: ORA-12899: value too large for column "HR"."EMP_TEMP"."JOB" (actual: 20, maximum: 18)
*/

delete from emp_temp;
select * from emp_temp;

--Qn
SET SERVEROUTPUT ON
DECLARE
    v_customer      VARCHAR2(50) := 'womansport';
    v_credit_rating VARCHAR2(50) := 'excellent';
BEGIN
    DECLARE
        v_customer number(7) := 201 ;
        v_name Varchar2(25) := 'Unisport';
    BEGIN
        v_credit_rating := 'GOOD';
        Dbms_Output.Put_Line('Customer '||v_customer||' rating is '||v_credit_rating);
    END;
    Dbms_Output.Put_Line('Customer '||v_customer||' rating is '||v_credit_rating); 
end;
/

--Qn
create table t
(
    d varchar2(10)
);
/

create or replace view v1
as
select * from t;
/

select * from v1;

create or replace view v2
as
select * from v1;
/

select * from v2;

drop table t purge;
select object_name, status from user_objects where object_name in ('T','V1','V2');
-- What will happen to v1 and v2
-- Error in both v1 and v2 (INVALID)

drop view v1;
drop view v2;
/

-- Qn
set serveroutput on;
declare
    low number;
    high number;
begin
    low := 4;
    high := 4;
    
    for i in low..high loop
        dbms_output.put_line(i);
    end loop;
end;
/

/*
4
*/

-- Qn
set serveroutput on;
declare
    ex exception;
begin
    declare
        ex exception;
    begin
        raise ex;
    end;
exception
    when ex then
        dbms_output.put_line('ex');
    when others then
        dbms_output.put_line('others');
end;
/

/*
If you will remove the declare section of inner block,
then it will display "ex".
*/

/***************** examtopics-1z0148 *****************/
/*
Use OT schema, but before to that execute the below in HR -->
grant select on hr.employees to ot;
grant select on hr.departments to ot;
grant select on hr.countries to ot;
grant select on hr.jobs to ot;
grant select on hr.job_history to ot;
grant select on hr.locations to ot;
grant select on hr.regions to ot;
*/

-- Qn
clear scr;
declare
    type cur_t1 is ref cursor return hr.employees%rowtype;
    type cur_t2 is ref cursor;
    
    cur_1 cur_t1;
    cur_2 cur_t2;
    cur_3 sys_refcursor;
    
    cursor cur is select * from hr.employees;
    cursor curx return hr.employees%rowtype is select * from hr.employees;
    
    type l_emp_t is table of cur_1%rowtype index by pls_integer;
    l_emp l_emp_t;
begin
    open cur_3 for
    select * from hr.employees;
    cur_1 := cur_3;
 -- It works!
    fetch cur_1 bulk collect into l_emp;
    close cur_3;
    dbms_output.put_line(l_emp.COUNT);
    
--    open cur;
--    cur_1 := cur; 
-- -- It does not work!
--    close cur;
--    
--    open curx;
--    cur_1 := curx; 
-- -- Its does not work!
--    close curx;
    
--    open cur_1 for
--    select * from hr.employees;
--    cur := cur_1; 
-- -- It does not work! Reason: You cannot assign a value to an explicit cursor, use it in an expression!
--    end cur_1;
    
--    open cur;
--    cur_3 := cur;
-- -- Its does not work!    
--    close cur;

--    open cur_1 for
--    select * from hr.employees;
--    cur_3 := cur_1;
-- -- It works!
--    close cur_1;
end;
/

-- Qn
create or replace package t_pkg is
    type rec_typ is record (pdt_id integer, pdt_name varchar2(25));
    type tab_typ is table of rec_typ index by pls_integer;
    x tab_typ;
end t_pkg;
/

create or replace function t_func(x t_pkg.tab_typ) return varchar2 is
    r varchar2(100);
begin
    for i IN 1..x.COUNT loop
        r := r || ' ' || x(i).pdt_id || ' ' || x(i).pdt_name;
    end loop;
    return r;
end t_func;
/

declare
    y t_pkg.tab_typ;
    r varchar2(100);
begin
    y(1).pdt_id := 1;
    y(1).pdt_name := 'Rakesh';
    select t_func(y) into r from dual;
    dbms_output.put_line('r: ' || r);
end;
/

CREATE OR REPLACE FUNCTION p4 (y t_pkg.tab_typ) RETURN t_pkg.tab_typ IS 
BEGIN 
    EXECUTE IMMEDIATE 
        'SELECT pdt_id+100 as pdt_id, pdt_name || '' Panigarhi'' as pdt_name FROM TABLE(:b)' BULK COLLECT INTO t_pkg.x USING y;
    return t_pkg.x;
end p4;
/

declare
    y t_pkg.tab_typ;
begin
    y(1).pdt_id := 1;
    y(1).pdt_name := 'Rakesh';
    y := p4(y);
    dbms_output.put_line('y(1).pdt_id: ' || y(1).pdt_id);
    dbms_output.put_line('y(1).pdt_name: ' || y(1).pdt_name);
end;
/

CREATE OR REPLACE PROCEDURE p1(y IN OUT t_pkg.tab_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 
        'SELECT t_func(:b) FROM DUAL' INTO y using pkg.x;
end p1;
/
-- This does not work!

CREATE or replace PROCEDURE p2(v IN OUT VARCHAR2) IS 
    BEGIN EXECUTE IMMEDIATE 'SELECT t_f(:b) FROM DUAL' INTO v using t_pkg.x;
end p2;
/

CREATE OR REPLACE FUNCTION p3 RETURN t_pkg.tab_typ IS 
BEGIN 
    EXECUTE IMMEDIATE 'SELECT t_func(:b) FROM DUAL' INTO t_pkg.x; 
END p3;
/
show err;
-- This does not work! 

CREATE OR REPLACE PROCEDURE p5(y t_pkg.rec_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 'SELECT pdt_name FROM TABLE(:b)' BULK COLLECT INTO y USING t_pkg.x;
END p5;
/
show err;
-- This does not work!

CREATE OR REPLACE PROCEDURE p5(y t_pkg.tab_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 'SELECT pdt_name FROM TABLE(:b)' BULK COLLECT INTO y USING t_pkg.x;
END p5;
/
show err;
-- This does not work!

CREATE OR REPLACE PROCEDURE p5(y IN OUT t_pkg.rec_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 'SELECT pdt_name FROM TABLE(:b)' BULK COLLECT INTO y USING t_pkg.x;
END p5;
/
show err;
-- This does not work!

CREATE OR REPLACE PROCEDURE p5_mod (y t_pkg.rec_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 
        'SELECT pdt_id, pdt_name FROM TABLE(:b)' BULK COLLECT INTO t_pkg.x USING y;
end p5_mod;
/
-- This works!

CREATE OR REPLACE PROCEDURE p5_mod (y t_pkg.tab_typ) IS 
BEGIN 
    EXECUTE IMMEDIATE 
        'SELECT pdt_id, pdt_name FROM TABLE(:b)' BULK COLLECT INTO t_pkg.x USING y;
end p5_mod;
/
-- This works!

drop procedure p1;
drop procedure p2;
drop function p3;
drop function p4;
drop procedure p5;
drop procedure p5_mod;
drop function t_func;
drop package t_pkg;

-- Qn
describe all_plsql_object_settings;
select name, plsql_optimize_level, plsql_code_type from user_plsql_object_settings;
select * from user_errors;

-- Qn
DECLARE 
    SUBTYPE new_one IS BINARY_INTEGER RANGE 0..9; 
    my_val new_one;
    
    --SUBTYPE new_string IS VARCHAR2 (5) NOT NULL;
    -- PLS-00218: a variable declared NOT NULL must have an initialization assignment
    --my_str new_string;
    
    SUBTYPE new_one_1 IS NUMBER (2,1);
    my_val_1 new_one;
    
    --SUBTYPE new_one_2 IS INTEGER RANGE 1..10 NOT NULL;
    -- PLS-00218: a variable declared NOT NULL must have an initialization assignment
    --my_val_2 new_one_2;
    
    SUBTYPE new_one_3 IS NUMBER (1,0);
    my_val_3 new_one_3;
BEGIN 
    my_val := 0; 
    --my_str := 'abc';
    --my_val_1 := 12.5; -- ORA-06502: PL/SQL: numeric or value error
    --my_val_2 := 2;
    my_val_3 := -1;
END;
/

--------- Misc ---------

SELECT level, json_object(employee_id, first_name)
FROM hr.employees
START WITH employee_id = 100
CONNECT BY manager_id = prior employees.EMPLOYEE_ID;