# Excursion Sales SQL Exercise

Welcome to the **Excursion Sales** SQL exercise! This project focuses on analyzing data from an online excursion sales company, aiming to enhance our understanding of customer preferences and improve our excursion offerings. This project is my own invention.

## Database Schema Overview

The database consists of five main tables, each serving a distinct purpose:

### 1. Excursions
This table contains detailed information about the available excursions. Each entry includes:
- **`id_excursion`**: Primary key uniquely identifying each excursion.
- **`title`**: The name of the excursion.
- **`guide_id`**: Foreign key linking to the **Guides** table.
- **`description`**: A brief overview of what the excursion entails.
- **`date`**: The scheduled date for the excursion.
- **`category_id`**: Foreign key referencing the **Categories** table.
- **`price`**: The cost of the excursion.
- **`availability`**: The number of spots available for booking.

### 2. Guides
This table holds information about the excursion guides. It includes:
- **`id_guide`**: Primary key uniquely identifying each guide.
- **`first_name`**: The guide's first name.
- **`last_name`**: The guide's last name.

### 3. Categories
This table provides details about the different excursion categories. It features:
- **`id_category`**: Primary key uniquely identifying each category.
- **`name`**: The name of the category (e.g., Adventure, Cultural, Nature).

### 4. Customers
This table contains information about the customers who book excursions. Each entry consists of:
- **`id_customer`**: Primary key uniquely identifying each customer.
- **`first_name`**: The customer's first name.
- **`last_name`**: The customer's last name.
- **`email`**: The customer's email address.
- **`phone_number`**: The customer's contact number.

### 5. Bookings
This table captures the details of excursion bookings made by customers. Each entry consists of:
- **`id_booking`**: Primary key uniquely identifying each booking.
- **`excursion_id`**: Foreign key linking to the **Excursions** table.
- **`customer_id`**: Foreign key linking to the **Customers** table.
- **`booking_date`**: The date the booking was made.
- **`return_date`**: The date of the excursion's conclusion.

## Querying the Data

Leveraging these tables, a variety of SQL queries can be executed to extract meaningful insights and information about excursion sales, customer preferences, and guide performance. This exercise not only enhances your SQL skills but also provides practical insights into managing and analyzing sales data for an online excursion platform.
