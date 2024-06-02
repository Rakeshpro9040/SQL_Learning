/*
Solving a REAL Business Use Case Using SQL | Business Days Excluding Weekends and Public Holidays:
In this video we are going to solve a very important business use case where we need to find difference between 2 dates excluding weekends and public holidays. 
Basically we need to find business days between 2 given dates using SQL. 

Write a sql to find business days between create date and resolved date by excluding weekends and public holidays.
--2022-08-01 -> Monday, --2022-08-03 -> Wednesday
--2022-08-01 -> Monday, --2022-08-12 -> Friday
--2022-08-01 -> Monday, --2022-08-16 -> Tuesday

Assignment: What if your public holiday is on weekend.
*/

--script:
create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

delete from tickets;
insert into tickets values (1,'01-AUG-2022','03-AUG-2022');
insert into tickets values (2,'01-AUG-2022','12-AUG-2022');
insert into tickets values (3,'01-AUG-2022','16-AUG-2022');
commit;

create table holidays
(
holiday_date date,
reason varchar(100)
);

delete from holidays;
insert into holidays values ('11-AUG-2022','Rakhi');
insert into holidays values ('15-AUG-2022','Independence day');
commit;

select * from tickets;
select * from holidays;

select to_char(sysdate+(level-1), 'FMDAY') as day, to_char(sysdate+(level-1), 'D') as day_no,
trunc(sysdate+(level-1),'iw') as start_week
from dual
connect by level < 8
order by 2;

select to_char(to_date('02-Jul-2023','DD-Mon-RRRR'),'D') from dual;

select t.*, to_char(t.create_date, 'FMDAY') as create_day,
    to_char(t.resolved_date, 'FMDAY') as resolved_day,
    t.resolved_date - t.create_date as no_of_days
from tickets t;

with cte as
(
select t.ticket_id, t.create_date
from tickets t
union all
select t.ticket_id, t.resolved_date
from tickets t
order by ticket_id, create_date
)
select t1.*, t1.create_date + (level-1) as consecutive_date
from cte t1, cte t2
where t1.ticket_id = t2.ticket_id
and t1.create_date < t2.create_date
order by t1.ticket_id;

-- Solution
with cte as
(
select t.*, t.create_date + (level-1) as consecutive_date
from tickets t
connect by t.create_date + (level-1) <= t.resolved_date
and prior t.ticket_id = t.ticket_id
and prior sys_guid() is not null
order by t.ticket_id, t.create_date
),
cte1 as
(
select ticket_id, consecutive_date
from cte
where to_char(consecutive_date, 'FMDAY') not in ('SATURDAY','SUNDAY')
and consecutive_date not in (select holiday_date from holidays)
)
select ticket_id, count(consecutive_date)-1 as no_of_days
from cte1
group by ticket_id
order by 1;

-- Solution

with cte as
(
select t.*, to_char(t.create_date, 'FMDAY') as create_day,
    to_char(t.resolved_date, 'FMDAY') as resolved_day,
    trunc(create_date, 'iw') as create_date_week,
    trunc(resolved_date, 'iw') as resolved_date_week,
    to_char(create_date, 'WW') as create_date_week_no,
    to_char(resolved_date, 'WW') as resolved_date_week_no,
    t.resolved_date - t.create_date as no_of_days
from tickets t
), cte1 as
(
select cte.*,
    case when resolved_date_week_no-create_date_week_no = 0 then 0
        else (resolved_date_week_no-create_date_week_no)*2
    end no_of_weekends
from cte
)
select ticket_id,
    t.create_date,
    t.resolved_date,
    (no_of_days-no_of_weekends)-count(h.holiday_date) as no_of_days
from cte1 t
left join holidays h
on h.holiday_date between t.create_date and t.resolved_date
and to_char(h.holiday_date, 'FMDAY') not in ('SATURDAY','SUNDAY') 
-- this is to exclude overlap of holiday and weekends scenario
group by ticket_id, t.create_date, t.resolved_date, (no_of_days-no_of_weekends)
order by 1;













