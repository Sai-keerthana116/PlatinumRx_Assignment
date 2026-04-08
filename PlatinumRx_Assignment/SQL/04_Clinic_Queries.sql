-- CLINICS
INSERT INTO clinics VALUES
('cnc-001', 'ABC Clinic', 'Hyderabad', 'Telangana', 'India'),
('cnc-002', 'XYZ Clinic', 'Bangalore', 'Karnataka', 'India');

-- CUSTOMERS
INSERT INTO customer VALUES
('cust-001', 'Rahul', '98XXXXXXXX'),
('cust-002', 'Sneha', '97XXXXXXXX'),
('cust-003', 'Arjun', '96XXXXXXXX');

-- CLINIC SALES
INSERT INTO clinic_sales VALUES
('ord-001', 'cust-001', 'cnc-001', 5000, '2021-10-10 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-001', 7000, '2021-10-15 12:00:00', 'offline'),
('ord-003', 'cust-003', 'cnc-002', 8000, '2021-11-05 14:00:00', 'online'),
('ord-004', 'cust-001', 'cnc-002', 6000, '2021-11-20 16:00:00', 'offline');

-- EXPENSES
INSERT INTO expenses VALUES
('exp-001', 'cnc-001', 'Medicines', 3000, '2021-10-12 09:00:00'),
('exp-002', 'cnc-001', 'Staff Salary', 4000, '2021-10-20 18:00:00'),
('exp-003', 'cnc-002', 'Equipment', 5000, '2021-11-10 11:00:00'),
('exp-004', 'cnc-002', 'Maintenance', 2000, '2021-11-25 17:00:00');

--Find the revenue we got from each sales channel in a given year

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE strftime('%Y', datetime) = '2021'
GROUP BY sales_channel;

--Find top 10 the most valuable customers for a given year

SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c 
    ON cs.uid = c.uid
WHERE strftime('%Y', cs.datetime) = '2021'
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

--Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year

WITH revenue AS (
    SELECT 
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY month
),

expenses_cte AS (
    SELECT 
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY month
)

SELECT 
    r.month,
    r.total_revenue,
    e.total_expense,
    (r.total_revenue - e.total_expense) AS profit,
    CASE 
        WHEN (r.total_revenue - e.total_expense) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
JOIN expenses_cte e 
    ON r.month = e.month;


--For each city find the most profitable clinic for a given month
WITH revenue AS (
    SELECT 
        cid,
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    GROUP BY cid, month
),

expenses_cte AS (
    SELECT 
        cid,
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    GROUP BY cid, month
),

profit_calc AS (
    SELECT 
        r.cid,
        c.clinic_name,
        c.city,
        r.month,
        (r.total_revenue - IFNULL(e.total_expense, 0)) AS profit
    FROM revenue r
    LEFT JOIN expenses_cte e 
        ON r.cid = e.cid AND r.month = e.month
    JOIN clinics c 
        ON r.cid = c.cid
    WHERE r.month = '2021-11'
),

ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rank
    FROM profit_calc
)

SELECT 
    city,
    clinic_name,
    profit
FROM ranked
WHERE rank = 1;

--For each state find the second least profitable clinic for a given month

WITH revenue AS (
    SELECT 
        cid,
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    GROUP BY cid, month
),

expenses_cte AS (
    SELECT 
        cid,
        strftime('%Y-%m', datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    GROUP BY cid, month
),

profit_calc AS (
    SELECT 
        r.cid,
        c.clinic_name,
        c.state,
        r.month,
        (r.total_revenue - IFNULL(e.total_expense, 0)) AS profit
    FROM revenue r
    LEFT JOIN expenses_cte e 
        ON r.cid = e.cid AND r.month = e.month
    JOIN clinics c 
        ON r.cid = c.cid
    WHERE r.month = '2021-11'
),

ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rank
    FROM profit_calc
)

SELECT 
    state,
    clinic_name,
    profit
FROM ranked
WHERE rank = 2;

--to avoid empty result , some records are inserted into clinics table
-- Add another clinic in SAME state
INSERT INTO clinics VALUES
('cnc-004', 'GHI Clinic', 'Hyderabad', 'Telangana', 'India');

-- Add revenue for BOTH clinics in SAME month
INSERT INTO clinic_sales VALUES
('ord-006', 'cust-001', 'cnc-003', 9000, '2021-11-12 10:00:00', 'online'),
('ord-007', 'cust-002', 'cnc-004', 5000, '2021-11-15 12:00:00', 'offline');

-- Add expenses for BOTH
INSERT INTO expenses VALUES
('exp-006', 'cnc-003', 'Equipment', 2000, '2021-11-13 09:00:00'),
('exp-007', 'cnc-004', 'Maintenance', 1000, '2021-11-16 11:00:00');