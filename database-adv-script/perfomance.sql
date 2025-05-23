-- Retrieves all bookings along with the user details, property details, and payment details
SELECT
    *
FROM
    users u
    LEFT JOIN bookings b ON b.user_id = u.id
    LEFT JOIN properties pr ON b.property_id = pr.id
    LEFT JOIN payments pm ON pm.booking_id = b.id
WHERE
    u.id = b.user_id
    AND pr.id = b.property_id
    AND pm.booking_id = b.id;

-- Analyze the query
EXPLAIN
SELECT
    *
FROM
    users u
    LEFT JOIN bookings b ON b.user_id = u.id
    LEFT JOIN properties pr ON b.property_id = pr.id
    LEFT JOIN payments pm ON pm.booking_id = b.id
WHERE
    u.id = b.user_id
    AND pr.id = b.property_id
    AND pm.booking_id = b.id;

-- Refactor the query to reduce execution time
SELECT
    u.id AS user_id,
    u.first_name,
    u.last_name,
    pr.name AS property_name,
    b.total_price AS booking_price,
    pm.amount AS paid_amount,
    pm.payment_date
FROM
    bookings b
    JOIN users u ON b.user_id = u.id
    JOIN properties pr ON b.property_id = pr.id
    JOIN payments pm ON pm.booking_id = b.id;