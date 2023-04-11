-- Lesson#6 Date/String/Number Functions
-- https://www.w3schools.com/sql/sql_ref_mysql.asp

-- text/string functions
select customerNumber, addressLine1,
ASCII(addressLine1),-- Returns the number code that represents the specific character	
CHAR(addressLine1), -- Returns the ASCII character based on the number code
CONCAT(contactFirstName,' ', contactLastName),-- Concatenates two or more strings together
SUBSTRING(addressLine1,6,1), -- Extracts a substring from a string
LEFT(addressLine1,8), RIGHT(addressLine1,8),-- Extracts a substring from a string (starting from left)	
LTRIM(addressLine1), RTRIM(addressLine1), TRIM(addressLine1), -- Removes leading spaces from a string
LENGTH(addressLine1), -- Returns the length of the specified string
LOWER(contactLastName),UPPER(contactLastName)-- Converts a string to lower-case	
from classicmodels.customers;

-- ---------------------------------------------------
-- number functions (aggregation/group by)
select city, 
AVG(creditLimit),-- Returns the average value of an expression	
ABS(creditLimit),-- Returns the absolute value of a number
CEILING(creditLimit),-- Returns the smallest integer value that is greater than or equal to a number		
COUNT(creditLimit),	-- Returns the count of an expression
FLOOR(creditLimit),	-- Returns the largest integer value that is equal to or less than a number	
MAX(creditLimit),-- Returns the maximum value of an expression	
MIN(creditLimit),-- Returns the minimum value of an expression	
RAND(creditLimit),	-- Returns a random number or a random number within a range	
ROUND(creditLimit),	-- Returns a number rounded to a certain number of decimal places	
SUM(creditLimit) -- Returns the summed value of an expression
from classicmodels.customers 
group by city
having city ='San Francisco';

select city, creditLimit
from classicmodels.customers
where city ='San Francisco';


-- ---------------------------------------------------
-- date functions
select orderNumber,orderDate,shippedDate,
(orderDate)+5,	-- Returns a date after a certain time/date interval has been added		
ADDDATE(orderDate,5),-- Returns a date after a certain time/date interval has been added	
ADDTIME(orderDate,5),-- Returns time after a certain time/date interval has been added	
DATEDIFF(shippedDate,orderDate),	-- Returns the difference between two date values, based on the interval specified		
DAY(orderDate),	-- Returns the day of the month (from 1 to 31) for a given date		
MONTH(orderDate),	-- Returns the month (from 1 to 12) for a given date		
YEAR(orderDate),	-- Returns the year (as a four-digit number) for a given date
NOW()	-- Returns the current date and time			
from classicmodels.orders;
-- ---------------------------------------------------

-- Advanced Functions           
-- CASE - #1 tool for data analysts - segmentation
select
city, state, country,
case when country = 'USA' then 'USA' else 'non USA' end as US_customer1,
case when length(state)=2 then 'USA' else 'non USA' end as US_customer2
from classicmodels.customers;	

-- RANK and NTILE Function      -- PARTITION BY if needed
-- 122 records
select customerNumber, creditLimit,
ROW_NUMBER() OVER (ORDER BY creditLimit DESC) as `row_number`,
RANK() OVER (ORDER BY creditLimit DESC) as `rank`,
DENSE_RANK() OVER (ORDER BY creditLimit DESC) as `dense_rank`,
NTILE(4)  OVER (ORDER BY creditLimit DESC) as cust_ntile
from classicmodels.customers
order by creditLimit desc, customerNumber asc;

-- create upper_lower from upper case
drop table if exists mywork.upper_lower;
create table mywork.upper_lower
as 
select UPPER(TRIM(contactFirstName)) as contactFirstName,
UPPER(TRIM(contactLastName)) as contactLastName,
CONCAT(TRIM(contactFirstName),' ', TRIM(contactLastName)) as contactFullName
from classicmodels.customers;
-- select * from mywork.upper_lower;

-- change name from upper to upper_lower case
select contactFirstName, contactLastName,
CONCAT(UCASE(LEFT(contactFirstName, 1))) as first_upper,
SUBSTRING(LCASE(contactFirstName),2,LENGTH(trim(contactFirstName))-1) as second_lower,
CONCAT(CONCAT(UCASE(LEFT(contactFirstName, 1))),SUBSTRING(LCASE(contactFirstName),2,LENGTH(trim(contactLastName))-1)) as ul_case_first,
CONCAT(CONCAT(UCASE(LEFT(contactLastName, 1))),SUBSTRING(LCASE(contactLastName),2,LENGTH(trim(contactLastName))-1)) as ul_case_last,
-- break into two columns
contactFullName,
locate(' ',contactFullName) position_of_space,
left(contactFullName,locate(' ',contactFullName))  as first_name,
substring((contactFullName),locate(' ',contactFullName)+1,length(contactFullName)) last_name
from mywork.upper_lower;

select * from classicmodels.customers;
desc classicmodels.customers;

