-- SQL aggregation and window functions
-- Find total number of bookings made by each user
-- Aggregation
SELECT
    user_id,
    COUNT(*) AS count
FROM
    bookings
GROUP BY
    user_id;

-- Window function
SELECT
    p.id,
    p.name,
    COUNT(*) AS total_books,
    RANK() OVER (
        ORDER BY
            COUNT(*) DESC
    ) AS property_rank,
    ROW_NUMBER() OVER (
        ORDER BY
            COUNT(*) DESC
    ) AS property_row_number
FROM
    properties p
    JOIN bookings b ON b.property_id = p.id
GROUP BY
    p.id,
    p.name;