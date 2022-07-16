--remove_special_characters
SELECT UPPER(NVL(TRIM(REPLACE(TRANSLATE(I_NAME,'~`!@#$%^&*()+=/{}[]|\:;''"",.<>?_-'' ''','~'),'')), ''))
FROM DUAL;

--Prints 1 to 100
/*
https://stackoverflow.com/questions/42184715/select-level-from-dual-connect-by-level-4-how-it-works-internally
*/
select level
from dual
connect by level  <= 100;

select rownum
from dual
connect by rownum  <= 100;

select r from (select rownum r from all_objects) e where r<=100;