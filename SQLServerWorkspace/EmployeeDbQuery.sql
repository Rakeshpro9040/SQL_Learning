/****** TOP 1000  ******/
SELECT TOP (1000) [EmployeeID]
    ,[FullName]
    ,[EMPCode]
    ,[Mobile]
    ,[Position]
FROM [EmployeeDB].[dbo].[Employee];

/****** Select all  ******/
SELECT *
FROM [EmployeeDB].[dbo].[Employee];

USE EmployeeDB
GO
SELECT * FROM tblEmployee
GO