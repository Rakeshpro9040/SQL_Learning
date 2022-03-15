-- Use OE Connection

--Uncomment code below to run the solution for Task 1 of Practice 05
DROP TABLE personnel
/

CREATE TABLE personnel (
 id        NUMBER(6) constraint personnel_id_pk PRIMARY KEY,
 last_name VARCHAR2(35),
 review    CLOB,
 picture   BLOB);
/

--Uncomment code below to run the solution for Task 2 of Practice 05

INSERT INTO  personnel
VALUES (2034, 'Allen', empty_clob(), NULL);

INSERT INTO  personnel
VALUES (2035, 'Bond', empty_clob(), NULL);
/

-- Use OE Connection

--Uncomment code below to run the solution for Task 4_a of Practice 05
SELECT ann_review
FROM   review_table
WHERE  employee_id = 2034;

/*
Output:
Very good performance this year. Recommended to increase salary by $500
*/

UPDATE personnel
 SET review = (SELECT ann_review
               FROM   review_table
               WHERE  employee_id = 2034)
 WHERE last_name = 'Allen';

--Uncomment code below to run the solution for Task 4_b of Practice 05

SELECT ann_review
FROM   review_table
WHERE  employee_id = 2035;
-- Excellent performance this year. Recommended to increase salary by $1000

UPDATE personnel
 SET review = (SELECT ann_review 
              FROM   review_table
              WHERE  employee_id = 2035)
 WHERE last_name = 'Bond';

--Uncomment code below to run the solution for Task 5_a of Practice 05

--Execute as PDB1-sys
CREATE OR REPLACE DIRECTORY product_pic AS 
'/home/oracle/labs/DATA_FILES/PRODUCT_PIC';
Grant read on DIRECTORY product_pic to OE;

--Uncomment code below to run the solution for Task 5_b of Practice 05
ALTER TABLE product_information ADD (picture BFILE);


--Uncomment code below to run the solution for Task 5_c of Practice 05

CREATE OR REPLACE PROCEDURE load_product_image (p_dir IN VARCHAR2) 
IS
  v_file           BFILE;
  v_filename       VARCHAR2(40);
  v_rec_number     NUMBER;
  v_file_exists    BOOLEAN;
  CURSOR product_csr IS
    SELECT product_id
    FROM product_information
    WHERE category_id = 12
    FOR UPDATE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('LOADING LOCATORS TO IMAGES...');
  FOR rec IN product_csr
  LOOP
    v_filename := rec.product_id || '.gif';
    v_file := BFILENAME(p_dir, v_filename);
    v_file_exists := (DBMS_LOB.FILEEXISTS(v_file) = 1);
    IF v_file_exists THEN
     DBMS_LOB.FILEOPEN(v_file);
     UPDATE product_information
       SET picture = v_file
       WHERE CURRENT OF product_csr;
     DBMS_OUTPUT.PUT_LINE('Set Locator to file: '|| v_filename ||
       ' Size: ' || DBMS_LOB.GETLENGTH(v_file));
     DBMS_LOB.FILECLOSE(v_file);
     v_rec_number := product_csr%ROWCOUNT;
    ELSE
     DBMS_OUTPUT.PUT_LINE('File ' || v_filename ||' does not exist');
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('TOTAL FILES UPDATED: ' || v_rec_number);   
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_LOB.FILECLOSE(v_file);
      DBMS_OUTPUT.PUT_LINE('Error: '|| to_char(SQLCODE) || SQLERRM);
END load_product_image;
/


--Uncomment code below to run the solution for Task 5_d of Practice 06

SET SERVEROUTPUT ON
EXECUTE load_product_image('PRODUCT_PIC');

/*
Output:

LOADING LOCATORS TO IMAGES...
Set Locator to file: 1782.gif Size: 7888
Set Locator to file: 2430.gif Size: 7462
Set Locator to file: 1792.gif Size: 7462
Set Locator to file: 1791.gif Size: 7462
Set Locator to file: 2302.gif Size: 7462
Set Locator to file: 2453.gif Size: 9587
Set Locator to file: 1797.gif Size: 7888
Set Locator to file: 2459.gif Size: 9587
Set Locator to file: 3127.gif Size: 9587
TOTAL FILES UPDATED: 9
*/