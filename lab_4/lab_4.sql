USE lab_4;

-- 1. Добавить внешние ключи.

ALTER TABLE room
ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel);

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category);

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room (id_room);

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking);

ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client (id_client);

-- 2.Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г

SELECT client.id_client, client.name, client.phone FROM client
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' AND room_category.name = 'Люкс' AND (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01');

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля.

SELECT * FROM room WHERE id_room NOT IN (
	SELECT room.id_room FROM room_in_booking RIGHT JOIN room ON room.id_room = room_in_booking.id_room
	WHERE room_in_booking.checkin_date <= '2019-04-22' AND room_in_booking.checkout_date >= '2019-04-22'
	)
ORDER BY id_room;

-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров

SELECT room_category.name, COUNT(room_in_booking.id_room) AS live_room FROM room_category
INNER JOIN room ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
INNER JOIN room_in_booking ON room_in_booking.id_room = room.id_room
WHERE hotel.name = 'Космос' AND (room_in_booking.checkin_date <= '2019-03-23' AND room_in_booking.checkout_date > '2019-03-23')
GROUP BY room_category.name;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда.

SELECT room.id_room, client.id_client, client.name, client.phone, room_in_booking.checkout_date FROM client
INNER JOIN booking ON client.id_client = booking.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN (SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS last_checkout_date
			FROM (SELECT * FROM room_in_booking WHERE room_in_booking.checkout_date BETWEEN '2019-04-01' AND '2019-04-30') AS room_in_booking
			GROUP BY room_in_booking.id_room) AS booking_room ON booking_room.id_room = room_in_booking.id_room
INNER JOIN room ON room_in_booking.id_room = room.id_room
INNER JOIN (SELECT * FROM hotel WHERE hotel.name = 'Космос') AS hotel ON hotel.id_hotel = room.id_hotel
WHERE (room_in_booking.id_room = booking_room.id_room AND booking_room.last_checkout_date = room_in_booking.checkout_date)
ORDER BY room.id_room;

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая

UPDATE room_in_booking
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM room
INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
WHERE hotel.name = 'Космос' AND room_category.name = 'Бизнес' AND room_in_booking.checkout_date = '2019-05-10';

-- 7. Найти все "пересекающиеся" варианты проживания.

SELECT * FROM room_in_booking room_booking_1, room_in_booking room_booking_2
WHERE room_booking_1.id_room = room_booking_2.id_room AND room_booking_1.id_booking != room_booking_2.id_booking AND 
	(room_booking_1.checkin_date <= room_booking_2.checkin_date AND room_booking_2.checkin_date < room_booking_1.checkout_date)
ORDER BY room_booking_1.id_room_in_booking;

-- 8.Создать бронирование в транзакции.

BEGIN TRANSACTION
	INSERT INTO client VALUES ('Панков Алексей Михайлович', '7(826)435-20-45')
	INSERT INTO booking VALUES (SCOPE_IDENTITY(), '2019-06-11')
	INSERT INTO room_in_booking VALUES (SCOPE_IDENTITY(), 147, '2019-07-11', '2019-07-25')
COMMIT;

-- 9. Добавить необходимые индексы для всех таблиц

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON [dbo].[booking]
(
	[id_client] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON [dbo].[room_in_booking]
(
	[id_booking] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON [dbo].[room_in_booking]
(
	[id_room] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON [dbo].[room]
(
	[id_room_category] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_id_hotel] ON [dbo].[room]
(
	[id_hotel] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_name] ON [dbo].[hotel]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_category_name] ON [dbo].[room_category]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkout_date] ON [dbo].[room_in_booking]
(
	[checkout_date] ASC
)