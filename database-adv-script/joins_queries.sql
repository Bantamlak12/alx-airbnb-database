-- Retrieving all booking and respective users who have made those booking.
SELECT
    *
FROM
    booking
    INNER JOIN user ON booking.user_id = user.id;

-- Retrieving all properties and their reviews, including properties that have no reviews.
SELECT
    *
FROM
    property
    LEFT JOIN review ON property.id = review.property_id;

-- Retrieve all users and all bookings, even if the user has no booking or booking is not linked to user.
SELECT
    *
FROM
    user
    FULL OUTER JOIN booking ON user.id = booking.user_id;