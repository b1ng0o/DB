-- АГрегация данных

/*Задание 1 Подсчитайте средний возраст пользователей в таблице users*/


SELECT
  round(AVG ((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25), 1) as AGE
FROM
  users;
  
 /*Задание 2 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
  *Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
 
 
select 
 COUNT(*) as Total, -- количество записей
 DAYNAME (CONCAT_WS('-', YEAR (CURRENT_DATE), DATE_FORMAT(birthday_at, '%m-%d' ))) as week_day -- день недели(склеиваем строку через -  Год(текущей даты) и месяца и дня даты рождения
FROM users 
 group by week_day -- групируем по дню недели
 order by (WEEKDAY (CONCAT_WS('-', YEAR (CURRENT_DATE), DATE_FORMAT(birthday_at, '%m-%d' )))); -- сортируем по порядку дней недели
