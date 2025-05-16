# SQL JOIN Project

This project aims to teach complex queries with Joins.

## INNER JOIN
- Retrieves records that have matching values in both tables.


## LEFT JOIN
- Retrieve all records from the left table and matched records from the right table. Unmatched right table records will be `NULL`.

## FULL OUTER JOIN
- Retrieves all records when there is a match in either table. Unmatched values will show as `NULL`.

> Note: FULL OUTER JOIN: may not be supported in MySQL. Use a combination of LEFT JOIN and RIGHT JOIN with UNION.

## Correlated Subquery
- A subquery that depends on a value from the outer query. It runs once per row of the outer query.

## Non-correlated Subquery
- A subquery that is independent of the outer query. It runs once and returns a result used by the outer query.

## Aggregation
- Functions like `COUNT`, `SUM`, `AVG`, `MAX`, and `MIN` to perform calculations on data sets.

## Window Function
- Perform calculations across a set of table rows related to the current row, such as `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `SUN() OVER()`, `AVG() OVER()`, and `PARTITION BY`.

- Insteady of `Summarize everything by group` like `GROUP BY`, window function says:
`Let me see everything, and also compare each row to the rest.`
 
- `ROW_NUMBER`: Give each row a number, starting from 1

## Indexing
- Indexes are data structure that improve the speed of data retrieval operations on a database table by providing quick access to rows.

### 1. Primary Index
- Automatically created for **PRIMARY KEY** column(s).

### 2. Unique Index
- Prevents duplicate values in that column. For instance email, username.

### 3. Composite Index
- An indexon more that one column (like customer_id + toy_id), which helps for combined searches.

### 4. Full-Text Index
- Helps search big **text fields** like searching words inside reviews or descriptions.

### 5. Clustered Index
- Sorts and stores the data rows of the table in order based on key values.You can only have one per table.

### 6. Non-Clustered Index
- Just a **pointer** to rows. You can have **many** of these.
