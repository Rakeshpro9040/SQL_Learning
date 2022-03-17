*****************************************
Instructions:
*****************************************

This File Contains content from below sites:
https://www.oracletutorial.com/plsql-tutorial/

Login to ADB_USER@ADB.
You can find HR tables in HR@ADB. For more info check ADB section.
You can find oracletutorial databse in OT@ADB.

*****************************************
Anonymous Block
*****************************************
SET SERVEROUTPUT ON

<<outer_block>>
-- Also called a Enclosing bloc
declare
    var_common varchar2(20) := 'OUTER BLOCK';
begin
    <<inner_block>>
    declare
        var_common varchar2(20) := 'INNER BLOCK';
    begin
        dbms_output.put_line(var_common);
        dbms_output.put_line(outer_block.var_common);
    end;
    --dbms_output.put_line(inner_block.var_common); -- Illegal, reference is out of scope
    dbms_output.put_line(var_common);
end;
/
-- Here outer_block & inner_block are known as lables

*****************************************
Datatypes
*****************************************
declare
    var3 pls_integer; -- Can assigne NULL
    var1 signtype; -- Only -1, 0, 1 can be assigned
    var2 simple_integer := 10; -- Can not assigne NULL
    var4 boolean := TRUE; -- This is not a SQL datatype, can't use this in SQL/dbms_output.put_line
    var5 date := sysdate; -- 15-MAR-22
    var6 timestamp := systimestamp; -- 15-MAR-22 05.12.18.478591 PM (Server-Time)
    var7 timestamp := current_timestamp; -- 15-MAR-22 10.55.22.552267 PM (Session-Time)
    var8 timestamp with time zone := systimestamp; -- 15-MAR-22 05.25.00.844067 PM +00:00
    var9 timestamp with time zone := current_timestamp; -- 15-MAR-22 10.57.20.166853 PM ASIA/CALCUTTA
    var10 timestamp with time zone := localtimestamp; -- 15-MAR-22 10.57.47.412157 PM ASIA/CALCUTTA
    var11 timestamp with local time zone := systimestamp; -- 15-MAR-22 11.00.49.958883 PM (Server-Time + SESSIONTIMEZONE)
    var12 timestamp with local time zone := current_timestamp; -- 15-MAR-22 11.01.31.102225 PM
    var13 interval year to month := INTERVAL '10-2' YEAR TO MONTH; -- +10-02 -- 10 years 2 months
    var14 interval day to second := INTERVAL '73' HOUR; -- +03 01:00:00.000000
    co_pi constant real := 3.14159; -- Can not be modified
    l_product_name VARCHAR2(100) DEFAULT 'Laptop'; -- DEFAULT keyword to initialize a variable
    l_shipping_status VARCHAR2( 25 ) NOT NULL := 'Shipped'; -- cannot accept a NULL value
    l_customer_name customers.name%TYPE; -- Anchored declaration
begin
    dbms_output.put_line(co_pi);
end;
/

*****************************************
Conditional Control
*****************************************
-- IF THEN ELSIF
DECLARE
  n_sales NUMBER := 300000;
  n_commission NUMBER( 10, 2 ) := 0;
BEGIN
  IF n_sales > 200000 THEN
    n_commission := n_sales * 0.1;
  ELSIF n_sales <= 200000 AND n_sales > 100000 THEN 
    n_commission := n_sales * 0.05;
  ELSIF n_sales <= 100000 AND n_sales > 50000 THEN 
    n_commission := n_sales * 0.03;
  ELSE
    n_commission := n_sales * 0.02;
  END IF;
  
  dbms_output.put_line(n_commission);
END;
/

-- Note: PL/SQL raises a "CASE_NOT_FOUND" error if you don’t specify an ELSE clause 
-- and the result of the CASE expression does not match any value in the WHEN clauses.

-- Simple CASE
-- Only equality can be checked in the CASE conditions using selector and selector value
-- Here selector = c_grade, and selector_value = 'A', 'B', etc.
DECLARE
  c_grade CHAR( 1 );
  c_rank  VARCHAR2( 20 );
BEGIN
  c_grade := 'B';
  CASE c_grade
  WHEN 'A' THEN
    c_rank := 'Excellent' ;
  WHEN 'B' THEN
    c_rank := 'Very Good' ;
  WHEN 'C' THEN
    c_rank := 'Good' ;
  WHEN 'D' THEN
    c_rank := 'Fair' ;
  WHEN 'F' THEN
    c_rank := 'Poor' ;
  ELSE
    c_rank := 'No such grade' ;
  END CASE;
  DBMS_OUTPUT.PUT_LINE( c_rank );
