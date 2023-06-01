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
    dbms_output.put_line(to_char(var8,'DD-MON-RRRR HH.MI.SS AM TZD'));
    dbms_output.put_line(var13);
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

-- Note: PL/SQL raises a "CASE_NOT_FOUND" error if you don't specify an ELSE clause 
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
Implicit Cursor Attribute
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
-- Procedure and Functions are otherwise known as named PL/SQL block
-- Procedure
CREATE OR REPLACE PROCEDURE print_contact(
    in_customer_id NUMBER 
)
IS
  r_contact contacts%ROWTYPE;
BEGIN
  -- get contact based on customer id
  SELECT *
  INTO r_contact
  FROM contacts
  WHERE customer_id = in_customer_id;

  -- print out contact's information
  dbms_output.put_line( r_contact.first_name || ' ' ||
  r_contact.last_name || '<' || r_contact.email ||'>' );

EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
END;
/

-- The below syntax will show the list of compilation errors
SHOW ERR;

-- To Execute the Procedure
EXEC PRINT_CONTACT(10);

-- Implicit Statement Results (DBMS_SQL.RETURN_RESULT)
-- This is an alternative to OUT REF_CURSOR (Refer to the Doc) 
CREATE OR REPLACE PROCEDURE get_customer_by_credit(
    min_credit NUMBER
)
AS 
    c_customers SYS_REFCURSOR;
BEGIN
    -- open the cursor
    OPEN c_customers FOR
        SELECT customer_id, credit_limit, name
        FROM customers
        WHERE credit_limit > min_credit
        ORDER BY credit_limit;
    
    -- return the result set
    dbms_sql.return_result(c_customers);
END;
/

EXEC get_customer_by_credit(4000);
/

-- Returning multiple result sets
CREATE OR REPLACE PROCEDURE get_customers(
    page_no NUMBER, 
    page_size NUMBER
)
AS
    c_customers SYS_REFCURSOR;
    c_total_row SYS_REFCURSOR;
BEGIN
    -- return the total of customers
    OPEN c_total_row FOR
        SELECT COUNT(*)
        FROM customers;
    
    dbms_sql.return_result(c_total_row);
    
    -- return the customers 
    OPEN c_customers FOR
        SELECT customer_id, name
        FROM customers
        ORDER BY name
        OFFSET page_size * (page_no - 1) ROWS
        FETCH NEXT page_size ROWS ONLY;
        
    dbms_sql.return_result(c_customers);    
END;
/

EXEC get_customers(1,10);
/

-- Capture the result set in a PL/SQL Block (NEW CONCEPT)
-- Usually in real-world, the result set is utilized by Python/C#/Java
-- The following anonymous block calls the get_customers() procedure 
-- and uses the get_next_resultset() procedure to process the result sets.
SET SERVEROUTPUT ON
DECLARE
    l_sql_cursor    PLS_INTEGER;
    c_cursor        SYS_REFCURSOR;
    l_return        PLS_INTEGER;
    
    l_column_count  PLS_INTEGER;
    l_desc_tab      dbms_sql.desc_tab;
    
    l_total_rows    NUMBER;
    l_customer_id   customers.customer_id%TYPE;
    l_name          customers.NAME%TYPE;
