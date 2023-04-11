
-- -------------------------- Lesson #4 Table Joins ------------------
-- inner join
-- left join
-- self join
-- full join
 -- ---------------------------------------------------
select * from mywork.dept; -- 7
select * from mywork.emp; -- 13

-- inner join
-- table alias 
-- 13 records
select * 
from mywork.emp e
inner join mywork.dept d on e.dept = d.deptno
order by empno;

-- inner join vs. left join

-- inner join = join
-- 100
select *
from classicmodels.customers c -- 122
inner join classicmodels.employees e -- 23
 on c.salesrepemployeenumber=e.employeenumber;

-- 122
select *
from classicmodels.customers c -- 122
left join classicmodels.employees e -- 23
 on c.salesrepemployeenumber = e.employeenumber;

-- full join 
/*The FULL OUTER JOIN return all records when there is a match in either 
left (table1) or right (table2) table records.*/
/* there is no full join in MySQL -- this sql below doesn't work
select * 
from mywork.emp e
full outer join mywork.dept d on e.dept = d.deptno
order by empno; 

-- same as this union 
select * 
from mywork.emp e
left join mywork.dept d on e.dept = d.deptno
union
select * 
from mywork.emp e
right join mywork.dept d on e.dept = d.deptno;
*/

-- self join 
/*A self-join joins data from the same table. In other words, it joins a table with itself. 
Records taken from the table are matched to other records from the same table. 
Why would you do this? You may need to compare a value with another value from the same row. 
You can’t do that unless you join the table to itself and compare the values as if 
they were in two separate records.
*/
select * from classicmodels.employees;

select e1.employeeNumber, e1.firstName, e1.lastName, e1.jobTitle, e1.reportsTo,  -- employee level
e2.firstName as boss_firstName, e2.lastName as boss_lastName, e2.jobTitle as boss_jobTitle -- manager level
from classicmodels.employees e1
left join classicmodels.employees e2 on e1.reportsTo = e2.employeeNumber;


-- ----------------------------------------
-- classicmodels table counts 
select count(*) from classicmodels.customers;-- 122
select count(*) from classicmodels.employees; -- 23
select count(*) from classicmodels.offices; -- 7
select count(*) from classicmodels.orderdetails; -- 2996
select count(*) from classicmodels.orders; -- 326
select count(*) from classicmodels.payments; -- 273
select count(*) from classicmodels.productlines; -- 7
select count(*) from classicmodels.products; -- 110


-- 23
select *  -- select count(*) 
from classicmodels.employees emp -- 23
join classicmodels.offices office -- 7
on emp.officeCode = office.officeCode;

-- 100
select *  -- select count(*) 
from classicmodels.customers cust -- 122
INNER join classicmodels.employees emp -- 23
on cust.SalesRepEmployeeNumber = emp.employeeNumber;

-- 122
select *  -- select count(*) 
from classicmodels.customers cust -- 122
LEFT join classicmodels.employees emp -- 23
on cust.SalesRepEmployeeNumber = emp.employeeNumber;

-- 326
select *  -- select count(*) 
from classicmodels.customers cust -- 122
JOIN classicmodels.orders orders  -- 326
on cust.customerNumber = orders.customerNumber;
-- where cust.customerNumber = 339;
 
-- 2996
select *   -- select count(*) 
from classicmodels.orders orders -- 326
JOIN classicmodels.orderdetails orderd -- 2996
on orders.orderNumber = orderd.orderNumber ;
-- where orders.orderNumber in (10183,10307);

-- 110
select *   -- select count(*) 
from classicmodels.products prod -- 110
JOIN classicmodels.productLines prodline -- 7 
on prod.productLine = prodline.productLine;

-- 273
select *  -- select count(*) 
from classicmodels.customers cust -- 122
JOIN classicmodels.payments pay -- 273
on cust.customerNumber = pay.customerNumber ;
-- where cust.customerNumber = 339;


