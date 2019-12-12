/* 
 * задача 2. Создайте базу данных example, разместите в ней таблицу users,
*состоящую из двух столбцов, числового id и строкового name.
*/



-- создание БД
CREATE DATABASE IF NOT EXISTS example;
USE example;
-- создание таблицы с 2 столбцами
CREATE TABLE IF NOT EXISTS users(
-- столбец id цифровой тип
  id INT UNSIGNED,
-- строковый столбец name
  name VARCHAR(30)
);

