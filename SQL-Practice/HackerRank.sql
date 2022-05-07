--Misc
select * from user_tables;
select * from cat;

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
WHERE (NOT REGEXP_LIKE (city, '^[aeiou]', 'i'))
AND (NOT REGEXP_LIKE (city, '[aeiou]$', 'i'));

SELECT last_name
FROM employees
WHERE (NOT REGEXP_LIKE (last_name, '^[aeiou]', 'i'))
AND (NOT REGEXP_LIKE (last_name, '[aeiou]$', 'i'))
ORDER BY last_name;

-- Qn
/*
Query the Name of any student in STUDENTS who scored higher than 75 Marks. 
Order your output by the last three characters of each name. 
If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), 
secondary sort them by ascending ID.
*/
select name
from students
where marks > 75
order by substr(name,-3, 3);

select e.last_name
from employees e
where e.salary > 12000
order by substr(e.last_name,-3, 3);

-- Qn
/*
Write a query that prints a list of employee names (i.e.: the name attribute) 
from the Employee table in alphabetical order.
*/
select name
from employee;

select last_name
from employees
order by 1;

-- Qn
/*
Write a query that prints a list of employee names (i.e.: the name attribute) for employees 
in Employee having a salary greater than 2000 per month who have been employees for less than 10 months. 
Sort your result by ascending employee_id.
*/
select name
from employee
where salary > 2000
and months < 10
order by employee_id;

-- Qn
/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) 
and their respective average city populations (CITY.Population) rounded down to the nearest integer.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/
select b.continent, nvl(floor(avg(a.population)),0) as populations
from city a 
inner join country b
on a.countrycode = b.code
group by b.continent
order by 1;

-- Qn
/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.
*/

select 
    case when ((A+B) <= C) OR ((A+C) <= B) OR ((B+C) <= A) then
            'Not A Triangle'
        when (A = B) AND (A = C) AND (B = C) then
            'Equilateral'
        when (A = B) OR (A = C) OR (B = C) then
            'Isosceles'
        else
            'Scalene'
    end as output
from TRIANGLES;

-- Qn
/*
Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, 
immediately followed by the first letter of each profession as a parenthetical 
(i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
Query the number of ocurrences of each occupation in OCCUPATIONS. 
Sort the occurrences in ascending order, and output them in the following format:

There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation 
in OCCUPATIONS and [occupation] is the lowercase occupation name. 
If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

Note: There will be at least two entries in the table for each type of occupation.
*/

select 
    name || '(' || substr(occupation,1,1) || ')' AS output
from OCCUPATIONS
UNION ALL
select 'There are a total of ' ||
       count(occupation) || ' ' ||
       lower(occupation) ||
       's.'
from OCCUPATIONS
group by occupation
order by 1;

-- Qn
-- did not work
select 
    case when main.Doctor = 1 then
        main.name
    else NULL end AS Doctor,
    case when main.Professor = 1 then
        main.name
    else NULL end AS Professor,
    case when main.Singer = 1 then
        main.name
    else NULL end AS Singer,
    case when main.Actor = 1 then
        main.name
    else NULL end AS Actor
from
(
    SELECT * FROM
    (
      SELECT name, occupation
      FROM OCCUPATIONS 
    )
    PIVOT
    (
      COUNT(occupation)
      FOR occupation IN ('Doctor' AS Doctor, 
                         'Professor' AS Professor, 
                         'Singer' AS Singer, 
                         'Actor' AS Actor)
    )
) main;

-- solution (Here the PIVOT is built on occupation column, keeping row_number & name as the row data)
SELECT 
	--rn,
    Doctor, 
    Professor, 
    Singer, 
    Actor 
FROM 
(
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) as rn, 
        name, 
        occupation 
    FROM                    
        occupations
) 
PIVOT 
(
    MAX(name) FOR occupation 
		IN ('Doctor' as Doctor,'Professor' as Professor, 'Singer'  as Singer, 'Actor' as Actor)
) 
ORDER BY rn;
/*
rn	Doctor Professor Singer Actor
--	------ --------- ------ -----
1	Aamina Ashley Christeen Eve
2	Julia Belvet Jane Jennifer
3	Priya Britney Jenny Ketty
4	NULL Maria Kristeen Samantha
5	NULL Meera NULL NULL
6	NULL Naomi NULL NULL
7	NULL Priyanka NULL NULL
*/

