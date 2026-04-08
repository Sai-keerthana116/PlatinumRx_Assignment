-- USERS
INSERT INTO users VALUES
('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX Street Y ABC City'),
('22abcdxy-123abc', 'Jane Smith', '98XXXXXXXX', 'jane.smith@example.com', 'YY Street Z XYZ City');

-- BOOKINGS
INSERT INTO bookings VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-11g7h-22kl', '2021-11-15 10:20:00', 'rm-xy12-abcd', '22abcdxy-123abc');

-- ITEMS
INSERT INTO items VALUES
('itm-a9e8-q8fu', 'Tawa Paratha', 18),
('itm-a07vh-aer8', 'Mix Veg', 89),
('itm-w978-23u4', 'Paneer Butter Masala', 150);

-- BOOKING COMMERCIALS
INSERT INTO booking_commercials VALUES
('id-001', 'bk-09f3e-95hj', 'bl-001', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('id-002', 'bk-09f3e-95hj', 'bl-001', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('id-003', 'bk-11g7h-22kl', 'bl-002', '2021-11-15 14:00:00', 'itm-w978-23u4', 2);


--For every user in the system, get the user_id and last booked room_no
SELECT b.user_id, b.room_no
FROM bookings b
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = b.user_id
);

--Get booking_id and total billing amount of every booking created in November, 2021
--sqlite does not support MONTH() and YEAR() functions, so we will use strftime to filter by month and year
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill_amount
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE strftime('%Y-%m', b.booking_date) = '2021-11'
GROUP BY b.booking_id;

--MYSQL VERSION
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill_amount
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;


--Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
--to get result, another record is inserted in booking_commercials with higher quantity for the same booking
INSERT INTO booking_commercials VALUES
('id-006', 'bk-33cc-44dd', 'bl-005', '2021-10-15 12:00:00', 'itm-w978-23u4', 10);

SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE strftime('%Y-%m', bc.bill_date) = '2021-10'
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

--Determine the most ordered and least ordered item of each month of year 2021
WITH item_totals AS (
    SELECT 
        strftime('%Y-%m', bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE strftime('%Y', bc.bill_date) = '2021'
    GROUP BY month, i.item_name
),

ranked_items AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_quantity DESC) AS rank_desc,
        RANK() OVER (PARTITION BY month ORDER BY total_quantity ASC) AS rank_asc
    FROM item_totals
)

SELECT 
    month,
    item_name,
    total_quantity,
    CASE 
        WHEN rank_desc = 1 THEN 'Most Ordered'
        WHEN rank_asc = 1 THEN 'Least Ordered'
    END AS category
FROM ranked_items
WHERE rank_desc = 1 OR rank_asc = 1;

--Find the customers with the second highest bill value of each month of year 2021

INSERT INTO booking_commercials VALUES
('id-007', 'bk-22aa-33bb', 'bl-006', '2021-11-25 15:00:00', 'itm-a07vh-aer8', 8);

WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        strftime('%Y-%m', bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE strftime('%Y', bc.bill_date) = '2021'
    GROUP BY bc.bill_id, month
),

ranked_bills AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS bill_rank
    FROM bill_totals
)

SELECT 
    month,
    bill_id,
    total_bill
FROM ranked_bills
WHERE bill_rank = 2;



