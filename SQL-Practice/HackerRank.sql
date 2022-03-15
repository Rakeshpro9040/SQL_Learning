--Misc
select * from user_tables;

--Qn
/*
Query the list of CITY 
names starting with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE REGEXP_LIKE (city, '^[aeiou]', 'i');

SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '([aeiou])\1', 'i')
ORDER BY last_name;

SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '^[aeiou]', 'i')
ORDER BY last_name;

-- Qn
/*
Query the list of CITY 
names ending with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE REGEXP_LIKE (city, '[aeiou]$', 'i');

SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '[aeiou]$', 'i')
ORDER BY last_name;

-- Qn
/*
Query the list of CITY 
names beginning & ending with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE REGEXP_LIKE (city, '^[aeiou].*[aeiou]$', 'i');
-- Here .* --> . for a single not null char, * for any number

SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '^[aeiou].*[aeiou]$', 'i')
ORDER BY last_name;

-- Qn
/*
Query the list of CITY 
names can not start with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE NOT REGEXP_LIKE (city, '^[aeiou]', 'i');

SELECT last_name
FROM employees
WHERE NOT REGEXP_LIKE (last_name, '^[aeiou]', 'i')
ORDER BY last_name;

-- Qn
/*
Query the list of CITY 
names can not end with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE NOT REGEXP_LIKE (city, '[aeiou]$', 'i');

SELECT last_name
FROM employees
WHERE NOT REGEXP_LIKE (last_name, '[aeiou]$', 'i')
ORDER BY last_name;

-- Qn
/*
Query the list of CITY 
names can not start/end with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT distinct city
FROM STATION
WHERE NOT REGEXP_LIKE (city, '^[aeiou]', 'i')
OR NOT REGEXP_LIKE (city, '[aeiou]$', 'i');

SELECT last_name
FROM employees
WHERE NOT REGEXP_LIKE (last_name, '^[aeiou]', 'i')
OR NOT REGEXP_LIKE (last_name, '^[aeiou]$', 'i')
ORDER BY last_name;





