-- Step-1
SELECT 
	ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) as rn, 
	name, 
	occupation 
FROM                    
	occupations;
/*
rn name occupation
-- ---- ----------
1 Eve Actor
2 Jennifer Actor
3 Ketty Actor
4 Samantha Actor
1 Aamina Doctor
2 Julia Doctor
3 Priya Doctor
1 Ashley Professor
2 Belvet Professor
3 Britney Professor
4 Maria Professor
5 Meera Professor
6 Naomi Professor
7 Priyanka Professor
1 Christeen Singer
2 Jane Singer
3 Jenny Singer
4 Kristeen Singer
*/

/*
1 Eve Actor
1 Christeen Singer
1 Ashley Professor
1 Aamina Doctor

2 Jennifer Actor
2 Jane Singer
2 Belvet Professor
2 Julia Doctor

3 Jenny Singer
3 Britney Professor
3 Ketty Actor
3 Priya Doctor

4 Maria Professor
4 Samantha Actor
4 Kristeen Singer

5 Meera Professor

6 Naomi Professor

7 Priyanka Professor
*/

-- Test
SELECT 
    Doctor, 
    Professor, 
    Singer, 
    Actor 
FROM 
(
    SELECT 
        name, 
        occupation 
    FROM                    
        occupations
) 
PIVOT 
(
    MAX(name) FOR occupation 
        IN ('Doctor' as Doctor,'Professor' as Professor, 'Singer'  as Singer, 'Actor' as Actor)
);
/*
Priya Priyanka Kristeen Samantha
*/

-- PIVOT Table Hands-on
-- Task: Display Dept as column and Data for Job id and last name
select
    *
from
(
    select
        department_id,
        job_id, 
        last_name,
        salary
    from
        employees
)
pivot
(
    sum(salary) FOR department_id
        in (10,15,20,30,40,50,60,70,80,90,100,110)
)
order by 1,2;

-- Qn
/*
You are given a table, BST, containing two columns: N and P, 
where N represents the value of a node in Binary Tree, and P is the parent of N.
Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
    Root: If node is root node.
    Leaf: If node is leaf node.
    Inner: If node is neither root nor leaf node.
*/
/*
insert into ot.bst values (1,2);
insert into ot.bst values (3,2);
insert into ot.bst values (6,8);
insert into ot.bst values (9,8);
insert into ot.bst values (2,5);
insert into ot.bst values (8,5);
insert into ot.bst values (5,null);
commit;
*/
desc ot.bst;
select * from ot.bst order by 1;

select n, p, connect_by_isleaf isleaf,
case when p is NULL then
    'Root'
    when connect_by_isleaf = 1 then
    'Leaf'
else 'Inner' end node
from ot.bst
start with p is NULL
connect by prior n = p
order by 1;

--Ans
select n,
case when p is NULL then
    'Root'
    when connect_by_isleaf = 1 then
    'Leaf'
else 'Inner' end node
from bst
start with p is NULL
connect by prior n = p
order by 1;

SELECT N, 
case when P IS NULL then 
    'Root'
    when ((SELECT COUNT(*) FROM BST A WHERE A.P=B.N)>0) then
    'Inner'
else 'Leaf' end node,
(SELECT COUNT(*) FROM BST A WHERE A.P=B.N) cnt 
FROM BST B
ORDER BY N;

--Qn
/*
New Companies
*/

select distinct 
    c.company_code, 
    c.founder,
    (select count(distinct lead_manager_code) 
     from lead_manager 
     where company_code = c.company_code) AS tot_lead_manager, 
    (select count(distinct senior_manager_code) 
     from senior_manager 
     where company_code = c.company_code) AS tot_senior_manager, 
    (select count(distinct manager_code) 
     from manager 
     where company_code = c.company_code) AS tot_manager, 
    (select count(distinct employee_code) 
     from employee 
     where company_code = c.company_code) AS tot_employee
