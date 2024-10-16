#Create database “excursions”
CREATE SCHEMA excursions;
-- to enter this database
USE excursions;

#Create table “guides” and insert data:
CREATE TABLE guides (
    id_guide INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

INSERT INTO guides (id_guide, first_name, last_name)
VALUES
    (1, 'Carlos', 'Ramíres'),
    (2, 'Maria', 'Samira'),
    (3, 'Jonathan', 'Clarkson'),
    (4, 'Miguel', 'Pascual'),
    (5, 'Olivia', 'Perez');

#Create table “categories” and insert data:
CREATE TABLE categories (
    id_category INTEGER PRIMARY KEY,
    name TEXT
);

INSERT INTO categories (id_category, name) 
VALUES
    (1, 'Adventure'),
    (2, 'Cultural'),
    (3, 'Historical'),
    (4, 'Nature'),
    (5, 'Relaxation'),
    (6, 'Sport'),
    (7, 'Wellness');
    
#Create table “excursions” and insert data:
CREATE TABLE excursions (
    id_excursion INTEGER PRIMARY KEY,
    title TEXT,
    guide_id INTEGER,
    description TEXT,
    date DATE,
    category_id INTEGER,
    price DECIMAL(10,2),
    availability INTEGER,
    FOREIGN KEY (guide_id) REFERENCES guides(id_guide),
    FOREIGN KEY (category_id) REFERENCES categories(id_category)
);

INSERT INTO excursions (id_excursion, title, guide_id, description, date, category_id, price, availability)
VALUES
    (1, 'Mountain Hiking', 1, 'A challenging hike through the mountains', '2024-05-30', 1, 50.00, 10),
    (2, 'City Tour', 2, 'A guided tour of the city\'s historical sites', '2024-06-28', 2, 30.00, 15),
    (3, 'Beach Day', 3, 'A relaxing day at the beach with activities', '2024-07-15', 5, 40.00, 20),
    (4, 'Museum Visit', 4, 'A visit to the city\'s famous museum', '2024-08-10', 3, 25.00, 12),
    (5, 'Kayaking', 5, 'An adventurous kayaking trip', '2024-09-05', 6, 45.00, 8),
    (6, 'Yoga Retreat', 3, 'A peaceful yoga retreat in nature', '2024-10-01', 7, 60.00, 6);

#Create table “bookings” and insert data:
CREATE TABLE bookings (
    id_booking INTEGER PRIMARY KEY,
    excursion_id INTEGER,
    customer_id INTEGER,
    booking_date DATE,
    return_date DATE,
    FOREIGN KEY(excursion_id) REFERENCES excursions(id_excursion)
);

INSERT INTO bookings (id_booking, excursion_id, customer_id, booking_date, return_date)
VALUES
    (1, 1, 1, '2024-03-01', '2024-03-07'),
    (2, 2, 2, '2024-03-02', '2024-03-08'),
    (3, 3, 3, '2024-03-03', '2024-03-09'),
    (4, 4, 4, '2024-03-04', '2024-03-10'),
    (5, 5, 5, '2024-03-05', '2024-03-11'),
    (6, 1, 5, '2024-04-01', '2024-04-07'),
    (7, 1, 3, '2024-03-09', '2024-03-15'),
    (8, 5, 3, '2024-03-15', '2024-03-24');

#Create table "customers" and insert data:
CREATE TABLE customers (
    id_customer INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT
);

INSERT INTO customers (id_customer, first_name, last_name, email, phone)
VALUES
    (1, 'Alice', 'Smith', 'alice.smith@email.com', '+1234567890'),
    (2, 'Bob', 'Johnson', 'bob.johnson@email.com', '+1987654321'),
    (3, 'Carol', 'Williams', 'carol.williams@email.com', '+1123456789'),
    (4, 'David', 'Brown', 'david.brown@email.com', '+1345678901'),
    (5, 'Eva', 'Jones', 'eva.jones@email.com', '+1456789012'),
    (6, 'Frank', 'Garcia', 'frank.garcia@email.com', '+1567890123'),
    (7, 'Grace', 'Miller', 'grace.miller@email.com', '+1678901234'),
    (8, 'Henry', 'Davis', 'henry.davis@email.com', '+1789012345'),
    (9, 'Ivy', 'Martinez', 'ivy.martinez@email.com', '+1890123456'),
    (10, 'Jack', 'Rodriguez', 'jack.rodriguez@email.com', '+1901234567');

##QUERYING THE DATA##
#EXCURSIONS#
#1.) Select all excursions with a price greater than €40 and less than €50:
SELECT * FROM excursions WHERE price > 40 AND price < 50;

#2.) Find the excursion with the most recent date:
SELECT * FROM excursions ORDER BY date DESC LIMIT 1;

#3.) Show excursions with a price higher than the average price:
SELECT * FROM excursions WHERE price > (SELECT AVG(price) FROM excursions);

#4.) Show the name and number of excursions for each category name:
SELECT categories.name, COUNT(excursions.id_excursion) AS number_of_excursions
FROM excursions
JOIN categories ON excursions.category_id = categories.id_category
GROUP BY categories.name;

#5.) Find the most expensive excursion in each category:
SELECT categories.name, excursions.title, excursions.price
FROM excursions
JOIN categories ON excursions.category_id = categories.id_category
JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM excursions
    GROUP BY category_id
) AS max_excursions ON excursions.category_id = max_excursions.category_id AND excursions.price = max_excursions.max_price
ORDER BY price;

