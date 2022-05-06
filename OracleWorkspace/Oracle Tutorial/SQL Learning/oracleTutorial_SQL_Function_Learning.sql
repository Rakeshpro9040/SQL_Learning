*****************************************
Instructions:
*****************************************

This File Contains content from below sites:
https://www.oracletutorial.com/






*****************************************
Aggregate Functions
*****************************************
-- Refer to the Doc
/*
Oracle aggregate functions can appear in SELECT lists and ORDER BY, GROUP BY, and HAVING clauses. (only not in WHERE)
All aggregate functions ignore null values except COUNT(*), GROUPING(), and GROUPING_ID().
The COUNT() and REGR_COUNT() functions never return null, but either a number or zero (0). 
Other aggregate functions return NULL if the input data set contains NULL or has no row
*/
-- DISTINCT vs. ALL
/*
DISTINCT: Removes the duplicates and then does the aggregation. (considers non-null vlaues)
ALL: Includes the duplicates. (considers non-null vlaues) (This the default in any aggregate functions)
*/
with test_tab as
(
    select 2 test_col from dual
    union all
    select 2 from dual
    union all
    select 2 from dual
    union all
    select 4 from dual
)
select
    SUM(DISTINCT test_col) distinct_sum,
    COUNT(DISTINCT test_col) distinct_count,
    AVG(DISTINCT test_col) distinct_avg,
    SUM(ALL test_col) all_sum,
    COUNT(ALL test_col) all_count,
    AVG(ALL test_col) all_avg
from test_tab;
/

-- NULL
with test_tab as
(
    select 1 test_col from dual
    union all
    select 2 from dual
    union all
    select 2 from dual
    union all
    select null from dual
)
select
    COUNT(test_col) count, -- Ignores NULL
    SUM(test_col) sum,
    MIN(test_col) min,
    avg(test_col) avg,
    COUNT(*) count_star -- Considers NULL & Duplicates
from test_tab;

-- COUNT
-- COUNT(*) vs. COUNT(DISTINCT expr) vs. COUNT(ALL)
SELECT * FROM items;

SELECT
    COUNT(*),
    COUNT(DISTINCT val),
    COUNT(ALL val)
FROM
    items;
-- COUNT & HAVING
-- The below query helps to find the duplicates
SELECT
    last_name,
    COUNT( last_name )
FROM
    contacts
GROUP BY
    last_name
HAVING
    COUNT( last_name )> 1
ORDER BY
    last_name;

-- AVG
SELECT
    ROUND(AVG(list_price ),2) avg_list_price_all,
    ROUND(AVG(DISTINCT list_price),2) avg_list_price_dist
FROM
    products;
-- AVG vs NULL
with test_tab as
(
    select 95 test_col from dual
    union all
    select 70 from dual
    union all
    select 60 from dual
    union all
    select null from dual
)
select
    AVG(test_col) avg, -- This ignores null: sum(non-null)/count(non-null), hence the count is 3
    AVG(NVL(test_col,0)) avg_null -- This converst null to not null, hence the count is 4
from test_tab;

-- LISTAGG
/*
Aggregate strings from multiple rows into a single string by concatenating them. (mainly for reporting purpose)
*/
-- Syntax
LISTAGG (
    [ALL] column_name [,
    delimiter]
) WITHIN GROUP(
    ORDER BY
        sort_expressions
);

-- Example-1 (list of job titles along with employees first name)
SELECT
    job_title,
    LISTAGG(
        first_name,
        ',' -- separated by comma
    ) WITHIN GROUP(
    ORDER BY
        first_name
    ) AS employees
FROM
    employees
GROUP BY
    job_title
ORDER BY
    job_title;

-- Check the result using below query
select job_title, first_name
from employees
group by job_title, first_name
order by 1, 2;

-- Example-2 (list of order ids along with product name)
SELECT
    order_id,
    LISTAGG(
        product_name,
        ';'
    ) WITHIN GROUP(
    ORDER BY
        product_name
    ) AS products
FROM
    order_items
INNER JOIN products
        USING(product_id)
GROUP BY
    order_id;

-- Example-3: ON OVERFLOW ERROR
-- Oracle will issue teh overflow error: ORA-01489: result of string concatenation is too long 
SELECT
    category_id,
    LISTAGG(
        description,
        ';' ON OVERFLOW ERROR
    ) WITHIN GROUP(
    ORDER BY
        description
    ) AS products
