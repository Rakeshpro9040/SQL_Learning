-- Multi insert in MERGE
select * from user_tables order by 1;

drop table merge_test_src;
create table merge_test_src (
    test_col1 varchar2(10),
    test_col2 varchar2(10),
    test_col3 varchar2(10)
);
/

drop table merge_test_tgt;
create table merge_test_tgt (
    test_col1 varchar2(10),
    test_col2 varchar2(10),
    test_col3 varchar2(10)
);
/

select * from merge_test_src order by 1;
select * from merge_test_tgt order by 1;

insert all
    into merge_test_src 
    values ('4', 'ABC1', 'DEF2')
    
    into merge_test_src 
    values ('5', 'ABC2', 'DEF2')
    
    into merge_test_src 
    values ('6', 'ABC3', 'DEF3')
select 1 from dual;

merge into merge_test_tgt tgt
using merge_test_src src
on (src.test_col1 = tgt.test_col1)
when matched then
    update set tgt.test_col2 = src.test_col2,
        tgt.test_col3 = src.test_col3
when not matched then
    insert(test_col1, test_col2, test_col3)
    values(src.test_col1, src.test_col2, src.test_col3);












