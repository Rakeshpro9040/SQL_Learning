/*
can you ask me few secnario based Oracle SQL query question, but ask one by one
yes shoot the next one
i am ready for or another scenario-based question, but not so easy ones now
how you would answer if someone asks that qn to you
you just copied my answer
*/

/*
Scenario: You have a table called "Employees" with the following columns: "EmployeeID" (numeric), "FirstName" (text), "LastName" (text), and "Salary" (numeric). 
You want to retrieve the employee with the highest salary.
Question: How would you write a query to fetch the employee with the highest salary from the "Employees" table?
*/
select *
from
(
select e.*,
	dense_rank() over(partition by salary desc) as rnk
from Employees e
)
where rnk = 1;

/*
Scenario: You have two tables: "Orders" and "Customers". The "Orders" table contains columns: "OrderID" (numeric), "CustomerID" (numeric), and "OrderDate" (date). 
The "Customers" table contains columns: "CustomerID" (numeric) and "CustomerName" (text). 
You want to retrieve the names of customers who have placed orders on or after a specific date, along with the count of their orders.
Question: How would you write a query to fetch the customer names and the count of orders placed by them on or after a specific date?
*/
select c.CustomerName,
	count(o.OrderID)
from Orders o
join Customers c
on o.CustomerID = c.CustomerID
where o.OrderDate >= trunc(&enter_date)
group by c.CustomerName;

/*
Scenario: You have a table called "Products" with the following columns: "ProductID" (numeric), "ProductName" (text), "Category" (text), and "Price" (numeric). 
You want to retrieve the average price of products in each category, along with the highest and lowest prices within each category.
Question: How would you write a query to fetch the category, average price, highest price, and lowest price for each category from the "Products" table?
*/

select Category, avg(Price), max(Price), min(Price)
from Products
group by Category;

/*
Scenario: You have three tables: "Customers", "Orders", and "OrderDetails". 
The "Customers" table contains columns: "CustomerID" (numeric), "CustomerName" (text), and "City" (text). 
The "Orders" table contains columns: "OrderID" (numeric), "CustomerID" (numeric), and "OrderDate" (date). 
The "OrderDetails" table contains columns: "OrderID" (numeric), "ProductID" (numeric), and "Quantity" (numeric). 
You want to retrieve the top 3 customers who have placed the highest total quantity of orders, along with the total quantity of orders for each customer.

Question: How would you write a query to fetch the top 3 customers with the highest total quantity of orders from the given tables?
*/

select CustomerName, qty_tot
from
(
select CustomerName,
	qty_tot,
	dense_rank() over(partition by qty_tot desc) as rnk
from
(
select c.CustomerName,
	sum(Quantity) qty_tot,
	count(OrderID) ord_tot
from Customers c
join Orders o
on c.CustomerID = o.CustomerID
join OrderDetails od
on o.OrderID = od.OrderID
group by c.CustomerName
)
)
where rnk <= 3
order by rnk;

SELECT CustomerName, TotalQuantity
FROM (
    SELECT c.CustomerName, SUM(od.Quantity) AS TotalQuantity,
        RANK() OVER (ORDER BY SUM(od.Quantity) DESC) AS Rank
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerName
)
WHERE Rank <= 3;

/*
Scenario: You have three tables: "Customers", "Orders", and "Payments". 
The "Customers" table contains columns: "CustomerID" (numeric), "CustomerName" (text), and "City" (text). 
The "Orders" table contains columns: "OrderID" (numeric), "CustomerID" (numeric), "OrderDate" (date), and "OrderTotal" (numeric). 
The "Payments" table contains columns: "PaymentID" (numeric), "OrderID" (numeric), and "PaymentAmount" (numeric). 
You want to retrieve the customer name, order date, order total, and the remaining order amount 
(order total minus the sum of payment amounts) for all orders that have not been fully paid.

Question: How would you write a query to fetch the customer name, order date, order total, 
and the remaining order amount for all orders that have not been fully paid?
*/

SELECT c.CustomerName, o.OrderDate, o.OrderTotal, 
o.OrderTotal - COALESCE(SUM(p.PaymentAmount), 0) AS remaining_order_amount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Payments p ON o.OrderID = p.OrderID
GROUP BY c.CustomerName, o.OrderDate, o.OrderTotal
HAVING o.OrderTotal - COALESCE(SUM(p.PaymentAmount), 0) > 0;



























