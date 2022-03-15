-- Use OE Connection

--Uncomment code below to run the solution for Task 6_a of Practice 13

SET SERVEROUTPUT ON
exec get_income_level('Kris.Harris@DIPPER.EXAMPLE.COM')

exec get_income_level('x'' union select username from all_users where ''x''=''x')
--Uncomment code below to run the solution for Task 7_a of Practice 13
SET SERVEROUTPUT ON
exec get_income_level('Kris.Harris@DIPPER.EXAMPLE.COM')

exec get_income_level('x'' union select username from all_users where ''x''=''x')

          