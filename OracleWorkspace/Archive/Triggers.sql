
CREATE TABLE emp(
emp_no NUMBER,
emp_name VARCHAR2(50),
salary NUMBER,
manager VARCHAR2(50),
dept_no NUMBER);

CREATE TABLE dept( 
Dept_no NUMBER, 
Dept_name VARCHAR2(50),
LOCATION VARCHAR2(50));

CREATE TRIGGER emp_trig 
FOR INSERT 
ON emp
COMPOUND TRIGGER 
BEFORE EACH ROW IS 
BEGIN
  if inserting then
     :new.salary:=5000;
  end if;
END BEFORE EACH ROW;
END emp_trig;

CREATE TRIGGER emp_trig 
FOR INSERT 
ON emp
COMPOUND TRIGGER 
BEFORE EACH ROW IS 
BEGIN
  if inserting then 
     :new.salary:=5000;
   end if;
END BEFORE EACH ROW;
END emp_trig;

CREATE TRIGGER emp_trig 
FOR INSERT 
ON emp
COMPOUND TRIGGER 
AFTER EACH ROW IS 
BEGIN
:new.salary:=5000;
END AFTER EACH ROW;
END emp_trig;

select * from emp;
delete from emp;
INSERT INTO EMP VALUES(1004,'CCC',15000,'AAA',30);
