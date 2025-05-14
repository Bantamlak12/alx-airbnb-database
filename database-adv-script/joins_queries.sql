-- Retrieving all booking and respective users who have made those booking.
SELECT
    *
FROM
    bookings
    INNER JOIN users ON bookings.user_id = users.id;

-- Retrieving all properties and their reviews, including properties that have no reviews.
SELECT
    *
FROM
    properties
    LEFT JOIN reviews ON properties.id = reviews.property_id;

-- Retrieve all users and all bookings, even if the user has no booking or booking is not linked to user.
SELECT
    *
FROM
    users
    FULL OUTER JOIN bookings ON users.id = bookings.user_id;