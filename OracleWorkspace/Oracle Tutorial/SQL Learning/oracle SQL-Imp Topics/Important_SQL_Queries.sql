--remove_special_characters
SELECT UPPER(NVL(TRIM(REPLACE(TRANSLATE(I_NAME,'~`!@#$%^&*()+=/{}[]|\:;''"",.<>?_-'' ''','~'),'')), ''))
FROM DUAL;