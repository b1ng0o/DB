/* 
 * задача 2. Создайте базу данных example, разместите в ней таблицу users,
*состоящую из двух столбцов, числового id и строкового name.
*/



-- создание БД
CREATE DATABASE IF NOT EXISTS example;
USE example;
-- создание таблицы с 2 столбцами
CREATE TABLE IF NOT EXISTS users(
-- столбец id цифровое значение начинающееся с 1 и увиличивающееся на 1 если такого номера нет
  id INT NOT NULL auto_increment primary key,
-- строковый столбец name
  name VARCHAR(30)
);