-- ---------------------------------------------------			
-- Homework for Lesson #4 
-- Part #1 classicmodels database 
-- (write sql for #6, 8, 9, 10, 11, 14, 16, 17, 21) -- easy questions

-- 1.how many vendors, product lines, and products exist in the database?
select count(distinct(productVendor)) as VendorsNum, count(distinct(productLine)) as ProductLinesNum, count(distinct(productName)) as ProductsNum 
from classicmodels.products;

-- 2.what is the average price (buy price, MSRP) per vendor?
select productVendor, avg(buyPrice) as avgPrice, avg(MSRP) as avgMSRP from classicmodels.products group by productVendor;

-- 3.what is the average price (buy price, MSRP) per customer?
select orders.customerNumber, avg(det.priceEach) as avgPrice, avg(prod.MSRP) as avgMSRP 
from classicmodels.orders orders
join classicmodels.orderdetails det on orders.orderNumber=det.orderNumber
join classicmodels.products prod on det.productCode=prod.productCode
group by orders.customerNumber
order by orders.customerNumber;

-- 4.what product was sold the most?
select prod.productName, 
count(prod.productCode) as prod_cnt,
sum(det.quantityOrdered) as quantity_ordered_sum,
max(det.quantityOrdered) as order_cnt 
from classicmodels.orderdetails det
inner join classicmodels.products prod on det.productCode=prod.productCode
group by prod.productCode order by prod_cnt desc limit 1;

-- 5.how much money was made between buyPrice and MSRP?
ALTER TABLE classicmodels.products
ADD COLUMN calc_val DECIMAL(10,2) 
GENERATED ALWAYS AS (classicmodels.products.MSRP - classicmodels.products.buyPrice) virtual;

select * from classicmodels.products;

ALTER TABLE classicmodels.products
drop COLUMN calc_val;

-- OR with sum:
select 
sum(prod.msrp*det.quantityOrdered) as msrp_sales,
sum(prod.buyPrice*det.quantityOrdered) as buyPrice_sales,
sum(prod.msrp*det.quantityOrdered)-sum(prod.buyPrice*det.quantityOrdered) as diff_in_sales
from classicmodels.products prod
join classicmodels.orderdetails det on prod.productCode=det.productCode;
 
-- 6.which vendor sells 1966 Shelby Cobra?
select productVendor, productName from classicmodels.products where productName like '%1966 Shelby Cobra%';

-- 7.which vendor sells more products?
select productVendor, count(det.productCode) as quantity 
from classicmodels.products prod
join classicmodels.orderdetails det on prod.productCode=det.productCode
group by prod.productVendor  order by quantity desc limit 1;

-- 8.which product is the most and least expensive?
(select productName, max(msrp) as max_price from classicmodels.products group by productName order by max_price desc limit 1)
union
(select productName, min(msrp) as min_price from classicmodels.products group by productName order by min_price limit 1);
SELECT max(msrp) as mostexp, min(msrp) as leastexp FROM classicmodels.products;

-- 9.which product has the most quantityInStock?
select productName, quantityInStock as max from classicmodels.products order by max desc limit 1;

-- 10.list all products that have quantity in stock less than 20
select productName, quantityInStock from classicmodels.products where quantityInStock <20;

-- 11.which customer has the highest and lowest credit limit?
(select customerNumber, creditLimit as minCreditLimit from classicmodels.customers order by minCreditLimit limit 1)
union
(select customerNumber, creditLimit as maxCreditLimit from classicmodels.customers order by maxCreditLimit desc limit 1);

-- 12.rank customers by credit limit
select customerName, creditLimit, RANK() OVER (ORDER BY creditLimit DESC) as `rank` from classicmodels.customers;

-- 13.
-- #1 list the most sold product by city
WITH a as (
SELECT c.City, od.productCode, sum(quantityOrdered) as quantitySold,
(ROW_NUMBER() OVER (PARTITION BY c.City ORDER BY sum(quantityOrdered) DESC)) as rowNum
FROM classicmodels.orderDetails od
JOIN classicmodels.orders o on o.orderNumber = od.orderNumber
JOIN classicmodels.customers c on c.customerNumber = o.customerNumber
GROUP BY c.City, od.productCode
) 
SELECT a.City, a.productCode, a.quantitySold
FROM a
WHERE rowNum = 1;

-- #2 list the most sold product by city
select * from (
select  oc.city, p.productname, SUM(od.quantityOrdered), COUNT(p.productcode),
RANK() OVER (PARTITION BY oc.city ORDER BY sum(od.quantityOrdered) DESC)  as myrank
from classicmodels.offices oc 
join classicmodels.employees e on oc.officecode=e.officecode
join classicmodels.customers c on c.salesrepemployeenumber=e.employeenumber
join classicmodels.orders o on o.customernumber=c.customernumber
join classicmodels.orderdetails od on o.ordernumber=od.ordernumber
join classicmodels.products p on p.productcode=od.productcode
group by  oc.city, p.productname) a
where myrank = 1 ;

-- 14.customers in what city are the most profitable to the company?
select  city, amount from classicmodels.customers
inner join classicmodels.payments on classicmodels.payments.customerNumber=classicmodels.customers.customerNumber
order by amount desc limit 1;

-- 15.what is the average number of orders per customer?
select customerNumber, count(orderNumber) as numberOfOrders from classicmodels.orders group by customerNumber;
SELECT (COUNT(orderNumber)/COUNT(distinct customerNumber)) as avgPerCust
FROM classicmodels.orders;

-- 16.who is the best customer?
select  customerName, amount from classicmodels.customers
inner join classicmodels.payments on classicmodels.payments.customerNumber=classicmodels.customers.customerNumber
order by amount desc limit 1;

-- 17.customers without payment
select  c.customerNumber, c.customerName, p.amount from classicmodels.customers c
left join classicmodels.payments p on p.customerNumber=c.customerNumber where p.amount is null;

-- 18.what is the average number of days between the order date and ship date?
select round(avg(datediff(shippedDate,orderDate)),0) as avgDateNumber from classicmodels.orders;

-- 19.sales by year
select year(paymentDate) as year, sum(amount) as salesSum from classicmodels.payments group by year order by salesSum desc; 

-- 20.how many orders are not shipped?
-- where status <> 'Shipped'; -- wrong because there customers that are in 'Disputed' status
select count(*) from classicmodels.orders where shippeddate is null; 

-- 21.list all employees by their (full name: first + last) in alpabetical order
SELECT CONCAT(lastName, ' ', firstName) as fullName FROM classicmodels.employees order by fullName;

-- 22.list of employees  by how much they sold in 2003?
select e.employeeNumber, p.amount, year(p.paymentDate) as year from classicmodels.employees e
inner join classicmodels.customers c on c.salesRepEmployeeNumber=e.employeeNumber
inner join classicmodels.payments p on p.customerNumber=c.customerNumber
group by e.employeeNumber, p.amount, year
having year='2003'
order by p.amount desc;

-- 23.which city has the most number of employees?
select city, count(employeeNumber) as max from classicmodels.employees
inner join classicmodels.offices on classicmodels.employees.officeCode=classicmodels.offices.officeCode group by city order by max desc limit 1;

-- 24.which office has the biggest sales?
select o.officeCode, sum(p.amount)  as salesAmount from offices o
inner join classicmodels.employees e on o.officeCode=e.officeCode
inner join classicmodels.customers c on c.salesRepEmployeeNumber=e.employeeNumber
inner join classicmodels.payments p on p.customerNumber=c.customerNumber
group by o.officeCode
order by salesAmount desc
limit 1;

-- Part #2  -- library_simple database
-- 1.find all information (query each table seporately for book_id = 252)
select * from library_simple.author_has_book where book_id=252; 
select * from library_simple.author where id in (750,770,794);
select * from library_simple.book where id=252;
select * from library_simple.copy f where book_id = 252;
select * from library_simple.issuance g where copy_id = 252;
select * from library_simple.category_has_book d where book_id = 252;
select * from library_simple.category e where id in (46,142);
select * from library_simple.reader h where id = 234;
select * from library_simple.issuance g where reader_id = 234;

-- 2.which books did Van Parks write?
select `name` from library_simple.author 
inner join library_simple.author_has_book on library_simple.author.id=library_simple.author_has_book.author_id
inner join library_simple.book on library_simple.author_has_book.book_id=library_simple.book.id where first_name='Van' and last_name='Parks';

-- 3.which books where published in 2003?
select * from library_simple.author 
inner join library_simple.author_has_book on library_simple.author.id=library_simple.author_has_book.author_id
inner join library_simple.book on library_simple.author_has_book.book_id=library_simple.book.id where pub_year=2003;