-- Created on 11/23/2019 by RAKES 
declare 
  -- Local variables here
  i integer;
  V_TERR_CDE EMPLOYEES_TERR.TERR_CDE%TYPE;
  V_EID EMPLOYEES.EMPLOYEE_ID%TYPE := 1;
  V_MAPPING_ALL CHAR(1) := '*';
    
  CURSOR C1 IS
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

  
begin
  FOR C1_REC IN C1
    LOOP      
     UPDATE EMPLOYEES E
     SET E.TERR_CDE = C1_REC.NEW_TERR_CDE
     WHERE E.EMPLOYEE_ID = C1_REC.EMPLOYEE_ID;
     DBMS_OUTPUT.put_line('Employee '|| C1_REC.EMPLOYEE_ID || ' Terr Code ' || C1_REC.OLD_TERR_CDE ||
                          'Changed to New Terr Code '|| C1_REC.NEW_TERR_CDE);
    END LOOP;
COMMIT;
EXCEPTION
  WHEN OTHERS THEN 
    ROLLBACK;
    DBMS_OUTPUT.put_line(SQLERRM);

END;