BEGIN
    -- Execute the function.
    l_sql_cursor := dbms_sql.open_cursor(treat_as_client_for_results => TRUE);
    
    dbms_sql.parse(C             => l_sql_cursor,
                    STATEMENT     => 'BEGIN get_customers(1,10); END;',
                    language_flag => dbms_sql.NATIVE);
    
    l_return := dbms_sql.EXECUTE(l_sql_cursor);

    -- Loop over the result sets.
    LOOP
        -- Get the next resultset.
        BEGIN
        dbms_sql.get_next_result(l_sql_cursor, c_cursor);
        EXCEPTION
        WHEN no_data_found THEN
            EXIT;
        END;
    
        -- Get the number of columns in each result set.
        l_return := dbms_sql.to_cursor_number(c_cursor);
        dbms_sql.describe_columns (l_return, l_column_count, l_desc_tab);
        c_cursor := dbms_sql.to_refcursor(l_return);
    
        -- Handle the result set based on the number of columns.
        CASE l_column_count
        WHEN 1 THEN
            dbms_output.put_line('The total number of customers:');
            FETCH c_cursor
            INTO  l_total_rows;
    
            dbms_output.put_line(l_total_rows);
            CLOSE c_cursor;
        WHEN 2 THEN
            dbms_output.put_line('The customer list:');
            LOOP
            FETCH c_cursor
            INTO  l_customer_id, l_name;
    
            EXIT WHEN c_cursor%notfound;
    
            dbms_output.put_line(l_customer_id || ' ' || l_name);
            END LOOP;
            CLOSE c_cursor;
        ELSE
            dbms_output.put_line('An error occurred!');
        END CASE;
    END LOOP;
END;
/

-- Function
-- At least one RETURN statement is mandatory
CREATE OR REPLACE FUNCTION get_total_sales(
    in_year PLS_INTEGER
) 
RETURN NUMBER
IS
    l_total_sales NUMBER := 0;
BEGIN
    -- get total sales
    SELECT SUM(unit_price * quantity)
    INTO l_total_sales
    FROM order_items
    INNER JOIN orders USING (order_id)
    WHERE status = 'Shipped'
    GROUP BY EXTRACT(YEAR FROM order_date)
    HAVING EXTRACT(YEAR FROM order_date) = in_year;
    
    -- return the total sales
    RETURN l_total_sales;
END;
/

SHOW ERR;
/

select get_total_sales(2017) from dual;

*****************************************
Packages
*****************************************
-- Refer to the Docs for more info
-- The "Package Specification" Doc is having different ways to Create a Package

-- Package Specification
-- Way-1 (For env like SQL*PLUS or SQL Devloper)
-- / is required for SQL*PLUS to tell Oracle to compile the whole block
create package test_package as
    gc_status constant varchar(10) := 'Active';
end;
/

-- Way-2 (For env like Git/bash/CMD)
@c:\plsql\sample.sql
/

-- Example
CREATE OR REPLACE PACKAGE order_mgmt
AS
  gc_shipped_status  CONSTANT VARCHAR(10) := 'Shipped';
  gc_pending_status CONSTANT VARCHAR(10) := 'Pending';
  gc_canceled_status CONSTANT VARCHAR(10) := 'Canceled';
  gv_status varchar2(10);

  -- cursor that returns the order detail
  CURSOR g_cur_order(p_order_id NUMBER)
  IS
    SELECT
      customer_id,
      status,
      salesman_id,
      order_date,
      item_id,
      product_name,
      quantity,
      unit_price
    FROM
      order_items
    INNER JOIN orders USING (order_id)
    INNER JOIN products USING (product_id)
    WHERE
      order_id = p_order_id;

  -- get net value of a order
  FUNCTION get_net_value(
      p_order_id NUMBER)
    RETURN NUMBER;

  -- Get net value by customer
  FUNCTION get_net_value_by_customer(
      p_customer_id NUMBER,
      p_year        NUMBER)
    RETURN NUMBER;

END order_mgmt;
/

-- Package State
-- Unique for individual Sessions
-- Test the below block in two diff sessions
-- Session-1
BEGIN
  order_mgmt.gv_status := order_mgmt.gc_shipped_status;
  DBMS_OUTPUT.PUT_LINE(order_mgmt.gv_status);
END;
/

-- Session-2
-- To create new Session, click on the SQL* icon on the "SQL Worksheet" tool bar: Ctrl + Shift + N
BEGIN
  order_mgmt.gv_status := order_mgmt.gc_pending_status;
  DBMS_OUTPUT.PUT_LINE(order_mgmt.gv_status);
