SELECT * FROM EMPLOYEES E WHERE E.MANAGER_ID = 1;
SELECT E.EMPLOYEE_ID, E.MANAGER_ID, E.JOB_TITLE, E.TERR_CDE FROM EMPLOYEES E
WHERE E.EMPLOYEE_ID IN (106,101,9,104,105,1,3,102,49,47, 21);
SELECT ET.*, ET.ROWID FROM EMPLOYEES_TERR ET;

UPDATE EMPLOYEES
SET TERR_CDE = '';

SELECT ET.TERR_CDE, E.*
FROM EMPLOYEES E, EMPLOYEES_TERR ET
WHERE E.MANAGER_ID = ET.MANAGER_ID
AND E.JOB_TITLE = ET.JOB_TITLE
AND ET.TERR_CDE = 'A5';

SELECT ET.TERR_CDE, E.*
FROM EMPLOYEES E, EMPLOYEES_TERR ET
WHERE E.MANAGER_ID = ET.MANAGER_ID
AND ET.TERR_CDE = 'A5';

SELECT E.EMPLOYEE_ID, E.TERR_CDE "OLD_TERR_CDE", ET.TERR_CDE "NEW_TERR_CDE"
FROM EMPLOYEES E, EMPLOYEES_TERR ET
WHERE E.MANAGER_ID = ET.MANAGER_ID
AND E.JOB_TITLE = ET.JOB_TITLE
AND E.EMPLOYEE_ID IN (106,101,9,104,105,1,3,102,49,47,21)
AND NVL(E.TERR_CDE, '~') <> NVL(ET.TERR_CDE, '~')
UNION
SELECT E.EMPLOYEE_ID, E.TERR_CDE "OLD_TERR_CDE", ET.TERR_CDE "NEW_TERR_CDE"
FROM EMPLOYEES E, EMPLOYEES_TERR ET
WHERE E.MANAGER_ID = ET.MANAGER_ID
AND ET.JOB_TITLE = '*'
AND E.EMPLOYEE_ID IN (106,101,9,104,105,1,3,102,49,47,21)
AND NVL(E.TERR_CDE, '~') <> NVL(ET.TERR_CDE, '~')
AND NOT EXISTS 
(SELECT NULL
FROM EMPLOYEES E1, EMPLOYEES_TERR ET1
WHERE E1.MANAGER_ID = ET1.MANAGER_ID
AND E1.JOB_TITLE = ET1.JOB_TITLE
AND E1.EMPLOYEE_ID = E.EMPLOYEE_ID);