#6.) List excursions that have not been booked at all:
SELECT excursions.title FROM excursions
LEFT JOIN bookings ON excursions.id_excursion = bookings.excursion_id
WHERE bookings.id_booking IS NULL;

#7.) Calculate the running total of bookings for each excursion:
SELECT excursions.title, bookings.excursion_id, bookings.booking_date, 
SUM(1) OVER (PARTITION BY bookings.excursion_id ORDER BY bookings.booking_date) AS running_total
FROM bookings
JOIN excursions ON bookings.excursion_id = excursions.id_excursion;

#GUIDES#
#1.) List all guides alphabetically by their last name:
SELECT * FROM guides ORDER BY last_name;

#2.) Find the guide with the most excursions:
SELECT guides.first_name, guides.last_name, COUNT(excursions.id_excursion) AS number_of_excursions
FROM guides
JOIN excursions ON guides.id_guide = excursions.guide_id
GROUP BY guides.id_guide
ORDER BY number_of_excursions DESC
LIMIT 1;

#3.) Get the first and last names of the guides along with the total availability of their excursions:
SELECT guides.first_name, guides.last_name, SUM(excursions.availability) AS total_availability
FROM guides
JOIN excursions ON guides.id_guide = excursions.guide_id
GROUP BY guides.id_guide
ORDER BY total_availability DESC;

#4.) Show the guides whose excursions have an average price higher than the overall average price:
SELECT guides.first_name, guides.last_name, AVG(excursions.price) AS average_price
FROM guides
JOIN excursions ON guides.id_guide = excursions.guide_id
GROUP BY guides.id_guide
HAVING average_price > (SELECT AVG(price) FROM excursions);

#5.) Find guides who have led excursions in more than one category:
SELECT guides.first_name, guides.last_name, COUNT(DISTINCT excursions.category_id) AS number_of_categories
FROM guides
JOIN excursions ON guides.id_guide = excursions.guide_id
GROUP BY guides.id_guide
HAVING number_of_categories > 1;

#CATEGORIES#
#1.) Count the total number of categories:
SELECT COUNT(*) FROM categories;

#2.) Find the category with the most excursions:
SELECT categories.name, COUNT(excursions.id_excursion) AS number_of_excursions
FROM categories
JOIN excursions ON categories.id_category = excursions.category_id
GROUP BY categories.id_category
ORDER BY number_of_excursions DESC
LIMIT 1;

