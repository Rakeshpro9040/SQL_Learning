SELECT max(sal) KEEP (DENSE_RANK FIRST ORDER BY sal) AS HighestPaid,
       min(sal) KEEP (DENSE_RANK LAST ORDER BY sal) AS LowestPaid
FROM emp;

select * from emp;
select * from employees;