FROM
    products
GROUP BY
    category_id
ORDER BY
    category_id;

-- Example-4: ON OVERFLOW TRUNCATE
-- You can use the ON OVERFLOW TRUNCATE clause to handle the overflow error gracefully
SELECT
    category_id,
    LISTAGG(
        description,
        ';' ON OVERFLOW TRUNCATE '!!!' WITHOUT COUNT
    ) WITHIN GROUP(
    ORDER BY
        description
    ) AS products
FROM
    products
GROUP BY
    category_id
ORDER BY
    category_id;

-- MAX
-- Return the maximum value in a set of values
/*
The following query retrieves the product category and the list prices of the most expensive product per each product category. 
In addition, it returns only the product category whose the highest list price is between 3000 and 5000
*/
SELECT
    category_name,
    MAX(list_price)
FROM
    products
INNER JOIN product_categories
        USING(category_id)
GROUP BY
    category_name
HAVING
    MAX(list_price) BETWEEN 3000 AND 6000
ORDER BY
    category_name;

-- MIN
-- Return the minimum value in a set of values
-- Below query returns the information on the cheapest product
SELECT
    product_id,
    product_name,
    list_price
FROM
    products
WHERE
    list_price =(
        SELECT
            MIN( list_price )
        FROM
            products
    );

-- SUM
-- Returns the sum of values in a set of values
SELECT
    product_name,
    SUM( quantity * unit_price ) sales
FROM
    order_items
INNER JOIN products
        USING(product_id)
GROUP BY
    product_name
ORDER BY
    sales DESC;


*****************************************
Analytic/Window Functions
*****************************************

-- CUME_DIST (Refer to the Doc)
-- Calculate the cumulative distribution of a value in a set of values
-- Syntax
CUME_DIST() OVER (
    [ query_partition_clause ] 
    order_by_clause
)
/*
Omitting PARTITION BY clause will treat the whole result set as a single partition.
*/
-- The following statement calculates the sales percentile for each salesman in 2017
SELECT 
    salesman_id,
    sales,  
    ROUND(cume_dist() OVER (ORDER BY sales DESC) * 100,2) || '%' cume_dist
FROM 
    salesman_performance
WHERE 
    YEAR = 2017;
--The following statement calculates the sales percentile for each salesman in 2016 and 2017
SELECT 
    salesman_id,
    year,
    sales,  
    ROUND(CUME_DIST() OVER (
        PARTITION BY year
        ORDER BY sales DESC
    ) * 100,2) || '%' cume_dist
FROM 
    salesman_performance
WHERE 
    year in (2016,2017);   

-- RANK
-- Calculate the rank of a value in a set of values
/*
The RANK() function is useful for top-N and bottom-N queries.
The RANK() function returns the same rank for the rows with the same values.
It adds the number of tied rows to the tied rank to calculate the next rank. 
Therefore, the ranks may not be consecutive numbers. (This can be resolved by using DENSE_RANK)
the ORDER BY clause is mandatory, but you can skip PARTITION BY clause.
*/
-- Syntax
RANK()
	OVER ([ query_partition_clause ] order_by_clause)

-- to calculate the rank for each row of the rank_demo table
select * from rank_demo;
SELECT 
	col, 
	RANK() OVER (ORDER BY col) my_rank,
    DENSE_RANK() OVER (ORDER BY col) my_dense_rank
FROM 
	rank_demo;

-- To get the top 10 most expensive products, you use the following statement
WITH cte_products AS (
	SELECT 
		product_name, 
		list_price, 
		RANK() OVER(ORDER BY list_price DESC) price_rank
	FROM 
		products
)
SELECT 
	product_name,  
	list_price,
	price_rank
FROM 
	cte_products
WHERE
	price_rank <= 10;

-- Returns the top-3 most expensive products for each category
WITH cte_products AS (
	SELECT 
		product_name, 
		list_price, 
		category_id,
		RANK() OVER(
			PARTITION BY category_id
			ORDER BY list_price DESC) 
			price_rank
	FROM 
		products
)
SELECT 
	product_name,  
	list_price,
	category_id,
	price_rank
FROM 
	cte_products
WHERE
	price_rank <= 3;



