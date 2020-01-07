/*Задание 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем*/

update shop.users set
created_at = NOW(), -- устанавливает для столбца created_at
updated_at = NOW() -- устанавливает для столбца updated_at
where created_at is null or updated_at is NULL; -- только для значений null в одном из стобцов


/*Задание 2. Таблица users была неудачно спроектирована. 
*Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
*Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.*/

-- Проверяем смену формата
select STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i') 
from users;
-- обновляем формат даты в колонке таблицы
update users 
set updated_at = str_to_date(updated_at, '%d.%m.%Y %H:%i');
-- меняем тип данных VARCHAR с на DATETIME
ALTER TABLE shop.users MODIFY COLUMN updated_at DATETIME; 

-- Проверяем смену формата
select STR_TO_DATE(created_at, '%d.%m.%Y %H:%i') 
from users;
-- обновляем формат даты в колонке таблицы
update users
set created_at = str_to_date(created_at, '%d.%m.%Y %H:%i');
-- меняем тип данных VARCHAR с на DATETIME
ALTER TABLE shop.users MODIFY COLUMN created_at DATETIME; 


/*Задание 3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
 *если товар закончился и выше нуля, если на складе имеются запасы. 
 *Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
 *Однако, нулевые запасы должны выводиться в конце, после всех записей.*/

select * from storehouses_products order by if(value, 0, 1), value; -- выводит список по возрастанию, но нулевые позиуии ноходятся внизу списка
