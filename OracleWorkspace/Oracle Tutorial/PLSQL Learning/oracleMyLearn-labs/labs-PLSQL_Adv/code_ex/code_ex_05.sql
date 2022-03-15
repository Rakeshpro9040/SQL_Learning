--This is the SQL Script to run the code_examples for Lesson 5
--Use OE as the default connection if the connection name is not mentioned.

-- BFILE Example
--Execute as the PDB1-sys user
--Uncomment the code below to execute the code on slide 05_17sb
-- create the database directory object
CREATE OR REPLACE DIRECTORY data_files AS '/home/oracle/labs/DATA_FILES/MEDIA_FILES';

--Uncomment the code below to execute the code on slide 05_17sc
-- if needed, grant privs on the directory object
GRANT READ ON DIRECTORY data_files TO OE;

--Uncomment the code below to execute the code on slide 05_18sa 
--Code to drop the column use it if required.
--Execute as OE
ALTER TABLE customers DROP column video;

ALTER TABLE customers ADD video BFILE;

--Uncomment the code below to execute the code on slide 05_18sb
UPDATE customers
 SET video = BFILENAME('DATA_FILES', 'Winters.avi')
WHERE customer_id = 448;

--Uncomment the code below to execute the code on slide 05_19sa 

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE set_video(
  dir_alias VARCHAR2, custid NUMBER) IS
  filename VARCHAR2(40);  
  file_ptr BFILE;
  CURSOR cust_csr IS
    SELECT cust_first_name FROM customers 
	    WHERE customer_id = custid FOR UPDATE;
BEGIN
  FOR rec IN cust_csr LOOP
    filename := rec.cust_first_name || '.gif';
    file_ptr := BFILENAME(dir_alias, filename);
    DBMS_LOB.FILEOPEN(file_ptr);
    UPDATE customers SET video = file_ptr
      WHERE CURRENT OF cust_csr;
    DBMS_OUTPUT.PUT_LINE('FILE: ' || filename ||
     ' SIZE: ' || DBMS_LOB.GETLENGTH(file_ptr));
    DBMS_LOB.FILECLOSE(file_ptr);
  END LOOP;
END set_video;
/
--Uncomment the code below to execute the code on slide 05_19na 
-- Execute the procedue set_video 
EXECUTE set_video('DATA_FILES', 844)

--Uncomment the code below to execute the code on slide 05_20sa

SET SERVEROUTPUT ON

CREATE or replace FUNCTION get_filesize(p_file_ptr IN OUT BFILE)
RETURN NUMBER IS
  v_file_exists BOOLEAN;
  v_length NUMBER:= -1;
BEGIN
  v_file_exists := DBMS_LOB.FILEEXISTS(p_file_ptr) = 1;
  IF v_file_exists THEN
    DBMS_LOB.FILEOPEN(p_file_ptr);
    v_length := DBMS_LOB.GETLENGTH(p_file_ptr);
    DBMS_LOB.FILECLOSE(p_file_ptr);
  END IF;
  RETURN v_length;
END;
/
--Code to see the execution of the get_filesize function
DECLARE
  v_fp BFILE := BFILENAME('DATA_FILES', 'Alice.gif');
BEGIN
  dbms_output.put_line(get_filesize(v_fp));
END;
/
-- 2619802

--Uncomment the code below to execute the code on slide 05_23sa

-- LOB Example
ALTER TABLE customers ADD (resume CLOB, picture BLOB);


--Uncomment the code below to execute the code on slide 05_23sb

--Execute as PDB1-sys user

CREATE TABLESPACE lob_tbs1
 DATAFILE 'lob_tbs1.dbf' SIZE 800M REUSE
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 64M
SEGMENT SPACE MANAGEMENT AUTO;
/

--Uncomment the code below to execute the code on slide 05_24sa 

--Execute as oe/oe
DROP  TABLE customer_profiles
/
CREATE TABLE customer_profiles (
   id  NUMBER,
   full_name    VARCHAR2(45),
   resume       CLOB DEFAULT EMPTY_CLOB(),
   picture      BLOB DEFAULT EMPTY_BLOB())
   LOB(picture) STORE AS BASICFILE
     (TABLESPACE lob_tbs1);
/

--Uncomment the code below to execute the code on slide 05_25sa 

INSERT INTO customer_profiles
  (id, full_name, resume, picture)
 VALUES (164, 'Charlotte Kazan', EMPTY_CLOB(), NULL);

INSERT INTO customer_profiles
  (id, full_name, resume, picture)
 VALUES (150, 'Harry Dean Fonda', EMPTY_CLOB(), NULL);
 
--Uncomment the code below to execute the code on slide 05_25sb

UPDATE customer_profiles
 SET resume = 'Date of Birth: 8 February 1951',
    picture = EMPTY_BLOB()
 WHERE id = 164;
 
 --Uncomment the code below to execute the code on slide 05_25sc

