USE lab_5

--1. Добавить внешние ключи

ALTER TABLE [order]
ADD FOREIGN KEY (id_production) REFERENCES [production] (id_production);

ALTER TABLE [order]
ADD FOREIGN KEY (id_dealer) REFERENCES [dealer] (id_dealer);

ALTER TABLE [order]
ADD FOREIGN KEY (id_pharmacy) REFERENCES [pharmacy] (id_pharmacy);

ALTER TABLE [dealer]
ADD FOREIGN KEY (id_company) REFERENCES [company] (id_company);

ALTER TABLE [production]
ADD FOREIGN KEY (id_company) REFERENCES [company] (id_company);

ALTER TABLE [production]
ADD FOREIGN KEY (id_medicine) REFERENCES [medicine] (id_medicine);

--2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.

SELECT pharmacy.name, date, quantity FROM medicine
INNER JOIN production ON medicine.id_medicine = production.id_medicine
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN [order] ON production.id_production = [order].id_production
INNER JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус'

--3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

SELECT medicine.name FROM medicine
INNER JOIN production ON medicine.id_medicine = production.id_medicine
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN [order] ON production.id_production = [order].id_production
WHERE company.name = 'Фарма' AND production.id_production NOT IN (SELECT [order].id_production FROM [order] WHERE [order].date < '2019-01-25')
GROUP BY medicine.name;

--4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.

SELECT company.name, MIN(production.rating) AS min_rating, MAX(production.rating) AS max_rating FROM company
INNER JOIN production ON company.id_company = production.id_company
INNER JOIN [order] ON production.id_production = [order].id_production
GROUP BY company.name HAVING COUNT([order].id_order) >= 120;

--5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT dealer.name, pharmacy.name FROM dealer
LEFT JOIN [order] ON dealer.id_dealer = [order].id_dealer
LEFT JOIN company ON dealer.id_company = company.id_company
LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
WHERE company.name = 'AstraZeneca' ORDER BY dealer.name;

--6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.

UPDATE production SET production.price = production.price * 0.8
WHERE production.price > 3000 AND production.id_medicine IN (SELECT medicine.id_medicine FROM medicine WHERE cure_duration <= 7)

--7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON [dbo].[production]
(
	id_medicine ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [dbo].[order]
(
	id_production ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON [dbo].[production]
(
	id_company ASC
)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON [dbo].[production]
(
	rating ASC
)

CREATE NONCLUSTERED INDEX [IX_company_name] ON [dbo].[company]
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON [dbo].[medicine]
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [dbo].[order]
(
	id_dealer ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [dbo].[order]
(
	id_pharmacy ASC
)
INCLUDE ([date], [quantity])

CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON [dbo].[dealer]
(
	id_company ASC
)
INCLUDE ([name])