-- Ensure you're using the correct database
-- USE airbnb_database;

-- Retrieve existing role, payment method, and status IDs
SET @guest_role_id = (SELECT id FROM Role WHERE role_name = 'guest' LIMIT 1);
SET @host_role_id = (SELECT id FROM Role WHERE role_name = 'host' LIMIT 1);
SET @admin_role_id = (SELECT id FROM Role WHERE role_name = 'admin' LIMIT 1);

SET @pending_status_id = (SELECT id FROM Status WHERE status_name = 'pending' LIMIT 1);
SET @confirmed_status_id = (SELECT id FROM Status WHERE status_name = 'confirmed' LIMIT 1);
SET @canceled_status_id = (SELECT id FROM Status WHERE status_name = 'canceled' LIMIT 1);

SET @credit_card_method_id = (SELECT id FROM Payment_Method WHERE method_name = 'credit_card' LIMIT 1);
SET @paypal_method_id = (SELECT id FROM Payment_Method WHERE method_name = 'paypal' LIMIT 1);
SET @stripe_method_id = (SELECT id FROM Payment_Method WHERE method_name = 'stripe' LIMIT 1);

-- Populate Locations
INSERT INTO Location (id, city, state, country) VALUES
    (UUID(), 'New York', 'New York', 'United States'),
    (UUID(), 'San Francisco', 'California', 'United States'),
    (UUID(), 'Austin', 'Texas', 'United States'),
    (UUID(), 'Chicago', 'Illinois', 'United States'),
    (UUID(), 'Miami', 'Florida', 'United States');

-- Get the location IDs for use in subsequent queries
SET @nyc_location_id = (SELECT id FROM Location WHERE city = 'New York' LIMIT 1);
SET @sf_location_id = (SELECT id FROM Location WHERE city = 'San Francisco' LIMIT 1);
SET @austin_location_id = (SELECT id FROM Location WHERE city = 'Austin' LIMIT 1);
SET @chicago_location_id = (SELECT id FROM Location WHERE city = 'Chicago' LIMIT 1);
SET @miami_location_id = (SELECT id FROM Location WHERE city = 'Miami' LIMIT 1);

-- Populate Users (mix of guests and hosts)
INSERT INTO User (id, role_id, first_name, last_name, email, password_hash, phone_number) VALUES
    -- Hosts
    (UUID(), @host_role_id, 'Emma', 'Rodriguez', 'emma.host@example.com', SHA2('password123', 256), '+1-555-123-4567'),
    (UUID(), @host_role_id, 'Alex', 'Thompson', 'alex.host@example.com', SHA2('securepass456', 256), '+1-555-987-6543'),
    (UUID(), @host_role_id, 'Sophia', 'Chen', 'sophia.host@example.com', SHA2('rentalpro789', 256), '+1-555-246-8135'),
    
    -- Guests
    (UUID(), @guest_role_id, 'Michael', 'Johnson', 'michael.guest@example.com', SHA2('travelguest123', 256), '+1-555-369-2580'),
    (UUID(), @guest_role_id, 'Emily', 'Williams', 'emily.guest@example.com', SHA2('booknow456', 256), '+1-555-159-7532'),
    (UUID(), @guest_role_id, 'David', 'Miller', 'david.guest@example.com', SHA2('vacation789', 256), '+1-555-753-9514');

-- Get user IDs for use in subsequent queries
SET @emma_host_id = (SELECT id FROM User WHERE email = 'emma.host@example.com' LIMIT 1);
SET @alex_host_id = (SELECT id FROM User WHERE email = 'alex.host@example.com' LIMIT 1);
SET @sophia_host_id = (SELECT id FROM User WHERE email = 'sophia.host@example.com' LIMIT 1);
SET @michael_guest_id = (SELECT id FROM User WHERE email = 'michael.guest@example.com' LIMIT 1);
SET @emily_guest_id = (SELECT id FROM User WHERE email = 'emily.guest@example.com' LIMIT 1);
SET @david_guest_id = (SELECT id FROM User WHERE email = 'david.guest@example.com' LIMIT 1);

