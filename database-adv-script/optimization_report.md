# Complex Query Optimization

## Initial Query

```sql
SELECT *
FROM
    bookings b
    LEFT JOIN users u ON b.user_id = u.id
    LEFT JOIN properties pr ON b.property_id = pr.id
    LEFT JOIN payments pm ON pm.booking_id = b.id;

````

---

## Issues Identified

* U used `SELECT *`, which can fetch unnecessary data causing extra I/O and memory usage.

* `EXPLAIN` shows:
  * Full table scan on `bookings` (`type: ALL`).
  * Full table scan on `payments` despite index presence.
  * Efficient joins on `users` and `properties` (`eq_ref` using primary keys).

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
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN properties pr ON b.property_id = pr.id
LEFT JOIN payments pm ON pm.booking_id = b.id;
```

---

## Indexing Recommendations

Ensure the following indexes exist to speed up joins:

```sql
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
```