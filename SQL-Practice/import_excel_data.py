'''
https://stackoverflow.com/questions/46854609/import-data-from-excel-into-oracle-table-using-python
'''
import pandas as pd
import cx_Oracle    
import config_ADB

# Connection
## On-prem
# connection = cx_Oracle.connect("<schema>", "<pwd>", "<hostname>/<sid/service>")

## ADB
cx_Oracle.init_oracle_client(config_ADB.lib_dir)

connection = cx_Oracle.connect(
                user=config_ADB.username, 
                password=config_ADB.password, 
                dsn=config_ADB.dsn)

cursor = connection.cursor()    
file = r'D:\\C_Workspaces_Repositories\\GitHub_Repositories\\SQL_Learning\\SQL-Practice\\Helper_Tables.xlsx'        
tab_name = "PROJECTS"
tab_exists = """
DECLARE
  v_exst INT;
BEGIN
  SELECT COUNT(*) 
    INTO v_exst 
    FROM cat 
   WHERE table_name = '"""+tab_name+"""' 
     AND table_type = 'TABLE';
  IF v_exst = 1 THEN
     EXECUTE IMMEDIATE('DROP TABLE """+tab_name+"""');
  END IF;   
END;
"""
cursor.execute(tab_exists)    
create_table = """
CREATE TABLE """+tab_name+""" (
       task_id integer NOT NULL,
       start_date date,
       end_date date
)    """    
cursor.execute(create_table)  

# Insert from single sheet from an excel into an Oracle table (with Sheet-name)
insert_table = "INSERT INTO "+tab_name+" VALUES (:1,:2,:3)"
sheet_name = 'Projects'
df = pd.read_excel(file,sheet_name)
df_list = df.fillna('').values.tolist()
cursor.executemany(insert_table,df_list)    
cursor.close()
connection.commit()
connection.close()

# Insert from single sheet from an excel into an Oracle table (without Sheet-name)
# By default thsi will consider the first sheet
'''
insert_table = "INSERT INTO "+tab_name+" VALUES (:1,:2,:3)"    
df = pd.read_excel(file)
df_list = df.fillna('').values.tolist()
cursor.executemany(insert_table,df_list)    
cursor.close()
connection.commit()
connection.close()
'''

# Insert from multiple sheet from an excel into an Oracle table:
'''
xl = pd.ExcelFile(file)
ls = list(xl.sheet_names)
insert_table = "INSERT INTO "+tab_name+" VALUES(:1,:2,:3)"
for i in ls:
    df = pd.read_excel(file,sheet_name=i)
    df_list = df.fillna('').values.tolist()
    cursor.executemany(insert_table,df_list)    
cursor.close()
connection.commit()
connection.close()
'''