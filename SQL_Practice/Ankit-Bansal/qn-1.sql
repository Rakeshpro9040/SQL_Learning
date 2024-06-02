/*
Olympic Gold Medal Problem:
Write a query to find number of gold medal per swimmer for the swimmers who won only gold medals. 
Solve using 2 methods -
1) Sub-query
2) Group by & Having - CTE
*/

drop table events;

CREATE TABLE events 
(
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

desc events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

-- Solution-1
select e.gold as player_name, count(*) as no_of_gold
from events e
where not exists (
    select null
    from events e1
    where e1.silver = e.gold
    union all
    select null
    from events e2
    where e2.bronze = e.gold    
)
group by e.gold
order by 1;

-- Solution-2
select e.gold as player_name, count(*) as no_of_gold
from events e
where e.gold not in (
    select e1.silver
    from events e1
    union all
    select e2.bronze
    from events e2
)
group by e.gold
order by 1;

-- Solution-3
with cte as
(
select gold as player_name, 'gold' as medal_type from events
union all
select silver as player_name, 'silver' from events
union all
select bronze as player_name, 'bronze' from events
)
select player_name, count(*)
from cte
group by player_name
having count(distinct medal_type) = 1
and max(medal_type) = 'gold'
order by 1;