END;
/

-- Searched CASE
DECLARE
  n_sales      NUMBER;
  n_commission NUMBER;
BEGIN
  n_sales := 150000;
  CASE
  WHEN n_sales > 200000 THEN
    n_commission := 0.2;
  WHEN n_sales >= 100000 AND n_sales < 200000 THEN
    n_commission := 0.15;
  WHEN n_sales >= 50000 AND n_sales < 100000 THEN
    n_commission := 0.1;
  WHEN n_sales > 30000 THEN
    n_commission := 0.05;
  ELSE
    n_commission := 0;
  END CASE;

  DBMS_OUTPUT.PUT_LINE( 'Commission is ' || n_commission * 100 || '%'
  );
END;
/

-- GOTO
-- There are many restrictions for this, check the doc
BEGIN
  GOTO label_2;

  <<label_1>>
  DBMS_OUTPUT.PUT_LINE( 'Hello' );
  GOTO label_3;

  <<label_2>>
  DBMS_OUTPUT.PUT_LINE( 'PL/SQL GOTO Demo' );
  GOTO label_1;

  <<label_3>>
  DBMS_OUTPUT.PUT_LINE( 'and good bye...' );

END;
/

-- NULL
-- This helps to pass the control to next line in the execution block by doing nothing
-- Can be used with GOTO to end the processing, check doc.
-- Can be used with CASE ELSE statement, to not generate "CASE_NOT_FOUND" exception.
DECLARE
  n_credit_status VARCHAR2( 50 );
BEGIN
  n_credit_status := 'GOOD';

  CASE n_credit_status
  WHEN 'BLOCK' THEN
    --request_for_aproval;
    null;
  WHEN 'WARNING' THEN
    --send_email_to_accountant;
    null;
  ELSE
    NULL;
  END CASE;
END;
/

*****************************************
Loops
*****************************************
-- LOOP
-- Note that EXIT allows you to exit the current block execution.
DECLARE
  l_counter NUMBER := 0;
BEGIN
  LOOP
    l_counter := l_counter + 1;
    EXIT WHEN l_counter > 3;
    /*
    -- Equals to:
    IF l_counter > 3 THEN
      EXIT;
    END IF;
    */
    dbms_output.put_line( 'Inside loop: ' || l_counter ) ;
  END LOOP;

  -- control resumes here after EXIT
  dbms_output.put_line( 'After loop: ' || l_counter );
END;
/

-- FOR LOOP
DECLARE
  l_step  PLS_INTEGER := 2;
BEGIN
  FOR l_counter IN 1..5 LOOP
  --FOR l_counter IN REVERSE 1..5 -- This will reverse the loop
    dbms_output.put_line (l_counter*l_step);
    --l_counter := 3; -- This will be illegal
  END LOOP;
  --l_counter := 3; -- This will throw an error
END;
/

-- WHILE Loop
DECLARE
    n_counter NUMBER := 1;
BEGIN
    WHILE n_counter <= 5 LOOP
        dbms_output.put_line('Counter : ' || n_counter);
        n_counter := n_counter + 1;
        --EXIT WHEN n_counter = 3; -- This can be used to exit the loop explicitly
    END LOOP;
END;
/

-- CONTINUE
-- The CONTINUE statement allows you to exit the current loop iteration 
-- and immediately continue on to the next iteration of that loop.
BEGIN
    FOR n_index IN 1..10 LOOP
        -- skip even numbers
        CONTINUE WHEN MOD(n_index,2) = 1;
        -- Equals to:
        /*
        IF MOD(n_index,2) = 1 THEN
            CONTINUE;
        END IF;
        */
        dbms_output.put_line(n_index);
    END LOOP;
END;
/

*****************************************
SELECT INTO
*****************************************
-- Fastest Way to fetch a single row/value
DECLARE
  l_customer_name customers.name%TYPE;
  l_contact_first_name contacts.first_name%TYPE;
  l_contact_last_name contacts.last_name%TYPE;
BEGIN
  -- get customer and contact names
  SELECT
    name, 
    first_name, 
    last_name
  INTO
    l_customer_name, 
    l_contact_first_name, 
    l_contact_last_name
  FROM
    customers
  INNER JOIN contacts USING( customer_id )
  WHERE
    customer_id = 100;
  -- show the information  
  dbms_output.put_line( 
    l_customer_name || ', Contact Person: ' ||
    l_contact_first_name || ' ' || l_contact_last_name );
END;
/

