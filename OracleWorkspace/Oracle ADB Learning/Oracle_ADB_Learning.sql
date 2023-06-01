/*****************************************
IMP Blogs
*****************************************/
/*
Oracle Autonomous Database: Autonomous Database for Experienced Users:
https://mjromeo81.com/2020/12/24/oracle-autonomous-database-autonomous-database-for-experienced-users/

*/


/*****************************************
ADB Setup
*****************************************/

-- Connect to ADB_USER
select * from all_users order by 3 desc;
select * from all_users order by 1;
select * from all_users where username 
    in ('ADMIN', 'ADB_USER', 'DEMO',
        'SH', 'OT', 'HR');
select owner, object_type, object_name from all_objects where owner = 'SH';

-- Create ADB User
Step-1: Craete User in OCI (Database Actions >> Adminstrations (Web Access))
Step-2: Provide Grants - CONNECT, DWROLE, UNLIMITED TABLESPACE
        GRANT UNLIMITED TABLESPACE TO HR;

-- Issue: ORA-01950: no privileges on tablespace 'DATA'
select * from user_tablespaces; 
-- If this results no rows, then GRANT UNLIMITED TABLESPACE
select * from dba_role_privs where grantee = 'OT';
select * from dba_tab_privs where grantee = 'OT';
select * from dba_sys_privs where grantee 
    in (select granted_role from dba_role_privs where grantee = 'OT');

-- Load Data into OT
-- Check the Current directory
host cd; 
-- D:\C_Workspaces_Repositories\GitHub_Repositories\SQL_Learning\OracleWorkspace
@oracle-sample-database/ot_schema.sql;
@oracle-sample-database/ot_data.sql;
-- If anything goes wrong, cleanup all
@oracle-sample-database/ot_drop.sql;
purge recyclebin; -- This will delete the identity column sequence

-- Load data into HR
define dir = D:\db_home\demo\schema-hr\human_resources;
@&dir\hr_cre.sql
@&dir\hr_popul.sql
@&dir\hr_idx.sql
@&dir\hr_code.sql
@&dir\hr_comnt.sql
-- Analyze schema
EXECUTE dbms_stats.gather_schema_stats( -
        'HR', -
        granularity => 'ALL', -
        cascade => TRUE, -
        block_sample => TRUE);

-- Load data into 

-- Cleanup after Drop table
/*
    Cleanup-Drop all existing tables.
    Import Sample HR Database. 
    Refer Learning >> Oracle Install >> Create a Sample Database
*/
/*
BEGIN
--    FOR c IN (SELECT table_name FROM user_tables) LOOP
--    EXECUTE IMMEDIATE ('DROP TABLE "' || c.table_name || '" CASCADE CONSTRAINTS');
--    END LOOP;
    
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
    EXECUTE IMMEDIATE ('DROP SEQUENCE ' || s.sequence_name);
    END LOOP;
END;
*/

/*****************************************
Set Idle Time Limits
*****************************************/
/*
https://docs.oracle.com/en/cloud/paas/autonomous-database/adbsa/idle-tile-limits.html#GUID-241F4C85-24E5-4F8A-B9EE-E3FCEF566D36

https://oracle-help.com/oracle-database/how-to-set-idle-time-in-oracle-database/
*/

select * from dba_profiles order by resource_name;
select * from dba_profiles where profile='DEFAULT' order by resource_name;
select * from dba_profiles where profile='DEFAULT' and resource_name in ('IDLE_TIME','CONNECT_TIME');

ALTER PROFILE DEFAULT LIMIT IDLE_TIME 60;
-- It is changed to 60 min of idle time. The application will disconnect if it is idle for 60.

/*****************************************
Password Update
*****************************************/
-- https://oracle-base.com/articles/misc/change-your-own-password-in-oracle-database

ALTER USER my_user IDENTIFIED BY MyNewPassword123;

/*****************************************
Misc
*****************************************/
-- Simulate Long Running query
grant execute on sys.dbms_lock to adb_user;

CREATE OR REPLACE FUNCTION SLEEP( SECONDS IN NUMBER )
RETURN NUMBER
IS
BEGIN
  DBMS_LOCK.SLEEP( SECONDS );
  return SECONDS;
END;
/

set timings on;
SELECT sleep( 300 ) from DUAL;


*****************************************