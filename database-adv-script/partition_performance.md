# Partitioning Optimization Report for Bookings Table

## Objective

To improve query performance on the large `bookings` table by implementing partitioning based on the `start_date` column.

## Implementation

- The table is partitioned by `YEAR(start_date)` using `RANGE` partitioning.
- Partition defined for the years **bofore-2021**, **2022**, **2023**, **2024**, and with a `MAXVALUE` partition for future dates.
- `PRIMARY KEY` is adjusted to include `start_date`.

## Performance Testing

### Query Tested:

```sql
SELECT * FROM bookings
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';
```

### Before Partitioning:

- Full table scan

### After Partitioning:

- Only `p2023` partition scanned