*****************************************
Exception Handler
*****************************************
-- EXCEPTION
/*
    Three types of Exceptions: https://docs.oracle.com/cd/E18283_01/timesten.112/e13076/exceptions.htm
        1) Internally defined -- It has error code, but on name. Eg: ORA-27102 (occurs due to out of memory)
        2) Predefined -- It has error code and name. Eg: ORA-01403:NO_DATA_FOUND, ORA-01422:TOO_MANY_ROWS
            By Using PRAGMA EXCEPTION_INIT(err_name, err_code), we can give a name for these exceptions.
        3) User-defined -- Defined Explicitly by User by defining error code (-20,000 and -20,999) and name.
            By Using exp_name EXCEPTION; and RAISE exp_name;
*/

DECLARE
    l_name customers.NAME%TYPE;
    l_customer_id customers.customer_id%TYPE := &customer_id;
BEGIN
    -- get the customer
    SELECT NAME INTO l_name
    FROM customers
    WHERE customer_id > l_customer_id;
    
    -- show the customer name   
    dbms_output.put_line('Customer name is ' || l_name);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Customer ' || l_customer_id ||  ' does not exist');
        WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('The database returns more than one customer');    
END;
/

-- RAISE EXCEPTION
SELECT * FROM customers WHERE customer_id = 100; --1400
select max(credit_limit) from customers; --5000
select avg(credit_limit) from customers; -- 1894.67

SET VERIFY OFF
SET FEEDBACK OFF
DECLARE
    e_credit_too_high EXCEPTION;
    -- Declare a user-defined exception e_credit_too_high Exception (like a variable declaration)
    PRAGMA exception_init( e_credit_too_high, -20001 );
    -- associate e_credit_too_high exception with the error number -20001
    l_max_credit customers.credit_limit%TYPE;
    l_customer_id customers.customer_id%TYPE := 10;
    l_credit customers.credit_limit%TYPE     := 10003;
BEGIN
    IF l_credit = 10001 THEN
        DBMS_STANDARD.raise_application_error(-20002,'Credit change not allowed!');
        -- Include a Cutome message to the user-defined error
        -- Output: ORA-20011: Credit change no allowed! (and program aborts abruptly - unhandled exception)
    ELSIF l_credit = 10002 THEN
        raise_application_error(-20001,'Credit change not allowed!');
        -- This will redirect it to e_credit_too_high Exception (and program does not abort - handled exception)
        -- Here SQLCODE= -20001 & SQLERRM= Credit change not allowed!
    ELSIF l_credit = 10003 THEN
        RAISE e_credit_too_high;
        -- This will redirect it to e_credit_too_high Exception (and program does not abort - handled exception)
        -- Here SQLCODE= -20001 & SQLERRM=
    ELSE
        -- The below inner block is to test reraise the exception concept
        BEGIN
            SELECT MAX(credit_limit) 
            INTO l_max_credit
            FROM customers;
            
            IF l_credit > l_max_credit THEN 
                RAISE e_credit_too_high;
                -- check if the input credit with the maximum credit, 
                -- if the input credit is greater than the max, then raise the e_credit_too_high exception
            END IF;
            EXCEPTION
                WHEN e_credit_too_high THEN
                    dbms_output.put_line('The credit is too high: ' || l_credit);
                    RAISE; 
                    -- reraise the exception, no need to mention the exception name again
        END;
    END IF; 
EXCEPTION
    WHEN e_credit_too_high THEN
        SELECT avg(credit_limit) 
        into l_credit
        from customers;
        
        dbms_output.put_line('SQLCODE: ' || SQLCODE);
        dbms_output.put_line('SQLERRM: ' || SQLERRM);
        dbms_output.put_line('Adjusted credit to ' || l_credit);
END;
/

-- Exception Propagation (Check the Doc)
-- Exception can be propagated from inner to outer/enclsoing blocks till it finds an Exception block
-- Otherwise the program will abort abruptly

-- Handling Other Unhandled Exceptions
DECLARE
    l_first_name  contacts.first_name%TYPE := 'Flor';
    l_last_name   contacts.last_name%TYPE := 'Stone';
    l_email       contacts.email%TYPE := 'flor.stone@raytheon.com';
    l_phone       contacts.phone%TYPE := '+1 317 123 4105';
    l_customer_id contacts.customer_id%TYPE := -1;
