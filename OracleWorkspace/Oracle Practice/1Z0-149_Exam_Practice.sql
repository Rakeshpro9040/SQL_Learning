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
    null;
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

