UPDATE customer_profiles
 SET resume = 'Date of Birth: 1 June 1956'
 WHERE id = 150;

--Uncomment the code below to execute the code on slide 05_26sa 

CREATE OR REPLACE PROCEDURE loadLOBFromBFILE_proc 
  (p_dest_loc IN OUT BLOB, p_file_name IN VARCHAR2, 
   p_file_dir IN VARCHAR2)
IS
  v_src_loc  BFILE := BFILENAME(p_file_dir, p_file_name);
  v_amount   INTEGER := 4000;
  offset     INTEGER := 1;
BEGIN
  DBMS_LOB.OPEN(v_src_loc, DBMS_LOB.LOB_READONLY);
  v_amount := DBMS_LOB.GETLENGTH(v_src_loc);
  DBMS_LOB.LOADBLOBFROMFILE(p_dest_loc, v_src_loc, v_amount,offset,offset);
  DBMS_LOB.CLOSE(v_src_loc);
END loadLOBFromBFILE_proc;
/

--Uncomment the code below to execute the code on slide 05_27sa 

CREATE OR REPLACE PROCEDURE write_lob 
  (p_file IN VARCHAR2, p_dir IN VARCHAR2)
IS
 i    NUMBER;          v_fn VARCHAR2(15); 
 v_ln VARCHAR2(40);    v_b  BLOB;
BEGIN
  DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE('Begin inserting rows...');
  FOR i IN 1 .. 30 LOOP
    v_fn:=SUBSTR(p_file,1,INSTR(p_file,'.')-1);
    v_ln:=SUBSTR(p_file,INSTR(p_file,'.')+1,LENGTH(p_file)-
                 INSTR(p_file,'.')-4);
    INSERT INTO customer_profiles 
      VALUES (i, v_fn, v_ln, EMPTY_BLOB())
      RETURNING picture INTO v_b;
    loadLOBFromBFILE_proc(v_b,p_file, p_dir);
    DBMS_OUTPUT.PUT_LINE('Row '|| i ||' inserted.');
  END LOOP;
  COMMIT;
END write_lob;
/

--Uncomment the code below to execute the code on slide 05_28sa 
--Execute as PDB1-sys
CREATE OR REPLACE DIRECTORY resume_files AS '/home/oracle/labs/DATA_FILES/RESUMES';
Grant read on DIRECTORY resume_files to OE;
/

--Execute as OE

set serveroutput on
set verify on
set term on
set linesize 200
-- You can use timing start if you execute the code in SQLPlus.
--timing start load_data 
execute write_lob('karl.brimmer.doc', 'RESUME_FILES')
execute write_lob('monica.petera.doc', 'RESUME_FILES')
execute write_lob('david.sloan.doc',  'RESUME_FILES')
--timing stop
/

-- Execute the grant statement as PDB1-sys user
GRANT CREATE ANY DIRECTORY TO OE;
-- Use OE connection
DROP TABLE LOB_TEXT;
CREATE TABLE lob_text(key number,txt clob);
CREATE SEQUENCE lob_seq;
CREATE OR REPLACE DIRECTORY PLSQL_DIR AS '/home/oracle/labs/code_ex';
/
--Uncomment the code below to execute the code on slide 05_31sa

CREATE OR REPLACE  PROCEDURE 
lob_txt(file_name VARCHAR2,p_dir VARCHAR2 DEFAULT 'PLSQL_DIR')
IS
c CLOB:=null;
byte_count pls_integer;
fil BFILE:=BFILENAME(p_DIR,file_name);
v_dest_offset  integer:=1;
v_src_offset  integer:=1;
v_lang_context integer:=0;
v_warning integer;
BEGIN
c:=TO_CLOB(' ');  --very important!
IF DBMS_LOB.FILEEXISTS(FIL)=1 then 
  DBMS_LOB.FILEOPEN(fil,DBMS_LOB.FILE_READONLY);
   byte_count:=DBMS_LOB.GETLENGTH(fil);
  DBMS_OUTPUT.PUT_LINE('The length of the file:'||byte_count);
  DBMS_LOB.LOADCLOBFROMFILE  
  (dest_lob => c,src_bfile => fil,amount => byte_count,dest_offset => v_dest_offset
  ,src_offset => v_src_offset,bfile_csid => 0,lang_context => v_lang_context
  ,warning => v_lang_context);
  DBMS_LOB.FILECLOSEALL;
  INSERT INTO lob_text VALUES (lob_seq.nextval,c);
 COMMIT;
ELSE
  DBMS_OUTPUT.PUT_LINE('The file does not exist ');
END IF; 
END;
/

*/
--Uncomment the code below to execute the code on slide 05_31na
-- Load the user source from Linux Terminal 
--loadjava -user oe/oe@pdborcl java.sql