END;
/

-- Test
BEGIN
  DBMS_OUTPUT.PUT_LINE(order_mgmt.gv_status);
END;
/

-- Package Body
-- If the package specification has cursors or subprograms, then the package body is mandatory.
CREATE OR REPLACE PACKAGE BODY order_mgmt
AS
  -- Private Items
  gp_private_field VARCHAR2(10);

  -- Implementation
  -- get net value of a order
  FUNCTION get_net_value(
      p_order_id NUMBER)
    RETURN NUMBER
  IS
    ln_net_value NUMBER;
  BEGIN
    SELECT
      SUM(unit_price * quantity)
    INTO
      ln_net_value
    FROM
      order_items
    WHERE
      order_id = p_order_id;

    RETURN p_order_id;

  EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE( SQLERRM );
  END get_net_value;

  -- Get net value by customer
  FUNCTION get_net_value_by_customer(
      p_customer_id NUMBER,
      p_year        NUMBER)
    RETURN NUMBER
  IS
    ln_net_value NUMBER;
  BEGIN
    SELECT
      SUM(quantity * unit_price)
    INTO
      ln_net_value
    FROM
      order_items
    INNER JOIN orders USING (order_id)
    WHERE
      extract(YEAR FROM order_date) = p_year
    AND customer_id                 = p_customer_id
    AND status                      = gc_shipped_status;
    RETURN ln_net_value;
  EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE( SQLERRM );
  END get_net_value_by_customer;

  -- Initialization
  -- Performs one-time setup tasks
  -- The initialization part only runs once at the first time the package is referenced. 
  -- It can also include an exception handler.
  BEGIN
    gp_private_field := 'PRIVATE';
  EXCEPTION
    WHEN OTHERS THEN
        NULL;
END order_mgmt;
/

-- Testing
SELECT
  order_mgmt.get_net_value_by_customer(1,2017) sales
FROM
  dual;

-- Drop Package
-- Package Specification can survive without body, but vice-versa is not true.
-- This means body can be dropped leaving specification still valid.
-- But if you drop the specification, the body gets invalidated.
-- Oracle does not invalidate dependent objects when you drop only the body of a package but not the package specification
DROP PACKAGE BODY order_mgmt;
DROP PACKAGE order_mgmt;

-- Grant on Packages
-- This allows to execute the Package items, as well debug the code (by running the de-bugger)
GRANT EXECUTE, DEBUG ON order_mgmt to HR;

*****************************************
Triggers
*****************************************
-- Trigger Syntax
-- Header
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER | INSTEAD OF} triggering_event ON table_name
[FOR EACH ROW] 
[REFERENCING OLD AS old_name NEW AS new_name]
-- Specifies row-level trigger, otherwise statement-level trigger which fires at least once
[FOLLOWS | PRECEDES another_trigger]
-- Firing sequence of the dependent trigggers
[ENABLE / DISABLE ] 
-- To create a trigger in the disabled state, use DISABLE option, Later you can ENABLE it as required
[WHEN condition] -- OLD, NEW keyword can be used here
-- Body
DECLARE
    declaration statements
BEGIN
    executable statements
    -- :OLD, :NEW keyword can be used here (OLD= old_name, NEW=new_name)
    -- UPDATING, INSERTING, DELETING keyword can be used her
EXCEPTION
    exception_handling statements
END;
/

/*
triggering_event can be of 4 types:
    1) DML: INSERT, UPDATE, or DELETE
    2) DDL: CREATE or ALTER
    3) System event: STARTUP or SHUTDOWN
    4) User event: User login or logout
*/

-- Example
CREATE OR REPLACE TRIGGER customers_audit_trg
    AFTER UPDATE OR DELETE ON customers
    FOR EACH ROW    
DECLARE
   --PRAGMA AUTONOMOUS_TRANSACTION; -- to make changes permanent --But COMMIT is mandatory at the end
   l_transaction VARCHAR2(10);
