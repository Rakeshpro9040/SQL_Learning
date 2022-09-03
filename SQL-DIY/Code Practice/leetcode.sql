/*
https://leetcode.com/problems/big-countries/
*/
select name, population, area
from world
where area >= 3000000 
or population >= 25000000;

/*
https://leetcode.com/problems/classes-more-than-5-students/
*/
select class
from courses
group by class
having count(student) >= 5;

/*
https://leetcode.com/problems/combine-two-tables/
*/
select 
    p.firstname,
    p.lastname,
    a.city,
    a.state
from person p
left outer join address a
on p.personid = a.personid;

/*
https://leetcode.com/problems/second-highest-salary/
*/
select max(salary) "SecondHighestSalary"
from employee
where salary < (select max(salary) from employee);

