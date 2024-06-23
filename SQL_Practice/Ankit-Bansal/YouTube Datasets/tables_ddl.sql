-- To Convert SQL Server DML to SNowflake DML
-- Create Snowflake Table with postfix _complex
-- Mark all INSERT INTO except teh 1st one and removed bookmarked
-- Replace all ); with ),
-- Replace last , with ;
-- Replace all N' with '
-- Fix TableName and ColName


CREATE OR REPLACE TABLE orders_complex (
    Row_ID FLOAT,
    Order_ID STRING,
    Order_Date TIMESTAMP,
    Ship_Date TIMESTAMP,
    Ship_Mode STRING,
    Customer_ID STRING,
    Customer_Name STRING,
    Segment STRING,
    Country_Region STRING,
    City STRING,
    State STRING,
    Postal_Code FLOAT,
    Region STRING,
    Product_ID STRING,
    Category STRING,
    Sub_Category STRING,
    Product_Name STRING,
    Sales FLOAT,
    Quantity FLOAT,
    Discount FLOAT,
    Profit FLOAT
);

@orders_202406231449.sql

select * from orders_complex;
select count(*) from orders_complex;

CREATE OR REPLACE TABLE returns_complex (
	Returned nvarchar(255),
	Order_ID nvarchar(255)
);

@returns_202406231510.sql

select * from returns_complex;
select count(*) from returns_complex;


CREATE OR REPLACE TABLE Person_complex (
	PersonID int,
	Name nvarchar(255),
	Email nvarchar(255),
	Score float
);

INSERT INTO Person_complex (PersonID,Name,Email,Score) VALUES
	 (1,'Alice','alice2018@hotmail.com',88.0),
	 (2,'Bob','bob2018@hotmail.com',11.0),
	 (3,'Davis','davis2018@hotmail.com',27.0),
	 (4,'Tara','tara2018@hotmail.com',45.0),
	 (5,'Joh','john2018@hotmail.com',63.0);

select * from Person_complex;
select count(*) from Person_complex;

CREATE or Replace TABLE Friend_complex (
	PersonID int,
	FriendID int
);

INSERT INTO Friend_complex (PersonID,FriendID) VALUES
	 (1,2),
	 (1,3),
	 (2,1),
	 (2,3),
	 (3,5),
	 (4,2),
	 (4,3),
	 (4,5);

select * from Friend_complex;
select count(*) from Friend_complex;

CREATE or Replace TABLE happiness_index_complex (
	Rank1 float,
	Country nvarchar(255),
	Happiness_2021 float,
	Happiness_2020 float,
	Population_2022 float
);

select * from happiness_index_complex;
select count(*) from happiness_index_complex;

CREATE or replace TABLE sachin_batting_scores_complex (
	Match1 float NULL,
	Innings float NULL,
	match_date datetime NULL,
	Versus nvarchar(255) NULL,
	Ground nvarchar(255) NULL,
	How_Dismissed nvarchar(255) NULL,
	Runs float NULL,
	Balls_faced float NULL,
	strike_rate float NULL
);

select * from sachin_batting_scores_complex;
select count(*) from sachin_batting_scores_complex;



