insert into CUSTOMERS(
CUST_LAST_NAME
,MARITAL_STATUS
,CUSTOMER_ID
,CUST_ADDRESS
,CUST_FIRST_NAME
,INCOME_LEVEL
,NLS_LANGUAGE
,PHONE_NUMBERS
,CREDIT_LIMIT
,CUST_GEO_LOCATION
,GENDER
,CUST_EMAIL
,ACCOUNT_MGR_ID
,NLS_TERRITORY
,DATE_OF_BIRTH
) values (
'P'--p_CUST_LAST_NAME
,'married'--p_MARITAL_STATUS
,999--p_CUSTOMER_ID
,null--p_CUST_ADDRESS
,'rakesh'--p_CUST_FIRST_NAME
,null--p_INCOME_LEVEL
,'us'--p_NLS_LANGUAGE
,null--p_PHONE_NUMBERS
,5000--p_CREDIT_LIMIT
,null--p_CUST_GEO_LOCATION
,'M'--p_GENDER
,'Dom.Hoskins@AVOCET.EXAMPLE.COM'--p_CUST_EMAIL
,149--p_ACCOUNT_MGR_ID
,'AMERICA'--p_NLS_TERRITORY
,'01-JAN-1995'--p_DATE_OF_BIRTH
);