-- Populate Properties
INSERT INTO Property (id, host_id, location_id, name, description, price_per_night) VALUES
    (UUID(), @emma_host_id, @nyc_location_id, 'Luxury Loft in Manhattan', 'Spacious loft with stunning city views in the heart of Manhattan', 350.00),
    (UUID(), @alex_host_id, @sf_location_id, 'Cozy Apartment near Golden Gate', 'Charming studio apartment with a view of the Golden Gate Bridge', 250.00),
    (UUID(), @sophia_host_id, @austin_location_id, 'Modern Downtown Austin Condo', 'Sleek and contemporary condo in the vibrant downtown area', 200.00),
    (UUID(), @emma_host_id, @chicago_location_id, 'Riverside Retreat', 'Peaceful apartment near Chicago River with amazing amenities', 175.00),
    (UUID(), @alex_host_id, @miami_location_id, 'Beachfront Paradise', 'Gorgeous apartment right on the Miami Beach boardwalk', 400.00);

-- Get property IDs for use in subsequent queries
SET @manhattan_property_id = (SELECT id FROM Property WHERE name = 'Luxury Loft in Manhattan' LIMIT 1);
SET @sf_property_id = (SELECT id FROM Property WHERE name = 'Cozy Apartment near Golden Gate' LIMIT 1);
SET @austin_property_id = (SELECT id FROM Property WHERE name = 'Modern Downtown Austin Condo' LIMIT 1);
SET @chicago_property_id = (SELECT id FROM Property WHERE name = 'Riverside Retreat' LIMIT 1);
SET @miami_property_id = (SELECT id FROM Property WHERE name = 'Beachfront Paradise' LIMIT 1);

-- Populate Bookings
INSERT INTO Booking (id, property_id, user_id, status_id, start_date, end_date, total_price) VALUES
    -- Confirmed Bookings
    (UUID(), @manhattan_property_id, @michael_guest_id, @confirmed_status_id, '2024-07-15', '2024-07-20', 1750.00),
    (UUID(), @sf_property_id, @emily_guest_id, @confirmed_status_id, '2024-08-10', '2024-08-15', 1250.00),
    
    -- Pending Bookings
    (UUID(), @austin_property_id, @david_guest_id, @pending_status_id, '2024-09-05', '2024-09-10', 1000.00),
    
    -- Canceled Bookings
    (UUID(), @chicago_property_id, @michael_guest_id, @canceled_status_id, '2024-06-20', '2024-06-25', 875.00);

-- Get booking IDs for use in subsequent queries
SET @manhattan_booking_id = (SELECT id FROM Booking WHERE property_id = @manhattan_property_id AND user_id = @michael_guest_id LIMIT 1);
SET @sf_booking_id = (SELECT id FROM Booking WHERE property_id = @sf_property_id AND user_id = @emily_guest_id LIMIT 1);
SET @austin_booking_id = (SELECT id FROM Booking WHERE property_id = @austin_property_id AND user_id = @david_guest_id LIMIT 1);
SET @chicago_booking_id = (SELECT id FROM Booking WHERE property_id = @chicago_property_id AND user_id = @michael_guest_id LIMIT 1);

-- Populate Payments (for confirmed bookings)
INSERT INTO Payment (id, booking_id, payment_method_id, amount) VALUES
    (UUID(), @manhattan_booking_id, @credit_card_method_id, 1750.00),
    (UUID(), @sf_booking_id, @paypal_method_id, 1250.00);

-- Populate Reviews
INSERT INTO Review (id, property_id, user_id, rating, comment) VALUES
    (UUID(), @manhattan_property_id, @michael_guest_id, 5, 'Amazing stay! The loft was beautiful and the location was perfect.'),
    (UUID(), @sf_property_id, @emily_guest_id, 4, 'Great apartment with an incredible view of the Golden Gate Bridge. Would definitely recommend!');

-- Populate Messages
INSERT INTO Message (id, sender_id, recipient_id, message_body) VALUES
    (UUID(), @michael_guest_id, @emma_host_id, 'Hi, I have a question about the Manhattan loft. Is parking available nearby?'),
    (UUID(), @emma_host_id, @michael_guest_id, 'Yes, there are several parking garages within a 5-minute walk from the loft.'),
    
    (UUID(), @emily_guest_id, @alex_host_id, 'I noticed the San Francisco apartment description mentions a view. Can you confirm the exact perspective?'),
    (UUID(), @alex_host_id, @emily_guest_id, 'The apartment has a partial view of the Golden Gate Bridge from the living room window.');
