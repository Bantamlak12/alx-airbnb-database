# Complex Query Optimization

## Initial Query

```sql
SELECT *
FROM
    users u
    LEFT JOIN bookings b ON b.user_id = u.id
    LEFT JOIN properties pr ON b.property_id = pr.id
    LEFT JOIN payments pm ON pm.booking_id = b.id
WHERE
	u.id = b.user_id
    AND pr.id = b.property_id
    AND pm.booking_id = b.id;

````

---

## Issues Identified

- I used `SELECT *`, which can fetch unnecessary data causing extra I/O and memory usage.

- The usage of `LEFT JOIN`, `WHERE`,and `AND` are completely uncessary

---

## Optimized Query

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

## Indexing Recommendations

Ensure the following indexes exist to speed up joins:

```sql
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
```