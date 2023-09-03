---SQL
select ltrim(regexp_substr(email, '@.*'),'@') domain, ltrim(rtrim(regexp_substr(email, '(\.\w+)@(.*)\2'),'@'),'.') lastname from cte;
select * from temp_tab et where not regexp_like(et.email, '[a-z]+\.[a-z]+@[a-z]+\.com', 'i');
select email from your_table where regexp_like(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-za-z]{2,}$');
select regexp_instr(col, '[^a-z | ^0-9]', 1, 1, 0, 'i') from cte; -- special character find
select max(regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level)) as max_value;
from dual connect by regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level) is not null;
select e1.employee_id, e2.employee_id from emp e1, emp e2 where e1.manager_id = e2.employee_id;
select * from emp start with mgr is null connect by prior empno = mgr;
HIERARCHY -> connect_by_root, sys_connect_by_path, connect_by_isleaf, lpad('*', (level - 1), '*')
PIVOT -> select * from table pivot(SUM(col1) FOR col2 IN(list of values));
FIRST_VALUE(e.sal) ignore nulls over(partition by e.deptno order by e.sal) min_sal_dept_wise
LAST_VALUE(e.sal) ignore nulls over(partition by e.deptno order by e.sal rows between unbounded preceding and unbounded following) max_sal_dept_wise
NTH_VALUE(e.sal,2) from first ignore nulls over(partition by e.deptno order by e.sal rows between unbounded preceding and unbounded following) "2nd_min_sal_dept_wise"
NTH_VALUE(e.sal,2) from last ignore nulls over(partition by e.deptno order by e.sal rows between unbounded preceding and unbounded following) "2nd_max_sal_dept_wise"
listagg(distinct t2.owner,'//' on overflow truncate '...') within group(order by t2.owner);
OFFSET 2 ROWS  FETCH NEXT 5 ROWS ONLY;
LIKE '%25!%%' ESCAPE '!';
MERGE INTO tgt USING src on (tgt.col=src.col) WHEN MATCHED THEN UPDATE SET WHERE WHEN NOT MATCHED THEN INSERT() VALUES();
FOREIGN KEY(group_id) REFERENCES supplier_groups(group_id) ON DELETE CASCADE - SET NULL
EXPLAIN PLAN FOR SQL_QUERY; SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
CREATE BITMAP INDEX;
CREATE SEQUENCE id_seq INCREMENT BY 10 START WITH 10 MINVALUE 10 MAXVALUE 100 CYCLE CACHE 2;

-- PLSQL
PRAGMA AUTONOMOUS_TRANSACTION
FORALL -> SAVE EXCEPTIONS -> SQL%BULK_EXCEPTIONS.COUNT;SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE))
OPEN_CURSOR -> PARSE -> BIND_VARLABLE -> DEFINE_COLUMN -> EXECUTE -> FETCH_ROWS -> COLUMN_VALUE -> CLOSE_CURSOR
sqlldr username/password CONTROL=load_employees.ctl -> LOAD DATA INFILE'employees.txt' [APPEND] INTO TABLE employees FIELDS TERMINATED BY ',' [OPTIONALLY ENCLOSED BY '"']
utl_file.file_type -> utl_file.fopen -> utl_file.putf -> utl_file.fclose

---UNIX
sed -i -e 's/original/new/g' file.txt --replace text in a file
    -i --> This is an in-place editor, directly modifies the file
    -e --> Indicates the start of a new sed command  
sed -i '13,15' sample.txt --> This deletes from line 13 to 15
sed -i '3i\xxxx' sample.txt --> This adds a line line 3 and add content xxxx
sed -i '4s/.*/pala,lala jajja/' sample.txt --> Replaces the content in line 4 with "pala,lala jajja"
grep -c "complexsql" Filename --> count the number of line which consists of keyword "complexsql"
    --[-i Case insensitive search] [-n Print line number] [-v line does not contain]
grep -o 'UNIX' sample.txt | wc -l --> count the number of keyword "UNIX" in sample.txt file
    -o: used to display only the occurrences of the keyword, without showing the entire lines where the keyword appears
grep "I[tud]" Grep_File
grep "^P" Grep_File
grep -n "^$" Grep_File -- Prints empty line
grep -v "^$" Grep_File -- Prints non-empty line
cut -d ':' -f2  etc/passwd --fetch 2nd field
awk '{print $2}' file  -- fetch 2nd column
cut -f 1-3 Employee.txt --fetch field from 1 to 3
All the below command will fetch the 3 field from a tab seprated file
    cut -f3 employee.txt
    cut -d $'\t' -f3 employee.txt
        --$: This symbol signals that variable expansion or special character interpretation is happening
    awk '{print $3}' employee.txt
tr "[a-z]" "[A-Z]" < File_name -- replace
tr -d 'U' < Linux.txt -- deletes U from file
echo -n > f3.txt --> To empty a file
    -- -n: This option prevents echo from adding a newline character at the end of the output
cat f1.txt f2.txt > f3.txt --> This will merge f1.txt and f2.txt into f3.txt
rm -r Misc_1 --> This deletes the folder recusivelly
find . -mindepth 1 -delete --> This deletes all the content inside the current folder, except the current folder itself
    -- -mindepth 1: This option ensures that find does not consider the root folder itself when searching for files to delete
    -- delete: This option tells find to delete the files and directories it finds
rm * --> delete all files in the current directory, but it won't delete subdirectories or their contents, it won't delete hidden files
































