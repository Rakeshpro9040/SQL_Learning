SET SERVEROUTPUT ON
CLEAR SCR
ACCEPT var_age NUMBER PROMPT 'What is your age?';
DECLARE
  ex_age    EXCEPTION;
  exp1 EXCEPTION;
  age       NUMBER    := &var_age;
  PRAGMA EXCEPTION_INIT(ex_age, -20009);
BEGIN
  IF age<16 THEN
    RAISE_APPLICATION_ERROR(-20009, 'You should be 16 or above for the drinks!');
  END IF;
  
  IF age<18 THEN
    RAISE_APPLICATION_ERROR(-20010, 'You should be 18 or above for the drinks!');
  END IF;
  
  IF age=18 THEN
    raise exp1;
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('Sure! What would you like to have?');
  
  EXCEPTION 
    WHEN ex_age THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN exp1 THEN
      DBMS_OUTPUT.PUT_LINE('Ooops!!!');
    WHEN others THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;