USE [Streaming services library]
GO


--We got the four non-related tables, we need to make sense of the information.
--Tables overview
GO

/*We are defining the key columns for each of the tables. No null nor duplicated values.
How many rows on Netflix?*/
SELECT * FROM netflix_titles
GO

--Select rows with null values
SELECT * FROM netflix_titles WHERE netflix_titles.show_id IS NULL
GO

--Count rows with NOT null values
SELECT COUNT(*) FROM netflix_titles WHERE netflix_titles.show_id IS NOT NULL
GO

--Count rows with null values
SELECT COUNT(*) FROM netflix_titles WHERE netflix_titles.show_id IS NULL
GO

--Modify data type in show_id column to set as Primary Key. In several tables.
Alter table [dbo].[amazon_prime_titles] alter column [show_id] varchar(50) not null
Alter table [dbo].[disney_plus_titles] alter column [show_id] varchar(50) not null
Alter table [dbo].[hulu_titles] alter column [show_id] varchar(50) not null
Alter table [dbo].[netflix_titles] alter column [show_id] varchar(50) not null
GO


--PRIMARY KEY -- Changed show_id column from 'text' type to 'varchar'. Now the following script works.
Alter table [dbo].[netflix_titles]
ADD Primary Key ([show_id])
GO

--PRIMARY KEY - AMAZON PRIME
Alter table [dbo].[amazon_prime_titles]
ADD Primary Key ([show_id])
GO

--PRIMARY KEY - DISNEY PLUS
Alter table [dbo].[disney_plus_titles]
ADD Primary Key ([show_id])
GO

--PRIMARY KEY - HULU
Alter table [dbo].[hulu_titles]
ADD Primary Key ([show_id])
GO


--DO WE HAVE ANY REPEATED TITLES IN BETWEEN PLATFORMS?

SELECT DISTINCT(dbo.netflix_titles.title) FROM dbo.netflix_titles WHERE dbo.netflix_titles.title
IN (SELECT DISTINCT(dbo.amazon_prime_titles.title) FROM dbo.amazon_prime_titles)
-- YES, WE DO HAVE REPEATED TITLES IN THE PLATFORMS
GO



--I WANT TO MAKE AN INDEX OF THE DIFFERENT TITLES AND THE PLATFORMS WHERE THEY ARE PRESENT 
--We create the new table to insert the info into
CREATE TABLE AllTitles(
	title VARCHAR(50))
GO

--COUNT RECORDS IN COMBINED TABLES
WITH TitlesDummy AS (
	SELECT DISTINCT(dbo.netflix_titles.title) FROM dbo.netflix_titles 
	UNION
	SELECT DISTINCT(dbo.amazon_prime_titles.title) FROM dbo.amazon_prime_titles
	UNION
	SELECT DISTINCT(dbo.disney_plus_titles.title) FROM dbo.disney_plus_titles
	UNION
	SELECT DISTINCT(dbo.hulu_titles.title) FROM dbo.hulu_titles
	)
SELECT COUNT(*) FROM TitlesDummy -- 22,036
GO


--SAME AMOUNT OF RECORDS IF WE USE DISTINCT? JUST TO MAKE SURE WE HAVE NO REPEATED RECORDS
WITH TitlesDummy AS (
	SELECT DISTINCT(dbo.netflix_titles.title) FROM dbo.netflix_titles 
	UNION
	SELECT DISTINCT(dbo.amazon_prime_titles.title) FROM dbo.amazon_prime_titles
	UNION
	SELECT DISTINCT(dbo.disney_plus_titles.title) FROM dbo.disney_plus_titles
	UNION
	SELECT DISTINCT(dbo.hulu_titles.title) FROM dbo.hulu_titles
	)
SELECT COUNT(DISTINCT(TitlesDummy.title)) FROM TitlesDummy -- 
GO


--CLEAN TITLES TABLE
TRUNCATE TABLE dbo.AllTitles
GO


--INSERT COMBINED TITLE TABLES INTO 'TITLES'
WITH TitlesDummy AS (
	SELECT DISTINCT(dbo.netflix_titles.title) FROM dbo.netflix_titles 
	UNION
	SELECT DISTINCT(dbo.amazon_prime_titles.title) FROM dbo.amazon_prime_titles
	UNION
	SELECT DISTINCT(dbo.disney_plus_titles.title) FROM dbo.disney_plus_titles
	UNION
	SELECT DISTINCT(dbo.hulu_titles.title) FROM dbo.hulu_titles
	)
INSERT INTO AllTitles
--USING THE TOP FUNCTION ACTUALLY KEEPS THE TABLE ORDERED AND MAINTAINS IT ORDERED IN THE NEW TABLE
SELECT TOP(500000) * FROM TitlesDummy ORDER BY title
GO


SELECT * FROM AllTitles
GO