BEGIN
   -- determine the transaction type
   l_transaction := CASE  
         WHEN UPDATING THEN 'UPDATE'
         WHEN DELETING THEN 'DELETE'
   END;

   -- insert a row into the audit table   
   INSERT INTO audits (table_name, transaction_name, by_user, transaction_date)
   VALUES('CUSTOMERS', l_transaction, USER, SYSDATE);
END;
/

-- Testing
delete from customers where customer_id = 10;
select * from audits;
rollback;
/

update customers set credit_limit = 2000 where customer_id = 10;
select * from audits;
rollback;
/

-- Satement-level Triggers
/*
Used to enforce extra security measures on the kind of transaction that may be performed on a table.
*/
select extract(day from sysdate) day from dual;

CREATE OR REPLACE TRIGGER customers_credit_trg
    BEFORE UPDATE OF credit_limit  
    -- Trigger will only be fired if updates happen to only credit_limit column
    -- Otherwise it will not fire
    ON customers
DECLARE
    l_day_of_month NUMBER;
BEGIN
    -- determine the transaction type
    l_day_of_month := EXTRACT(DAY FROM sysdate);

    IF (l_day_of_month BETWEEN 28 AND 31) OR (l_day_of_month = 19) THEN
        raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
        -- Oracle automatically rollbacks the update because of the raise_application_error
    END IF;
END;
/

-- Testing
select customer_id, credit_limit from customers;
begin
    UPDATE 
        customers 
    SET 
        credit_limit = credit_limit * 110;
    dbms_output.put_line(SQL%ROWCOUNT);
end;
/
-- Check for any pending transactions (This will return 0 rows)
SELECT
    COUNT(*)
FROM
    v$transaction t,
    v$session     s,
    v$mystat      m
WHERE
        t.ses_addr = s.saddr
    AND s.sid = m.sid
    AND ROWNUM = 1;
/

select s.sid
      ,s.serial#
      ,s.username
      ,s.machine
      ,s.status
      ,s.lockwait
      ,t.used_ublk
      ,t.used_urec
      ,t.start_time
from v$transaction t
inner join v$session s 
    on t.addr = s.taddr;
/

-- Row-level Triggers (Refer to the Doc for more details)
/*
Useful for data-related activities such as data auditing and data validation.
It fires for each row.
NEW & OLD value reference is only applicable for row-level trigger.
Inside BEGIN block use :NEW/:OLD keywords.
Inside WHEN block use NEW/OLD keywords.
A BEFORE row-level trigger can modify the NEW column values, but an AFTER row-level trigger cannot.
*/
-- Example
CREATE OR REPLACE TRIGGER customers_update_credit_trg 
    BEFORE UPDATE OF credit_limit
    ON customers
    FOR EACH ROW
    WHEN (NEW.credit_limit > 0) -- This will improve the preformance
BEGIN
    -- check the credit limit
    IF :NEW.credit_limit >= 2 * :OLD.credit_limit THEN
        raise_application_error(-20101,'The new credit ' || :NEW.credit_limit || 
            ' cannot increase to more than double, the current credit ' || :OLD.credit_limit);
    END IF;
END;
/

-- Testing
SELECT credit_limit FROM customers  WHERE customer_id = 10;
UPDATE customers
SET credit_limit = 5000
WHERE customer_id = 10;
/

-- Instead of Trigggers (Refer to teh Doc)
-- An INSTEAD OF trigger is a trigger that allows you to update data in tables 
-- via their view which cannot be modified directly through DML statements.
-- In Oracle, you can create an INSTEAD OF trigger for a view only. 
-- You cannot create an INSTEAD OF trigger for a table.
-- Syntax
CREATE [OR REPLACE] TRIGGER trigger_name
INSTEAD OF {INSERT | UPDATE | DELETE}
ON view_name
FOR EACH ROW
BEGIN
    EXCEPTION
    ...
