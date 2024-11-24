DROP DATABASE IF EXISTS TransportDB;
CREATE DATABASE TransportDB;
USE TransportDB;

CREATE TABLE Car (
    CAR_ID INT NOT NULL PRIMARY KEY,
    CAR_MODEL VARCHAR(50) NOT NULL,
    CAR_YEAR INT NOT NULL,
    CAR_LICENSE_PLATE VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Driver (
    DRIVER_ID INT NOT NULL PRIMARY KEY,
    DRIVER_NAME VARCHAR(50) NOT NULL,
    DRIVER_LICENSE VARCHAR(20) NOT NULL UNIQUE,
    DRIVER_PHONE VARCHAR(15) NOT NULL,
    DRIVER_ADDRESS VARCHAR(100) NOT NULL
);

CREATE TABLE Route (
    ROUTE_ID INT NOT NULL PRIMARY KEY,
    ROUTE_START VARCHAR(50) NOT NULL,
    ROUTE_END VARCHAR(50) NOT NULL,
    ROUTE_DISTANCE DECIMAL(5,2) NOT NULL
);

CREATE TABLE Maintenance (
    MAINTENANCE_ID INT NOT NULL PRIMARY KEY,
    CAR_ID INT,
    MAINTENANCE_DATE DATE NOT NULL,
    MAINTENANCE_COST DECIMAL(10,2) NOT NULL,
    DESCRIPTION VARCHAR(100),
    FOREIGN KEY (CAR_ID) REFERENCES Car(CAR_ID) ON DELETE CASCADE
);

CREATE TABLE DriverRoute (
    DRIVER_ROUTE_ID INT NOT NULL PRIMARY KEY,
    DRIVER_ID INT,
    ROUTE_ID INT,
    ASSIGNMENT_DATE DATE NOT NULL,
    FOREIGN KEY (DRIVER_ID) REFERENCES Driver(DRIVER_ID) ON DELETE CASCADE,
    FOREIGN KEY (ROUTE_ID) REFERENCES Route(ROUTE_ID) ON DELETE CASCADE
);

INSERT INTO Car (CAR_ID, CAR_MODEL, CAR_YEAR, CAR_LICENSE_PLATE)
VALUES 
    (1, 'Toyota Camry', 2018, 'ВК 0000 НК'),
    (2, 'Brous 700', 2017, 'ВК 7447 НК'),
    (3, 'Honda Civic', 2019, 'ВК 1234 НК'),
    (4, 'Жигуль 2106', 1998, 'ВК 0987 НК'),
    (5, 'Honda Accord', 2016, 'ВК 7666 НК'),
    (6, 'Audi A4', 2000, 'ВК 7776 НК');

INSERT INTO Driver (DRIVER_ID, DRIVER_NAME, DRIVER_LICENSE, DRIVER_PHONE, DRIVER_ADDRESS)
VALUES 
    (1, 'Вадим Плисюк', 'D12345', '068987654', 'вул. Орлова 40'),
    (2, 'Тополюк Іван', 'D67890', '098765432', 'вул. Орлова 40'),
    (3, 'Жуковська Ангеліна', 'D54321', '097654321', 'вул. Орлова 40'),
    (4, 'Бугайчук Олександр', 'D67765', '908098988', 'вул. Соборна 1'),
    (5, 'Демчук Роман', 'D34534', '098464565', 'вул. Олени Теліги 53'),
    (6, 'Ткачук Сергій', 'D75437', '098765678', 'вул. Відіньська 12');

INSERT INTO Route (ROUTE_ID, ROUTE_START, ROUTE_END, ROUTE_DISTANCE)
VALUES 
    (1, 'Київ', 'Одеса', 120.50),
    (2, 'Рівне', 'Луцьк', 75.30),
    (3, 'Львів', 'Донбас', 200.00),
    (4, 'Одеса', 'Харків', 250.40),
    (5, 'Львів', 'Тернопіль', 234.43),
    (6, 'Київ', 'Хмельницький', 870.90);

INSERT INTO Maintenance (MAINTENANCE_ID, CAR_ID, MAINTENANCE_DATE, MAINTENANCE_COST, DESCRIPTION)
VALUES 
    (1, 1, '2023-12-12', 1000.00, 'Заміна мастила'),
    (2, 2, '2024-10-17', 1200.00, 'Заміна гальмівних колодок'),
    (3, 3, '2024-09-18', 5600.00, 'Заміна акумулятора'),
    (4, 4, '2023-12-18', 2300.00, 'Шиномонтаж'),
    (5, 5, '2024-10-17', 1500.00, 'Заміна форсунки'),
    (6, 6, '2024-09-18', 1200.00, 'Заміна паливного фільтра');

INSERT INTO DriverRoute (DRIVER_ROUTE_ID, DRIVER_ID, ROUTE_ID, ASSIGNMENT_DATE)
VALUES 
    (1, 1, 1, '2023-12-12'),
    (2, 2, 2, '2024-10-17'),
    (3, 3, 3, '2024-09-18'),
    (4, 4, 4, '2023-12-18'),
    (5, 5, 5, '2024-10-17'),
    (6, 6, 6, '2024-09-18');

SELECT Car.CAR_MODEL, Maintenance.MAINTENANCE_DATE, Maintenance.MAINTENANCE_COST
FROM Car
JOIN Maintenance ON Car.CAR_ID = Maintenance.CAR_ID
WHERE MAINTENANCE_DATE >= '2023-10-01';

SELECT Driver.DRIVER_NAME, Route.ROUTE_START, Route.ROUTE_END
FROM Driver
JOIN DriverRoute ON Driver.DRIVER_ID = DriverRoute.DRIVER_ID
JOIN Route ON DriverRoute.ROUTE_ID = Route.ROUTE_ID; 
SELECT CAR_MODEL, CAR_LICENSE_PLATE FROM Car
WHERE CAR_LICENSE_PLATE LIKE 'В%';

SELECT Car.CAR_MODEL, MAX(Maintenance.MAINTENANCE_COST) AS MaxCost
FROM Car
JOIN Maintenance ON Car.CAR_ID = Maintenance.CAR_ID
GROUP BY Car.CAR_MODEL;

DROP PROCEDURE IF EXISTS DriverMaintenanceRating;
DELIMITER $$
CREATE PROCEDURE DriverMaintenanceRating()
BEGIN
    SELECT Driver.DRIVER_NAME, Maintenance.MAINTENANCE_COST,
           CASE
               WHEN Maintenance.MAINTENANCE_COST > 400 THEN 'High Maintenance Cost'
               WHEN Maintenance.MAINTENANCE_COST BETWEEN 200 AND 400 THEN 'Moderate Maintenance Cost'
               ELSE 'Low Maintenance Cost'
           END AS MaintenanceRating
    FROM Driver
    JOIN DriverRoute ON Driver.DRIVER_ID = DriverRoute.DRIVER_ID
    JOIN Maintenance ON DriverRoute.DRIVER_ROUTE_ID = Maintenance.CAR_ID;
END $$
DELIMITER ;

CALL DriverMaintenanceRating();