
--USERS TABLE
create table users (
    user_id varchar(50) primary key,
    name varchar(100),
    phone_number varchar(15),
    mail_id varchar(100),
    billing_address TEXT
);

--Bookings TABLE
create table bookings (
    booking_id varchar(50) primary key,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id varchar(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--Items Table
create table items (
    item_id varchar(50) primary key,
    item_name varchar(100),
    item_rate DECIMAL(10, 2)
);

--BOOKING Commercials Table
create table booking_commercials (
    id varchar(50) primary key,
    booking_id varchar(50),
    bill_id varchar(50),
    bill_date DATETIME,
    item_id varchar(50),
    item_quantity decimal(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);