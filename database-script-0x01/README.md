# 🏡 Database Schema (DDL) for AirBnB Database

This folder contains the SQL schema for AirBnB booking platform. It includes tables and relationships to support user roles, property listings, bookings, payments, reviews, and messaging.

---

## 📚 Overview

The schema includes:

- **User management** with roles: guest, host, admin
- **Property hosting** and location data
- **Booking system** with status tracking
- **Payment tracking** with multiple methods
- **User reviews** for properties
- **Messaging system** between users

---

## 🧱 Schema Structure

### 🔐 `Role`

| Column     | Type    | Description        |
|------------|---------|--------------------|
| `id`       | UUID    | Primary key        |
| `role_name`| VARCHAR | Unique role name (e.g. `guest`, `host`, `admin`) |

---

### 📍 `Location`

| Column   | Type    | Description  |
|----------|---------|--------------|
| `id`     | UUID    | Primary key  |
| `city`   | VARCHAR | Required     |
| `state`  | VARCHAR | Required     |
| `country`| VARCHAR | Required     |

**Indexes**: `(city, state, country)`

---

### 📌 `Status`

| Column       | Type    | Description      |
|--------------|---------|------------------|
| `id`         | UUID    | Primary key      |
| `status_name`| VARCHAR | Unique status (e.g. `pending`, `confirmed`, `canceled`) |

---

### 💳 `Payment_Method`

| Column        | Type    | Description        |
|---------------|---------|--------------------|
| `id`          | UUID    | Primary key        |
| `method_name` | VARCHAR | Unique (e.g. `credit_card`, `paypal`, `stripe`) |

---

### 👤 `User`

| Column         | Type      | Description                 |
|----------------|-----------|-----------------------------|
| `id`           | UUID      | Primary key                 |
| `role_id`      | UUID      | FK → `Role(id)`             |
| `first_name`   | VARCHAR   | Required                    |
| `last_name`    | VARCHAR   | Required                    |
| `email`        | VARCHAR   | Unique, indexed             |
| `password_hash`| VARCHAR   | Hashed password             |
| `phone_number` | VARCHAR   | Optional                    |
| `created_at`   | TIMESTAMP | Default: current timestamp  |

**Indexes**: `email`

---

### 🏠 `Property`

| Column           | Type      | Description                  |
|------------------|-----------|------------------------------|
| `id`             | UUID      | Primary key                  |
| `host_id`        | UUID      | FK → `User(id)`              |
| `location_id`    | UUID      | FK → `Location(id)`          |
| `name`           | VARCHAR   | Required                     |
| `description`    | TEXT      | Required                     |
| `price_per_night`| DECIMAL   | Required                     |
| `created_at`     | TIMESTAMP | Default: current timestamp   |
| `updated_at`     | TIMESTAMP | Auto-update on modification  |

**Indexes**: `host_id`, `location_id`, `price_per_night`

---

### 📅 `Booking`

| Column        | Type      | Description                        |
|---------------|-----------|------------------------------------|
| `id`          | UUID      | Primary key                        |
| `user_id`     | UUID      | FK → `User(id)`                    |
| `property_id` | UUID      | FK → `Property(id)`                |
| `status_id`   | UUID      | FK → `Status(id)`                  |
| `start_date`  | DATE      | Must precede `end_date`            |
| `end_date`    | DATE      | Must follow `start_date`           |
| `total_price` | DECIMAL   | Total cost of booking              |
| `created_at`  | TIMESTAMP | Default: current timestamp         |

**Constraints**: `CHECK (end_date > start_date)`  
**Indexes**: `user_id`, `property_id`, `status_id`, `(start_date, end_date)`

---

### 💰 `Payment`

| Column             | Type      | Description                     |
|--------------------|-----------|---------------------------------|
| `id`               | UUID      | Primary key                     |
| `booking_id`       | UUID      | FK → `Booking(id)`              |
| `payment_method_id`| UUID      | FK → `Payment_Method(id)`       |
| `amount`           | DECIMAL   | Must be > 0                     |
| `payment_date`     | TIMESTAMP | Default: current timestamp      |

**Indexes**: `booking_id`, `payment_method_id`, `payment_date`  
**Constraint**: `CHECK (amount > 0)`

---

### ⭐ `Review`

| Column      | Type      | Description                     |
|-------------|-----------|---------------------------------|
| `id`        | UUID      | Primary key                     |
| `property_id`| UUID     | FK → `Property(id)`             |
| `user_id`   | UUID      | FK → `User(id)`                 |
| `rating`    | INTEGER   | Between 1 and 5                 |
| `comment`   | TEXT      | Required                        |
| `created_at`| TIMESTAMP | Default: current timestamp      |

**Constraint**: `CHECK (rating BETWEEN 1 AND 5)`  
**Indexes**: `property_id`, `user_id`, `rating`

---

### 💬 `Message`

| Column        | Type      | Description               |
|---------------|-----------|---------------------------|
| `id`          | UUID      | Primary key               |
| `sender_id`   | UUID      | FK → `User(id)`           |
| `recipient_id`| UUID      | FK → `User(id)`           |
| `message_body`| TEXT      | Required                  |
| `sent_at`     | TIMESTAMP | Default: current timestamp|

**Indexes**: `sender_id`, `recipient_id`

---

## 🚀 Initial Seed Data

The schema includes inserts for quick setup:

### `Role`
- `guest`
- `host`
- `admin`

### `Status`
- `pending`
- `confirmed`
- `canceled`

### `Payment_Method`
- `credit_card`
- `paypal`
- `stripe`

> **Note:** UUIDs are generated using `UUID()` in MySQL. For PostgreSQL, use `gen_random_uuid()` and enable the `pgcrypto` extension.

---

## ⚠️ Notes

- The script starts with `DROP TABLE IF EXISTS` — use caution in production.
- Table creation follows a dependency-safe order.
- UUIDs are used as primary keys across all tables.

---

## 🛠 Compatibility

- Compatible with **MySQL** and **PostgreSQL** with minor adjustments.
- Replace UUID function based on your RDBMS:
  - **MySQL**: `UUID()`
  - **PostgreSQL**: `gen_random_uuid()` (with `pgcrypto`)

