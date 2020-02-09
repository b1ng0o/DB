DROP DATABASE IF EXISTS autoshop; -- удаляем базу  если она существует
CREATE DATABASE autoshop; -- создаем базу
USE autoshop; -- используем созданную базу 

DROP TABLE IF EXISTS brands; -- удаляем таблицу  если она существует
CREATE TABLE  brands( -- создаем таблицу
 id serial PRIMARY KEY,  -- первичный елюч 
 brand_name varchar(255) NOT NULL unique, -- имя бренда авто, не пусто, униклаьное
 contry varchar(255) not null, -- страна бренда
 index brands_brand_name(brand_name), -- индекс для поиска по брендам
 index brands_contry(contry) -- индекс для поиска по странам брендов
);

drop table if exists models;
create table models(
	id serial primary key,  -- первичный ключ
	brand_id BIGINT UNSIGNED NOT null, -- поле id бренда, числовое, положительное, не пустое
	model_name varchar(255) not null unique, -- имя модели, текстовое , уникальное, не пустое
	index models_name(model_name),	 -- индекс по названию модели
	foreign key (brand_id) references brands(id) -- внешний ключ поля brand_id на поле id таблицы  brands
);

drop table if exists engines; 
create table engines(
	id serial primary key,
	brand_id BIGINT UNSIGNED NOT null, -- поле id бренда, числовое, положительное, не пустое
	model_id bigint unsigned not null, -- поле id модели, числовое, положительное, не пустое
	engine_type varchar(255) not null, -- тип двигателя, текстовое, не пустое
	engine_volume FLOAT (3,1) unsigned not null, -- обьем двигателя, положительное число из 3 цифр, одна из которых после запятой, не пустое значение
	engine_power BIGINT UNSIGNED NOT null,  -- мощность двигателя  числовое положительное не пустое
	index engines_engine_type(engine_type),	-- индекс для поиска по типу двигателя 
	foreign key (brand_id) references brands(id), -- внешний ключ на бренд
	foreign key (model_id) references models(id) -- нешний ключ на модель
);

drop table if exists transmissions; 
create table transmissions( -- таблица трансмиссий 
	id serial primary key,
	brand_id BIGINT UNSIGNED NOT null,
	transm_type varchar(255) unique, -- тип трансмиссии, уникальный 
	foreign key (brand_id) references brands(id) --внешний  ключ на бнед
);

drop table if exists completesets; -- таблица комплектаций авто
create table completesets( -- таблица комплектаций авто
	id serial primary key,
	model_id BIGINT UNSIGNED NOT null,-- id модели 
	brand_id BIGINT UNSIGNED NOT null, -- id бренда
	name varchar(255) not null unique, -- название комплектаций
	engines_id BIGINT UNSIGNED NOT null, -- id двигателя 
	transm_id BIGINT UNSIGNED NOT null,-- id трансмиссии 
	wheel_drive enum('FWD', '4WD', 'RWD', 'AWD') default 'FWD' not null, -- типа привода авто, не пустое, по умолчанию FWD
	index completesets_name(name),	 -- индекс для поиска по комплектации авто 
	foreign key (model_id) references models(id), -- ключ на модел
	foreign key (brand_id) references brands(id), -- ключ на бренд
	foreign key (engines_id) references engines(id), -- ключ на двигатель 
	foreign key (transm_id) references transmissions(id) -- ключ на трансмиссию 
);

drop table if exists cities; 
create table cities( -- таблица городов
	id serial primary key,
	city_name Varchar(255) NOT null unique -- имя города
	); 

drop table if exists cars; 
create table cars( -- таблица автомобилей
	id serial primary key,
	model_id BIGINT UNSIGNED NOT null,-- id модели 
	brand_id BIGINT UNSIGNED NOT null, -- id бренда
	engines_id BIGINT UNSIGNED NOT null, -- id двигателя 
	transm_id BIGINT UNSIGNED NOT null,-- id трансмиссии 
	completeset_id BIGINT UNSIGNED NOT null, -- id комплектации
	city_id BIGINT UNSIGNED NOT null, -- id города 
	created_at DATETIME DEFAULT NOW(), -- дата создания 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- дата обновления 
	year_auto DATE not null, -- год авто
	sale_status enum ('sale', 'sold') default 'sale' not null, -- статус продажи, по умолчанию sale, не пустое
	vin_car varchar(255) not null unique, -- вин код автомобиля, текстовый, не пустое, уникальное 
	index cars_year_auto(year_auto),	 -- индекс для поиска по году выпуска 
	-- внешние ключи на комплектацию, модель, бренд, двигатель, город, трансмиссию
	foreign key (completeset_id) references completesets(id),
	foreign key (model_id) references models(id),
	foreign key (brand_id) references brands(id),
	foreign key (engines_id) references engines(id),
	foreign key (city_id) references cities(id),
	foreign key (transm_id) references transmissions(id)
);

DROP TABLE IF EXISTS sellers;
CREATE TABLE  sellers( -- таблица продавцов
 id serial PRIMARY KEY,
 car_id bigint unsigned not null, -- id машины положительное не пустое
 seller_name varchar(255) NOT NULL unique, -- название продавца уникальное не пусток 
  foreign key (car_id) references cars(id) -- ключ на автомобиль
 );

DROP TABLE IF EXISTS customers; 
CREATE TABLE  customers( -- таблица клиентов 
 	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50), -- имя, текстовое
    lastname VARCHAR(50), -- фамилия, текстовое
    email VARCHAR(120) UNIQUE, -- электронная почта, текстовое уникальное 
    phone BIGINT,  -- телефон, цифровое
    INDEX customers_phone_idx(phone),  -- индекс поиска по номеру телефона 
    INDEX customers_firstname_lastname_idx(firstname, lastname) -- индекс поиска по имени и фамилиии
    
);

DROP TABLE IF EXISTS prices;
CREATE TABLE  prices( -- таблица с ценами 
 id serial PRIMARY KEY,
 car_id bigint unsigned not null, -- машины , положительное не пустое
 price bigint NOT NULL, -- цена, числовое, не пустое 
  foreign key (car_id) references cars(id) -- ключ на машину
 );

drop table if exists orders;
create table orders( -- таблица с заказами
	id serial primary key,
	customer_id bigint unsigned not null, -- код клиента
	car_id bigint unsigned not null, -- код авто
	price_id bigint unsigned not null, -- код цены
	created_at DATETIME DEFAULT NOW(), -- дата создания 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- дата обновления 
	foreign key (car_id) references cars(id), -- ключ на авто 
	foreign key (customer_id) references customers(id), -- ключ на клиента 
	foreign key (price_id) references prices(id) -- ключ на цену
);
