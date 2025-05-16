CREATE INDEX idx_booking_property_name ON properties (name);

CREATE INDEX idx_booking_user ON bookings (user_id);

CREATE INDEX idx_booking_property ON bookings (property_id);

EXPLAIN
SELECT
    *
FROM
    properties
WHERE
    name = 'Riverside Retreat';