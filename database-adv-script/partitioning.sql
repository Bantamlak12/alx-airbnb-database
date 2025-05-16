-- Partition Large Tables by date
CREATE TABLE
    bookings_partitioned (
        id VARCHAR(36),
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_price DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id, start_date)
    )
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_before_2021 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

-- Create indexes for common query patterns
CREATE INDEX idx_start_date ON bookings_partitioned(start_date);
CREATE INDEX idx_end_date ON bookings_partitioned(end_date);
CREATE INDEX idx_created_at ON bookings_partitioned(created_at);

-- Migrate data from the bookings table to the partitioned table
INSERT INTO bookings_partitioned (id, start_date, end_date, total_price, created_at)
SELECT id, start_date, end_date, total_price, created_at
FROM bookings;

-- Analyze the table to update statistics
ANALYZE TABLE bookings_partitioned;
