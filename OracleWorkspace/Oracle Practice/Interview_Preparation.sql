---SQL
select
    ltrim(regexp_substr(email, '@.*'),'@') domain,
    ltrim(rtrim(regexp_substr(email, '(\.\w+)@(.*)\2'),'@'),'.') lastname
from cte;

select * 
from email_validation_temp et
where not regexp_like(et.email, '[a-z]+\.[a-z]+@[a-z]+\.com', 'i');

select regexp_instr(col, '[^a-z | ^0-9]', 1, 1, 0, 'i') from cte;

select max(regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level)) as max_value
from dual
connect by regexp_substr('zzabcy001295zz9e', '[a-z]+', 1, level) is not null;

---UNIX
sed -i -e 's/original/new/g' file.txt --replace text in a file

grep -c "complexsql" Filename --count 
	-i Case insensitive search
	-n Print line number
	-v line does not contain

grep "I[tud]" Grep_File
grep "^P" Grep_File
grep -n "^$" Grep_File -- Prints empty line
grep -v "^$" Grep_File -- Prints non-empty line

cut -d ':' -f2  etc/passwd --ftech 2nd field 

awk '{print $2}' file  -- ftech 2nd column

cut -f 1-3 Employee.txt --fetch field from 1 to 3

tr "[a-z]" "[A-Z]" < File_name -- replace

tr -d 'U' < Linux.txt -- deletes U from file