END;
/

-- Example
CREATE VIEW vw_customers AS
    SELECT 
        name, 
        address, 
        website, 
        credit_limit, 
        first_name, 
        last_name, 
        email, 
        phone
    FROM 
        customers 
        -- non-key-preserved table, as the primary/unique key customer_id is not present in the query
        -- This will not allow to insert data into the customers table via this view
    INNER JOIN contacts USING (customer_id);
/

CREATE OR REPLACE TRIGGER new_customer_trg
    INSTEAD OF INSERT ON vw_customers
    FOR EACH ROW
DECLARE
    l_customer_id NUMBER;
BEGIN
    -- insert a new customer first
    INSERT INTO customers(name, address, website, credit_limit)
    VALUES(:NEW.NAME, :NEW.address, :NEW.website, :NEW.credit_limit)
    RETURNING customer_id INTO l_customer_id;
    
    -- insert the contact
    INSERT INTO contacts(first_name, last_name, email, phone, customer_id)
    VALUES(:NEW.first_name, :NEW.last_name, :NEW.email, :NEW.phone, l_customer_id);
END;
/

-- Testing
/*
Before creating the INSTEAD OF Trigger:
The below insert will throw below error -
ORA-01779: cannot modify a column which maps to a non key-preserved table

After creating the INSTEAD OF Trigger:
new record will be inserted into both customers & contacts table.
*/
INSERT INTO 
    vw_customers(
        name, 
        address, 
        website, 
        credit_limit, 
        first_name, 
        last_name, 
        email, 
        phone
    )
VALUES(
    'Lam Research',
    'Fremont, California, USA', 
    'https://www.lamresearch.com/',
    2000,
    'John',
    'Smith',
    'john.smith@lamresearch.com',
    '+1-510-572-0200'
);
/

select * from customers order by customer_id desc;
select * from contacts  order by customer_id desc;
/

-- Enable/Disable Trigger
ALTER TRIGGER trigger_name DISABLE; -- Disbale a single Trigger
ALTER TABLE table_name DISABLE ALL TRIGGERS; -- Disbale all Triggers on a table

-- Drop Trigger
DROP TRIGGER [schema_name.]trigger_name;
/*
Schema must have: DROP ANY TRIGGER system privilege.
*/
-- Drop trigger IF Exists
CREATE OR REPLACE PROCEDURE drop_trigger_if_exists(
    in_trigger_name VARCHAR2
)
AS
    l_exist PLS_INTEGER;
BEGIN
    -- get the trigger count
    SELECT COUNT(*) INTO l_exist
    FROM user_triggers
    WHERE trigger_name = UPPER(in_trigger_name);
    
    -- if the trigger exist, drop it
    IF l_exist > 0 THEN 
        EXECUTE IMMEDIATE 'DROP TRIGGER ' ||  in_trigger_name;
    END IF;
END;
/

EXEC drop_trigger_if_exists('CUSTOMERS_UPDATE_CREDIT_TRG');
/

-- Mutating Table Error
-- To fix the mutating table error, you can use a compound trigger.
-- Simulating this Error
CREATE OR REPLACE TRIGGER customers_credit_policy_trg 
    AFTER INSERT OR UPDATE 
    ON customers
    FOR EACH ROW 
DECLARE 
    l_max_credit   customers.credit_limit%TYPE; 
BEGIN 
    -- get the lowest non-zero credit 
    SELECT MIN (credit_limit) * 5 
        INTO l_max_credit 
        FROM customers
        WHERE credit_limit > 0;
    
    -- check with the new credit
    IF l_max_credit < :NEW.credit_limit 
    THEN 
        UPDATE customers 
        SET credit_limit = l_max_credit 
        WHERE customer_id = :NEW.customer_id; 
    END IF; 
END;
/

UPDATE customers
SET credit_limit = 12000
WHERE customer_id = 1;
/

