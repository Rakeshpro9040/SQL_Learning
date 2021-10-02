PL/SQL Developer Test script 3.0
33
-- Created on 11/16/2019 by RAKES 
declare
  -- Local variables here
  i integer := 0;
begin
  -- Test statements here
  insert into REGISTRATION
    (SEX, CLASS, EMAIL, NAME)
  values
    ('Male', 'B. Tech', 'abc@gmail.com', 'Rakesh');
  savepoint s1;
  i := i+1;
  
  insert into REGISTRATION
    (SEX, CLASS, EMAIL, NAME)
  values
    ('Male', 'B. Tech', 'abc@gmail.com', 'Rakesh');
  savepoint s2;
  i := i+1;
--commit;

if (i = 1) then 
  rollback to s1;
end if;

commit;

Exception
  when others then
    dbms_output.put_line(SQLERRM); 
    rollback to s1;
    commit;
end;
0
2
i
