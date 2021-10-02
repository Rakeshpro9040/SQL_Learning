/******  DDL Commands  ******/
--Create Databse
CREATE DATABASE Students;

-- Use Database
USE Students;

--Create table
CREATE TABLE StudentsInfo
(
StudentID int,
StudentName varchar(8000),
ParentName varchar(8000),
PhoneNumber int,
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
PhoneNumber int ,
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
PhoneNumber int ,
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
PhoneNumber int ,
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
PhoneNumber int ,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
);
--NOT NULL on ALTER TABLE
ALTER TABLE StudentsInfo ALTER COLUMN PhoneNumber int NOT NULL;
DROP TABLE StudentsInfo;

--CHECK
--CHECK Constraint on CREATE TABLE
--CHECK Constraint on single column
CREATE TABLE StudentsInfo
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber int ,
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
PhoneNumber int ,
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
PhoneNumber int ,
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

--Query on the table
SELECT * FROM StudentsInfo;
SELECT * FROM Students.dbo.StudentsInfo;

/******  DML Commands  ******/