BEGIN
    INSERT INTO contacts(first_name, last_name, email, phone, customer_id)
    VALUES(l_first_name, l_last_name, l_email, l_phone, l_customer_id);
    
    EXCEPTION 
        WHEN OTHERS THEN
            DECLARE
                l_error PLS_INTEGER := SQLCODE;
                l_msg VARCHAR2(255) := sqlerrm;
            BEGIN
                CASE l_error 
                WHEN -1 THEN
                    -- If the exceptions are internal, SQLCODE returns a negative number 
                    -- except for the NO_DATA_FOUND exception which has the number code +100.
                    -- If the exception is user-defined, SQLCODE returns +1 or the number 
                    -- that you associated with the exception via the pragma EXCEPTION_INIT.
                    dbms_output.put_line('duplicate email found ' || l_email);
                    dbms_output.put_line(l_msg);
                    
                WHEN -2291 THEN
                    -- parent key not found
                    dbms_output.put_line('Invalid customer id ' || l_customer_id);
                    dbms_output.put_line(l_msg);
                END CASE;
                -- reraise the current exception
                --RAISE;
            END;      
END;
/

*****************************************
RECORDS
*****************************************
/*
Useful to process a single ROW at a time.
Three Types:
    Table-based: table_name%ROWTYPE
    Cursor-based: cursor_name%ROWTYPE
    Programmer-defined: user_defined_TYPE
*/
-- Programmer-defined
DECLARE
  -- define a RECORD TYPE
  TYPE r_contact_t 
  IS RECORD
  (
    first_name    contacts.first_name%TYPE,
    last_name     contacts.last_name%TYPE,
    phone         contacts.phone%TYPE
  );
  -- declare a RECORD based on the User-defined RECORD TYPE
  r_contact r_contact_t;
  
  cursor cur_contacts IS
    SELECT
        first_name, last_name, phone
    FROM contacts
    WHERE contact_id = 100;
BEGIN
  -- Fetch a whole record, We can also fetch individual fields
  -- Instead of this (cursor-based) approach we can use SELECT INTO as well (Check next example)
  OPEN cur_contacts;
  FETCH cur_contacts INTO r_contact;
  CLOSE cur_contacts;
  
  -- Accessing values from the RECORD TYPE fields
  dbms_output.put_line(r_contact.first_name);
  dbms_output.put_line(r_contact.last_name);
  dbms_output.put_line(r_contact.phone);
  
END;
/

-- Using RECORD Insert/Update row in Table
select * from persons;

DECLARE
  -- Declare RECORD
  r_person persons%ROWTYPE;
BEGIN
  -- Assign values to the RECORD
  r_person.person_id  := 1;
  r_person.first_name := 'John';
  r_person.last_name  := 'Doe';
  
  -- Insert into table from RECORD values
  INSERT INTO persons VALUES r_person;
  
  -- Using SELECT INTO to fetch the record from table into RECORD
  SELECT * INTO r_person 
  FROM persons 
  WHERE person_id = 1;
  
  dbms_output.put_line('OLD:r_person.last_name: ' || r_person.last_name);
  
  -- Re-assign the RECORD value
  r_person.last_name  := 'Smith';
  
  -- Update table using RECORD values
  -- Here we are using pseudo Column ROW to update the whole row based on RECORD values
  UPDATE persons
  SET ROW = r_person
  WHERE person_id = r_person.person_id;
  
  dbms_output.put_line('NEW:r_person.last_name: ' || r_person.last_name);
  
END;
/

-- Nested RECORD (Check the Doc)

*****************************************
CURSORS
*****************************************
/*
Explicit Cursor Attribute
----------------
SQL%ROWCOUNT
SQL%ISOPEN
SQL%FOUND
SQL%NOTFOUND
*/

/*
Explicit Cursor Attribute
----------------
%ISOPEN
%FOUND
%NOTFOUND
%ROWCOUNT
*/

-- Normal Cursor
DECLARE
  l_budget NUMBER := 1000000;
   -- Declare a cursor
  CURSOR c_sales IS
  SELECT  *  FROM sales  
  ORDER BY total DESC;
   -- Declare record to store date for a single row   
   r_sales c_sales%ROWTYPE;
BEGIN
  UPDATE customers SET credit_limit = 0;

  OPEN c_sales;
  -- When you open a cursor, Oracle parses the query, binds variables, and executes the associated SQL statement.
  LOOP
    FETCH  c_sales  INTO r_sales;
    EXIT WHEN c_sales%NOTFOUND;

    UPDATE 
        customers
    SET  
        credit_limit = 
            CASE WHEN l_budget > r_sales.credit 
                        THEN r_sales.credit 
                            ELSE l_budget
            END
    WHERE 
        customer_id = r_sales.customer_id;

    l_budget := l_budget - r_sales.credit;

    DBMS_OUTPUT.PUT_LINE( 'Customer id: ' ||r_sales.customer_id || 
                          ' Credit: ' || r_sales.credit || ' Remaining Budget: ' || l_budget );

    EXIT WHEN l_budget <= 0;
  END LOOP;

  CLOSE c_sales;
