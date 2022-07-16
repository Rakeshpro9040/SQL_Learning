/*
https://www.oracletutorial.com/oracle-administration/oracle-sqlloader/
*/

CREATE TABLE emails(
    email_id NUMBER PRIMARY KEY,
    email VARCHAR2(150) NOT NULL
);

sqlldr parfile=dept_loader.par

SELECT * FROM emails;