-- DENSE_RANK
-- Calculate the rank of a row in an ordered set of rows with no gaps in rank values.
/*
Unlike the RANK() function, the DENSE_RANK() function returns rank values as consecutive integers.
*/
-- Syntax
DENSE_RANK( ) OVER([ query_partition_clause ] order_by_clause)

SELECT 
	col, 
	RANK() OVER (ORDER BY col) my_rank,
    DENSE_RANK() OVER (ORDER BY col) my_dense_rank
FROM 
	rank_demo;

-- Return the top-5 cheapest products in each category
WITH cte_products AS(  
SELECT 
    product_name, 
    category_id,
    list_price, 
    RANK() OVER (
    PARTITION BY category_id
    ORDER BY list_price
    ) my_rank
FROM 
    products
)
SELECT * FROM cte_products
WHERE my_rank <= 5;

-- FIRST_VALUE
-- Get the value of the first row in a specified window frame.
-- Syntax
FIRST_VALUE (expression) [ {RESPECT | IGNORE} NULLS ])
OVER (
    [ query_partition_clause ] 
    order_by_clause
    [frame_clause]
)

/*
Note that the frame clause:
    RANGE BETWEEN UNBOUNDED PRECEDING AND 
              UNBOUNDED FOLLOWING
defines that the window frame starts at the first row and ends at last row of the result set.
*/

-- To get the lowest price product in each category
SELECT 
    product_id, 
    product_name,
    list_price, 
    FIRST_VALUE(product_name) 
     OVER (
        PARTITION BY category_id 
        ORDER BY list_price
    ) first_product
FROM 
    products;

-- LAST_VALUE
-- Get the value of the last row in a specified window frame.
-- Show the highest price product in each category
SELECT 
    product_id, 
    product_name, 
    category_id,
    list_price,
    LAST_VALUE(product_name) OVER (
        PARTITION BY category_id
        ORDER BY list_price 
        RANGE BETWEEN UNBOUNDED PRECEDING AND 
            UNBOUNDED FOLLOWING) highest_price_product_id
FROM 
    products;

-- LEAD
-- Provide access to a row at a given physical offset that follows the current row without using a self-join.
/*
The LEAD() function is very useful for calculating the difference between the values of current and subsequent rows.
*/
-- Sytnax
LEAD(expression [, offset ] [, default ])
OVER (
	[ query_partition_clause ] 
	order_by_clause
)

-- Example
SELECT salesman_id, year, sales
FROM salesman_performance
ORDER BY salesman_id, year, sales;

-- Return sales of the following year for every salesman
SELECT 
	salesman_id,
	year, 
	sales,
	LEAD(sales) OVER (
		PARTITION BY SALESMAN_ID
		ORDER BY year
	) following_year_sales
FROM 
	salesman_performance;

-- LAG
-- Provide access to a row at a given physical offset that comes before the current row without using a self-join.
/*

*/
-- Syntax
LAG(expression [, offset ] [, default ])
OVER (
	[ query_partition_clause ] 
	order_by_clause
)

-- return YoY sales performance of every salesman
WITH cte_sales (
	salesman_id, 
	year, 
	sales,
	py_sales) 
AS (
	SELECT 
		salesman_id,
		year, 
		sales,
		LAG(sales) OVER (
			PARTITION BY salesman_id
			ORDER BY year
		) py_sales
	FROM 
		salesman_performance
)
SELECT 
	salesman_id,
	year,
	sales,
	py_sales,
	CASE 
    	 WHEN py_sales IS NULL THEN 'N/A'
  	ELSE
    	 TO_CHAR((sales - py_sales) * 100 / py_sales,'999999.99') || '%'
  	END YoY
FROM 
	cte_sales;

-- ROW_NUMBER
-- Assign a unique sequential integer starting from 1 to each row in a partition or in the whole result
/*
To effectively use the ROW_NUMBER() function, you should use a subquery or 
a common table expression to retrieve row numbers for a specified range to get the top-N, bottom-N, and inner-N results.
*/
-- Syntax
ROW_NUMBER() OVER (
   [query_partition_clause] 
   order_by_clause
)
-- To get a single most expensive product by category
WITH cte_products AS (
SELECT 
    row_number() OVER(
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) row_num, 
    category_id,
    product_name, 
    list_price
FROM 
    products
)
SELECT * FROM cte_products
WHERE row_num = 1;


