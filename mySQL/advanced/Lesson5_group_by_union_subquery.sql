-- Lesson #5 Group by, Union, Subquery

-- GROUP BY (most common): COUNT, SUM, MAX, MIN, AVG
-- --------------- customer table ---------------------
select * from  classicmodels.customers;

-- general analyses	(record counts, count of distinct values, min/max/avg)
SELECT COUNT(*) as Customer_Cnt, COUNT(distinct country), COUNT(distinct city), 
MAX(creditLimit), MIN(creditLimit), AVG(creditLimit)
FROM classicmodels.customers;

-- analysis by country
SELECT country, COUNT(*) as Customer_Cnt, COUNT(distinct city), 
MAX(creditLimit), MIN(creditLimit), AVG(creditLimit)
FROM classicmodels.customers
GROUP BY country;

-- --------------- employee table ----------------- 
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(*) as Employee_Cnt, COUNT(distinct jobTitle)
FROM classicmodels.employees;

-- by job title
SELECT jobTitle, COUNT(*) as Employee_Cnt
FROM classicmodels.employees
GROUP BY jobTitle;

-- --------------- offices table ----------------- 
select * from classicmodels.offices;
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(officeCode) as Offices_Cnt, COUNT(distinct city), COUNT(distinct country) 
FROM classicmodels.offices;

-- by country
SELECT country, COUNT(officeCode) as Offices_Cnt, COUNT(distinct city)
FROM classicmodels.offices
GROUP BY country;

-- --------------- products table ----------------- 
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(productCode) as Product_Cnt, COUNT(distinct productLine),
MIN(buyPrice), MAX(buyPrice)
FROM classicmodels.products;
 
-- by productLine
SELECT productLine, COUNT(productCode) as Product_Cnt, 
MIN(buyPrice), MAX(buyPrice), AVG(buyPrice)
FROM classicmodels.products 
GROUP BY productLine;


-- ---------------  UNION vs UNION ALL ---------------------	
-- doesn't allow dups
select city
from classicmodels.customers
UNION 
select city
from classicmodels.customers
ORDER BY city;

-- allows dups
select city
from classicmodels.customers
UNION ALL
select city
from classicmodels.customers
ORDER BY city;

-- union can be from different DBs
-- 102 (record San Diego/SAN DIEGO)
select 'classicmodels' as db,  city
from classicmodels.customers
-- where city = 'San Diego'
UNION 
select 'mywork' as db,  city
from mywork.dept
-- where city = 'San Diego'
ORDER BY city;

-- 100
select  city
from classicmodels.customers
-- where city = 'San Diego'
UNION 
select  city
from mywork.dept
-- where city = 'San Diego'
ORDER BY city;

-- UNION can be used many times
-- 9 records
select customerNumber, customerName, city
from classicmodels.customers
where city = 'San Francisco'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'NYC'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'Boston';

-- SUBQUERY #1
SELECT COUNT(*) FROM
(select customerNumber, customerName, city
from classicmodels.customers
where city = 'San Francisco'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'NYC'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'Boston')as a;

-- SUBQUERY #2
select customerNumber, customerName, city, state, country
from classicmodels.customers
where customerNumber in 
(select customerNumber from classicmodels.payments 
group by customerNumber
having sum(amount) >70000);

-- HAVING (like where in group by)
-- show all customers with payments >$70,000
-- 56
select customerNumber, sum(amount) 
from classicmodels.payments 
group by customerNumber
having sum(amount) >70000;



-- Homework #5
-- Part 1
-- Group By  Example by Animation: https://dataschool.com/how-to-teach-people-sql/how-sql-aggregations-work/
-- sql statement (classicmodels db) using union: show products with buyPrice > 100 and <200
-- 110 rows, query does not make sense
select * from classicmodels.products where buyPrice >100 union select * from classicmodels.products where buyPrice < 200;
select * from classicmodels.products where buyPrice between 100 and 200;

-- sql statement (classicmodels db) using subquery: show all customer names with employees in San Francisco office
-- 12 rows
select customerName from classicmodels.customers where salesRepEmployeeNumber in 
(select  distinct employeeNumber from classicmodels.employees where officeCode in ( select officeCode from classicmodels.offices where city='San Francisco'));

-- Part 2
-- Finish working with Library Simple db
-- Join all tables
select count(*) from library_simple.author; -- 86
select count(*) from library_simple.author_has_book; -- 596
select count(*) from library_simple.book; -- 322
select count(*) from library_simple.category; -- 184
select count(*) from library_simple.category_has_book; -- 556
select count(*) from library_simple.copy; -- 1121
select count(*) from library_simple.issuance; -- 2000
select count(*) from library_simple.reader; -- 241 

select distinct 
-- a.id, a.first_name, a.last_name,
-- b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year,
-- d.category_id, d.book_id,	
-- e.id, e.name,
f.id, f.book_id, f.number, f.admission_date,
g.id, g.copy_id, -- g.reader_id, 
g.issue_date, g.release_date, g.deadline_date,	
h.id, h.first_name, h.last_name, h.reader_num	
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
join library_simple.category_has_book d
on c.id = d.book_id
join library_simple.category e
on d.category_id = e.id
join library_simple.copy f
on c.id = f.book_id
join library_simple.issuance g
on f.id = g.copy_id 
join library_simple.reader h
on g.reader_id = h.id;

-- Find all release dates for book 'Dog With Money'
-- none 
select * from library_simple.book b
left join library_simple.copy c on b.id=c.book_id
left join library_simple.issuance i on c.id=i.copy_id
where b.name='Dog With Money';

-- to verify 
select * from library_simple.book where name = 'Dog With Money';
select * from library_simple.copy f where book_id = 61;
select * from library_simple.issuance where copy_id in (573,768,960);


