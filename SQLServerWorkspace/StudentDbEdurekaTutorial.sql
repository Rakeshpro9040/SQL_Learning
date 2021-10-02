/******  DDL Commands  ******/
--Create Databse
CREATE DATABASE Students;

-- Use Database
USE Students;
Use tempdb;

--Create table
CREATE TABLE StudentsInfo
(
StudentID int,
StudentName varchar(8000),
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000),
City varchar(8000),
Country varchar(8000)
);

--Drop table
DROP TABLE StudentsInfo;

--Drop Databse
Use tempdb; --tempdb is used to temporarily swtich db
DROP DATABASE Students;

--ALTER
--ADD Column
ALTER TABLE StudentsInfo ADD BloodGroup varchar(8000);

--DROP Column
ALTER TABLE StudentsInfo DROP COLUMN BloodGroup;

--Change the data type of a column
ALTER TABLE StudentsInfo ADD DOB date;
ALTER TABLE StudentsInfo ALTER COLUMN DOB datetime;
ALTER TABLE StudentsInfo DROP COLUMN DOB;

--TRUNCATE
TRUNCATE TABLE StudentsInfo;

--RENAME
--This statement is used to rename one or more tables/ databases
EXEC sp_rename 'StudentsInfo', 'Infostudents';
DROP TABLE Infostudents;

/******  Keys  ******/
--PRIMARY KEY
CREATE TABLE StudentsInfo
(
StudentID int,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000),
PRIMARY KEY (StudentID)
);
DROP TABLE StudentsInfo;

--UNIQUE
--UNIQUE on Single Column
CREATE TABLE StudentsInfo
(
StudentID int UNIQUE,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000),
);
DROP TABLE StudentsInfo;

--UNIQUE on Multiple Columns
CREATE TABLE StudentsInfo
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000),
CONSTRAINT UC_Student_Info UNIQUE(StudentID, PhoneNumber)
);
DROP TABLE StudentsInfo;

--UNIQUE on ALTER TABLE
--Default Constraint Name
ALTER TABLE StudentsInfo ADD UNIQUE (StudentID);
--Explicit Constraint Name
ALTER TABLE StudentsInfo ADD CONSTRAINT UC_Student_Info UNIQUE (StudentID, PhoneNumber);

--To drop a UNIQUE constraint
ALTER TABLE StudentsInfo DROP CONSTRAINT UC_Student_Info;

/******  Constraints  ******/
--NOT NULL
CREATE TABLE StudentsInfo
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
);
--NOT NULL on ALTER TABLE
ALTER TABLE StudentsInfo ALTER COLUMN PhoneNumber bigint NOT NULL;
DROP TABLE StudentsInfo;

--CHECK
--CHECK Constraint on CREATE TABLE
--CHECK Constraint on single column
CREATE TABLE StudentsInfo
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000) CHECK (Country ='India')
);
DROP TABLE StudentsInfo;

--CHECK Constraint on multiple columns
CREATE TABLE StudentsInfo
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000),
CONSTRAINT Check_Constraint CHECK (Country ='India' AND City = 'Hyderabad')
);
DROP TABLE StudentsInfo;
  
--CHECK Constraint on ALTER TABLE
ALTER TABLE StudentsInfo ADD CHECK (Country ='India');
  
--To give a name to the CHECK Constraint
ALTER TABLE StudentsInfo ADD CONSTRAINT CheckConstraintName CHECK (Country ='India');
  
--To drop a CHECK Constraint
ALTER TABLE StudentsInfo DROP CONSTRAINT CheckConstraintName;

--DEFAULT
--DEFAULT Constraint on CREATE TABLE
CREATE TABLE StudentsInfo
(
StudentID int,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000) DEFAULT 'India'
);
DROP TABLE StudentsInfo;
  
--DEFAULT Constraint on ALTER TABLE
ALTER TABLE StudentsInfo ADD CONSTRAINT default_Country DEFAULT 'India' FOR Country;
  
--To drop the Default Constraint
ALTER TABLE StudentsInfo DROP CONSTRAINT default_Country;