-- PERCENT_RANK
-- Calculate the percent rank of a value in a set of values.
/*
The PERCENT_RANK() function is similar to the CUME_DIST() function.
*/
-- Syntax
PERCENT_RANK() OVER (
    [ query_partition_clause ] 
    order_by_clause
)
-- The following statement calculates the sales percentile for each salesman in 2016 and 2017.
SELECT 
    salesman_id,
    year,
    sales,  
    ROUND(PERCENT_RANK() OVER (
        PARTITION BY year
        ORDER BY sales DESC
    ) * 100,2) || '%' percent_rank
FROM 
    salesman_performance
WHERE 
    year in (2016,2017);   


-- NTH_VALUE
-- Get the Nth value in a set of values.
NTH_VALUE (expression, N)
[ FROM { FIRST | LAST } ]
[ { RESPECT | IGNORE } NULLS ] 
OVER (
    [ query_partition_clause ] 
    order_by_clause
    [frame_clause]
)
-- The following query uses the NTH_VALUE() function 
-- to get all the products as well as the second most expensive product by category:
SELECT
    product_id,
    product_name,
    category_id,
    list_price,
    NTH_VALUE(product_name,2) OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND 
            UNBOUNDED FOLLOWING
    ) AS second_most_expensive_product
FROM
    products;


-- NTILE
-- Divide an ordered set of rows into a number of buckets and assign an appropriate bucket number to each row.
-- Syntax
NTILE(expression) OVER ( 
    [query_partition_clause]
    order_by_clause 
)
-- The following statement divides into 4 buckets the values 
-- in the sales column of the salesman_performance view in the year of 2016 and 2017:
SELECT 
	salesman_id, 
	sales,
	year,
	NTILE(4) OVER(
		PARTITION BY year
		ORDER BY sales DESC
	) quartile
FROM 
	salesman_performance
WHERE
	year = 2016 OR year = 2017;


*****************************************
Comparison Functions
*****************************************
-- COALESCE
-- show you how to substitute null with a more meaningful alternative.

-- DECODE
-- learn how to add if-then-else logic to a SQL query.

-- NVL
-- return the first argument if it is not null, otherwise, returns the second argument.

-- NVL2
-- show you how to substitute a null value with various options.

--NULLIF
-- return a null if the first argument equals the second one, otherwise, returns the first argument.

*****************************************
Date Functions
*****************************************
-- ADD_MONTHS
-- Add a number of months (n) to a date and return the same day which is n of months away.
select ADD_MONTHS(DATE '2016-02-29', 1) from dual;

-- CURRENT_DATE
-- Return the current date and time in the session time zone
SELECT CURRENT_DATE FROM dual;

-- CURRENT_TIMESTAMP
-- Return the current date and time with time zone in the session time zone
SELECT CURRENT_TIMESTAMP FROM dual;

-- DBTIMEZONE
-- Get the current database time zone
SELECT DBTIMEZONE FROM dual;

-- EXTRACT
-- Extract a value of a date time field e.g., YEAR, MONTH, DAY, � from a date time value.
select
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
from dual;

-- FROM_TZ
-- Convert a timestamp and a time zone to a TIMESTAMP WITH TIME ZONE value
select FROM_TZ(TIMESTAMP '2017-08-08 08:09:10', '-09:00') from dual;

-- LAST_DAY
-- Gets the last day of the month of a specified date.
select LAST_DAY(DATE '2016-02-01') from dual;

-- LOCALTIMESTAMP
-- Return a TIMESTAMP value that represents the current date and time in the session time zone.
SELECT LOCALTIMESTAMP FROM dual;

-- MONTHS_BETWEEN
-- Return the number of months between two dates.
select MONTHS_BETWEEN( DATE '2017-07-01', DATE '2017-01-01' ) from dual;

-- NEW_TIME
-- Convert a date in one time zone to another
select NEW_TIME(TO_DATE('08-07-2017 01:30:45', 'MM-DD-YYYY HH24:MI:SS'), 'AST', 'PST') from dual;

-- NEXT_DAY
-- Get the first weekday that is later than a specified date.
select NEXT_DAY(DATE '2000-01-01', 'SUNDAY') from dual;

-- ROUND
-- Return a date rounded to a specific unit of measure.
select ROUND(DATE '2017-07-16', 'MM') from dual;

-- SESSIONTIMEZONE
-- Get the session time zone
SELECT SESSIONTIMEZONE FROM dual;

