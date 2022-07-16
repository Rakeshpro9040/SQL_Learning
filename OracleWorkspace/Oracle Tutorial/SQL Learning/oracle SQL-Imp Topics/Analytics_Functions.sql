/*
https://mode.com/sql-tutorial/sql-window-functions/
https://oracle-base.com/articles/misc/analytic-functions
https://www.oracleplsqltr.com/2020/05/09/analytic-functions-windowing-clause/
*/

select * from emp;
select distinct sal from emp order by 1 desc;

/*
SUM, COUNT, and AVG
*/
/*
Write a qery to get the sum and average of the salary of all employees department-wise,
also print the number of the employess for the department.
*/
--Approach-1: Without Window Function
--Step-1: Find the totals in group by mode
select deptno, sum(sal) tot_sal, count(empno) tot_emp
from emp e
group by deptno;
--Step-2: Join this with main table
select
    e1.*, e2.tot_sal, e2.tot_emp
from
    emp e1
    left outer join
    (
        select deptno, sum(sal) tot_sal, count(empno) tot_emp
        from emp
        group by deptno
    ) e2
    on e1.deptno = e2.deptno
order by 1;

--Approach-2: With Window Function
select e.*,
    sum(e.sal) over(partition by e.deptno) tot_sal,
    count(e.empno) over(partition by e.deptno) tot_emp
from emp e
order by 1;

/*
ROW_NUMBER()
*/
/*
Write a query to fetch exactly 2 rows from each department having maximum empno
*/
select e.*,
    row_number() over(partition by e.deptno order by e.empno desc) row_num
from emp e;

/*
RANK() and DENSE_RANK()
*/
/*
Write a query to fetch the employees having highest salary in each department
*/
select *
from
(
    select e.*,
        rank() over(partition by deptno order by sal) rank
    from emp e
)
where rank = 1;


/*
Write a query to fetch the employees having 3rd highest salary in each department
*/
select *
from
(
    select e.*,
        dense_rank() over(partition by deptno order by sal) dense_rank
    from emp e
)
where dense_rank = 3;

/*
LAG and LEAD
*/
/*
Write a query to to calculate the difference between the salary of the current row and that of the previous row department-wise
*/
select e.*,
    lag(sal, 1 /*offset*/, 0 /*default*/) over(partition by e.DEPTNO order by sal) lag_sal,
    sal - lag(sal, 1 /*offset*/, 0 /*default*/) over(partition by e.DEPTNO order by sal) diff_sal
from emp e;


/*
Write a query to to calculate the difference between the salary of the current row and that of the next row department-wise
*/
select e.*,
    lead(sal, 1 /*offset*/, 0 /*default*/) over(partition by e.DEPTNO order by sal) lead_sal,
    lead(sal, 1 /*offset*/, 0 /*default*/) over(partition by e.DEPTNO order by sal) - sal diff_sal
from emp e;

/*
FIRST_VALUE
LAST_VALUE
NTH_VALUE
*/
/*
Write a query to determine the highlest and lowest salary departmentwise
*/
select e.*,
    first_value(sal) ignore nulls over(partition by deptno order by sal) lowest_sal,
    last_value(sal) ignore nulls over(partition by deptno order by sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) highest_sal
from emp e
order by e.deptno, e.sal;

/*
Write a query to fetch 4th highest salary
*/
--Approach-1
select distinct sal
from emp
order by sal desc
offset 3 rows
fetch next 1 rows only;

--Approach-2 (does not work)
select *
from
    (select distinct sal
    from emp
    order by sal desc)
where rownum <=4;

--Approach-3 (does not work)
select sal
from
(
    select
    sal, row_number() over(order by sal desc) row_num
    from emp
)
where row_num = 4;

--Approach-4 (does not work)
select sal
from
(
    select
    sal, rank() over(order by sal desc) rank
    from emp
)
where rank = 4;

--Approach-5
select sal
from
(
    select
    sal, dense_rank() over(order by sal desc) rank
    from emp
)
where rank = 15;

--Approach-6 (does not work)
select
distinct nth_value(sal,4) respect nulls over(order by sal desc range between unbounded preceding and unbounded following) nth_val
from emp;

--Approach-7
select max(sal)
from emp
where sal < (select max(sal) from emp);