END;
/

-- Cursor FOR Loop
DECLARE
  CURSOR c_product
  IS
    SELECT 
        product_name, list_price
    FROM 
        products 
    ORDER BY 
        list_price DESC
    FETCH FIRST 5 ROWS ONLY;
BEGIN
  FOR r_product IN c_product
  -- r_product: Implicit RECORD
  -- Instead of c_product, we can use Implicit Cursor i.e. SELECT statement
  LOOP
    dbms_output.put_line( r_product.product_name || ': $' ||  r_product.list_price );
  END LOOP;
END;
/

-- Parameterized Cursor
-- Below is an exmple of Parameterized Cursor with Default value
select * from orders where EXTRACT( YEAR FROM order_date) = 2017;

DECLARE
    CURSOR c_revenue (in_year NUMBER :=2017 , in_customer_id NUMBER := 1)
    IS
        SELECT SUM(quantity * unit_price) revenue
        FROM order_items
        INNER JOIN orders USING (order_id)
        WHERE status = 'Shipped' 
        AND EXTRACT(YEAR FROM order_date) = in_year
        GROUP BY customer_id
        HAVING customer_id = in_customer_id;
        
    r_revenue c_revenue%rowtype;
BEGIN
    OPEN c_revenue;
    LOOP
        FETCH c_revenue INTO r_revenue;
        EXIT    WHEN c_revenue%notfound;
        -- show the revenue
        dbms_output.put_line(r_revenue.revenue);
    END LOOP;
    CLOSE c_revenue;

    OPEN c_revenue(2017,5);
    LOOP
        FETCH c_revenue INTO r_revenue;
        EXIT    WHEN c_revenue%notfound;
        -- show the revenue
        dbms_output.put_line(r_revenue.revenue);
    END LOOP;
    CLOSE c_revenue;
END;
/

-- Cursor Variables with REF CURSOR
/*
Advantage:
    Instead of creating a Collection to transfer data between two PL/SQL block or with some other Program
    (.NET/Java), we can use REF CURSOR, which can be OPENed in parent block and simply pass the reference
    to the Child block Cursor for processing/FETCHing and CLOSing the Cursor.

Note:
    Once Data is fetched from the SYS_REFCURSOR, it can not be Re-fetched.

Two Types:
    Strong typed: 
        TYPE customer_t IS REF CURSOR RETURN customers%ROWTYPE;
        c_customer customer_t;
    Weak typed:
        TYPE customer_t IS REF CURSOR;
        c_customer customer_t;
        -- Above Two lines can be replaced by below: SYS_REFCURSOR is a predefined weak typed REF CURSOR
        c_customer SYS_REFCURSOR; 
*/
-- Parnet Block
CREATE OR REPLACE FUNCTION get_direct_reports(
      in_manager_id IN employees.manager_id%TYPE)
   RETURN SYS_REFCURSOR
AS
   c_direct_reports SYS_REFCURSOR;
   -- Declare c_direct_reports as Weak Type REF CURSOR
BEGIN
   -- OPEN the Cursor in Parent Block
   OPEN c_direct_reports FOR 
   SELECT 
      employee_id, 
      first_name, 
      last_name, 
      email
   FROM 
      employees 
   WHERE 
      manager_id = in_manager_id 
   ORDER BY 
         first_name,   
         last_name;

   -- Return/Send/Pass the reference to Child Block
   RETURN c_direct_reports;
END;
/

-- Child Block
DECLARE
   c_direct_reports SYS_REFCURSOR;
   l_employee_id employees.employee_id%TYPE;
   l_first_name  employees.first_name%TYPE;
   l_last_name   employees.last_name%TYPE;
   l_email       employees.email%TYPE;
BEGIN
   -- get the ref cursor from function
   c_direct_reports := get_direct_reports(46); 
   
   -- process each employee
   LOOP
      FETCH
         c_direct_reports
      INTO
         l_employee_id,
         l_first_name,
         l_last_name,
         l_email;   
      EXIT
   WHEN c_direct_reports%notfound;
      dbms_output.put_line(l_first_name || ' ' || l_last_name || ' - ' ||    l_email );
   END LOOP;
   -- close the cursor
   CLOSE c_direct_reports;
END;
/

-- Updatable cursor: CURSOR FOR UPDATE (Refer to the Doc)
-- Check the "WHERE CURRENT OF" example from oracleMyLearn_PLSQL_Learning.sql

*****************************************
Stored procedures and Functions
*****************************************










*****************************************


























