-- SYSDATE
-- Return the current system date and time of the operating system where the Oracle Database resides.
select SYSDATE from dual;

-- SYSTIMESTAMP
-- Return the system date and time that includes fractional seconds and time zone.
SELECT SYSTIMESTAMP FROM dual;

-- TO_CHAR
-- Convert a DATE or an INTERVAL value to a character string in a specified format.
select TO_CHAR(SYSDATE, 'DL') from dual;
SELECT TO_CHAR(INTERVAL '600' SECOND, 'HH24:MM') result FROM  DUAL;

-- TRUNC
-- Return a date truncated to a specific unit of measure.
select TRUNC(DATE '2017-07-16', 'MM') from dual;

-- TZ_OFFSET
-- Get time zone offset of a time zone name from UTC
select TZ_OFFSET( 'Asia/Kolkata') from dual;

*****************************************
String Functions
*****************************************

-- ASCII
-- Returns an ASCII code value of a character.
select ASCII('A') from dual;

-- CHR
-- Converts a numeric value to its corresponding ASCII character.
select CHR(65) from dual;

-- CONCAT
-- Concatenate two strings and return the combined string.
select CONCAT('A','BC') from dual;

-- CONVERT	
-- Convert a character string from one character set to another.
SELECT CONVERT('ABC', 'utf8', 'us7ascii') FROM dual;

-- DUMP
-- Return a string value (VARCHAR2) that includes the datatype code, length measured in bytes, 
-- and internal representation of a specified expression.
SELECT DUMP('A') FROM dual;

-- INITCAP
-- Converts the first character in each word in a specified string to uppercase and the rest to lowercase.
select INITCAP('hi there') from dual;

-- INSTR
-- Search for a substring and return the location of the substring in a string
select INSTR('This is a playlist', 'is') from dual;

-- LENGTH
-- Return the number of characters (or length) of a specified string
select LENGTH('ABC') from dual;

-- LOWER
-- Return a string with all characters converted to lowercase.
select LOWER('Abc') from dual;

-- LPAD
-- Return a string that is left-padded with the specified characters to a certain length.
select LPAD('ABC',5,'*') from dual;

-- LTRIM
-- Remove spaces or other specified characters in a set from the left end of a string.
select LTRIM(' ABC ') from dual;

-- REGEXP_COUNT
-- Return the number of times a pattern occurs in a string.
select REGEXP_COUNT('1 2 3 abc','\d') from dual;

-- REGEXP_INSTR
-- Return the position of a pattern in a string.
select REGEXP_INSTR('Y2K problem','\d+') from dual;

-- REGEXP_LIKE
-- Match a string based on a regular expression pattern.
/*
Can not be used in the WHERE condition.
*/
SELECT first_name FROM employees WHERE REGEXP_LIKE( first_name, 'y$', 'i' ) ORDER BY first_name; 

-- REGEXP_REPLACE
-- Replace substring in a string by a new substring using a regular expression.
select REGEXP_REPLACE('Year of 2017','\d+', 'Dragon') from dual;

-- REGEXP_SUBSTR
-- Extract substrings from a string using a pattern of a regular expression.
select REGEXP_SUBSTR('Number 10', '\d+') from dual;

-- REPLACE
-- Replace all occurrences of a substring by another substring in a string.
select REPLACE('JACK AND JOND','J','BL') from dual;

-- RPAD
-- Return a string that is right-padded with the specified characters to a certain length.
select RPAD('ABC',5,'*') from dual;

-- RTRIM
-- Remove all spaces or specified character in a set from the right end of a string.
select REPLACE(RTRIM(' ABC '), ' ', '$') from dual;

-- SOUNDEX
-- Return a phonetic representation of a specified string.
select SOUNDEX('sea'), SOUNDEX('see') from dual;

-- SUBSTR
-- Extract a substring from a string.
select SUBSTR('Oracle Substring', 1, 6 ) from dual;

-- TRANSLATE
-- Replace all occurrences of characters by other characters in a string.
select TRANSLATE('12345', '143', 'bx') from dual;

-- TRIM
-- Remove the space character or other specified characters either from the start or end of a string.
select TRIM(' ABC ') from dual;

-- UPPER
-- Convert all characters in a specified string to uppercase.
select UPPER('Abc') from dual;

*****************************************







































