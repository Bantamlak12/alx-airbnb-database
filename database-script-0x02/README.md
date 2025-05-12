# How to Seed the Airbnb Database with Sample Data?

This folder contains a SQL script (`seed.sql`) used to populate our Airbnb-style relational database with sample data. This data is ideal for development, testing, and demonstration purposes.

## 📄 What's Included?

The `seed.sql` script inserts realistic sample data into the following tables:

- `Role` – User roles like guest, host, admin
- `Status` – Booking statuses (pending, confirmed, canceled)
- `Payment_Method` – Payment options (credit card, PayPal, Stripe)
- `Location` – City/state/country combinations for property listings
- `User` – A mix of hosts and guests with basic contact details
- `Property` – Listings created by hosts, tied to locations
- `Booking` – Bookings made by users for specific properties
- `Payment` – Payments made for confirmed bookings
- `Review` – Reviews left by guests
- `Message` – Messages exchanged between users (guests and hosts)

## ⚙️ How to Run the Script

Make sure you’ve already created the database and the schema (tables and constraints). Then run the seed script like this:

```bash
sudo mysql -h localhost -u your_username -p your_database_name < seed.sql
