-- Drop table if they exists to avoid conflicts (Note: be careful while in production)
-- Execute in reverse order of dependencies to avoid foreign key constraint errors
DROP TABLE IF EXISTS messages;

DROP TABLE IF EXISTS reviews;

DROP TABLE IF EXISTS payments;

DROP TABLE IF EXISTS bookings;

DROP TABLE IF EXISTS properties;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS locations;

DROP TABLE IF EXISTS statuses;

DROP TABLE IF EXISTS payment_methods;

DROP TABLE IF EXISTS roles;

-- Create roles table
CREATE TABLE
    roles (
        id VARCHAR(36) PRIMARY KEY,
        role_name VARCHAR(50) UNIQUE NOT NULL
    );

-- Create locations table
CREATE TABLE
    locations (
        id VARCHAR(36) PRIMARY KEY,
        city VARCHAR(50) NOT NULL,
        state VARCHAR(50) NOT NULL,
        country VARCHAR(50) NOT NULL,
        -- Composite index for locations based queries
        INDEX idx_location_composite (city, state, country)
    );

-- Create statuses table
CREATE TABLE
    statuses (
        id VARCHAR(36) PRIMARY KEY,
        status_name VARCHAR(50) NOT NULL UNIQUE
    );

-- Create payment_methods table
CREATE TABLE
    payment_methods (
        id VARCHAR(36) PRIMARY key,
        method_name VARCHAR(50) NOT NULL UNIQUE
    );

-- Create users table
CREATE TABLE
    users (
        id VARCHAR(36) PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        password_hash VARCHAR(100) NOT NULL,
        phone_number VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        role_id VARCHAR(36) NOT NULL,
        -- Foreign key constraint
        CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES roles (id),
        -- Indexing email
        INDEX idx_user_email (email)
    );

-- Create properties table
CREATE TABLE
    properties (
        id VARCHAR(36) PRIMARY key,
        name VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        price_per_night DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        host_id VARCHAR(36) NOT NULL,
        location_id VARCHAR(36) NOT NULL,
        -- Foregin key constraints
        CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES users (id),
        CONSTRAINT fk_property_location FOREIGN KEY (location_id) REFERENCES locations (id),
        -- Indexes
        INDEX idx_property_host (host_id),
        INDEX idx_property_location (location_id),
        INDEX idx_property_price (price_per_night)
    );

-- Create bookings table
CREATE TABLE
    bookings (
        id VARCHAR(36) PRIMARY KEY,
        status_id VARCHAR(36) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_price DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        user_id VARCHAR(36) NOT NULL,
        property_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users (id),
        CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES properties (id),
        CONSTRAINT fk_booking_status FOREIGN KEY (status_id) REFERENCES statuses (id),
        -- Check constraints
        CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
        -- Indexes
        INDEX idx_booking_user (user_id),
        INDEX idx_booking_property (property_id),
        INDEX idx_booking_status (status_id),
        INDEX idx_booking_dates (start_date, end_date)
    );

-- Create payments table
CREATE TABLE
    payments (
        id VARCHAR(36) PRIMARY KEY,
        amount DECIMAL(10, 2) NOT NULL,
        payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        booking_id VARCHAR(36) NOT NULL,
        payment_method_id VARCHAR(36) NOT NULL,
        -- Foreign Key constraints
        CONSTRAINT fk_payments_booking FOREIGN KEY (booking_id) REFERENCES bookings (id),
        CONSTRAINT fk_payments_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id),
        -- Check constrainst
        CONSTRAINT chk_payments_amount CHECK (amount > 0),
        -- Indexes
        INDEX idx_payments_booking (booking_id),
        INDEX idx_payments_method (payment_method_id),
        INDEX idx_payments_dates (payment_date)
    );

--  Create reviews table
CREATE TABLE
    reviews (
        id VARCHAR(36) PRIMARY KEY,
        rating INTEGER NOT NULL,
        comment TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        property_id VARCHAR(36) NOT NULL,
        user_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_reviews_property FOREIGN KEY (property_id) REFERENCES properties (id),
        CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users (id),
        -- Check constraints
        CONSTRAINT chk_reviews_rating CHECK (
            rating >= 1
            AND rating <= 5
        ),
        -- Indexes
        INDEX idx_reviews_property (property_id),
        INDEX idx_reviews_user (user_id),
        INDEX idx_reviews_rating (rating)
    );

-- Create messages table
CREATE TABLE
    messages (
        id VARCHAR(36) PRIMARY KEY,
        body TEXT NOT NULL,
        sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        sender_id VARCHAR(36) NOT NULL,
        recipient_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES users (id),
        CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES users (id),
        -- Indexes
        INDEX idx_message_sender (sender_id),
        INDEX idx_message_recipient (recipient_id)
    );

-- Insert initial data for reference tables
-- Insert into ROle table
INSERT INTO
    roles (id, role_name)
VALUES
    (UUID (), 'guest'), -- MySQL support UUID(), and PostgreSQL support gen_random_uuid()
    (UUID (), 'host'),
    (UUID (), 'admin');

-- Insert into statuses table
INSERT INTO
    statuses (id, status_name)
VALUES
    (UUID (), 'pending'),
    (UUID (), 'confirmed'),
    (UUID (), 'canceled');

-- Insert into payment_methods table
INSERT INTO
    payment_methods (id, method_name)
VALUES
    (UUID (), 'credit_card'),
    (UUID (), 'paypal'),
    (UUID (), 'stripe');