from company c
order by company_code;

--Qn
/*
SQL Project Planning
*/

/*
create table ot.projects
(
    task_id integer,
    start_date date,
    end_date date
);
*/

select 
    p1.task_id,
    p1.start_date, 
    p1.end_date,
    (p1.end_date - p1.start_date) AS days, --1 day gap
    p2.start_date,
    p2.end_date
from projects p1, projects p2
where (p1.end_date+1) = p2.end_date(+) --consecutive dates
and  p2.start_date is null --last task id of the project
order by days, p1.start_date;

--Ans
SELECT START_DATE, MIN(END_DATE)
FROM
  (SELECT START_DATE
   FROM PROJECTS
   WHERE START_DATE NOT IN
       (SELECT END_DATE
        FROM PROJECTS)) A,
  (SELECT END_DATE
   FROM PROJECTS
   WHERE END_DATE NOT IN
       (SELECT START_DATE
        FROM PROJECTS)) B
WHERE START_DATE < END_DATE
GROUP BY START_DATE
ORDER BY (MIN(END_DATE) - START_DATE), START_DATE;

--Qn
/*
Placement
*/
select s1.name 
from students s1, friends f, packages p1, students s2, packages p2
where s1.id = f.id
and s1.id = p1.id
and f.friend_id = s2.id
and f.friend_id = p2.id
and p1.salary < p2.salary
order by p2.salary;

--Qn
/*
Symmetric Pairs
*/
select f1.x,f1.y
from
    (select x,y
    from functions
    where x < y) f1,
    (select x,y
    from functions
    where x > y) f2
where f1.x = f2.y
and f1.y = f2.x
union
select distinct x,y
from
(
    select x,y,count(*) over(partition by x,y) cnt
    from functions
    where x=y
)
where cnt > 1
order by 1;

--Aggregarion Qns
/*
Query a count of the number of cities in CITY having a Population larger than 100000.
*/
select count(id)
from city
where population > 100000;

/*
Query the total population of all cities in CITY where District is California.
*/
select sum(population)
from city
where district = 'California';

/*
Query the average population of all cities in CITY where District is California.
*/
select avg(population)
from city
where district = 'California';

/*
Query the average population for all cities in CITY, rounded down to the nearest integer.
*/
select floor(avg(population))
from city;

/*
Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
*/
select sum(population)
from city
where COUNTRYCODE = 'JPN';

/*
Query the difference between the maximum and minimum populations in CITY.
*/
select max(population)-min(population)
from city;

/*
The Bluder
*/
/*
Keyword:
next integer: ceil
round down: floor
*/
select 2600-replace(2006,0) from dual;
select ceil(avg(salary)-avg(replace(salary,0)))
from employees;

/*
Top Earners
*/
select (salary*months) || ' ' || count(employee_id)
from employee
where (salary*months) = 
(
    select max(salary*months)
    from employee
)
group by (salary*months);

/*
Weather Observation Station 2
*/
select round(sum(lat_n),2), round(sum(long_w),2)
from station;

/*
Weather Observation Station 13
*/
select trunc(sum(lat_n),4)
from station
where lat_n between 38.7880 and 137.2345;

/*
Weather Observation Station 14
*/
select trunc(max(lat_n),4)
from station
where lat_n < 137.2345;

/*
Weather Observation Station 15
*/
select round(long_w,4)
from station
where lat_n =
(
    select max(lat_n)
    from station
    where lat_n < 137.2345
);

/*
Weather Observation Station 16
*/
select round(min(lat_n),4)
from station
where lat_n > 38.7780;

/*
Weather Observation Station 17
*/
select round(long_w,4)
from station
where lat_n =
(
    select min(lat_n)
    from station
    where lat_n > 38.7780
);

/*
Weather Observation Station 18
Manhattan Distance: |x2-x1|+|y2-y1|
*/
select round((abs(c-a)+abs(d-b)),4)
from
(
    select min(lat_n) a, max(lat_n) c, min(long_w) b, max(long_w) d
    from station
);


















