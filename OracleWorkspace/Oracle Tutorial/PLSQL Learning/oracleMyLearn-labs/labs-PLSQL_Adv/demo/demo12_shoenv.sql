-- Use OE connection
SET SERVEROUTPUT ON
DECLARE
  PROCEDURE showenv(str IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      (str || '=' || SYS_CONTEXT('USERENV', str));
  END;
BEGIN
  showenv ('IP_ADDRESS');
  showenv ('CURRENT_USER');
  showenv ('SESSION_USERID');
  showenv ('PROXY_USERID');
  showenv ('CURRENT_SCHEMA');
  showenv ('DB_NAME');
END;
/
