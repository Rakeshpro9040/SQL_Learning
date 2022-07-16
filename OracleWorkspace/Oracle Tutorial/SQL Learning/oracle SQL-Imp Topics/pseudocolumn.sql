/*
ROWNUM:
    ROWNUM assignment is performed prior to the ORDER BY operation
https://oracle-base.com/articles/misc/top-n-queries#mistake    
*/
select rownum, e.*
from emp e
order by e.sal desc;

/*
As ROWNUM assignment is performed prior to the ORDER BY operation, so to determine Top N rows we can not use this directly when we use order by in our query, instead we have to use FETCH block, which executes after order by clause.
*/
/*
Print Top 5 highest paying employees
*/
select rownum, e.*
from emp e
where rownum <= 5
order by e.sal desc; --wrong

select *
from
(
    select rownum, e.*
    from emp e
    order by e.sal desc
)
where rownum <= 5; --correct (Inline View)

select rownum, e.*
from emp e
order by e.sal desc
fetch first 5 rows only; --correct (FETCH)