/******  Indexes  ******/
CREATE INDEX idex_StudentName ON StudentsInfo (StudentName);
  
--To delete an index in a table
DROP INDEX StudentsInfo.idex_StudentName;

/******  DML Commands  ******/
--INSERT INTO
INSERT INTO StudentsInfo(StudentID, StudentName, ParentName, PhoneNumber, AddressofStudent, City, Country)
VALUES ('01', 'Rakesh', 'Kapoor', '9977331199', 'Buffalo Street House No 10', 'Kolkata', 'India');
  
INSERT INTO StudentsInfo
VALUES ('02', 'Ramesh', 'Mishra', '9876509712', 'Nice Road 15', 'Pune', 'India');

INSERT INTO StudentsInfo
VALUES ('03', 'John', 'Khan', '9876509712', 'Nice Road 15', 'Banglore', 'India');

INSERT INTO StudentsInfo
VALUES ('04', 'Jack', 'Sahu', '9876509712', 'Nice Road 15', 'Kolkata', 'India');

INSERT INTO StudentsInfo(StudentID, StudentName, ParentName, PhoneNumber, AddressofStudent, City, Country)
VALUES ('06', 'Sanjana', 'Kapoor', '9977331199', 'Buffalo Street House No 10', 'Kolkata', 'India');
  
INSERT INTO StudentsInfo
VALUES ('07', 'Vishal', 'Mishra', '9876509712', 'Nice Road 15', 'Pune', 'India');

BEGIN TRANSACTION
INSERT INTO Students.dbo.StudentsInfo
VALUES ('11', 'Vishal','Mishra', '9876509712', 'Nice Road 15', 'Pune', 'India');
COMMIT TRANSACTION;

--UPDATE
UPDATE StudentsInfo
SET StudentName = 'Aahana', City= 'Ahmedabad'
WHERE StudentID = 11;

--DELETE
DELETE FROM Students.dbo.StudentsInfo
WHERE StudentsInfo.StudentID = 11;

--MERGE
--Merge Columns/Tuples between two tables
CREATE TABLE SampleSourceTable (StudentID int, StudentName varchar(8000), Marks int);
CREATE TABLE SampleTargetTable (StudentID int, StudentName varchar(8000), Marks int);

INSERt INTO SampleSourceTable VALUES ('1', 'Vihaan', '87');
INSERt INTO SampleSourceTable VALUES ('2', 'Manasa', '92');
INSERt INTO SampleSourceTable VALUES ('3', 'Anay', '74');
INSERt INTO SampleSourceTable VALUES ('4', 'Rakesh', '77');

INSERt INTO SampleTargetTable VALUES ('1', 'Vihaan', '87');
INSERt INTO SampleTargetTable VALUES ('2', 'Manasa', '67');
INSERt INTO SampleTargetTable VALUES ('3', 'Saurabh', '55');
INSERt INTO SampleTargetTable VALUES ('5', 'Ramesh', '95');

DELETE FROM SampleSourceTable;
DELETE FROM SampleTargetTable;

SELECT * FROM SampleSourceTable;
SELECT * FROM SampleTargetTable;

MERGE SampleTargetTable AS TARGET USING SampleSourceTable AS SOURCE 
    ON (TARGET.StudentID = SOURCE.StudentID)                                                                                       
WHEN MATCHED AND TARGET.StudentName <> SOURCE.StudentName OR TARGET.Marks <> SOURCE.Marks 
    THEN UPDATE SET TARGET.StudentName = SOURCE.StudentName, TARGET.Marks = SOURCE.Marks         
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (StudentID,StudentName,Marks) VALUES (SOURCE.StudentID,SOURCE.StudentName,SOURCE.Marks)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

--SELECT
--Query on the table
SELECT * FROM StudentsInfo;
SELECT * FROM Students.dbo.StudentsInfo;

--Select TOP 2
SELECT TOP 2 * FROM StudentsInfo;

--Select Distinct values
SELECT DISTINCT City FROM Students.dbo.StudentsInfo;

--Order by
SELECT * FROM Students.dbo.StudentsInfo SI
ORDER BY SI.StudentID DESC;