-- Use OE Connection
SET LONG 10000
set serveroutput on
exec lob_txt('java.sql')
select KEY,txt from lob_text;
/
/*
Output:
The length of the file:284

       KEY TXT                                                                             
---------- --------------------------------------------------------------------------------
         1 CREATE OR REPLACE PACKAGE JPROG AUTHID CURRENT_USER AS                          
           FUNCTION TAXI ("value" IN NUMBER)                                               
            RETURN NUMBER                                                                  
           AS LANGUAGE JAVA                                                                
           NAME 'jprog.Stored.tax(double) return double';                                  
           PROCEDURE HELLO ("val" IN OUT VARCHAR2)                                         
           AS LANGUAGE JAVA                                                                
           NAME 'jprog.Stored.hello(java.lang.String[])';                                  
           END JPROG;                                                                      
           /                                                                               

*/

-- LOB Locator Example
--Uncomment the code below to execute the code on slide 05_32sa 
SET SERVEROUTPUT ON

DECLARE
  v_lobloc CLOB;    	-- serves as the LOB locator
  v_text   VARCHAR2(50) := 'Resigned = 5 June 2000';
  v_amount NUMBER ; 	-- amount to be written
  v_offset INTEGER; 	-- where to start writing
BEGIN
  SELECT resume INTO v_lobloc FROM customer_profiles
  WHERE id = 164 FOR UPDATE;
  v_offset := DBMS_LOB.GETLENGTH(v_lobloc) + 2;
  v_amount := length(v_text);
  DBMS_LOB.WRITE (v_lobloc, v_amount, v_offset, v_text);
  v_text := ' Resigned = 30 September 2000';
  SELECT resume INTO v_lobloc FROM customer_profiles
  WHERE id = 150 FOR UPDATE;
  v_amount := length(v_text);
  DBMS_LOB.WRITEAPPEND(v_lobloc, v_amount, v_text);
  COMMIT;
END;
/

--Uncomment the code below to execute the code on slide 05_33sa
SELECT id, full_name , resume -- CLOB
FROM customer_profiles
WHERE id IN (164, 150);
/*
Output:

        ID FULL_NAME                                     RESUME                                                                          
---------- --------------------------------------------- --------------------------------------------------------------------------------
       164 Charlotte Kazan                               Date of Birth: 8 February 1951 Resigned = 5 June 2000                           
       150 Harry Dean Fonda                              Date of Birth: 1 June 1956 Resigned = 30 September 2000                         
*/
--Uncomment the code below to execute the code on slide 05_34sa 

SELECT DBMS_LOB.SUBSTR (resume, 5, 18),
       DBMS_LOB.INSTR (resume,' = ')
FROM   customer_profiles
WHERE  id IN (150, 164);
/*
Output:
Febru	40
June 	36
*/

--Uncomment the code below to execute the code on slide 05_35sa

SET SERVEROUTPUT ON 

DECLARE
  text VARCHAR2(4001);
BEGIN
 SELECT resume INTO text
 FROM customer_profiles
 WHERE id = 150;
 DBMS_OUTPUT.PUT_LINE('text is: '|| text);
END;
/

--Delete LOB data example
--Uncomment the code below to execute the code on slide 05_36sa

DELETE 
FROM  customer_profiles
WHERE id = 164;

--Uncomment the code below to execute the code on slide 05_36sb

UPDATE customer_profiles
SET resume = EMPTY_CLOB()
WHERE id = 150;

commit;

--Uncomment the code below to execute the code on slide 05_42sa

CREATE OR REPLACE PROCEDURE is_templob_open(
  p_lob IN OUT BLOB, p_retval OUT INTEGER) IS
BEGIN
  -- create a temporary LOB
  DBMS_LOB.CREATETEMPORARY(p_lob, TRUE);
  -- check whether the LOB created is a temporary one or not
  p_retval := DBMS_LOB.ISTEMPORARY(p_lob);
  DBMS_OUTPUT.PUT_LINE (
    'You have created a temporary LOB in the the PL/SQL block...');
  -- free the temporary LOB
  DBMS_LOB.FREETEMPORARY(p_lob);
END;
/

set serveroutput on
DECLARE
  v_lob BLOB;
  v_return INTEGER;
BEGIN
  is_templob_open(v_lob, v_return);
END;
/

/*
Output:
You have created a temporary LOB in the the PL/SQL block...
*/

--Uncomment the code below to execute the code on slide 05_46sa 

--Execute as PDB1-sys
CREATE TABLESPACE sf_tbs1
 DATAFILE 'sf_tbs1.dbf' SIZE 1500M REUSE
 AUTOEXTEND ON NEXT 200M
 MAXSIZE 3000M
 SEGMENT SPACE MANAGEMENT AUTO;

CONNECT oe/oe
CREATE TABLE customer_profiles_sf
(id NUMBER,
 first_name VARCHAR2 (40),
 last_name  VARCHAR2 (80),
 profile_info  BLOB)
 LOB(profile_info) STORE AS SECUREFILE
 (TABLESPACE sf_tbs1);