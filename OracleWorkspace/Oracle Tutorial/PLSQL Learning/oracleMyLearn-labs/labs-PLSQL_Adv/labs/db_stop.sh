#!/usr/bin/bash

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19.3.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:bin/javac::")
export ORACLE_SID=orclcdb

sqlplus / as sysdba << EOF
shutdown immediate
exit
EOF

lsnrctl stop