--Создание базы данных Store
CREATE DATABASE Store  
ON   
( NAME = Store_dat,  
    FILENAME = 'E:\MSSM SQL Projects\1\store_dat.mdf',  
    SIZE = 10,  
    MAXSIZE = 50,  
    FILEGROWTH = 5 )  
LOG ON  
( NAME = Store_log,  
    FILENAME = 'E:\MSSM SQL Projects\1\DATAstore_log.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 25MB,  
    FILEGROWTH = 5MB ) 
	Collate Cyrillic_General_CI_AS;
GO

USE Store;

--Таблица 1 – покупатель
CREATE TABLE Customer 
(
	CustomerID int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(30) NOT NULL,
	DateOfBirth date NOT NULL CHECK (DateDiff(YY, DateOfBirth, GETDATE()) >= 12),
	Gender nvarchar(6) NOT NULL CHECK (Gender IN ('Male', 'Female')),
	PhoneNumber char(16) CHECK (PhoneNumber LIKE '+7([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
	Email nvarchar(40),
	BonusNumber float NOT NULL CHECK (BonusNumber >= 0),
	CHECK (PhoneNumber IS NOT NULL OR Email IS NOT NULL)
)
 
 --Таблица 2 - издательство
CREATE TABLE PubHouse
(
	HouseId int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(30) UNIQUE NOT NULL,
	Address nvarchar(80) NOT NULL,
	DateOfSet date NOT NULL CHECK (DateOfSet <= GETDATE()),
	PhoneNumber char(16) CHECK (PhoneNumber LIKE '+7([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
	Email nvarchar(40) NOT NULL
)

--Таблица 3 серия книг
CREATE TABLE Series
(
	SeriesId int IDENTITY(1,1) PRIMARY KEY,
	PubHouseId int,
    FOREIGN KEY (PubHouseId) REFERENCES PubHouse(HouseId) ON DELETE CASCADE,
	Name nvarchar(30) NOT NULL UNIQUE,
	DateOfSet date NOT NULL,
)

--Таблица 4 Автор
CREATE TABLE Author
(
	AuthorId int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(80) NOT NULL,
	DateOfBirth date NOT NULL CHECK (DateDiff(YY, DateOfBirth, GETDATE()) >= 18),
)

--Таблица 5 книга 
CREATE TABLE Book
(
	BookId int IDENTITY(1,1) PRIMARY KEY,
	SeriesNumber int,
	FOREIGN KEY (SeriesNumber) REFERENCES Series(SeriesId) ON DELETE CASCADE,
	Name nvarchar(50) NOT NULL,
	DateOfSet date NOT NULL CHECK (DateOfSet <= GETDATE()),
	Price float NOT NULL CHECK (Price BETWEEN 50 AND 10000),
	Genre nvarchar(40) NOT NULL CHECK (Genre IN (
	'Художественная литература', 
	'Компьютерная литература',
	'Книги для детей',
	'Образование',
	'Наука и техника',
	'Общество',
	'Деловая литература',
	'Красота. Здоровье. Спорт',
	'Увлечения',
	'Психология',
	'Эзотерика',
	'Философия и религия',
	'Искусство'
)),
	Censor nvarchar(3) NOT NULL CHECK(Censor IN (
	'0+',
	'6+',
	'12+',
	'16+',
	'18+'
))
)
--промежуточные таблицы для связи многие ко многим
--Таблица продаж книг покупателям
CREATE TABLE Sales
(
	SalesId int IDENTITY(1, 1) PRIMARY KEY,
	cust_id int,
	book_id int,
	DateOfSale date NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (cust_id) REFERENCES Customer(CustomerId) ON DELETE CASCADE,
	FOREIGN KEY (book_id) REFERENCES Book(BookId) ON DELETE CASCADE,
)

--таблица соответсвия между авторами и книгами.
CREATE TABLE auth_book
(
	auth_id int,
	books_id int,
	PRIMARY KEY(auth_id, books_id),
	FOREIGN KEY (auth_id) REFERENCES Author(AuthorId) ON DELETE CASCADE,
	FOREIGN KEY (books_id) REFERENCES Book(BookId) ON DELETE CASCADE
)



--Вставка значений в табллицы	
INSERT PubHouse (Name, Address, DateOfSet, PhoneNumber, Email) VALUES 
('Даръ', 'г. Первомайский, ул. Полины Осипенко, дом 27', '2000-04-08', '+7(123)456-11-12', 'lavanda@mail.ru'),
('Захаров', 'г. Кушва, ул. Будайская, дом 73', '2001-03-08', '+7(923)454-72-19', 'zas1@mail.ru'),
('Алаборг', 'г. Первомайский, ул. Полины Осипенко, дом 27', '2004-06-01', '+7(233)456-00-19', 'yard01@mail.ru'),
('Десяточка', 'г. Усть-Лабинск, ул. Высокая, дом 10', '1999-01-11', '+7(142)456-70-39', 'ala0a@mail.ru'),
('Златоуст', 'г. Чунский, ул. Колокольников Переулок, дом 6', '2009-04-08', '+7(705)456-76-41', 'nba@mail.ru'),
('Мега', 'г. Муезерский, ул. Пересветов Переулок, дом 43', '2019-01-08', '+7(475)456-22-59', 'zaltoyst0@mail.ru'),
('Импэто', 'г. Торбеево, ул. Пермская, дом 47', '2000-02-01', '+7(474)456-72-19', 'megafon@mail.ru'),
('СО РАН', 'г. Каргаполье, ул. Ростовская Набережная, дом 84', '1988-03-25', '+7(475)456-11-62', 'wefwef@mail.ru'),
('Инфра-М', 'г. Курья, ул. Столешников Переулок, дом 91', '1983-02-27', '+7(343)456-27-44', 'infomed2019@mail.ru'),
('Коло', 'г. Кущевская, ул. Щербинская, дом 76', '1979-06-30', '+7(654)456-23-81', 'greer@mail.ru'),
('Лань', 'г. Горняк, ул. Народного Ополчения, дом 87', '2000-01-08', '+7(633)956-72-15', 'fewf@mail.ru'),
('Мирт', 'г. Губкин, ул. Южнопортовый 2-й Проезд, дом 63', '1899-02-28', '+7(634)456-10-00', 'gweg@mail.ru'),
('Алба', 'г. Первомайский, ул. Полины Осипенко, дом 27', '2012-12-12', '+7(235)452-74-39', 'ewfwe@mail.ru'),
('Петроний', 'г. Дмитриев-Льговский, ул. Жданова, дом 46', '2003-04-01', '+7(645)956-25-74', 'fewf@mail.ru'),
('ИЗВЕСТИЯ', 'г. Покровское, ул. Пекуновский Тупик, дом 11', '2010-10-10', '+7(263)436-17-53', 'news55@mail.ru'),
('ИнформМед', 'г. Скопин, ул. Можайское Шоссе', '2002-05-02', '+7(353)466-43-12', 'info25@mail.ru'),
('Сырмала', 'г. Москва, ул. Красного маяка, д 1', '2014-08-01', '+7(233)416-57-43', 'dmitriy1@mail.ru'),
('Автограф века', 'г. Богородицк, ул. Абельмановская, дом 77', '2001-01-30', '+7(524)466-72-59', 'nastasia4@mail.ru'),
('КоЛибри', 'г. Комсомольское, ул. Генерала Карбышева Бульвар', '2011-03-22', '+7(624)436-17-44', 'efremov1983@mail.ru'),
('РОО', 'г. Баргузин, ул. Братская, дом 20', '1999-04-08', '+7(542)446-17-44', 'nastasia@mail.ru');

INSERT INTO Series VALUES
(1,'Гарри Поттер','2016-02-01'),
(1,'Палестинский патерик','2009-02-21'),
(1,'Шахматные ежегодники','2010-12-30'),
(3,'Перри Мейсон','2007-12-22'),
(20,'Klio','2010-02-06'),
(3,'Огненный перст','2014-02-02'),
(4,'Мартин Бек','2010-03-25'),
(5,'Биография дома','2005-09-22'),
(11,'Дачные истории','2008-09-21'),
(19,'Наука','2010-02-28'),
(1,'Banner of the Starsи','2003-12-12'),
(6,'Живое и мёртвое','2015-12-15'),
(2,'Отважные герои','2014-10-18'),
(11,'Мир приключений','2012-11-09'),
(13,'Великие книги','2018-07-30'),
(12,'Вся Москва','2016-02-08'),
(17,'Découvertes Gallimard','2013-08-19'),
(2,'Из истории искусства','2009-07-27'),
(17,'Возвращение книги','2004-03-11'),
(11,'Жемчужины галахи','2001-05-16'),
(18,'Черновики будущего','2006-12-31'),
(19,'Пионер — значит первый','2003-02-01');

INSERT INTO Book VALUES
(1, 'Гарри Поттер 1', '2018-07-30', 500.25, 'Художественная литература', '6+'),
(1, 'Гарри Поттер 2', '2010-03-11', 460.60, 'Художественная литература', '6+'),
(3, 'Призраки', '2003-02-01', 200.26, 'Деловая литература', '16+'),
(3, 'Вурдалаки', '2004-06-10', 280.27, 'Деловая литература', '18+'),
(10, 'О здоровье', '2016-02-08', 1999.99, 'Красота. Здоровье. Спорт', '0+'),
(5, 'Картины', '2012-11-09', 500.33, 'Искусство', '12+'),
(10, 'Правильное питание', '2005-09-22', 400.34, 'Красота. Здоровье. Спорт', '12+'),
(13, 'Момент истины', '2011-02-28', 309.09 , 'Художественная литература', '18+'),
(6, 'Русский язык', '2002-05-11', 400.23, 'Образование', '0+'),
(10, 'ЗдОрово жить', '2014-03-30', 698.55, 'Красота. Здоровье. Спорт', '0+'),
(2, 'Убить пересмешника', '2000-04-08', 360.3, 'Художественная литература', '6+'),
(4, 'Библия.', '2005-03-06', 500.00, 'Философия и религия', '0+'),
(5, 'Евгений Онегин', '2008-03-05', 400.33, 'Художественная литература', '18+'),
(6, 'Бойцовский клуб', '2003-09-09', 600, 'Деловая литература', '18+'),
(7, 'Компьютер', '2013-08-19', 700.33, 'Компьютерная литература', '12+'),
(8, 'Каменный замок', '2003-12-12', 356.44, 'Художественная литература', '16+'),
(9, 'О солнце', '2008-03-15', 403.33, 'Художественная литература', '12+'),
(11, 'Метоморфизм', '2000-03-04', 456.345, 'Философия и религия', '12+'),
(12, 'Конец', '2005-02-01', 456.34, 'Образование', '0+'),
(13, 'Золото в огне', '2006-11-11', 475.33, 'Общество', '12+'),
(14, 'Жизнь', '2001-02-16', 1500.74, 'Психология', '18+'),
(15, 'Прекрасная жизнь', '2001-02-17', 1501.74, 'Психология', '18+'),
(16, 'Фантазии нет', '2010-11-11', 1500.74, 'Психология', '12+'),
(17, 'Torrino', '2001-04-09', 154.74, 'Эзотерика', '18+'),
(18, 'Fernando', '2004-09-10', 400.33, 'Художественная литература', '18+'),
(19, 'Дон Пьер', '2014-10-22', 500.22, 'Художественная литература', '6+'),
(20, 'Карьера', '2018-10-15', 200.312, 'Образование', '16+'),
(21, 'Progr', '2016-11-01', 500.05, 'Общество', '18+'),
(22, 'Нарния', '2005-02-06', 500.05, 'Книги для детей', '6+');

INSERT INTO Author VALUES
('Ичёткина Ульяна Григорьевна', '1975-02-21'),
('Михайлов Мстислав Иванович', '1963-06-29'),
('Джоан Роулин', '1965-07-21'),
('Тарская Станислава Александровна ', '1989-12-31'),
('Карпов Рубен Константинович', '1961-01-21'),
('Комарова Мелитриса Григорьевна ', '1995-08-14'),
('Кириллова Любовь Георгиевна ', '1987-02-12'),
('Лютов Аверьян Игоревич', '1975-02-23'),
('Быков Остромир Леонидович', '1978-03-08'),
('Виноградов Тихон Макарович', '1990-06-21'),
('Кочеткова Фаина Владимировна ', '1967-10-03'),
('Волков Лука Борисович', '1985-09-02');

INSERT INTO Customer VALUES
('Блохина Искра Васильевна', '1988-01-18', 'Female', '+7(142)452-71-32', 'ifuberre-9689@yopmail.com', 0),
('Палий Георгий Иванович', '1975-02-21', 'Male', '+7(423)159-21-02', 'uqottysseje-1796@yopmail.com', 199),
('Петрик Ольга Сергеевна', '2000-03-25', 'Female', '+7(999)234-21-00', NULL, 500),
('Винов Герман Виталиевич', '1999-01-06', 'Male', '+7(543)412-71-32', 'ossenakello-4030@yopmail.com', 100),
('Шубин Павел Михайлович', '1996-10-12', 'Male', '+7(198)222-78-10', 'ikaxilaca-9514@yopmail.com', 2000),
('Бирюков Зигмунд Богданович', '1998-12-29', 'Male', '+7(167)863-12-11', NULL, 1500),
('Чухрай Эрик Максимович', '1990-11-20', 'Male', NULL, 'ylemmodadde-0937@yopmail.com', 10),
('Фомичёв Устин Фёдорович', '1988-09-11', 'Male', '+7(999)999-91-09', 'corapyddaffa-0460@yopmail.com', 400),
('Орехов Роберт Сергеевич', '1918-08-29', 'Male', '+7(111)454-12-00', NULL, 2678),
('Бачей Закир Васильевич', '1967-10-03', 'Male', '+7(245)123-32-32', 'agazuddaq-6251@yopmail.com', 349),
('Семёнов Марат Эдуардович', '1980-06-04', 'Male', NULL, 'rerruxurrar-1693@yopmail.com', 150),
('Игнатьева Надежда Михайловна', '1948-05-01', 'Female', '+7(232)453-90-32', NULL,780),
('Моисеева Мария Борисовна', '1967-04-30', 'Female', '+7(907)632-88-90', 'qezillefimmu-6155@yopmail.com', 905),
('Доронин Богдан Фёдорович', '1990-02-27', 'Male', '+7(643)422-77-31', NULL, 738);

INSERT INTO Sales(cust_id, book_id) VALUES
(10, 1),
(10, 2),
(10, 15),
(2, 6),
(2, 1),
(3, 7),
(12, 1),
(1, 5),
(10, 4),
(1, 29),
(5, 7),
(2, 26),
(9, 1),
(8, 22),
(9, 11),
(4, 26),
(6, 14),
(8, 12),
(7, 5),
(11, 14);


INSERT INTO auth_book VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 3),
(12, 1),
(12, 8),
(11, 4),
(10, 4),
(11, 5),
(10, 9),
(7, 7),
(4, 26),
(8, 25),
(8, 24),
(6, 20),
(9, 19),
(10, 18),
(4, 17),
(12, 13),
(12, 6),
(10, 10),
(10, 11),
(1, 12),
(9, 12),
(10, 14),
(8, 15),
(12, 16),
(11, 21),
(2, 22),
(2, 23),
(11, 28),
(9, 29),
(1, 26),
(12, 29);

--Таблица приглашенных/пригласивших пользователей
CREATE TABLE CustRelations
(
	Inviting int,
	Invited int,
	PRIMARY KEY(Inviting, Invited),
	FOREIGN KEY (Inviting) REFERENCES Customer(CustomerId) ON DELETE CASCADE,
	FOREIGN KEY (Invited) REFERENCES Customer(CustomerId),
)

INSERT INTO CustRelations VALUES
(1, 2),
(2, 3),
(5, 10),
(10, 1),
(1, 8),
(11, 14),
(9, 13),
(10, 11),
(10, 4),
(1, 5);