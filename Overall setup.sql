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