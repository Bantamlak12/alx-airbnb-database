# Monitor and Refine Database Performance

## Step 1: Identify a Frequently Used Query

Here's a sample query used to retrieve booking details along with user and payment information:

```sql
SELECT
    b.id AS booking_id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties pr ON b.property_id = pr.id
JOIN payments pm ON pm.booking_id = b.id;
```

---

## Step 2: Analyze Query Performance Using SHOW PROFILE

### Enable profiling and run the query:

```sql
SET profiling = 1;

-- Execute query
SELECT
    b.id AS booking_id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties pr ON b.property_id = pr.id
JOIN payments pm ON pm.booking_id = b.id;
```

### Review profiling results:

```sql
SHOW PROFILE FOR QUERY 1;
```

#### Sample Output:

```
+------------------------------+----------+
| Status                       | Duration |
+------------------------------+----------+
| Opening tables               | 0.001950 |
| optimizing                   | 0.000022 |
| statistics                   | 0.000083 |
| executing                    | 0.000114 |
| ...                          | ...      |
+------------------------------+----------+
```

**Observation**: `Opening tables` and `executing` are taking time (but not that serious), so it's a sign to investigate.

---

## Step 3: With EXPLAIN ANALYZE

```sql
EXPLAIN ANALYZE
SELECT
    b.id AS booking_id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties pr ON b.property_id = pr.id
JOIN payments pm ON pm.booking_id = b.id;
```

#### Sample Output:

```
-> Nested loop inner join
    -> Table scan on pm
    -> Single-row index lookup on b using PRIMARY
    -> Single-row index lookup on pr using PRIMARY
    -> Single-row index lookup on u using PRIMARY
```

**Observation**: The most expensive part is the **table scan on `payments (pm)`**.

---

## Step 4: Identify Bottlenecks

From the EXPLAIN and profiling data:

- `payments` is doing a **table scan** → no usable index on `booking_id`.
- All other tables use **PRIMARY key lookups**, which is efficient.
- A nested loop join pattern is fine for small datasets, but scales poorly with growth.

---

## Step 5: Optimize Schema & Indexes

1. **Add index on `payments.booking_id`**.

```sql
CREATE INDEX idx_payments_composite ON payments(booking_id, amount, payment_date);
```

---

## Step 6: Rerun and Compare Performance

### After adding the index, re-run:

#### With **SHOW PROFILE**

```sql
SET profiling = 1;

SELECT
    b.id AS booking_id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties pr ON b.property_id = pr.id
JOIN payments pm ON pm.booking_id = b.id;

SHOW PROFILE FOR QUERY 1;
```

#### WITH **EXPLAIN ANALYZE**

```
EXPLAIN ANALYZE
SELECT
    b.id AS booking_id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties pr ON b.property_id = pr.id
JOIN payments pm ON pm.booking_id = b.id;
```