-- classicmodels.customers. What is the max lenght of each field?
select 
max(length(customerNumber)),
max(length(customerName)),
max(length(contactLastName)),
max(length(contactFirstName)),
max(length(phone)),
max(length(addressLine1)),
max(length(addressLine2)),
max(length(city)),
max(length(state)),
max(length(postalCode)),
max(length(country)),
max(length(salesRepEmployeeNumber)),
max(length(creditLimit))
from classicmodels.customers;

-- ---------------------------------------------------
-- Homework #6
-- Part #1: join all tables of classicmodels DB together
select  count(*) from classicmodels.offices; -- 7
select  count(*) from classicmodels.employees; -- 23
select  count(*) from classicmodels.customers; -- 122
select  count(*) from classicmodels.payments; -- 273
select  count(*) from classicmodels.orders; -- 326
select  count(*) from classicmodels.orderdetails; -- 2996
select  count(*) from classicmodels.products; -- 110
select  count(*) from classicmodels.productlines; -- 7

select  distinct * from classicmodels.offices o
inner join classicmodels.employees e on o.officeCode=e.officeCode
inner join classicmodels.customers c on c.salesRepEmployeeNumber=e.employeeNumber
inner join (select customerNumber, max(paymentDate) as paymentDate, sum(amount) as amount 
from classicmodels.payments group by customerNumber) p on p.customerNumber=c.customerNumber
inner join classicmodels.orders ord on ord.customerNumber=p.customerNumber
inner join classicmodels.orderdetails od on od.orderNumber=ord.orderNumber
inner join classicmodels.products pr on pr.productCode=od.productCode
inner join classicmodels.productlines pl on pl.productLine=pr.productLine;

/* Homework - Part #2 
Find any dataset you want to analyze (csv, xls, etc.) and import the data 
https://www.dataquest.io/blog/free-datasets-for-projects/
https://www.kaggle.com/datasets
https://catalog.data.gov/dataset
https://data.world
https://datasf.org/opendata/

Import this dataset to mysql database: 
1. create a database
2. right click on that database - Table Data Import Wizard - next - next - next ...
*/
select * from honda_cars.honda_sell_data;

/*Film Locations in San Francisco
-- https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am
-- import csv file Film_Locations_in_San_Francisco.csv
-- in MySQL Workbanch: create database Film
-- right click on Film database - Import Table - Wizard - Next ...
*/
-- ????205 rows
select * from film.film_locations_in_san_francisco;

-- Queries:
-- 1. count distinct movies
select count(distinct Title) from film.film_locations_in_san_francisco;

-- 2. count of all films by release year
select `Release Year`, count(distinct Title) from film.film_locations_in_san_francisco group by `Release Year` order by `Release Year` desc;

-- 3. count of all films by 'production company'
select `Production Company`, count(distinct Title) from film.film_locations_in_san_francisco group by `Production Company` order by `Production Company`;

-- 4. count of all films directed by Woody Allen
select Director, count(distinct Title) from film.film_locations_in_san_francisco where Director like '%Woody Allen%' group by Director;

-- 5. how many movies have/don't have fun facts?
(select count(distinct Title) from film.film_locations_in_san_francisco where length(`Fun Facts`)<>0) 
union
(select count(distinct Title) from film.film_locations_in_san_francisco where length(`Fun Facts`)=0);

select case when `fun facts` = '' then 'no' else 'yes' end fun_fact, 
count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
group by case when `fun facts` = '' then 'no' else 'yes' end; 

-- 6. in how many movies were Keanu Reeves and Robin Williams?
select count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
where `actor 1` in ('Keanu Reeves', 'Robin Williams')
or `actor 2` in ('Keanu Reeves', 'Robin Williams')
or `actor 3` in ('Keanu Reeves', 'Robin Williams');

-- ------------------- ETL (EXTRACT TRANSFORM LOAD) -------------------
-- ------------------- Loading Data via the Command-Line --------------

-- Find the data type of existing columns 
SELECT  column_name, column_type 
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'film';

-- Prepare database and table for CSV data load
DROP DATABASE IF EXISTS film2;
CREATE DATABASE film2;
CREATE TABLE film2.film_locations_in_san_francisco (
`Title`	text,
`Release Year`	int(11),
`Locations`	text,
`Fun Facts`	text,
`Production Company`	text,
`Distributor`	text,
`Director`	text,
`Writer`	text,
`Actor 1`	text,
`Actor 2`	text,
`Actor 3`	text);
select * from film2.film_locations_in_san_francisco;

-- Set Client and Server ON to load data
-- Instructions for Windows in file 'ETL - Enabling local data load on MySQL Client and Server.docx'

-- Import the CSV file
-- Windows - Search MySQL - command prompt
 LOAD DATA LOCAL INFILE 'C:/Users/shari/SQL/mySQL/advanced/Film_Locations_in_San_Francisco.csv'
 INTO TABLE film2.film_locations_in_san_francisco
 FIELDS TERMINATED BY ',' 
 ENCLOSED BY '"' 
 LINES TERMINATED BY '\n' 
 IGNORE 1 ROWS
 (`Title`,`Release Year`,`Locations`,`Fun Facts`,`Production Company`,`Distributor`,
 `Director`,`Writer`,`Actor 1`,`Actor 2`,`Actor 3`);

-- see records loaded  
-- 1976
  select * from film2.film_locations_in_san_francisco;

	