create or replace function get_customer_status ( SALES_REP_ID number, order_details varchar2) return varchar2 as
 status_obj    json_object_t;
 order_obj     json_object_t;
 order_arr     json_array_t;
 status_json   varchar2(4000);
 num_orders    number;
 order_value   number;
begin
  -- build new object and set 'id' value
  status_obj := new json_object_t();
  status_obj.put('id', SALES_REP_ID);

  -- parse the orders array and count items in array
  order_arr := json_array_t.parse(order_details);
  num_orders := order_arr.get_size();

  -- set 'manyOrders' field to true if 10 or more orders
  if (num_orders >= 10) then
   status_obj.put('manyOrders', TRUE);
  end if;

  -- loop over array and add up order values
  order_value := 0;
  for i in 0 .. num_orders-1 loop
    -- get current item of array as an json object (cast to json_object_t)
    order_obj := TREAT (order_arr.get(i) as JSON_OBJECT_T);
    order_value := order_value + order_obj.get_Number('order_value');
  end loop;

  -- if sepnd over half a million, you're a big spender, add this to json_status
  if (order_value > 500000) then
     status_obj.put('bigSpender', TRUE);
     status_obj.put('totalValue', order_value);
  end if;

  -- serialize the object to a varchar2 value
  status_json := status_obj.to_string();
  return status_json;
end;
/

select get_customer_status(SALES_REP_ID, ORDER_DETAILS) from sales_report;

--Expected output for the query is as follows
/*
{"id":155}
{"id":156}
{"id":163,"manyOrders":true}
{"id":153}
{"id":161,"manyOrders":true,"bigSpender":true,"totalValue":661734.5}
{"id":160}
{"id":154,"manyOrders":true}
{"id":158}
{"id":159}
*/