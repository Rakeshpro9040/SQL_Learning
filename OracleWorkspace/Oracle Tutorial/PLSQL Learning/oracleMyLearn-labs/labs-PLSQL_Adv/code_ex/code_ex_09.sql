--This is the SQL Script to run the code_examples for Lesson 9
--Use OE as the default connection if the connection name is not mentioned.

--Uncomment the code below to execute the code on slide 09_12sa 
--Execute as PDB1-sys

SELECT name, value
FROM   v$parameter
WHERE  name = 'result_cache_max_size';
--Uncomment the code below to execute the code on slide 09_14sa 
--Execute as PDB1-sys
set serveroutput on
execute dbms_result_cache.memory_report
/*

R e s u l t   C a c h e   M e m o r y   R e p o r t
[Parameters]
Block Size          = 1K bytes
Maximum Cache Size  = 9856K bytes (9856 blocks)
Maximum Result Size = 492K bytes (492 blocks)
[Memory]
Total Memory = 335736 bytes [0.032% of the Shared Pool]

... Fixed Memory = 7616 bytes [0.001% of the Shared Pool]
... Dynamic Memory = 328120 bytes [0.031% of the Shared Pool]
....... Overhead = 164280 bytes
....... Cache Memory = 160K bytes (160 blocks)
........... Unused Memory = 37 blocks
........... Used Memory = 123 blocks
............... Dependencies = 52 blocks (52 count)
............... Results = 71 blocks
................... SQL     = 31 blocks (31 count)
................... CDB     = 13 blocks (13 count)
................... Invalid = 27 blocks (27 count)
*/

--Uncomment the code below to execute the code on slide 09_18sa 
--Execute as PDB1-sys
REM flush.sql

REM Start with a clean slate. Flush the cache and shared pool. 
REM Verify that memory was released.
SET ECHO ON
SET FEEDBACK 1
SET SERVEROUTPUT ON

execute dbms_result_cache.flush
alter system flush shared_pool
/
execute dbms_result_cache.memory_report
/
--Uncomment the code below to execute the code on slide 09_19sa 
--Execute as OE
REM plan_query1.sql

REM Generate the execution plan.
REM (The query name Q1 is optional)

explain plan for
select /*+ result_cache  q_name(Q1)  */ * from orders;
set echo off
REM Display the execution plan. Verify that the query result 
REM is placed in the Result Cache.
REM using the code in ORACLE_HOME/rdbms/admin/utlxpls
select plan_table_output from table(dbms_xplan.display('plan_table',null,'serial'));
/*
-------------------------------------------------------------------------------------------------
| Id  | Operation          | Name                       | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                            |   105 |  3885 |     3   (0)| 00:00:01 |
|   1 |  RESULT CACHE      | 4t08q69vuacwd8cr98hmwan96p |   105 |  3885 |     3   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| ORDERS                     |   105 |  3885 |     3   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------
*/

--Uncomment the code below to execute the code on slide 09_20sa 
--- plan_query2.sql
set echo on

--- Generate the execution plan.
--- (The query name Q2 is optional)
explain plan for
 select c.customer_id, o.ord_count
 from (select /*+ result_cache q_name(Q2) */
      customer_id, count(*) ord_count
      from orders
      group by customer_id) o, customers c
 where o.customer_id = c.customer_id;

set echo off

--- Display the execution plan.
--- using the code in ORACLE_HOME/rdbms/admin/utlxpls
select plan_table_output from table(dbms_xplan.display('plan_table', null,'serial'));
/*
 
--------------------------------------------------------------------------------------------------
| Id  | Operation           | Name                       | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                            |    47 |  1410 |     1   (0)| 00:00:01 |
|   1 |  NESTED LOOPS       |                            |    47 |  1410 |     1   (0)| 00:00:01 |
|*  2 |   VIEW              |                            |    47 |  1222 |     1   (0)| 00:00:01 |
|   3 |    RESULT CACHE     | 1bdqnznadd1hp6c7kcr1yncw98 |    47 |   188 |     1   (0)| 00:00:01 |
|   4 |     HASH GROUP BY   |                            |    47 |   188 |     1   (0)| 00:00:01 |
|   5 |      INDEX FULL SCAN| ORD_CUSTOMER_IX            |   105 |   420 |     1   (0)| 00:00:01 |
|*  6 |   INDEX UNIQUE SCAN | CUSTOMERS_PK               |     1 |     4 |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------
*/

--Uncomment the code below to execute the code on slide 09_21sa
--Execute as OE
--- query3.sql
--- Cache result of both queries, then use the cached result.
set timing on
set echo on

select /*+ result_cache q_name(Q1)  */ from orders
/
-- Elapsed: 00:00:00.023

select c.customer_id, o.ord_count
 from (select /*+ result_cache q_name(Q3) */
      customer_id, count(*) ord_count
      from orders
      group by customer_id) o, customers c
 where o.customer_id = c.customer_id
/
-- Elapsed: 00:00:00.032
set echo off

--Uncomment the code below to execute the code on slide 09_22sa 

  
--Execute as PDB1-sys
col name format a55
select * from v$result_cache_statistics
/

--Uncomment the code below to execute the code on slide 09_23sa 

--Execute as PDB1-sys
select *  from v$result_cache_statistics
 /

--Uncomment the code below to execute the code on slide 09_27sa 
--Execute as PDB1-sys
REM flush.sql

REM Start with a clean slate. Flush the cache and shared pool. 
REM Verify that memory was released.
SET ECHO ON
SET FEEDBACK 1
SET SERVEROUTPUT ON

execute dbms_result_cache.flush
alter system flush shared_pool
/
execute dbms_result_cache.memory_report
/
--Uncomment the code below to execute the code on slide 09_28sa 
--Execute as OE
--- cre_func.sql

--- Create a function that populates the cache

CREATE OR REPLACE FUNCTION ORD_COUNT(cust_no number)
RETURN NUMBER
RESULT_CACHE RELIES_ON (orders)
IS
 V_COUNT NUMBER;
BEGIN
 SELECT COUNT(*) INTO V_COUNT
 FROM orders
 WHERE customer_id = cust_no;

 return v_count;
end;
/ 
--Uncomment the code below to execute the code on slide 09_29sa
--Execute as OE
--- call_func.sql

--- Call a caching PL/SQL function
SELECT cust_last_name, ORD_COUNT(customer_id) no_of_orders
FROM customers
WHERE cust_last_name = 'MacGraw'
/
--Uncomment the code below to execute the code on slide 09_30sa 
--Execute as PDB1-sys
col name format a55
select *
from v$result_cache_statistics
/

--Uncomment the code below to execute the code on slide 09_31sa 
--Execute as OE
--- call_func.sql

--- Call a caching PL/SQL function
SELECT cust_last_name, ORD_COUNT(customer_id) no_of_orders
FROM customers
WHERE cust_last_name = 'MacGraw'
/

--Uncomment the code below to execute the code on slide 09_32sa
--Execute as PDB1-sys
col name format a55
select *
from v$result_cache_statistics
/

--Uncomment the code below to execute the code on slide 09_33sa 
--Execute as PDB1-sys
col name format a55
select type, namespace,status, scan_count,name
from v$result_cache_objects
/
