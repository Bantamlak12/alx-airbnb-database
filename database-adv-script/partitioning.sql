-- Partition Large Tables by date
RENAME TABLE bookings TO bookings_backup;

CREATE TABLE
    bookings (
        id VARCHAR(36),
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_price DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id, start_date)
    )

PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

INSERT INTO bookings (id, start_date, end_date, total_price, created_at)
SELECT id, start_date, end_date, total_price, created_at
FROM bookings_backup;
