PL/SQL Developer Test script 3.0
49
-- Created on 11/23/2019 by RAKES 
declare 
  -- Local variables here
  i integer;
  V_TERR_CDE EMPLOYEES_TERR.TERR_CDE%TYPE;
  V_EID EMPLOYEES.EMPLOYEE_ID%TYPE := 1;
  V_MAPPING_ALL CHAR(1) := '*';
    
  CURSOR C1 IS
  SELECT * FROM EMPLOYEES E
  WHERE E.EMPLOYEE_ID IN (106,101,9,104,105,1,3,102,49,47);
  
begin
  FOR C1_REC IN C1
    LOOP
      BEGIN 
        DBMS_OUTPUT.put_line('Employee ID : ' || C1_REC.EMPLOYEE_ID); 
        DBMS_OUTPUT.put_line('1st Check.');
        SELECT ET.TERR_CDE
        INTO V_TERR_CDE
        FROM EMPLOYEES_TERR ET
        WHERE ET.MANAGER_ID = C1_REC.MANAGER_ID
        AND ET.JOB_TITLE = C1_REC.JOB_TITLE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            BEGIN
              DBMS_OUTPUT.put_line('2nd Check.');
              SELECT ET.TERR_CDE
              INTO V_TERR_CDE
              FROM EMPLOYEES_TERR ET
              WHERE ET.MANAGER_ID = C1_REC.MANAGER_ID
              AND ET.JOB_TITLE = V_MAPPING_ALL;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
              DBMS_OUTPUT.put_line('Default.');
              V_TERR_CDE := -1;
            END;
      END;
     UPDATE EMPLOYEES E
     SET E.TERR_CDE = V_TERR_CDE
     WHERE E.EMPLOYEE_ID = C1_REC.EMPLOYEE_ID;
    END LOOP;
COMMIT;
EXCEPTION
  WHEN OTHERS THEN 
    ROLLBACK;
    DBMS_OUTPUT.put_line(SQLERRM);

END;
0
0
