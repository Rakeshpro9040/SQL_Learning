BEGIN
  rakesh.send_mail(p_to        => 'rakeshroshanpanigrahipro@gmail.com',
            p_from      => 'rrp9861@gmail.com',
            p_message   => 'This is a test message.',
            p_smtp_host => '*');
END;

select * from dba_network_acls;

select utl_http.request('http://www.tiger.com') from dual;
