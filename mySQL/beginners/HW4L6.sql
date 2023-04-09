-- 1. Покажите все данные заказов покупателя (номер 13) и отсортируйте стоимость по возрастанию.
-- 7 rows
select * from chinook.invoice 
inner join chinook.customer on chinook.customer.CustomerId=chinook.invoice.CustomerId 
where chinook.customer.CustomerId=13
order by chinook.invoice.Total;

-- 2. Посчитайте количество треков в каждом альбоме. В результате вывести ID альбома, имя альбома и кол-во треков. 
-- 347 rows
select chinook.album.AlbumId,  chinook.album.Title, count(chinook.track.TrackId) as trackCount from chinook.album
inner join chinook.track on chinook.track.AlbumId=chinook.album.AlbumId
group by chinook.album.AlbumId, chinook.album.Title;

-- 3. Покажите имя, фамилию, кол-во и стоимость покупок по каждому клиенту. Столбцы кол-во назвать quantity, стоимость - sum.
-- 59 rows
select * from chinook.invoice;
select chinook.customer.CustomerId, FirstName, LastName, count(chinook.invoice.InvoiceId) as quantity, sum(chinook.invoice.Total) as sum from chinook.customer
inner join chinook.invoice on chinook.customer.CustomerId=chinook.invoice.CustomerId
group by chinook.customer.CustomerId
order by sum desc;

-- 4. Посчитайте общую сумму продаж в США в 1 квартале 2012 года. Присвойте любой псевдоним столбцу.
-- 17.82
select  year(InvoiceDate) as year, quarter(InvoiceDate) as quarter, BillingCountry, sum(Total) as TotalSum from chinook.invoice
where BillingCountry='USA'
group by year, quarter 
having quarter=1 and year=2012;

-- 5. Выполните запросы по очереди и ответьте на вопросы:
/* Вернут ли данные запросы одинаковый результат?  Ответы: Да или НЕТ. 
1)	Если ДА. Объяснить почему.
2)	Если НЕТ. Объяснить почему. 
3)	Какой запрос вернет больше строк? */
-- 59 rows
select * from chinook.customer;
-- 8 rows
select * from chinook.employee;
-- 59 rows
select * from chinook.customer left JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId;
-- 64 rows
select * from chinook.customer right JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId;

-- 6. Выполните запросы по очереди и ответьте на вопросы:
/* Вернут ли данные запросы одинаковый результат? Ответы: Да или НЕТ. 
1)	Если ДА. Объяснить почему.
2)	Если НЕТ. Объяснить почему. 
3)	Какой запрос вернет больше строк? */
-- 0 rows 
select * from chinook.customer LEFT JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId
where chinook.employee.FirstName is null;
-- 59 rows 
select * from chinook.customer LEFT JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId
and chinook.employee.FirstName is null;

-- 7. Покажите количество и среднюю стоимость треков в каждом жанре. Вывести ID жанра, название жанра, количество и среднюю стоимость.
-- 25 rows
select * from chinook.genre;
select * from chinook.track;
select chinook.genre.GenreId, chinook.genre.Name, count(chinook.track.TrackId) as trackQuantity, avg(chinook.track.UnitPrice) as avgPrice from chinook.genre
inner join chinook.track on chinook.genre.GenreId=chinook.track.GenreId
group by chinook.genre.GenreId;

-- 8. Покажите клиента, который потратил больше всего денег. Для сокращения количества символов в запросе, используйте псевдонимы. 
-- Для ограничения количества записей используйте оператор "limit".
-- 49.62
select chinook.customer.CustomerId, chinook.customer.FirstName, chinook.customer.LastName, sum(chinook.invoice.Total) as maxAmount from chinook.invoice 
inner join chinook.customer on chinook.invoice.CustomerId=chinook.customer.CustomerId
group by chinook.customer.CustomerId
order by maxAmount desc
limit 1;
 
-- 9. Покажите список названий альбомов, ID альбомов, количество треков и общую цену альбомов для исполнителя Audioslave.
-- 3 rows
select chinook.artist.Name, chinook.album.Title,chinook.album.AlbumId, count(chinook.track.TrackId) as trackQuantity, sum(chinook.track.UnitPrice) as albumPrice
from chinook.artist 
inner join chinook.album on chinook.artist.ArtistId=chinook.album.ArtistId
inner join chinook.track on chinook.track.AlbumId=chinook.album.AlbumId
where chinook.artist.Name='Audioslave'
group by chinook.album.Title, chinook.album.AlbumId;

