use autoshop;
-- ----------------------------------
-- select запрос выводящий id, полное имя и номер телефона клиента. запрос сортирует данные по алфавиту по имени клиентов.
select 
	id,   -- поле id клиента
	concat_ws(' ', firstname, lastname) as FullName, -- с помощью concate_ws объединяем столбы firstname и lastname через разделитель ' '
	phone -- поле с номером телефона
from customers -- из таблицы клиентов
order by fullname; -- сортировка по столбцу fullname
-- ---------------------------------
-- запрос выводяй количество машин в продаже в городах
select 
	count(*) as auto_sum, -- concate показывает количество записей(машин)
	city_id -- id города в котором продаются машины
from cars 
where cars.sale_status = 'sale' -- отбираем по условию только машины со статусом продается
group by city_id; -- групируем по городам


-- --------------------------------------
-- запрос с вложеным запросом, покажет полное имя клиента, номер телефона, машины купленные клиентом
select 
	concat_ws(' ', c1.firstname, c1.lastname) as full_customers_name, --  с помощью concate_ws объединяем столбы firstname и lastname через разделитель ' '
	c1.phone, -- телефон клиента 
	(select 							-- вложенный запрос  получени объедененной строки с название бренда и модели авто клиента
			concat_ws(' ', brands.brand_name,models.model_name) --   с помощью concate_ws объединяем столбы   brands.brand_name,models.model_name через разделитель ' '
		from cars  -- из таблицы авто 
		join brands on cars.brand_id = brands.id -- беря значения из  таблицы brands где  brand_id таблицы car  = id таблицы brands
		join models on cars.model_id = models.id -- беря значения из  таблицы models где  model_id таблицы car  = id таблицы models
		where cars.id = c2.id -- беря только авто с id указаном в where с2
	) as auto_brand_model, 
	c2.sale_status -- статус продажи авто 
from orders o2  --
join customers c1 on o2.customer_id = c1.id  -- обьединяя таблицу customers  с таблицей order по id клиента 
join cars c2 on o2.car_id = c2.id -- обьединяя таблицу car  с таблицей order по id машины
where c2.id <45 and c2.sale_status = 'sale'; -- только авто с id меньше 45 и статусом продается

 -- ------------------------------------------------------------------------
-- представление выдащие полную информацию по машине

create or replace view full_car_statistic as -- создаем/изменяем без удаления представление
SELECT  
	cars.id, -- id автомобиля
	concat_ws(' ', brands.brand_name, models.model_name) as model, -- объединяем строки brand name  и model name через  ' ' 
	completesets.name as complects, --  имя комплектации 
	year(cars.year_auto), -- год автомобиля 
	cities.city_name as City, -- город продажи
	prices.price as price -- ценник 
FROM cars
join models on cars.model_id = models.id -- беря значения из  таблицы models где  model_id таблицы car  = id таблицы models
join brands on brands.id = cars.brand_id  -- беря значения из  таблицы brands где  brand_id таблицы car  = id таблицы brands
join completesets on cars.completeset_id = completesets.id -- обьединяя таблицу completesets  с таблицей  cars  по completeset_id
join prices on prices.car_id = cars.id -- обьединяя таблицу prices  с таблицей  cars  по car_id
join cities on cars.city_id = cities.id -- обьединяя таблицу cities  с таблицей  cars  по city_id
order by cars.id; -- сортируем по возратанию 

select * from full_car_statistic; -- проверяем полученый результат


-- -------------------------------------------------------- 
-- представление выдающее машины купленые клиентами
create or replace view customers_cars as  -- создаем/изменяем без удаления представление
select 
	cu.firstname,  -- берем имя из таблицы клиент
	cu.lastname, -- фамилию из таблицы клиент
	models.model_name, -- имя модели из таблицы cars
	brands.brand_name, -- имя бренда из таблицы cars
	cars.vin_car, -- вин код авто 
	cars.sale_status -- статус продажи
FROM cars
join models on cars.model_id = models.id -- обьединяя таблицу models  с таблицей  cars  по model_id
join brands on brands.id = cars.brand_id -- обьединяя таблицу brands  с таблицей  cars  по brand_id
join orders on orders.car_id = cars.id -- обьединяя таблицу orders  с таблицей  cars  по car_id
join customers cu on cu.id = orders.customer_id -- обьединяя таблицу customers  с таблицей  orders  по customer_id_id
where cars.sale_status = 'sold'; -- выбираем по условию только проданные авто

select * from customers_cars;  -- проверяем созданное представление 

 -- ------------------------------------------------------------------------
-- процедура которой передается id машины и она возвращает вин код, город продажи и цену

DROP PROCEDURE IF EXISTS autoshop.prod1; -- удаляем процедуру если существует

DELIMITER $$ -- заменяем делиметр

CREATE PROCEDURE prod1 (in use_car_id INT) -- создаем процедуру, передавая внутрь процедуры числовую переменную с  id автомобиля
begin
	select 
		models.model_name, -- имя модели из таблицы cars
		brands.brand_name, -- имя бренда из таблицы cars
		cars.vin_car, -- берем вин код машины
		cities.city_name, -- город расположения машины 
		prices.price	-- и цену продажи
	from cars -- из таблицы с машинами
	join models on cars.model_id = models.id -- обьединяя таблицу models  с таблицей  cars  по model_id
	join brands on brands.id = cars.brand_id -- обьединяя таблицу brands  с таблицей  cars  по brand_id
	join prices on prices.car_id = cars.id -- объединяя с таблицой цен по id машины
	join cities on cars.city_id = cities.id -- объединяя с таблицой городов по id города
	where cars.id = use_car_id; -- указываем что id машины должен соответствовать переданому аргументу
END$$
DELIMITER ; -- меняем делиметр на стандартный 

call prod1(12); -- вызыаем процедуру

 -- ------------------------------------------------------------------------
 
delimiter //

create trigger count_car after insert on cars -- создаем триггер который после вставки данных в таблицу cars 
for each row
begin
	select count(*) into @carcount from cars; -- присваивает переменной общее количество машин
end//

delimiter ;
INSERT INTO cars VALUES ('52','1','1','1','1','1','1','1971-04-22 12:38:58','1992-12-17 00:50:28','2002-09-12','sale','yuiuytyrtrfgfg'); -- добавляем машину
select @carcount;  -- проверяем значение переменной 