SELECT * FROM Students.dbo.StudentsInfo SI
ORDER BY SI.StudentName, SI.ParentName DESC;

--OFFSET
--Out of line
SELECT * FROM Students.dbo.StudentsInfo SI
ORDER BY SI.StudentID DESC
OFFSET 1 ROWS;

--FETCH
SELECT * FROM Students.dbo.StudentsInfo SI
ORDER BY SI.StudentID DESC
OFFSET 1 ROWS
FETCH NEXT 2 ROWS ONLY;

--PIVOT - Aggregate
CREATE TABLE SupplierTable
(
SupplierID int NOT NULL,
DaysofManufacture int,
Cost int,
CustomerID int,
PurchaseID varchar(4000)
);

INSERT INTO SupplierTable VALUES ('1', '12', '1230', '11', 'P1'); 
INSERT INTO SupplierTable VALUES ('2', '21', '1543', '22', 'P2');
INSERT INTO SupplierTable VALUES ('3', '32', '2345', '11', 'P3');
INSERT INTO SupplierTable VALUES ('4', '14', '8765', '22', 'P1');
INSERT INTO SupplierTable VALUES ('5', '42', '3452', '33', 'P3');
INSERT INTO SupplierTable VALUES ('6', '31', '5431', '33', 'P1');
INSERT INTO SupplierTable VALUES ('7', '41', '2342', '11', 'P2');
INSERT INTO SupplierTable VALUES ('8', '54', '3654', '22', 'P2');
INSERT INTO SupplierTable VALUES ('9', '33', '1234', '11', 'P3');
INSERT INTO SupplierTable VALUES ('10','36', '6832', '33', 'P2');
INSERT INTO SupplierTable VALUES ('11', '12', '1230', '11', 'P1');

SELECT * FROM SupplierTable;

SELECT ST.CustomerID, AVG(ST.Cost) AS AverageCostOfCustomer
FROM SupplierTable ST
GROUP BY ST.CustomerID; 

SELECT *
FROM
(
    SELECT 'AverageCostOfCustomer' AS Cost_According_To_Customer, ST.CustomerID,ST.Cost
    FROM SupplierTable ST
) AS SourceTable
PIVOT
(
    AVG(COST) FOR CustomerID IN ([11], [22], [33])
) as PivotTable; 

--UNPIVOT - UnAggregate
CREATE TABLE SampleTable (SupplierID int, Supp1 int, Supp2 int, Supp3 int)
GO
INSERT INTO SampleTable VALUES (1, 10, 11, 12);
INSERT INTO SampleTable VALUES (2, 13, 14, 15);
INSERT INTO SampleTable VALUES (3, 16, 17, 18);
GO
SELECT * FROM SampleTable;

SELECT *
FROM
(
    SELECT ST.SupplierID, ST.Supp1, ST.Supp2, ST.Supp3 
    FROM SampleTable ST
) AS SourceTable
UNPIVOT
(
    Products FOR Customers IN (Supp1, Supp2, Supp3)
) as UnPivotTable
ORDER BY 1, 2;

--Aggregate
--Group by
SELECT SI.City, COUNT(SI.StudentID) StudentCount
FROM Students.dbo.StudentsInfo SI
GROUP BY SI.City
ORDER BY 1 DESC;

--Grouping Set
SELECT SI.City, SI.Country, COUNT(SI.StudentID) StudentCount
FROM Students.dbo.StudentsInfo SI
GROUP BY GROUPING SETS ((SI.City), (SI.City, SI.Country));

--Having clause
SELECT SI.City, COUNT(SI.StudentID) StudentCount
FROM Students.dbo.StudentsInfo SI
GROUP BY SI.City
HAVING COUNT(SI.StudentID) = 1
ORDER BY 1 DESC;

--Create a backup table
SELECT * INTO StudentsBackup FROM StudentsInfo;
SELECT * FROM StudentsBackup;

SELECT * INTO BangloreStudents FROM StudentsInfo
WHERE City = 'Banglore';
SELECT * FROM BangloreStudents;