-- Error: ORA-04091: table OT.CUSTOMERS is mutating, trigger/function may not see it
-- This is due to inside the row-level trigger it is again trying to select/update the same table 

-- Solution
-- To fix the mutating table error, you can use a compound trigger.
CREATE OR REPLACE TRIGGER customers_credit_policy_trg    
    FOR UPDATE OR INSERT ON customers    
    COMPOUND TRIGGER     
    
    -- Decare Array to Store the Customer Ids and their Credits
    TYPE r_customers_type IS RECORD (    
        customer_id   customers.customer_id%TYPE, 
        credit_limit  customers.credit_limit%TYPE    
    );    

    TYPE t_customers_type IS TABLE OF r_customers_type  
        INDEX BY PLS_INTEGER;    

    t_customer   t_customers_type;    

    AFTER EACH ROW IS    
    BEGIN  
        t_customer (t_customer.COUNT + 1).customer_id :=    
            :NEW.customer_id;    
        t_customer (t_customer.COUNT).credit_limit := :NEW.credit_limit;
    END AFTER EACH ROW;    

    AFTER STATEMENT IS    
        l_max_credit   customers.credit_limit%TYPE;    
    BEGIN      
        SELECT MIN (credit_limit) * 5    
            INTO l_max_credit    
            FROM customers
            WHERE credit_limit > 0;

        FOR indx IN 1 .. t_customer.COUNT    
        LOOP                                      
            IF l_max_credit < t_customer (indx).credit_limit    
            THEN    
                UPDATE customers    
                SET credit_limit = l_max_credit    
                WHERE customer_id = t_customer (indx).customer_id;    
            END IF;    
        END LOOP;    
    END AFTER STATEMENT;    
END; 
/

UPDATE customers
SET credit_limit = 12000
WHERE customer_id = 1;
/
-- Due to the Compound Trigger logic, the mutating table error is now resolved

*****************************************
Collections
*****************************************
/*
Type Category-1:
    1) Associative Arrays/ INDEX-BY TABLEs/ PL/SQL Tables
    2) Nested Tables
    3) VARRAY
Type Category-2:
    1) Sparse - Eelements are not sequential, it may have gaps between elements.
    2) Not Sparse: Never has gaps between the elements.
Type Category-3:
    1) Unbounded - It has a predetermined limits number of elements.
    2) Bounded - Fixed number of elements.
Type Category-4:
    1) Single/One-dimentional - Each row in the collection contain single column.
    2)
Type Category-5:
    1) Homogenous - Each element is of same datatype.
    2) Heterogenous
*/

-- Associative Arrays
/*
Associative arrays are single-dimensional, unbounded, sparse collections of homogeneous elements.
An associative array can be indexed by numbers or characters.
Declaring an associative array is a two-step process. 
    1) First, you declare an associative array type.
    2) Second, you declare an associative array variable of that type.
*/

/*
Difference between Associative arrays/Nested table/Varrays :-
Associative arrays index can be either integer or character, but Nested table and Varrays can only
be integer datatype.
Associative arrays integer indexed collections can be traverse using FIRST & LAST.
Associative arrays integer indexed collections can be traverse using FIRST & NEXT.
Associative arrays are not sequentially indexed, but Nested table & Varrasys are sequentially indexed.
Associative Arrays & Nested table can be either dense or sparse, but Varrays can only be dense.
Nested Tables need initilization, but not Associative Arrays.
*/
-- Example
DECLARE
    -- declare an associative array type
    TYPE t_capital_type 
        IS TABLE OF VARCHAR2(100) 
        INDEX BY VARCHAR2(50);
    -- declare a variable of the t_capital_type
    t_capital t_capital_type;
    -- local variable
    l_country VARCHAR2(50);
