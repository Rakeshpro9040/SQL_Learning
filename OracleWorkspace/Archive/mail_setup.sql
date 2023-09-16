-- create acl
begin
dbms_network_acl_admin.create_acl (
acl             => 'gmail.xml',
description     => 'Normal Access',
principal       => 'RAKESH',
is_grant        => TRUE,
privilege       => 'connect',
start_date      => null,
end_date        => null);
end;

-- add priviliege to acl
begin
dbms_network_acl_admin.add_privilege ( 
acl       => 'gmail.xml',
principal    => 'RAKESH',
is_grant    => TRUE, 
privilege    => 'connect', 
start_date    => null, 
end_date    => null); 
end;

begin
dbms_network_acl_admin.add_privilege ( 
acl       => 'gmail.xml',
principal    => 'RAKESH',
is_grant    => TRUE, 
privilege    => 'resolve', 
start_date    => null, 
end_date    => null);   
end;    

-- assign host, port to acl
begin
  dbms_network_acl_admin.assign_acl (
  acl => 'gmail.xml',
  host => 'smtp.gmail.com', -- or host => 'gmail.com', - I never used gmail in Oracle
  lower_port => 465,
  upper_port => 465);
end;

--delete acl
begin
dbms_network_acl_admin.unassign_acl(
acl        => 'gmail.xml',
host       => 'smtp.gmail.com',
lower_port => 465,
upper_port => 465
);
end;
