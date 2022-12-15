Создание таблиц

create table SELLER (SNUM number(4) PRIMARY KEY,
SNAME varchar2(10), CITY varchar2(10), COMM number(7,2));

create table CUSTOMER (CNUM number(4) PRIMARY KEY,
CNAME varchar2(10), CITY varchar2(10), RATING number(3));

create table ORDERS (ONUM number(4) PRIMARY KEY, AMT number(7,2),
ODATE date, CNUM number(4), SNUM number(4),
FOREIGN KEY(CNUM) REFERENCES CUSTOMER(CNUM),
FOREIGN KEY(SNUM) REFERENCES SELLER(SNUM));

Наполнение данными

INSERT ALL
 INTO SELLER (SNUM, SNAME, CITY, COMM) VALUES (1001, 'Peel', 'London', 0.12)
 INTO SELLER (SNUM, SNAME, CITY, COMM) VALUES (1002, 'Serres', 'San Jose', 0.13)
 INTO SELLER (SNUM, SNAME, CITY, COMM) VALUES (1004, 'Motica', 'London', 0.11)
 INTO SELLER (SNUM, SNAME, CITY, COMM) VALUES (1007, 'Rifkin', 'Barcelona', 0.15)
 INTO SELLER (SNUM, SNAME, CITY, COMM) VALUES (1003, 'Axelrod', 'New York', 0.10)
SELECT* FROM dual;

INSERT ALL
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2001, 'Hoffman', 'London', 100)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2002, 'Giovanni', 'Rome', 200)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2003, 'Liu', 'San Jose', 200)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2004, 'Grass', 'Berlin', 300)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2006, 'Clemens', 'London', 100)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2008, 'Cisneros', 'San Jose', 300)
 INTO CUSTOMER (CNUM, CNAME, CITY, RATING) VALUES (2007, 'Pereira', 'Rome', 100)
SELECT* FROM dual;

INSERT ALL
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3001, 18.69, to_date('03.01.2020','dd.mm.yyyy'), 2008, 1007)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3003, 767.19, to_date('03.01.2020','dd.mm.yyyy'), 2001, 1001)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3002, 1900.10, to_date('03.01.2020','dd.mm.yyyy'), 2007, 1004)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3005, 5160.45, to_date('03.01.2020','dd.mm.yyyy'), 2003, 1002)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3006, 1098.16, to_date('03.01.2020','dd.mm.yyyy'), 2008, 1007)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3009, 1713.23, to_date('04.01.2020','dd.mm.yyyy'), 2002, 1003)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3007, 75.75, to_date('04.01.2020','dd.mm.yyyy'), 2004, 1002)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3008, 4723.00, to_date('05.01.2020','dd.mm.yyyy'), 2006, 1001)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3010, 1309.95, to_date('06.01.2020','dd.mm.yyyy'), 2004, 1002)
 INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES (3011, 9891.88, to_date('06.01.2020','dd.mm.yyyy'), 2006, 1001)
SELECT* FROM dual;

Запросы

1.	Выведите всех покупателей с рейтингом выше 100, проживающих в городах, в названии
которых вторая буква не равна o ””, а четвертая буква не равна e.

SELECT* FROM CUSTOMER
WHERE RATING>100 AND CITY NOT LIKE '_o_e'

2.	Запросите двумя способами все заказы на 3 и 4 января.

SELECT* FROM ORDERS
WHERE ODATE='03-JAN-20' OR ODATE='04-JAN-20'

SELECT* FROM ORDERS
WHERE ODATE IN ('03-JAN-20','04-JAN-20')

3.	Выведите сумму самого раннего заказа за каждую дату.

SELECT AMT, ONUM, ODATE
FROM ORDERS
WHERE ONUM IN
(SELECT MIN(ONUM)
FROM ORDERS
GROUP BY ODATE)

4.	Напишите запрос, который сосчитал бы сумму всех заказов для покупателей, которых
обслуживает продавец с именем Peel.

SELECT SUM(AMT) FROM ORDERS
WHERE SNUM IN
(SELECT SNUM FROM SELLER WHERE SNAME='Peel')

5.	Напишите запрос, который выводит все заказы, сумма которых больше средней по всем
заказам, используя подзапрос.

SELECT * FROM ORDERS
WHERE AMT >
(SELECT AVG(AMT) FROM ORDERS)

6.	Напишите запрос, который вывел бы для каждого заказа его номер, стоимость и имя
заказчика. Данные вывести для заказчиков, размещенных не в Лондоне и не в Риме.

SELECT ORDERS.ONUM, ORDERS.CNUM, ORDERS.AMT, CUSTOMER.CNAME
FROM ORDERS, CUSTOMER
WHERE ORDERS.CNUM=CUSTOMER.CNUM
AND NOT CUSTOMER.CITY='London' AND NOT CUSTOMER.CITY='Rome'

или

SELECT ORDERS.ONUM, ORDERS.CNUM, ORDERS.AMT, CUSTOMER.CNAME FROM ORDERS
INNER JOIN CUSTOMER ON ORDERS.CNUM=CUSTOMER.CNUM
WHERE NOT CUSTOMER.CITY='London' AND NOT CUSTOMER.CITY='Rome'


7.	Вывести пары имен покупатель продавец, которые совершили сделки не 4 и не 6
января, при этом сумма каждой сделки от 1000 до 5000. Отсортировать по возрастанию
суммы. Без использования подзапросов.

SELECT CUSTOMER.CNAME, SELLER.SNAME
FROM CUSTOMER, SELLER, ORDERS
WHERE ORDERS.CNUM=CUSTOMER.CNUM AND ORDERS.SNUM=SELLER.SNUM
AND NOT ORDERS.ODATE='04-JAN-20' AND NOT ORDERS.ODATE='06-JAN-20'
AND ORDERS.AMT BETWEEN 1000 AND 5000
ORDER BY ORDERS.AMT

или

SELECT CUSTOMER.CNAME, SELLER.SNAME FROM ORDERS
INNER JOIN SELLER ON ORDERS.SNUM=SELLER.SNUM
INNER JOIN CUSTOMER ON ORDERS.CNUM=CUSTOMER.CNUM
WHERE NOT ORDERS.ODATE='04-JAN-20' AND NOT ORDERS.ODATE='06-JAN-20'
AND ORDERS.AMT BETWEEN 1000 AND 5000
ORDER BY ORDERS.AMT


8.	Вывести сумму сделки и имена покупателей, которые совершили сделку 3 января, но в
городе отличном от города продавца.

SELECT ORDERS.AMT, CUSTOMER.CNAME
FROM ORDERS, CUSTOMER, SELLER
WHERE ORDERS.CNUM=CUSTOMER.CNUM AND ORDERS.SNUM=SELLER.SNUM
AND ORDERS.ODATE='03-JAN-20' AND CUSTOMER.CITY!=SELLER.CITY