--CUBE
SELECT SI.City, COUNT(SI.StudentID) StudentCount
FROM Students.dbo.StudentsInfo SI
GROUP BY CUBE(SI.City);

--ROLLUP
SELECT SI.City, COUNT(SI.StudentID) StudentCount
FROM Students.dbo.StudentsInfo SI
GROUP BY ROLLUP(SI.City);

/******  Operators  ******/
SELECT 40 + 80.5673 AS Dummy;

DECLARE @var1 INT = 32
	,@var2 INT = 30
	,@var3 INT

SET @var1 /= 16
SET @var2 = @var2 % 16

SELECT @var1 AS Quotient
	,@var2 AS Reminder
GO

--Between And
SELECT * 
FROM Students.dbo.StudentsInfo ST
WHERE ST.StudentID BETWEEN 3 AND 6
ORDER BY 1;

--LIKE
--Start with J
SELECT * 
FROM Students.dbo.StudentsInfo ST
WHERE ST.StudentName LIKE 'J%';

--Start With J and ends with k, with nay numbers of letters presnet in bet
SELECT * 
FROM Students.dbo.StudentsInfo ST
WHERE ST.StudentName LIKE 'J%k';

--Starts with R and ends with h, with 4 letters presnet in between
SELECT * 
FROM Students.dbo.StudentsInfo ST
WHERE ST.StudentName LIKE 'R____h';

--Scope Resultion Operator
DECLARE @hid hierarchyid;    
SET @hid = hierarchyid::GetRoot();    
--SELECT @hid.ToString() as _Root; 
PRINT @hid.ToString();

--String Concatenate
SELECT (StudentName + ', ' + Parentname) AS Name
FROM Students.dbo.StudentsInfo;

--SET Operator
--1st Table
create table Employee1(    
   EmpId int,    
   First_Name varchar(20),    
);   
--2nd Table    
create table Employee2(    
   EmpId int,    
   First_Name varchar(20),    
);

--Values for table 1    
insert into Employee1 values    
(1,'Sourabh'),    
(2,'Shaili'),    
(3,'Swati'),    
(4,'Divya');    
    
--Values for table2    
insert into Employee2 values    
(1,'Sourabh'),    
(2,'Shaili'),    
(3,'Bittu');   

SELECT * FROM Employee1;
SELECT * FROM Employee2;

--UNION
SELECT * FROM Employee1
UNION
SELECT * FROM Employee2;

--INTERSECT
SELECT * FROM Employee1
INTERSECT
SELECT * FROM Employee2;

--EXCEPT
SELECT * FROM Employee1
EXCEPT
SELECT * FROM Employee2;

SELECT * FROM Employee2
EXCEPT
SELECT * FROM Employee1;


/******  Sub/Nested Query  ******/
SELECT st.StudentName
	,st.ParentName
FROM Students.dbo.StudentsInfo ST
WHERE st.StudentID IN (
		SELECT SB.StudentID
		FROM StudentsBackup SB
		);

--EXISTS
SELECT st.StudentName
	,st.ParentName
FROM Students.dbo.StudentsInfo ST
WHERE EXISTS (SELECT NULL
		    FROM StudentsBackup SB
            WHERE ST.StudentID = SB.StudentID);

/******  Joins  ******/
CREATE TABLE Subjects
(
SubjectID int,
StudentID int,
SubjectName varchar(8000),
);

INSERT INTO Subjects VALUES ('10', '10', 'Maths');
INSERT INTO Subjects VALUES ('2', '11', 'Physics');
INSERT INTO Subjects VALUES ('3', '12', 'Chemistry');

SELECT * FROM Subjects;
SELECT * FROm Students.dbo.StudentsInfo ST;

--INNER
SELECT S.StudentID, ST.StudentName, S.SubjectName 
FROM Subjects S
INNER JOIN
Students.dbo.StudentsInfo ST
ON S.StudentID = ST.StudentID;

--LEFT
SELECT S.StudentID, ST.StudentName, S.SubjectName 
FROM Subjects S
LEFT JOIN
Students.dbo.StudentsInfo ST
ON S.StudentID = ST.StudentID;

