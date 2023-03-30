-- 1. Покажите фамилии и имя клиентов, у которых имя Mарк.
SELECT FirstName, LastName FROM chinook.customer WHERE FirstName like 'Mar_';

-- 2. Покажите название и размер треков в Мегабайтах, применив округление до 2 знаков и отсортировав по убыванию. Столбец назовите MB.
SELECT Name, ROUND(Bytes/1048576,2) AS MB FROM chinook.track order by MB desc;
 
-- 3. Покажите возраст сотрудников, на момент оформления на работу. 
-- Вывести фамилию, имя, возраст. дату оформления и день рождения. Столбец назовите age.
SELECT LastName, FirstName, TIMESTAMPDIFF(YEAR,BirthDate, HireDate) AS age,HireDate, BirthDate FROM chinook.employee;

-- 4. Покажите покупателей-американцев без факса.
SELECT * FROM chinook.customer WHERE Country='USA' AND Fax IS NULL;

-- 5. Покажите почтовые адреса клиентов из домена gmail.com.
SELECT Email, Address FROM chinook.customer WHERE Email LIKE '%gmail.com';

-- 6. Покажите в алфавитном порядке все уникальные должности в компании.
SELECT distinct(Title) FROM chinook.employee ORDER BY Title;

-- 7. Покажите самую короткую песню.
SELECT * FROM chinook.track ORDER BY Milliseconds LIMIT 1;

-- 8. Покажите название и длительность в секундах самой короткой песни. Столбец назвать sec.
SELECT Name, FLOOR(Milliseconds/1000) AS sec FROM chinook.track ORDER BY Milliseconds LIMIT 1;

-- 9. Покажите средний возраст сотрудников, работающих в компании на дату приема.
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, BirthDate, HireDate)),0) AS average_age FROM chinook.employee;
-- на текущую дату
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, BirthDate, CURDATE())),0) AS average_age FROM chinook.employee;

-- 10. Проведите аналитическую работу: узнайте фамилию, имя и компанию покупателя (номер 5). 
-- Сколько заказов он сделал и на какую сумму. Покажите 2 запроса Вашей работы.
SELECT LastName, FirstName, Company  FROM chinook.customer WHERE CustomerId=5;
SELECT CustomerId, count(Total) as num_orders, sum(Total) as total_sum FROM chinook.invoice GROUP BY CustomerId HAVING CustomerId=5;

-- 11. Напишите запрос, определяющий количество треков, где ID плейлиста > 15.
select * from chinook.playlisttrack;
select PlaylistId, count(TrackId) as num_tracks from chinook.playlisttrack where PlaylistId>15 group by PlaylistId;

-- 12. Найти все ID счет-фактур, в которых количество товаров больше или равно 6 и меньше или равно 9.
select * from chinook.invoiceline;
select InvoiceId, sum(Quantity) as num from chinook.invoiceline group by InvoiceId having num between 6 and 9;


