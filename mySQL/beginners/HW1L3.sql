-- Покажите содержимое таблицы исполнителей (артистов)
SELECT * FROM chinook.artist;

-- Покажите фамилии и имена клиентов из города Лондон
SELECT FirstName, LastName FROM chinook.customer
WHERE city='London';

-- Покажите продажи за 2012 год, со стоимостью продаж более 4 долларов
SELECT * FROM chinook.invoice
WHERE InvoiceDate LIKE '2012%' 
AND Total >4.00;

-- Покажите дату продажи, адрес продажи, город в которую совершена продажа и стоимость покупки не равную 17.91. 
SELECT InvoiceDate, BillingAddress, BillingCity FROM chinook.invoice
WHERE Total !=17.91;

-- Присвоить названия столбцам InvoiceDate – ДатаПродажи, BillingAddress – АдресПродажи и BillingCity - ГородПродажи
SELECT InvoiceDate AS ДатаПродажи, BillingAddress AS АдресПродажи, BillingCity AS ГородПродаж FROM chinook.invoice
WHERE Total !=17.91;

-- Покажите фамилии и имена сотрудников компании, нанятых в 2003 году из города Калгари
SELECT FirstName, LastName FROM chinook.employee
WHERE HireDate LIKE '2003%' 
AND City='Calgary';

-- Покажите канадские города, в которые были сделаны продажи в августе?
SELECT BillingCity FROM chinook.invoice
WHERE BillingCountry='Canada'
AND InvoiceDate LIKE '____-08%';

-- Покажите Фамилии и имена работников, нанятых в октябре?
SELECT LastName, FirstName FROM chinook.employee
WHERE HireDate LIKE '____-10%';

-- Покажите фамилии и имена сотрудников, занимающих должность менеджера по продажам и ИТ менеджера. 
-- Решите задание двумя способами: 
-- используя оператор IN
SELECT LastName, FirstName FROM chinook.employee
WHERE Title IN ('Sales Manager','IT Manager');
-- используя логические операции
SELECT LastName, FirstName FROM chinook.employee
WHERE Title='Sales Manager' OR Title='IT Manager';