--RIGHT
SELECT S.StudentID, ST.StudentName, S.SubjectName 
FROM Subjects S
RIGHT JOIN
Students.dbo.StudentsInfo ST
ON S.StudentID = ST.StudentID;

--FULL
SELECT S.StudentID, ST.StudentID, ST.StudentName, S.SubjectName 
FROM Subjects S
FULL JOIN
Students.dbo.StudentsInfo ST
ON S.StudentID = ST.StudentID
ORDER BY 1;

SELECT S.StudentID, ST.StudentID, ST.StudentName, S.SubjectName 
FROM Students.dbo.StudentsInfo ST
FULL JOIN
Subjects S
ON S.StudentID = ST.StudentID
ORDER BY 1;

/******  Stored Procedure  ******/
USE Students
GO
CREATE OR ALTER PROCEDURE 
    dbo.STudent_City 
    @SCity varchar(8000)
AS
BEGIN
    SELECT * 
    FROM StudentsInfo SI
    WHERE SI.City = @SCity;
END;
GO

EXEC [dbo].[STudent_City] @SCity = 'Banglore';
GO

/******  DCL Commands  ******/
--Grant or Revoke access from User
--Create Login and User
--1st Create a login for the user
CREATE LOGIN SAMPLE1 WITH PASSWORD = 'rakesh';
--2nd Create the user
CREATE USER RAKESH FOR LOGIN SAMPLE1;
--3rd Grant/Revoke Previliges
GRANT SELECT ON StudentsInfo TO RAKESH;
REVOKE SELECT ON StudentsInfo TO RAKESH;

--Drop Login
DROP LOGIN SAMPLE1;

--Error: Could not drop login 'SAMPLE1' as the user is currently logged in.
--Kill all active sessions
SELECT session_id
FROM sys.dm_exec_sessions
WHERE login_name = 'SAMPLE1';

KILL 71;

--Drop User
DROP USER RAKESH;

/******  TCL Commands  ******/
CREATE TABLE TCLSample 
(
StudentID int,
StudentName varchar(8000),
Marks int
);

INSERT INTO [dbo].[TCLSample]
           ([StudentID]
           ,[StudentName]
           ,[Marks])
     VALUES
           (1, 'Rohit', 23),
           (2, 'Suhana', 48),
           (3, 'Ashish', 65),
           (4, 'Prerna', 32);

SELECT * FROM TCLSample;

--Start Transaction
USE Students
GO
BEGIN TRY
	BEGIN TRANSACTION

	INSERT INTO TCLSample
	VALUES (5, 'Avinash', 56);

	UPDATE TCLSample
	SET StudentName = 'Akash'
	WHERE StudentID = 5;

	UPDATE TCLSample
	SET Marks = '67x'
	WHERE StudentID = 5;

	COMMIT TRANSACTION

	PRINT 'Transaction Completed'
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION

	PRINT 'Transaction Unsuccessful and rolledback'
END CATCH
GO
SELECT * FROM TCLSample
GO

/******  Exception Handling ******/
THROW 51000, 'Record does not exist.', 1
GO
--Error Code range: 50000 to 2147483647

/*
Below block will throw an Excpetion
due to we can't concatenate int and String directly without CAST
*/
DECLARE @ErrorMessage VARCHAR(2000)
	,@ErrorSeverity TINYINT
	,@ErrorState TINYINT

BEGIN TRY
	--SELECT CAST(PhoneNumber AS varchar)+ ' : ' + StudentName
	--FROM StudentsInfo;
	SELECT PhoneNumber + ' : ' + StudentName
	FROM StudentsInfo;
END TRY

BEGIN CATCH
	--PRINT 'Not possible'
	SET @ErrorMessage = ERROR_MESSAGE()
	SET @ErrorSeverity = ERROR_SEVERITY()
	SET @ErrorState = ERROR_STATE()
    /*
    PRINT @ErrorMessage
    PRINT @ErrorSeverity
    PRINT @ErrorState
    */

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

	RETURN
END CATCH
GO