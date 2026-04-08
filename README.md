# PlatinumRx Data Analyst Assignment

## Objective

This project demonstrates core data analysis skills across:

* SQL (Database design & querying)
* Spreadsheet analysis (lookup & time-based logic)
* Python programming (basic logic implementation)

The assignment was completed step-by-step with iterative testing, debugging, and data adjustments to ensure correctness.

---

# SQL Proficiency

##  1. Database Setup

Two systems were implemented:

* Hotel Management System
* Clinic Management System

### Approach:

* Created tables using `CREATE TABLE`
* Defined primary keys for uniqueness
* Added foreign keys to maintain relationships (logical correctness)

### Note:

SQLite Online was used for execution. Since SQLite does not strictly enforce foreign key constraints by default, relationships were ensured logically through correct schema design.

---

##  2. Data Insertion Strategy

Initially, sample data was minimal. However, several queries required:

* Multiple months
* Multiple records per group
* Ranking conditions

### Decision Taken:

Additional records were inserted to:

* Support aggregation queries
* Enable ranking (e.g., 2nd highest, most/least ordered)
* Ensure meaningful outputs instead of empty results

---

## 3. Hotel System Queries

### Q1: Last booked room per user

* Used correlated subquery with `MAX(booking_date)`
* Ensured latest booking per user

---

### Q2: Total billing in November 2021

* Used `JOIN` across:

  * bookings
  * booking_commercials
  * items
* Calculated:
  `item_quantity × item_rate`
* Used `GROUP BY booking_id`

---

### Q3: Bills > 1000 (October 2021)

* Aggregated bill amount using `SUM`
* Used `HAVING` clause for filtering aggregated values

### Decision:

Additional high-value records were inserted to ensure non-empty output.

---

### Q4: Most & Least ordered item per month

* Used:

  * Aggregation (SUM of quantity)
  * Window functions (`RANK`)
* Partitioned by month
* Identified both:

  * Highest (Most ordered)
  * Lowest (Least ordered)

---

### Q5: 2nd Highest bill per month

* Computed total bill per bill_id
* Used `RANK()` with partition by month
* Selected `rank = 2`

### Decision:

Additional records were inserted to ensure at least 2 bills per month.

---

## 4. Clinic System Queries

### Q1: Revenue by sales channel

* Used `GROUP BY sales_channel`
* Aggregated using `SUM(amount)`

---

### Q2: Top 10 customers

* Joined `clinic_sales` with `customer`
* Aggregated total spending
* Sorted using `ORDER BY DESC`

---

### Q3: Revenue, Expense, Profit, Status

* Created separate CTEs for:

  * Revenue
  * Expenses
* Joined both
* Calculated:

  * Profit = Revenue - Expense
  * Status using CASE statement

---

### Q4: Most profitable clinic per city

* Calculated profit per clinic
* Used `RANK()` partitioned by city
* Selected rank = 1

---

### Q5: 2nd least profitable clinic per state

* Ranked by ascending profit
* Selected rank = 2

### Key Challenge:

Initial dataset did not satisfy ranking conditions.

### Solution:

Inserted additional clinics and transactions in the same state and month to ensure:

* Multiple entities per partition
* Valid ranking results

---

#Spreadsheet Proficiency

##  1. Data Setup

* Created two sheets:

  * `ticket`
  * `feedbacks`
* Ensured `cms_id` is common key

---

##  2. Populating ticket_created_at

### Initial Approach:

Used `VLOOKUP`

### Issue:

* Google Sheets does not support reverse lookup (right-to-left)

### Solution:

Used `INDEX + MATCH` instead:

```
=INDEX(ticket!B:B, MATCH(A2, ticket!E:E, 0))
```

### Insight:

INDEX-MATCH is more flexible and avoids VLOOKUP limitations.

---

##  3. Same Day & Same Hour Analysis

### Helper Columns Created:

* Same Day → `=INT(created_at) = INT(closed_at)`
* Same Hour → `=AND(INT(...) , HOUR(...) = HOUR(...))`

---

##  4. Outlet-wise Counting

Used `COUNTIFS` to calculate:

* Tickets resolved on same day
* Tickets resolved within same hour

### Example:

```
=COUNTIFS(D:D, "outlet-1", F:F, TRUE)
```

---

#  Phase 3: Python Implementation

##  1. Time Conversion

* Used integer division (`//`) for hours
* Used modulo (`%`) for remaining minutes
* Handled singular/plural formatting

---

##  2. Remove Duplicates from String

* Used loop-based approach (as required)
* Maintained order of characters
* Avoided using `set()` to follow instructions

---

#  Tools Used

* SQL: SQLite Online
* Spreadsheet: Google Sheets
* Programming: Python 3

---

#  Challenges & Decisions

| Challenge                             | Solution                    |
| ------------------------------------- | --------------------------- |
| Insufficient data for ranking queries | Inserted additional records |
| VLOOKUP not working (reverse lookup)  | Switched to INDEX-MATCH     |
| Empty SQL outputs                     | Adjusted dataset logically  |
| Foreign key enforcement               | Handled logically in schema |

---

#  Submission Links

* GitHub Repository: (https://github.com/Sai-keerthana116/PlatinumRx_Assignment)
* Spreadsheet Link: (https://docs.google.com/spreadsheets/d/1x8f--VexF6ieYt5OtAK8RlFo4cEyMC5gixNSUguaOrI/edit?usp=sharing)
* Screen Recording: (Optional but recommended)

---

# ✅ Conclusion

This assignment was approached with:

* Structured problem solving
* Iterative testing and debugging
* Logical data adjustments
* Focus on correctness and completeness

All queries, formulas, and scripts were validated with test data to ensure accurate results.
