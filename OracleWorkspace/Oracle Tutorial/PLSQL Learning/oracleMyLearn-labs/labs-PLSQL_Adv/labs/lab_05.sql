-- Use OE Connection

--Uncomment code below to run the lab script for Task 03 of Practice 05

CREATE TABLE review_table (
 employee_id number,
 ann_review  VARCHAR2(2000));

INSERT INTO review_table
VALUES (2034,
       'Very good performance this year. '||
       'Recommended to increase salary by $500');

INSERT INTO review_table
VALUES (2035,
       'Excellent performance this year. '||
       'Recommended to increase salary by $1000');

COMMIT;

--Uncomment code below to run the lab script for Task 05_e of Practice 05

CREATE OR REPLACE PROCEDURE check_space
IS
  l_fs1_bytes NUMBER;
  l_fs2_bytes NUMBER;
  l_fs3_bytes NUMBER;
  l_fs4_bytes NUMBER;
  l_fs1_blocks NUMBER;
  l_fs2_blocks NUMBER;
  l_fs3_blocks NUMBER;
  l_fs4_blocks NUMBER;
  l_full_bytes NUMBER;
  l_full_blocks NUMBER;
  l_unformatted_bytes NUMBER;
  l_unformatted_blocks NUMBER;
BEGIN 
  DBMS_SPACE.SPACE_USAGE( 
    segment_owner      => 'OE',
    segment_name       => 'PRODUCT_INFORMATION', 
    segment_type       => 'TABLE', 
    fs1_bytes          => l_fs1_bytes,
    fs1_blocks         => l_fs1_blocks, 
    fs2_bytes          => l_fs2_bytes,
    fs2_blocks         => l_fs2_blocks, 
    fs3_bytes          => l_fs3_bytes,
    fs3_blocks         => l_fs3_blocks,
    fs4_bytes          => l_fs4_bytes,
    fs4_blocks         => l_fs4_blocks,
    full_bytes         => l_full_bytes,
    full_blocks        => l_full_blocks,
    unformatted_blocks => l_unformatted_blocks,
    unformatted_bytes  => l_unformatted_bytes
   );
DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE(' FS1 Blocks = '||l_fs1_blocks||'
     Bytes = '||l_fs1_bytes);
  DBMS_OUTPUT.PUT_LINE(' FS2 Blocks = '||l_fs2_blocks||' 
     Bytes = '||l_fs2_bytes);
  DBMS_OUTPUT.PUT_LINE(' FS3 Blocks = '||l_fs3_blocks||' 
     Bytes = '||l_fs3_bytes);
  DBMS_OUTPUT.PUT_LINE(' FS4 Blocks = '||l_fs4_blocks||' 
     Bytes = '||l_fs4_bytes);
  DBMS_OUTPUT.PUT_LINE('Full Blocks = '||l_full_blocks||' 
     Bytes = '||l_full_bytes);
  DBMS_OUTPUT.PUT_LINE('====================================');
  DBMS_OUTPUT.PUT_LINE('Total Blocks = 
     '||to_char(l_fs1_blocks + l_fs2_blocks +
     l_fs3_blocks + l_fs4_blocks + l_full_blocks)||  ' ||  
     Total Bytes = '|| to_char(l_fs1_bytes + l_fs2_bytes 
     + l_fs3_bytes + l_fs4_bytes + l_full_bytes));
END;
/

set serveroutput on
execute check_space;

/*
Output:
FS1 Blocks = 0
     Bytes = 0
 FS2 Blocks = 0 
     Bytes = 0
 FS3 Blocks = 0 
     Bytes = 0
 FS4 Blocks = 4 
     Bytes = 32768
Full Blocks = 9 
     Bytes = 73728
====================================
Total Blocks = 
     13 ||  
     Total Bytes = 106496

*/