/* 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/

select 
	users.id, -- id пользователя
	users.name, -- имя пользователя 
	orders.id as order_id, -- id заказа
	orders.created_at -- время создания заказа
from users  -- берем таблицу users
join orders on users.id = orders.user_id -- и таблицу orders, сопостовляя id user'а и user_id из order


/*2.Выведите список товаров products и разделов catalogs, который соответствует товару.*/

select 
	p.name as product_name, -- Название товара
	catalogs.name as cat_name -- Название каталога в котором находится товар
from products p -- берем таблицу товары
	join catalogs on catalogs.id= p.catalog_id -- таблицу каталогов и сопостовляем id каталога в талицах catalogs и products
where p.name = 'AMD FX-8320E' -- отбираем товар по названию

