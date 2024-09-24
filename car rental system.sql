create database car_rental_system

use car_rental_system

create table vehicle (
    vehicleID int identity(1,1) primary key,
    make varchar(50) not null,
    model varchar(50) not null,
    [year] int not null,
    dailyrate decimal(10, 2) not null check (dailyrate >= 0),
    [status] varchar(20) not null check (status in ('available', 'not available')) default 'not available',
    passengercapacity int not null, 
    enginecapacity decimal(6, 2) not null 
)

create table customer (
    customerID int identity(1,1) primary key,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    email varchar(100) ,
    PhoneNumber varchar(15) 
)

create table lease (
    leaseID int identity(1,1) primary key,
    carID int,
    customerID int,
    startdate date not null,
    enddate date not null,
    leasetype varchar(20) not null check (leasetype in ('Daily', 'Monthly')),
	foreign key(carID) references vehicle(vehicleID),
	foreign key(customerID) references customer(customerID)
)

create table payment (
    paymentID int identity(1,1) primary key,
    leaseID int,
    paymentDate date not null,
    amount decimal(10, 2) not null check (amount>0),
	foreign key(leaseID) references lease(leaseID)
)

select * from vehicle
insert into vehicle (make, model, [year], dailyrate, [status], passengercapacity, enginecapacity)
values 
('Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
('Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
('Ford', 'Focus', 2022, 48.00, 'not available', 4, 1400),
('Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
('Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
('Hyundai', 'Sonata', 2023, 49.00, 'not available', 7, 1400),
('BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
('Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
('Audi', 'A4', 2022, 55.00, 'not available', 4, 2500),
('Lexus', 'ES', 2023, 54.00, 'available', 4, 2500)

insert into customer (firstname, lastname, email, PhoneNumber)
values
('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
('David', 'Lee', 'david@example.com', '555-987-6543'),
('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
('William', 'Taylor', 'william@example.com', '555-321-6547'),
('Olivia', 'Adams', 'olivia@example.com', '555-765-4321')
select * from customer
insert into lease (carID, customerID, startdate, enddate, leasetype)
values 
 (1, 1, '2023-01-01', '2023-01-05', 'Daily'),
 (2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
 (3, 3, '2023-03-10', '2023-03-15', 'Daily'),
 (4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
 (5, 5, '2023-05-05', '2023-05-10', 'Daily'),
 (4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
 (7, 7, '2023-07-01', '2023-07-10', 'Daily'),
 (8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
 (3, 3, '2023-09-07', '2023-09-10','Daily'),
( 10, 10, '2023-10-10', '2023-10-31', 'Monthly')

insert into payment (leaseid, paymentdate, amount)
values 
(1, '2023-01-03', 200.00),
(2, '2023-02-20', 1000.00),
(3, '2023-03-12', 75.00),
(4, '2023-04-25', 900.00),
(5, '2023-05-07', 60.00),
(6, '2023-06-18', 1200.00),
(7, '2023-07-03', 40.00),
(8, '2023-08-14', 1100.00),
(9, '2023-09-09', 80.00),
(10, '2023-10-25', 1500.00)
select * from vehicle
--1. Update the daily rate for a Mercedes car to 68.
update vehicle
set dailyrate=68.00 where vehicleId=8

--2. Delete a specific customer and all associated leases and payments.
delete from payment where leaseID in (select leaseID from lease where customerId=8)

delete from lease where customerID=8

delete from customer where customerID=8
--3. Rename the "paymentDate" column in the Payment table to "transactionDate".
exec sp_rename 'payment.paymentDate','transactionDate','column'
select * from payment
--4. Find a specific customer by email.
select concat(firstname,'-',lastname),email as full_name from customer
where email='robert@example.com'

--5. Get active leases for a specific customer.
select l.*,v.*
from lease l
join vehicle v on v.vehicleID=l.carID
join customer c on l.customerID=c.customerID
where  l.startDate <= GETDATE() and l.endDate >= GETDATE() and c.customerID=3

--6. Find all payments made by a customer with a specific phone number.
select (select PhoneNumber from customer where PhoneNumber='555-789-1234')

--7. Calculate the average daily rate of all available cars.
select vehicleID,make,model,avg(dailyrate) as averageDailyRate from vehicle
group by vehicleID,make,model


--8. Find the car with the highest daily rate.
select top 1 make,model from vehicle order by dailyrate desc
--9. Retrieve all cars leased by a specific customer.
select v.make,v.model
from vehicle v
join lease l on v.vehicleID=l.carID
join customer c on l.customerid = c.customerid
where c.customerid = 3

--10. Find the details of the most recent lease.
select top 1 l.*
from lease l
join vehicle v on l.carID = v.vehicleID
join customer c on l.customerID = c.customerID
order by l.enddate desc
--11. List all payments made in the year 2023.
select * from payment where year(transactionDate)=2024

--12. Retrieve customers who have not made any payments.
select c.customerID,c.firstName,c.lastName
from  customer c
left join  lease l on c.customerID = l.customerID
left join  payment p on l.leaseID = p.leaseID
where  p.paymentID is null

--13. Retrieve Car Details and Their Total Payments.
select V.*,SUM(p.amount) AS totalPayments from vehicle v
left join lease l ON v.vehicleID = l.carID
left join payment p ON l.leaseID = p.leaseID
group by v.vehicleID, v.make, v.model, v.year, v.dailyRate, v.status, v.passengercapacity, v.enginecapacity

--14. Calculate Total Payments for Each Customer.
select c.customerID,c.firstName,c.lastName,sum(p.amount) as total
from  customer c
left join lease l on c.customerID = l.customerID
left join   payment p on l.leaseID = p.leaseID
group by  c.customerID,c.firstName,c.lastName

--15. List Car Details for Each Lease.
select l.leaseID, v.* from
vehicle v
right join lease l
on l.carID=v.vehicleID
order by l.leaseID

--16. Retrieve Details of Active Leases with Customer and Car Information.
select l.*,v .make,v.model, c.* from lease l
join vehicle v on l.carID = v.vehicleID
join customer c on l.customerID = c.customerID
where l.startDate <= GETDATE() and l.endDate >= GETDATE() and v.[status] = 'available'

--17. Find the Customer Who Has Spent the Most on Leases.
select top 1 c.*,sum(p.amount) AS TotalSpentOnLeases from customer c
left join lease  l on c.customerID = l.customerID
left join payment p on l.leaseID = p.leaseID
group by c.customerID, c.firstName, c.lastName, c.email, c.phoneNumber
order by TotalSpentOnLeases desc

--18. List All Cars with Their Current Lease Information.
select vehicle.*,l.*,concat(c.firstname,' ',c.lastName) as Customer_Name from Vehicle
left join lease l on Vehicle.vehicleID = l.carID
left join customer c on l.customerID = c.customerID
where l.startDate <= GETDATE() and l.endDate >= GETDATE()


