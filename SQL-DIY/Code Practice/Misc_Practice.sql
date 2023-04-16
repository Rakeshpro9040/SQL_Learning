-- Dynamic SQL
DECLARE
lv_sql VARCHAR2(500);
lv_emp_name VARCHAR2(50);
ln_emp_no NUMBER;
ln_salary NUMBER;
ln_manager NUMBER;
BEGIN
lv_sql:='SELECT ename,empno,sal,mgr FROM emp WHERE empno=:empno';
EXECUTE IMMEDIATE lv_sql INTO lv_emp_name,ln_emp_no,ln_salary,ln_manager USING 7839;
Dbms_output.put_line('Employee Name:'||lv_emp_name);
Dbms_output.put_line('Employee Number:'||ln_emp_no);
Dbms_output.put_line('Salary:'||ln_salary);
Dbms_output.put_line('Manager ID:'||ln_manager);
END;
/

select * from emp;

-- DBMS_* PKG
begin
    dbms_output.put_line(dbms_utility.get_time);
end;
/

https://rules.sonarsource.com/plsql/RSPEC-1059
http://www.dba-oracle.com/t_adv_plsql_format_error_backtrace.htm
https://oracle-base.com/articles/12c/utl-call-stack-12cr1

BEGIN
  RAISE_APPLICATION_ERROR(-20000, 'This is an error example');
EXCEPTION
  WHEN OTHERS THEN  -- Noncompliant; only FORMAT_ERROR_STACK is used
    DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK); -- "ORA-20000: This is an error example"
    DBMS_OUTPUT.PUT_LINE('');
END;
/

BEGIN
  RAISE_APPLICATION_ERROR(-20000, 'This is an error example');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK); -- "ORA-20000: This is an error example"
    DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- "ORA-06512: at line 2"
    DBMS_OUTPUT.PUT_LINE('');
END;
/

BEGIN
  raise no_data_found;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Backtrace => '||dbms_utility.format_error_backtrace);
  dbms_output.put_line('SQLCODE => '||SQLCODE);
END;
/

select dbms_metadata.get_ddl('TABLE','EMPLOYEES','HR') from dual;
select dbms_metadata.get_ddl('INDEX','DEPT_IDX','HR') from dual;


-- TABLE Type
create type exch_row as object (
    currency_cd VARCHAR2(9),
    exch_rt_eur NUMBER,
    exch_rt_usd NUMBER);

create type exch_tbl as table of exch_row;

declare
   l_row     exch_row;
   exch_rt   exch_tbl;
begin
   l_row := exch_row('7839', 1, 1);
   exch_rt  := exch_tbl(l_row);

   for r in (select i.*
               from hr.employees i, TABLE(exch_rt) rt
              where i.employee_id = rt.currency_cd) loop
      
    DBMS_OUTPUT.PUT_LINE(r.first_name);
   end loop;
end;
/

select * from hr.employees;
select * from user_tab_cols where column_name like upper('%CURR%');

-- Multi insert in MERGE
select * from user_tables order by 1;

drop table merge_test_src;
create table merge_test_src (
    test_col1 varchar2(10),
    test_col2 varchar2(10),
    test_col3 varchar2(10)
);
/

drop table merge_test_tgt;
create table merge_test_tgt (
    test_col1 varchar2(10),
    test_col2 varchar2(10),
    test_col3 varchar2(10)
);
/

select * from merge_test_src order by 1;
select * from merge_test_tgt order by 1;

insert all
    into merge_test_src 
    values ('4', 'ABC1', 'DEF2')
    
    into merge_test_src 
    values ('5', 'ABC2', 'DEF2')
    
    into merge_test_src 
    values ('6', 'ABC3', 'DEF3')
select 1 from dual;

merge into merge_test_tgt tgt
using merge_test_src src
on (src.test_col1 = tgt.test_col1)
when matched then
    update set tgt.test_col2 = src.test_col2,
        tgt.test_col3 = src.test_col3
when not matched then
    insert(test_col1, test_col2, test_col3)
    values(src.test_col1, src.test_col2, src.test_col3);