#3.) List the categories alphabetically along with the average price of excursions in each category:
SELECT categories.name, AVG(excursions.price) AS average_price
FROM categories
JOIN excursions ON categories.id_category = excursions.category_id
GROUP BY categories.id_category
ORDER BY categories.name;

#BOOKINGS#
#1.) List the bookings made by a specific customer (e.g., customer with ID 3): 
SELECT * FROM bookings WHERE customer_id = 3; 

#2.) Calculate the number of excursions booked per month in a specific year:
SELECT MONTH(booking_date) AS month, COUNT(*) AS number_of_bookings
FROM bookings
WHERE YEAR(booking_date) = 2024
GROUP BY month;

#3.) Select the title of each excursion along with the number of times it has been booked:
SELECT excursions.title, COUNT(bookings.id_booking) AS number_of_bookings
FROM excursions
JOIN bookings ON excursions.id_excursion = bookings.excursion_id
GROUP BY excursions.id_excursion
ORDER BY number_of_bookings DESC;

#4.) Find the most booked excursion:
SELECT excursions.title, COUNT(bookings.id_booking) AS number_of_bookings
FROM excursions
JOIN bookings ON excursions.id_excursion = bookings.excursion_id
GROUP BY excursions.id_excursion
ORDER BY number_of_bookings DESC
LIMIT 1;

#5.) Select the first name and last name of the customer along with the title of the excursion (excursions that have been booked):
SELECT customers.first_name, customers.last_name, excursions.title, DATEDIFF(bookings.return_date, bookings.booking_date) AS duration
FROM bookings
JOIN customers ON bookings.customer_id = customers.id_customer
JOIN excursions ON bookings.excursion_id = excursions.id_excursion
ORDER BY duration DESC
LIMIT 1;

#5.) Calculate the total revenue generated from bookings for each excursion:
SELECT excursions.title, SUM(excursions.price) AS total_revenue
FROM bookings
JOIN excursions ON bookings.excursion_id = excursions.id_excursion
GROUP BY excursions.id_excursion
ORDER BY total_revenue DESC;

#6.) Find the average duration of bookings for each customer:
SELECT customers.first_name, customers.last_name, AVG(DATEDIFF(bookings.return_date, bookings.booking_date)) AS average_duration
FROM bookings
JOIN customers ON bookings.customer_id = customers.id_customer
GROUP BY customers.id_customer
ORDER BY average_duration;

##EXTRAS: ADVANCED SQL QUERIES##

#1.) *Common Table Expressions (CTEs):*
#Find excursions that have been booked more than the average number of times:

WITH booking_counts AS (
	SELECT excursion_id, COUNT(*) AS booking_count
	FROM bookings
	GROUP BY excursion_id
    ),
    average_bookings AS (
	SELECT AVG(booking_count) AS avg_bookings
	FROM booking_counts
    )
SELECT excursions.title, booking_counts.booking_count
FROM booking_counts
JOIN excursions ON booking_counts.excursion_id = excursions.id_excursion
CROSS JOIN average_bookings
WHERE booking_counts.booking_count > average_bookings.avg_bookings;

#2.) *Subqueries*
#Find excursions that have been booked by every customer:

SELECT title
FROM excursions
WHERE NOT EXISTS (
	SELECT 1
	FROM customers
	WHERE NOT EXISTS (
		SELECT 1
		FROM bookings
		WHERE bookings.excursion_id = excursions.id_excursion
			AND bookings.customer_id = customers.id_customer
        )
    );

#3.) *Advanced Joins*
#Find excursions that have been booked by customers who have also booked a specific excursion (e.g., 'Mountain Hiking'):

SELECT DISTINCT e2.title
FROM bookings AS b1
JOIN bookings AS b2 ON b1.customer_id = b2.customer_id
JOIN excursions AS e1 ON b1.excursion_id = e1.id_excursion
JOIN excursions AS e2 ON b2.excursion_id = e2.id_excursion
WHERE e1.title = 'Mountain Hiking' AND e2.title != 'Mountain Hiking';
