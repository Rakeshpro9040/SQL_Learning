select e.* from emp e;
delete from emp e where e.emp_no = 1007;
set SERVEROUTPUT ON

create table log
(dml_userid VARCHAR2(10),
dml_ts DATE);

select * from log;

declare
 emp_no number := 1006;
 exception_1 exception;
 procedure p1 is
  --PRAGMA AUTONOMOUS_TRANSACTION;
 begin
  dbms_output.put_line('OK');
  insert into log
  (dml_userid, dml_ts)
  values(user, sysdate);
  commit;
 end;
 
begin
 insert into emp
 (emp_no, emp_name, salary, manager, dept_no)
 values
 (1006, 'DDD', 6000, 'AAA', 40);
 
 if emp_no = 1006 then
  raise exception_1;
 end if;
 
 commit;
exception
 when exception_1 then
 dbms_output.put_line(sqlerrm);
 p1();
 rollback;
  
 when others then 
 dbms_output.put_line(sqlerrm);
 rollback;
end;