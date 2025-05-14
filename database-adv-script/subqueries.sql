-- Correlated and non-correlated subqueries
-- Find all properties where average rating is greater than 4.0
-- Non-correlated subquery
SELECT
    *
FROM
    properties
WHERE
    id IN (
        SELECT
            property_id
        FROM
            reviews
        WHERE
            AVG(rating) > 4.0
    );

-- Find user who have made more than 3 bookings
-- Correlated subquery
SELECT
    *
FROM
    users u
WHERE
    (
        SELECT
            COUNT(*)
        FROM
            bookings b
        WHERE
            u.id = b.user_id
    );