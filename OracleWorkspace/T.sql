SET SERVEROUTPUT ON
DECLARE
  l_tab1 t_number_tab := t_number_tab(1,2,3,4,5);
BEGIN
  DBMS_OUTPUT.put_line('COUNT       = ' || l_tab1.COUNT);
  DBMS_OUTPUT.put_line('CARDINALITY = ' || CARDINALITY(l_tab1));
END;
/
SELECT * FROM TABLE(POWERMULTISET(t_number_tab (1,2,3,4)));


select manager_id, phone from employees order by 1;

declare
    type ph_type is table of varchar2(100) index by pls_integer;
    l_ph_tab ph_type;
begin
    select phone bulk collect into l_ph_tab from employees;
    
    for ph in l_ph_tab.first .. l_ph_tab.last loop
        dbms_output.put_line(l_ph_tab(ph));
    end loop;
end;
/


select e.*, dense_rank() over(order by e.sal, e.ename desc) rank
from emp e
order by e.sal, e.ename;

select nvl2(null, 1, 2) from dual;
