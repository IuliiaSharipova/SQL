-- 1. Покажите длительность самой длинной песни. Столбец назвать sec.
select Milliseconds/1000 as sec from chinook.track where Milliseconds = (select max(Milliseconds) from chinook.track);

-- 2. Покажите название и длительность в секундах самой длинной песни применив округление по правилам математики. Столбец назвать sec.
select name, round(Milliseconds/1000,2) as sec from chinook.track where Milliseconds = (select max(Milliseconds) from chinook.track);

-- 3. Покажите все счёт-фактуры, стоимость которых ниже средней.
select * from chinook.invoice;
select InvoiceId, Total from chinook.invoice where Total < (select avg(Total) from chinook.invoice);

-- 4. Покажите счёт-фактуру с самой высокой стоимостью.
select InvoiceId, Total from chinook.invoice where Total=(select max(Total) from chinook.invoice);

-- 5. Покажите города, в которых живут и сотрудники, и клиенты.
select * from chinook.employee;
select * from chinook.customer;
select City from chinook.customer where (City) IN (select City from chinook.employee);

-- 6. Покажите имя, фамилию покупателя (номер 16), компанию и общую сумму его заказов. Столбец назовите sum.
select FirstName, LastName, Company, (select sum(total) from chinook.invoice where CustomerId = chinook.customer.CustomerId) as sum from chinook.customer where CustomerId = 16;

/* 7. Покажите сколько раз покупали треки группы Queen.  
Количество покупок необходимо посчитать по каждому треку. Вывести название, ИД трека и количество купленных треков группы Queen. Столбец назовите total. */
select * from chinook. track where Composer='Queen';
select TrackId, Quantity from chinook.invoiceline where TrackId IN (select TrackId from chinook. track where Composer='Queen');
select TrackId, Name, (select count(TrackId) from chinook.invoiceline 
where TrackId=chinook.track.TrackId) as total
from chinook.track where Composer='Queen';

-- 8. Посчитайте количество треков в каждом альбоме. В результате вывести имя альбома и кол-во треков.
select * from chinook.track;
select Title, (select count(*) from chinook.track where track.AlbumId=chinook.album.AlbumId) as track_amount from chinook.album;