/*1.В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
  Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.*/
START TRANSACTION; -- запускаем транзакцию
	INSERT INTO sample.users -- вставляем в sample.users
		SELECT * -- всю запись 
		FROM shop.users -- из таблицы shop.users 
		WHERE id = 1; -- где id пользователя 1
COMMIT; -- подтверждаем транзакцию



/*2.Создайте представление, которое выводит название name товарной позиции из таблицы products
 * и соответствующее название каталога name из таблицы catalogs.*/ 

drop view if exists full_name; -- удаляем представление если такое существовало
CREATE VIEW full_name as -- создаем представление 
select -- обьеденяем таблицы по полям name 
products.name,
catalogs.name as c_name
FROM products 
JOIN catalogs on catalogs.id = products.catalog_id; -- указываем что id каталога равно catalog_id таблицы products
 

select * from full_name; -- проверяем


/*3.Создайте двух пользователей которые имеют доступ к базе данных shop. 
 Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
 второму пользователю shop — любые операции в пределах базы данных shop.*/

-- По идее команда grant должна создать юзера если такого нет. но пришлось создавать командой create, потому что была ошибка You are not allowed to create a user with grant. ПОчему?

drop user if exists shop_read;-- удаляем пользователя если он существует
create user shop_read; -- создаем пользователя 
grant select on shop.* to shop_read; --  даем права на чтение ко всем таблицам базы shop

drop user if exists shop;
create user shop;-- удаляем пользователя если он существует
GRANT ALL ON shop.* TO shop; --  Даем все привелегии к базе shop

SELECT Host, User FROM mysql.user;

/*4.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/



DROP FUNCTION IF EXISTS hello; -- удаляем функцию сли он существует

DELIMITER // -- меняем делиметр на //

CREATE FUNCTION hello() -- создаем функцию
RETURNS TEXT deterministic -- возвращает тектовое значение, детерменирована так как возвращает одно и тоже значение
begin
	DECLARE hour TIME DEFAULT HOUR(CURTIME()); -- обьявляем переменную значение которой по умолчанию час настоящего времени
    IF hour >= 6 AND hour < 12 THEN RETURN 'Доброе утро!'; -- используем условие для вычисления часа и возврата необходимого сообщения 
    ELSEIF hour >= 12 AND hour < 18 THEN RETURN 'Добрый день!';
    ELSEIF hour >= 18 AND hour <= 23 THEN RETURN 'Добрый вечер!';
    ELSE RETURN 'Доброй ночи!';
    END IF; -- закрываем блок IF
END// -- заканчиваем блок функции 
DELIMITER ; -- меняем делиметр на ;

select hello(); -- проверяем



/*5/В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

drop trigger if exists insert_prod; -- удаляем тригер если он существует
delimiter // -- меняем делиметр
create trigger insert_prod before insert on products -- создаем тригер который срабатывает до внесения данных в таблицу
for each row -- тригер будет запускаться для каждой обрабатываемой строки
begin
	if new.name is null and new.description is null then -- если оба новых значения null 
	signal sqlstate '45000' -- передаем пользователькую ошибку
	set message_text = 'name and description are null'; -- с таким текстом
	end if; -- закончили блок if
end// -- закончили создание триера

drop trigger if exists update_products//  -- удаляем тригер если он существует
create trigger update_products befor update on products -- создаем тригер который срабатывает до обновления  данных в таблице
for each row -- тригер будет запускаться для каждой обрабатываемой строки
begin
	if new.name is null and new.description is null then -- если оба новых значения null 
	signal sqlstate '45000' -- передаем пользователькую ошибку
	set message_text = 'name and description are null';   -- с таким текстом
	end if;  -- закончили блок if
end// -- закончили создание триера