BEGIN   
    -- Assign value to array elements
    t_capital('USA')            := 'Washington, D.C.';
    t_capital('United Kingdom') := 'London';
    t_capital('Japan')          := 'Tokyo';
      
    -- Array method call: array_name.method_name(parameters); --> Similar to C#/Java
    if (t_capital.COUNT) > 0 then  
        dbms_output.put_line(t_capital.COUNT || ' items avilable in the collection');
        dbms_output.put_line('--------------------------------'); 
        
        -- To iterate over an Associative array: using FIRST and NEXT combinition
        -- Below will work both for PLS_INTEGER & VARCHAR2
        l_country := t_capital.FIRST;
        WHILE l_country IS NOT NULL LOOP
            dbms_output.put_line('Current Index: ' || l_country);
            dbms_output.put_line('The capital of ' || 
                l_country || 
                ' is ' || 
                t_capital(l_country)); -- Accessing array elements
            dbms_output.put_line('Next Index: ' || t_capital.NEXT(l_country));     
            l_country := t_capital.NEXT(l_country);
            dbms_output.put_line('--------------------------------'); 
        END LOOP;

        -- To iterate over an Associative array: using FIRST and LAST combinition
        -- Below will only work for PLS_INTEGER
        /*
        FOR l_index in t_capital.FIRST .. t_capital.LAST LOOP
          NULL;    
        END LOOP;
        */
    else
        dbms_output.put_line('No items avilable in the collection');
    end if;
END;
/

-- Nested Tables
/*
Nested tables are single-dimensional, unbounded collections of homogeneous elements.
Noted that a nested table is initially dense. However, it can become sparse through the removal of elements.
Declaring and Initializing a nested table:
    1) First, declare the nested table type.
    2) Second, declare the nested table variable based on a nested table type.
    3) Third, initialize a nested table variable: To initialize a nested table, 
        you can use a constructor function. The constructor function has the same name as the type.
        This is similar to constructor instantiate in C#/Java.
When you declare a nested table variable, it is initialized to NULL. Ex: nested_table_variable nested_table_type;
To add an element to a nested table, you first use the EXTEND(n) method.
To iterate through the Nested table use FIRST and LAST methods (returns first and last indexes of elements).
It is possible to create a nested table type located in the database.
    CREATE [OR REPLACE] TYPE element_datatype IS OBJECT (field list...);
    CREATE [OR REPLACE] TYPE nested_table_type IS TABLE OF element_datatype [NOT NULL];
If you want to drop a type, use the following DROP TYPE statement: DROP TYPE type_name [FORCE];
*/

-- Example
DECLARE
    -- declare a cursor that return customer name
    CURSOR c_customer IS 
        SELECT name 
        FROM customers
        ORDER BY name 
        FETCH FIRST 5 ROWS ONLY;
    
    -- declare a nested table type   
    TYPE t_customer_name_type 
        IS TABLE OF customers.name%TYPE;
    
    -- declare and initialize a nested table variable
    t_customer_names t_customer_name_type := t_customer_name_type();
    /*
    This is similar to:
    t_customer_names t_customer_name_type; -- First declare variable
    t_customer_names := t_customer_name_type(); -- Second initialize the variable    
    */  

    v_deleted_element VARCHAR2(10);
BEGIN
    -- Length
    DBMS_OUTPUT.PUT_LINE('Before Length: ' || t_customer_names.COUNT);
    -- populate customer names from a cursor
    FOR r_customer IN c_customer 
    LOOP
        t_customer_names.EXTEND;
        t_customer_names(t_customer_names.LAST) := r_customer.name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('After Length: ' || t_customer_names.COUNT);

    --t_customer_names.DELETE(1); 
    -- deleting element from a postion is allowed from a Nested Table due to sparse in nature
    
    -- display customer names
    -- Interate through the Nested Table elements
    FOR l_index IN t_customer_names.FIRST..t_customer_names.LAST 
    LOOP
        dbms_output.put_line(t_customer_names(l_index));
    END LOOP;
END;
/

