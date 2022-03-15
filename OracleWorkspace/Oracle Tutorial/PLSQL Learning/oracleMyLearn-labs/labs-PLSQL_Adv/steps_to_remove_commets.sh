## Step-0: Got to labs directory
cd /home/oracle/labs

## Step-1: Take Backup (Optional)
Ref: https://www.digitalocean.com/community/tutorials/workflow-loop-through-files-in-a-directory
for FILE in ./code_ex/*.sql; do cp $FILE "$FILE.bak"; done;
for FILE in ./labs/*.sql; do cp $FILE "$FILE.bak"; done;
for FILE in ./solns/*.sql; do cp $FILE "$FILE.bak"; done;

## Step-2: Remove Comments
Ref: https://stackoverflow.com/questions/30320347/unix-shell-loop-through-files-and-replace-texts
sed -i "s/\/\*//g" ./code_ex/code_ex_12.sql
sed -i "s/\*\///g" ./code_ex/code_ex_12.sql

sed -i "s/\/\*//g" ./labs/lab_12.sql
sed -i "s/\*\///g" ./labs/lab_12.sql

sed -i "s/\/\*//g" ./solns/sol_12.sql
sed -i "s/\*\///g" ./solns/sol_12.sql

## Step-3: Remove Consecutive blank lines
Ref: https://stackoverflow.com/questions/12598916/how-to-use-sed-to-remove-only-double-empty-lines
sed -i 'N;/^\n$/d;P;D' ./code_ex/code_ex_12.sql
sed -i 'N;/^\n$/d;P;D' ./labs/lab_12.sql
sed -i 'N;/^\n$/d;P;D' ./solns/sol_12.sql