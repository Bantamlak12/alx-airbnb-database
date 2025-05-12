-- Drop table if they exists to avoid conflicts (Note: be careful while in production)
-- Execute in reverse order of dependencies to avoid foreign key constraint errors
DROP TABLE IF EXISTS Message;

DROP TABLE IF EXISTS Review;

DROP TABLE IF EXISTS Payment;

DROP TABLE IF EXISTS Booking;

DROP TABLE IF EXISTS Property;

DROP TABLE IF EXISTS User;

DROP TABLE IF EXISTS Location;

DROP TABLE IF EXISTS Status;

DROP TABLE IF EXISTS Payment_Method;

DROP TABLE IF EXISTS Role;

-- Create Role table
CREATE TABLE
    Role (
        id VARCHAR(36) PRIMARY KEY,
        role_name VARCHAR(50) UNIQUE NOT NULL
    );

-- Create Location table
CREATE TABLE
    Location (
        id VARCHAR(36) PRIMARY KEY,
        city VARCHAR(50) NOT NULL,
        state VARCHAR(50) NOT NULL,
        country VARCHAR(50) NOT NULL,
        -- Composite index for location based queries
        INDEX idx_location_composite (city, state, country)
    );

-- Create Status table
CREATE TABLE
    Status (
        id VARCHAR(36) PRIMARY KEY,
        status_name VARCHAR(50) NOT NULL UNIQUE
    );

-- Create Payment_Method table
CREATE TABLE
    Payment_Method (
        id VARCHAR(36) PRIMARY key,
        method_name VARCHAR(50) NOT NULL UNIQUE
    );

-- Create User table
CREATE TABLE
    User (
        id VARCHAR(36) PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        password_hash VARCHAR(100) NOT NULL,
        phone_number VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        role_id VARCHAR(36) NOT NULL,
        -- Foreign key constraint
        CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES Role (id),
        -- Indexing email
        INDEX idx_user_email (email)
    );

-- Create Property table
CREATE TABLE
    Property (
        id VARCHAR(36) PRIMARY key,
        name VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        price_per_night DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        host_id VARCHAR(36) NOT NULL,
        location_id VARCHAR(36) NOT NULL,
        -- Foregin key constraints
        CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES User (id),
        CONSTRAINT fk_property_location FOREIGN KEY (location_id) REFERENCES Location (id),
        -- Indexes
        INDEX idx_property_host (host_id),
        INDEX idx_property_location (location_id),
        INDEX idx_property_price (price_per_night)
    );

-- Create Booking table
CREATE TABLE
    Booking (
        id VARCHAR(36) PRIMARY KEY,
        status_id VARCHAR(36) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_price DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        user_id VARCHAR(36) NOT NULL,
        property_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES User (id),
        CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property (id),
        CONSTRAINT fk_booking_status FOREIGN KEY (status_id) REFERENCES Status (id),
        -- Check constraints
        CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
        -- Indexes
        INDEX idx_booking_user (user_id),
        INDEX idx_booking_property (property_id),
        INDEX idx_booking_status (status_id),
        INDEX idx_booking_dates (start_date, end_date)
    );

-- Create Payment table
CREATE TABLE
    Payment (
        id VARCHAR(36) PRIMARY KEY,
        amount DECIMAL(10, 2) NOT NULL,
        payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        booking_id VARCHAR(36) NOT NULL,
        payment_method_id VARCHAR(36) NOT NULL,
        -- Foreign Key constraints
        CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking (id),
        CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES Payment_Method (id),
        -- Check constrainst
        CONSTRAINT chk_payment_amount CHECK (amount > 0),
        -- Indexes
        INDEX idx_payment_booking (booking_id),
        INDEX idx_payment_method (payment_method_id),
        INDEX idx_payment_dates (payment_date)
    );

--  Create Review table
CREATE TABLE
    Review (
        id VARCHAR(36) PRIMARY KEY,
        rating INTEGER NOT NULL,
        comment TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        property_id VARCHAR(36) NOT NULL,
        user_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Property (id),
        CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES User (id),
        -- Check constraints
        CONSTRAINT chk_review_rating CHECK (
            rating >= 1
            AND rating <= 5
        ),
        -- Indexes
        INDEX idx_review_property (property_id),
        INDEX idx_review_user (user_id),
        INDEX idx_review_rating (rating)
    );

-- Create Message table
CREATE TABLE
    Message (
        id VARCHAR(36) PRIMARY KEY,
        message_body TEXT NOT NULL,
        sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        sender_id VARCHAR(36) NOT NULL,
        recipient_id VARCHAR(36) NOT NULL,
        -- Foreign key constraints
        CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES User (id),
        CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES User (id),
        -- Indexes
        INDEX idx_message_sender (sender_id),
        INDEX idx_message_recipient (recipient_id)
    );

-- Insert initial data for reference tables
-- Insert into ROle table
INSERT INTO
    Role (id, role_name)
VALUES
    (UUID (), 'guest'), -- MySQL support UUID(), and PostgreSQL support gen_random_uuid()
    (UUID (), 'host'),
    (UUID (), 'admin');

-- Insert into Status table
INSERT INTO
    Status (id, status_name)
VALUES
    (UUID (), 'pending'),
    (UUID (), 'confirmed'),
    (UUID (), 'canceled');

-- Insert into Payment_Method table
INSERT INTO
    Payment_Method (id, method_name)
VALUES
    (UUID (), 'credit_card'),
    (UUID (), 'paypal'),
    (UUID (), 'stripe');
    