-- VARRAY
/*
A VARRAY is single-dimensional collections of elements with the same data type having an upper limit.
A VARRAY always has a fixed number of elements(bounded) and never has gaps between the elements (not sparse).
Note that you can assign a VARRAY to another using the following syntax: varray_name := another_varray_name;
*/

-- Example
DECLARE
    -- define record type
    TYPE r_customer_type IS RECORD(
        customer_name customers.NAME%TYPE,
        credit_limit customers.credit_limit%TYPE
    ); 
    
    -- declare a VARRAY type of the record r_customer_type with the size of two
    TYPE t_customer_type IS VARRAY(2) 
        OF r_customer_type;
    
    --  declare a VARRAY variable of the VARRAY type t_customer_type
    t_customers t_customer_type := t_customer_type();
    t_customers_new t_customer_type := t_customer_type();
BEGIN
    -- Use the EXTEND method to add an instance to t_customers 
    -- and the LAST method to append an element at the end of the VARRAY t_customers
    t_customers.EXTEND;
    t_customers(t_customers.LAST).customer_name := 'ABC Corp';
    t_customers(t_customers.LAST).credit_limit  := 10000;
    
    t_customers.EXTEND;
    t_customers(t_customers.LAST).customer_name := 'XYZ Inc';
    t_customers(t_customers.LAST).credit_limit  := 20000;
    
    -- assigning a VARRAY to another
    t_customers_new := t_customers;
    
    -- use the COUNT method to get the number of elements in the array
    dbms_output.put_line('The number of customers is ' || t_customers.COUNT);
    dbms_output.put_line('The number of customers-new is ' || t_customers_new.COUNT);
END;
/

-- The following example uses a cursor to retrieve five customers 
-- who have the highest credits from the customers table and add data to a VARRAY
DECLARE
    TYPE r_customer_type IS RECORD(
        customer_name customers.name%TYPE,
        credit_limit customers.credit_limit%TYPE
    ); 

    TYPE t_customer_type IS VARRAY(5) 
        OF r_customer_type;
    
    t_customers t_customer_type := t_customer_type();

    CURSOR c_customer IS 
        SELECT NAME, credit_limit 
        FROM customers 
        ORDER BY credit_limit DESC 
        FETCH FIRST 5 ROWS ONLY;
BEGIN
    -- fetch data from a cursor
    FOR r_customer IN c_customer LOOP
        t_customers.EXTEND;
        t_customers(t_customers.LAST).customer_name := r_customer.name;
        t_customers(t_customers.LAST).credit_limit  := r_customer.credit_limit;
    END LOOP;

    --t_customers.DELETE(1); 
    -- deleting element from a postion is illegal for a VARRAY due to dense in nature

    -- show all customers
    FOR l_index IN t_customers .FIRST..t_customers.LAST 
    LOOP
        dbms_output.put_line(
            'The customer ' ||
            t_customers(l_index).customer_name ||
            ' has a credit of ' ||
            t_customers(l_index).credit_limit
        );
    END LOOP;

END;
/

-- Delete elements from a VARRAY
-- To delete all elements of a VARRAY, you use the DELETE method:
varray_name.DELETE;
-- To remove one element from the end of a VARRAY, you use the TRIM method:
varray_name.TRIM;
-- To remove n elements from the end of a VARRAY, you use the TRIM(n) method:
varray_name.TRIM(n)

*****************************************
Dynamic SQL
*****************************************

DECLARE
  v_employee_id NUMBER;
  v_employee_name VARCHAR2(100);
  v_department_id NUMBER := 100;
BEGIN
  -- Dynamic SQL statement
  EXECUTE IMMEDIATE 'SELECT employee_id, employee_name FROM employees WHERE department_id = :dept_id'
    INTO v_employee_id, v_employee_name
    USING v_department_id;
  
  -- Output the retrieved values
  DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id);
  DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);
END;
/

*****************************************
Misc
*****************************************

*****************************************


























































