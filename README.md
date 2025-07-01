# Advanced SQL Project – RetailStoreDB

## Author
George Sepiadis

## Overview
This project demonstrates the design and querying of a retail database system using SQL.
It includes table creation, realistic data insertion, and advanced query tasks using **CTEs**, **window functions**, **joins**, and **aggregations**.

## Schema

- **Customers**: Stores personal information.
- **Products**: Catalog of products with categories and stock.
- **Orders**: Orders placed by customers.
- **OrderItems**: Line items within orders.
- **Payments**: Payment info linked to orders.

## Tasks Included

| # | Task Description |
|--|------------------|
| 1 | Find the most recent order per customer using `ROW_NUMBER()` |
| 2 | Full outer join of customers and orders |
| 3 | Count total orders per customer, including 0 orders |
| 4 | Flag orders with missing payments |
| 5 | Calculate total spending and assign spend rank using `RANK()` |
| 6 | Show previous and next order dates per customer using `LAG()` and `LEAD()` |
| 7 | Calculate running total and average of payments using window functions |
| 8 | Detect potential duplicate customers (same first and last name) |

## Technologies
- SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)

## Setup Instructions
1. Run the database and table creation scripts.
2. Insert the provided sample data.
3. Execute each task query block to view results.

## Notes
- Some records include `NULL` values to simulate incomplete or erroneous data.

