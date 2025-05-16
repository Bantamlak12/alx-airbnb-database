
## 📈 Indexing for Performance Improvement
Indexes significantly reduce query time and are essential for performance tuning. Be mindful though — over-indexing can slow down write operations like `INSERT`, `UPDATE`, and `DELETE`.

### Identify and Create Indexes

To improve query performance, I identified **high-usage columns** from the following tables:

- `users`: `user_id`
- `bookings`: `user_id`, `property_id`
- `properties`: `name`

### 🛠️ Index Creation Commands

```sql
CREATE INDEX idx_booking_property_name ON properties (name);
CREATE INDEX idx_booking_user ON bookings (user_id);
CREATE INDEX idx_booking_property ON bookings (property_id);
````

### 🔎 Measure Query Performance

I measured query performance **before and after** using `EXPLAIN ANALYZE`

#### 🕵️ Before the Index

```sql
EXPLAIN ANALYZE SELECT * FROM properties WHERE name = 'Riverside Retreat';
```

Output showed:

* `type = ALL` → full table scan
* `key = NULL` → no index used
* `rows = 5`

#### ⚡ After the Index

```sql
EXPLAIN ANALYZE SELECT * FROM properties WHERE name = 'Riverside Retreat';
```

Output showed:

* `type = ref` → uses index
* `key = idx_booking_property_name` → index selected
* `rows = 1` → efficient lookup

### 🧰 Useful Indexing Commands

* Show existing indexes:

  ```sql
  SHOW INDEXES FROM table_name;
  ```

* Create additional index:

  ```sql
  CREATE INDEX index_name ON table_name (column_name);
  ```

* Drop an index:

  ```sql
  DROP INDEX index_name ON table_name;
  ```