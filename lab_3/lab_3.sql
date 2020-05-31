USE lab_3;

CREATE TABLE telephone_user
	(id_telephone_user int identity PRIMARY KEY NOT NULL,
	 first_name varchar(20) NOT NULL,
	 last_name varchar(20) NOT NULL,
	 gender bit,
	 birthday datetime)

CREATE TABLE telephone
	(id_telephone int identity PRIMARY KEY NOT NULL,
	 id_telephone_user int NOT NULL,
	 telephone_number varchar(12) NOT NULL,
	 tariff varchar(20),
	 region_registration varchar(50)
	 )

CREATE TABLE telephone_service
	(id_telephone_service int identity PRIMARY KEY NOT NULL,
	 id_type_of_service int NOT NULL,
	 id_telephone int NOT NULL,
	 name_service varchar(20) NOT NULL,
	 price money
	 )

CREATE TABLE type_of_service
	(id_type_of_service int identity PRIMARY KEY NOT NULL,
	 category varchar(15) NOT NULL,
	 amount int NOT NULL
	 )

CREATE TABLE payment
	(id_payment int identity PRIMARY KEY NOT NULL,
	 id_telephone_user int NOT NULL,
	 id_telephone_service int NOT NULL,
	 price money,
	 date date)


--INSERT

INSERT INTO telephone_user VALUES ('Stepan', 'Pankov', 1, '2000-05-18T23:15:05');

SELECT * FROM telephone_user;

INSERT INTO telephone_user VALUES ('Mariya', 'Belova', 0, '1987-11-02T07:23:00');
INSERT INTO telephone_user VALUES ('Kseniya', 'Ivanova', 0, '1994-07-12T06:47:45');
INSERT INTO telephone_user VALUES ('Nikolay', 'Petrov', 1, '1964-02-18T15:15:10');
INSERT INTO telephone_user VALUES ('Nikita', 'Frolov', 1, '1996-09-07T17:55:30');
INSERT INTO telephone_user VALUES ('Oleg', 'Petuhov', 1, '2002-01-26T22:35:20');
INSERT INTO telephone_user VALUES ('Evgeniya', 'Kalashnikova', 0, '2001-10-05T20:10:40');

SELECT *FROM telephone_user;

INSERT INTO telephone (id_telephone_user, telephone_number, tariff, region_registration) VALUES (1,'+79873653212', 'Internet+', 'Mari El');

SELECT * FROM telephone;

INSERT INTO telephone (id_telephone_user, telephone_number, tariff, region_registration) VALUES (2,'+79991010212', 'Internet+', 'Mari El');
INSERT INTO telephone (id_telephone_user, telephone_number, tariff, region_registration) VALUES (3,'+79991231233', 'Internet+', 'Mari El');
INSERT INTO telephone (id_telephone_user, telephone_number, tariff, region_registration) VALUES (4,'+79991122334', 'Internet+', 'Krasnodar');

SELECT * FROM telephone;

INSERT INTO telephone_service (id_type_of_service, name_service, id_telephone) SELECT id_type_of_service, category,
(SELECT id_telephone FROM telephone) FROM type_of_service;

SELECT * FROM telephone_service;

--DELETE

DELETE telephone_user;

DELETE FROM telephone WHERE id_telephone_user = 4;

TRUNCATE TABLE telephone;


--UPDATE

UPDATE telephone SET tariff = 'SMS+MMS';

SELECT * FROM telephone_user;

UPDATE telephone_user SET first_name = 'Anton', last_name = 'Rakov' WHERE id_telephone_user = 1;

--SELECT

SELECT first_name, last_name, birthday FROM telephone_user;

SELECT * FROM telephone_user;

SELECT * FROM telephone_user WHERE gender = 1;


--SELECT ORDER BY + TOP (LIMIT)

SELECT TOP 3 * FROM telephone_user ORDER BY first_name ASC;

SELECT * FROM telephone_user ORDER BY first_name DESC;

SELECT * FROM telephone_user ORDER BY first_name, last_name ASC;

SELECT first_name, last_name FROM telephone_user ORDER BY 1;

--DATATIME

SELECT * FROM telephone_user WHERE birthday = '2000-05-18T23:15:05';

SELECT YEAR (birthday) AS year_birthday FROM telephone_user;

--SELECT GROUP BY

--MIN

SELECT id_telephone_user, MIN(price) AS min_price FROM payment GROUP BY id_telephone_user;

--MAX

SELECT id_telephone_user, MAX(price) AS max_price FROM payment GROUP BY id_telephone_user;

--AVG

SELECT id_telephone_user, AVG(price) AS avg_price FROM payment GROUP BY id_telephone_user;

--SUM

SELECT id_telephone_user, SUM(price) AS sum_price FROM payment GROUP BY id_telephone_user;

--COUNT

SELECT id_telephone_user, COUNT(price) AS count_price FROM payment GROUP BY id_telephone_user;

--SELECT GRUOP BY + HAVING

SELECT id_telephone_user, MIN(price) AS min_price FROM payment GROUP BY id_telephone_user HAVING MIN(price) < 800;

SELECT id_telephone_user, MAX(price) AS max_price FROM payment GROUP BY id_telephone_user HAVING MAX(price) > 500;

SELECT id_telephone_user, SUM(price) AS sum_price FROM payment GROUP BY id_telephone_user HAVING SUM(price) > 800;

--SELECT JOIN

SELECT * FROM telephone_user LEFT JOIN telephone ON telephone_user.id_telephone_user = telephone.id_telephone_user
WHERE YEAR(birthday) > 1999;

SELECT * FROM telephone RIGHT JOIN telephone_user ON telephone.id_telephone_user = telephone_user.id_telephone_user 
WHERE YEAR(birthday) >1999;

SELECT * FROM telephone_user LEFT JOIN telephone ON telephone_user.id_telephone_user = telephone.id_telephone_user
LEFT JOIN payment ON telephone_user.id_telephone_user = payment.id_telephone_user
WHERE price > 500 AND gender = 1 AND YEAR(birthday) > 1999;

SELECT * FROM telephone_user FULL OUTER JOIN payment ON telephone_user.id_telephone_user = payment.id_telephone_user;

--SUBQUERIES

SELECT * FROM telephone_user WHERE birthday NOT IN('1995-02-01T12:12:12', '2005-05-13T23:12:13');

SELECT id_telephone_user, first_name, last_name,
(SELECT region_registration FROM telephone WHERE telephone.id_telephone_user = telephone_user.id_telephone_user) AS region 
FROM telephone_user;



INSERT INTO payment VALUES ( 1, 1, 1000, '2020-01-30T03:00:00');
INSERT INTO payment VALUES ( 2, 2, 200, '2020-01-30T03:00:00');
INSERT INTO payment VALUES ( 3, 3, 500, '2020-01-30T03:00:00');
INSERT INTO payment VALUES ( 1, 1, 1200, '2020-02-02T03:00:00');
INSERT INTO payment VALUES ( 2, 2, 600, '2020-02-02T03:00:00');
INSERT INTO payment VALUES ( 3, 3, 400, '2020-02-02T03:00:00');

SELECT * FROM payment;
TRUNCATE TABLE payment;

SELECT * FROM telephone;

