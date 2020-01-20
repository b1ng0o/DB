
/* Задание 1.Пусть задан некоторый пользователь.
 *  Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. */

select
	(select firstname from users where id = messages.from_user_id) as user_sends_messages, -- Имя от кого было отправдено сооьщение 
	(select firstname from users where id = messages.to_user_id) as user_name, -- Имя кому было отправлено сообщение
	(SELECT status FROM friend_requests 					-- после статуса дружбы только подтвержденные 
		WHERE (initiator_user_id = messages.to_user_id or target_user_id = messages.to_user_id)
			and status = 'approved' -- только подтвержденные друзья
	) as friend_status,
 	 count(*) as messages -- количество сообщений
from messages
where to_user_id= 96 -- наш пользователь 
group by from_user_id -- групировка по юзеру отправителю
order by messages desc limit 1; -- сортируем по количеству сообщений в обратном порядке оставляя только самое большое количество

/*Задание 2.Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..*/



/*Задание 3.Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
alter table vk.users add sex enum('m', 'f') not null;  -- добавляем в таблицу users базы vk поле sex с значениями m или f

update users -- обновляем данные в талицы присваивая 'm'  пользователям чьи имена состоят из 5 символов
set sex = 'm' 
where firstname like '_____';

SELECT IF(											-- считаем количество лайков мужчин и количество лайков женщин, и выводим результат
	(SELECT COUNT(id) FROM LIKES WHERE user_id IN (
		SELECT id FROM users WHERE sex="m")
	) 
	> 
	(SELECT COUNT(id) FROM LIKES WHERE user_id IN (
		SELECT id FROM users WHERE sex="f")
	), 
   'male', 'female') as Likes;
   
 
		