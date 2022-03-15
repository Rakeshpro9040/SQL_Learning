--Use OE Connection
-- You should have executed demo08_simpleint_1.sql before executing the script
-- It demonstrates the difference of time when you use simple integer and pls_integer
-- The time consumed to execute with a simple_integer is less.
SET SERVEROUTPUT ON

ALTER PROCEDURE p COMPILE
PLSQL_Code_Type = NATIVE PLSQL_CCFlags = 'simple:true'
REUSE SETTINGS;

EXECUTE p()

ALTER PROCEDURE p COMPILE
PLSQL_Code_Type = native PLSQL_CCFlags = 'simple:false'
REUSE SETTINGS;

EXECUTE p()
