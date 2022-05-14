--remove_special_characters
SELECT UPPER(NVL(TRIM(REPLACE(TRANSLATE(I_NAME,'~`!@#$%^&*()+=/{}[]|\:;''"",.<>?_-'' ''','~'),'')), ''))
FROM DUAL;

--Prints 1 to 100
select level
from dual
connect by level  <= 100;

select rownum
from dual
connect by rownum  <= 100;