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
file = r'C:\\Users\\rakes\\Downloads\\temp\\by-data-map.xlsx' 

insert_table = "INSERT INTO DB_TAB(TABLE_NAME,COLUMN_NAME,DATA_TYPE,NULLABLE,DATA_DEFAULT) VALUES (:1,:2,:3,:4,:5)"
sheet_name = 'DataMap'
df = pd.read_excel(file,sheet_name, usecols=range(5))
df_list = df.fillna('').values.tolist()
# print(df_list[1:10])
# cursor.execute(insert_table, df_list[1])
cursor.executemany(insert_table, df_list)
cursor.close()
connection.commit()
connection.close()
