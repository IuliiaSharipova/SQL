-- 1. Find the data type of existing columns in tables: 
SELECT  column_name, column_type 
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'testdb' and table_name='department';

SELECT  column_name, column_type 
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'testdb' and table_name='employee';

-- 2. Используя запрос, установи нашу базу данных как БД по умолчанию.
use testdb;

-- 3. Используя запрос, посмотри какие таблицы содержит БД testdb.
show tables;

-- 4. Отобразите данные таблицы department
select * from department;

/* 5. Наша компания активно растет и теперь у нас в структуре появляется 2 дополнительных отдела: отдел
сопровождения и отдел планирования и продаж. Добавьте в таблицу новые отделы
следующими по списку. Описание отделов придумайте самостоятельно. */
insert into department(id, department, description_dep)
values
(5, 'отдел обработки заказов', 'прием и обработка заказов'),
(6, 'отдел продаж', 'построение взаимоотношений с клиентами, продажи');

/* 6. В компании поменялась «штатка». От отдела кадров поступил запрос на изменение
описания отдела аналитики и наименования подразделения администрация.
Необходимо изменить описание на 'системный и бизнес анализ', а название на 'проектный офис'. */
update department
set department='проектный офис',
    description_dep='системный и бизнес анализ'
where department='администрация';

-- 7. Покажите описание отдела тестирования.
select description_dep from department where id=3;

-- 8. А теперь представьте, что ID отделов Вы не видите. Попробуйте найти описание отдела тестирования еще раз. Используйте оператор like.
select description_dep from department where department like '%тестировани%';

-- 9. Отобразите данные всех сотрудников.
select * from employee;

/* 10. На совещании руководителей и заместителей ИТ-компании решили
оптимизировать количество отделов в компании. Отдел «проектный офис» решили
упразднить распределив всех руководителей подразделений в соответствующие
отделы, сохранив при этом им должности. Внесите соответствующие изменения в
таблицы. Важно: id отделов в таблице department не изменять.  */
select * from department;
select * from employee;
select id from department where department like '%офис';
select * from employee where department=2;
update employee
set department=(select id from department where department like '%разработк%')
where ServiceId=5;
update employee
set department=(select id from department where department like '%аналитик%')
where ServiceId=6;
delete from department where id=2;

-- 11. Посчитайте количество сотрудников отдела разработки.
select count(*) from employee
join department on employee.department=department.id
group by department.department
having department.department like '%разработк%';

/*  12. В компанию взяли 2 новеньких сотрудника в отдел сопровождения на должности
инженер сопровождения. ФИО: Матрешкин Олег Геннадьевич и Широкова Мария
Валерьевна. Обогатите данными соответствующую таблицу.
P.S. При добавлении данных, не указывайте и не вставляйте данные в столбец
ServiceId.  */
insert into department(id, department, description_dep)
values (7, 'отдел сопровождения', 'сопровождение');

insert into employee(LastName, FirstName, MiddleName, `Position`, department)
values
('Матрешкин', 'Олег', 'Геннадьевич', 'инженер сопровождения',7),
('Широкова', 'Мария', 'Валерьевна', 'инженер сопровождения',7);

-- 13. Сотрудники Алексеев Алексей с должностью аналитик и Исаев Илья уволились.
-- Внесите изменения в таблицу используя один запрос.
select * from employee;
delete from employee where ServiceId in (1,3);

-- 14. Покажите количество сотрудников в каждом отделе. Используйте данные из одной таблицы employee.
select department, count(LastName) from employee group by department;

-- 15. Покажите ФИО сотрудников и наименования отделов, в которых они работают.
select LastName,FirstName, MiddleName, department.department from employee
join department on employee.department=department.id;

-- 16. Покажите отделы, в которых количество сотрудников, больше 2. (Решить с помощью JOIN).
select department.department, count(LastName) as quantity from employee
join department on employee.department=department.id
group by department.department
having quantity>2;

-- 17. Выполните левостороннее соединение двух таблиц. Выполните правостороннее соединение двух таблиц. 
-- Объясните разницу между 2мя запросами.
select * from department left join employee on employee.department=department.id; -- 14 rows
select * from department right join employee on employee.department=department.id; -- 12 rows

-- 18. Покажите отделы, должности и количество работников в каждом отделе, у которых руководящая должность. (Решить с помощью JOIN).
select department.department, employee.position, count(LastName) as quantity from employee
join department on employee.department=department.id
group by department.department, employee.position
having employee.position like '%руководитель%';

/* 19. У нас в отделе тестирования хорошие новости! Алёна стала руководителем тестирования и обещала устроить пир. 
Прежде чем ты отправишься праздновать, нужно внести изменения в БД. Сделай это) */
update employee
set employee.position='руководитель отдела'
where ServiceId=(
select ServiceId from( -- нужен, чтобы избежать ошибку
select ServiceId from employee -- ищет ServiceId
join department on employee.department=department.id where department.department like '%тестировани%' and FirstName='Алена') as t);

-- 20. Выполни еще раз запрос № 18 и запиши в комментарии общее количество руководителей.
-- 3