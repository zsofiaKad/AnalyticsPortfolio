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
    (5, 'Olivia', 'Perez'),
    (6, 'Sophia', 'Lopez'),
    (7, 'David', 'Martin'),
    (8, 'Emma', 'Taylor'),
    (9, 'Liam', 'Anderson'),
    (10, 'Noah', 'King');

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
    (7, 'Wellness'),
    (8, 'Gastronomy'),
    (9, 'Photography'),
    (10, 'Wildlife');
    
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
    (6, 'Yoga Retreat', 3, 'A peaceful yoga retreat in nature', '2024-10-01', 7, 60.00, 6),
    (7, 'Culinary Tour', 6, 'Taste the local cuisine on this food tour', '2024-07-20', 8, 75.00, 5),
    (8, 'Wildlife Safari', 7, 'Explore the wildlife in their natural habitat', '2024-09-10', 10, 100.00, 3),
    (9, 'Photography Workshop', 8, 'Learn photography skills while exploring', '2024-08-15', 9, 55.00, 4),
    (10, 'Scuba Diving', 9, 'Dive into the ocean and discover marine life', '2024-11-11', 1, 85.00, 8),
    (11, 'Horseback Riding', 10, 'A scenic ride through the countryside', '2024-12-05', 4, 65.00, 10),
    (12, 'Rock Climbing', 1, 'An exciting rock climbing experience', '2024-06-15', 1, 70.00, 7),
    (13, 'Spa Day', 2, 'Enjoy a day of relaxation and pampering', '2024-07-25', 7, 90.00, 6),
    (14, 'Cultural Dance', 3, 'Learn traditional dances and their history', '2024-10-30', 2, 40.00, 12),
    (15, 'Bird Watching', 4, 'Observe local bird species in their habitat', '2024-11-20', 10, 50.00, 5);

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
    (1, 4, 8, '2024-11-30', '2024-12-08'),
    (2, 5, 6, '2024-06-24', '2024-06-30'),
    (3, 4, 8, '2024-04-11', '2024-04-16'),
    (4, 2, 9, '2024-12-24', '2024-12-29'),
    (5, 1, 9, '2024-04-15', '2024-04-24'),
    (6, 2, 3, '2024-05-20', '2024-05-26'),
    (7, 5, 5, '2024-05-24', '2024-06-03'),
    (8, 5, 7, '2024-11-06', '2024-11-14'),
    (9, 2, 6, '2024-09-27', '2024-09-30'),
    (10, 3, 3, '2024-08-02', '2024-08-11'),
    (11, 1, 2, '2024-10-10', '2024-10-20'),
    (12, 3, 7, '2024-04-21', '2024-04-24'),
    (13, 4, 7, '2024-12-08', '2024-12-15'),
    (14, 4, 3, '2024-07-24', '2024-08-01'),
    (15, 5, 1, '2024-09-16', '2024-09-18'),
    (16, 5, 6, '2024-05-27', '2024-06-06'),
    (17, 5, 3, '2024-12-10', '2024-12-12'),
    (18, 1, 9, '2024-08-03', '2024-08-04'),
    (19, 5, 2, '2024-01-30', '2024-02-06'),
    (20, 1, 9, '2024-08-01', '2024-08-03'),
    (21, 1, 8, '2024-07-29', '2024-08-02'),
    (22, 5, 6, '2024-10-05', '2024-10-14'),
    (23, 3, 2, '2024-10-27', '2024-11-01'),
    (24, 4, 10, '2024-10-13', '2024-10-15'),
    (25, 4, 6, '2024-10-08', '2024-10-16'),
    (26, 1, 1, '2024-12-02', '2024-12-05'),
    (27, 2, 7, '2024-06-12', '2024-06-17'),
    (28, 1, 8, '2024-06-27', '2024-07-03'),
    (29, 3, 4, '2024-02-24', '2024-03-01'),
    (30, 4, 10, '2024-05-26', '2024-05-27'),
    (31, 6, 6, '2024-06-07', '2024-06-13'),
    (32, 1, 9, '2024-02-26', '2024-03-03'),
    (33, 3, 6, '2024-12-12', '2024-12-15'),
    (34, 3, 3, '2024-07-17', '2024-07-26'),
    (35, 4, 5, '2024-05-24', '2024-05-25');

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

#Specific query, like selecting just the title and price columns
SELECT title, price FROM excursions WHERE price > 40 AND price < 50;

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
ORDER BY price DESC;

#6.) List excursions that have not been booked at all:
SELECT excursions.title FROM excursions
LEFT JOIN bookings ON excursions.id_excursion = bookings.excursion_id
WHERE bookings.id_booking IS NULL;

#7.) Calculate the running total of bookings for each excursion:
SELECT excursions.title, bookings.excursion_id, bookings.booking_date, 
SUM(1) OVER (PARTITION BY bookings.excursion_id ORDER BY bookings.booking_date) AS running_total
FROM bookings
JOIN excursions ON bookings.excursion_id = excursions.id_excursion;

#8.) List excursions that have more than 5 spots available and whose price is higher than the average price of all excursions.
SELECT e.title, e.availability, e.price
FROM excursions AS e
WHERE e.availability > 5 
AND e.price > (SELECT AVG(price) FROM excursions);

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
ORDER BY average_price, categories.name;

#BOOKINGS#
#1.) List the bookings made by a specific customer (e.g., customer with ID 3): 
SELECT * FROM bookings WHERE customer_id = 3; 

#2.) Calculate the number of excursions booked per month in a specific year:
SELECT MONTH(booking_date) AS month, COUNT(*) AS number_of_bookings
FROM bookings
WHERE YEAR(booking_date) = 2024
GROUP BY month
ORDER BY month;

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

#Get the full name of guides and the total number of excursions they have led in the "Adventure" category.
WITH adventure_excursions AS (
    SELECT e.guide_id, COUNT(e.id_excursion) AS total_excursions
    FROM excursions AS e
    INNER JOIN categories AS c
    ON e.category_id = c.id_category
    WHERE c.name = 'Adventure'
    GROUP BY e.guide_id
)
SELECT CONCAT(g.first_name, ' ', g.last_name) AS guide_full_name, ae.total_excursions
FROM adventure_excursions AS ae
INNER JOIN guides AS g
ON ae.guide_id = g.id_guide;

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
#Find excursions that have been booked by customers who have also booked a specific excursion (e.g., 'Mountain Hiking'):**

SELECT DISTINCT e2.title
FROM bookings AS b1
JOIN bookings AS b2 ON b1.customer_id = b2.customer_id
JOIN excursions AS e1 ON b1.excursion_id = e1.id_excursion
JOIN excursions AS e2 ON b2.excursion_id = e2.id_excursion
WHERE e1.title = 'Mountain Hiking' AND e2.title != 'Mountain Hiking';

#4.) *CASE...WHEN...*
#Obtain a detailed list of excursions, including the excursion title, the guide's full name, the rounded price, and a categorization based on price range
SELECT e.title AS excursion_title,
    CONCAT(g.first_name, ' ', g.last_name) AS guide_full_name,
    ROUND(e.price, 2) AS rounded_price,
CASE
    WHEN e.price < 40 THEN 'Economical'
    WHEN e.price BETWEEN 40 AND 59 THEN 'Moderate'
    ELSE 'Expensive'
END AS price_category
FROM excursions AS e
INNER JOIN guides AS g
ON e.guide_id = g.id_guide
ORDER BY e.title;

#Obtain a detailed list of excursions, including the title, the guide's full name, a "brief description" (first 100 characters of the description), and the total length of the description.
SELECT e.title AS excursion_title,
    CONCAT(g.first_name, ' ', g.last_name) AS guide_full_name,
    LEFT(e.description, 50) AS brief_description,
    LENGTH(e.description) AS description_length,
CASE
    WHEN LENGTH(e.description) < 30 THEN 'Short'
    WHEN LENGTH(e.description) BETWEEN 30 AND 40 THEN 'Moderate'
    ELSE 'Long'
END AS description_category
FROM excursions AS e
INNER JOIN guides AS g
ON e.guide_id = g.id_guide
ORDER BY LENGTH(e.description) DESC;

#Obtain a detailed list of guides, including their full names and the total number of excursions they have led in each category.
SELECT CONCAT(g.first_name, ' ', g.last_name) AS guide_full_name,
    COUNT(e.id_excursion) AS total_excursions,
    GROUP_CONCAT(DISTINCT c.name ORDER BY c.name) AS categories,
    CASE
        WHEN COUNT(DISTINCT c.id_category) = 1 THEN 'Specialized'
        WHEN COUNT(DISTINCT c.id_category) = 2 THEN 'Versatile'
        ELSE 'Multitalented'
    END AS classification
FROM guides AS g
INNER JOIN excursions AS e 
ON e.guide_id = g.id_guide
LEFT JOIN categories AS c
ON e.category_id = c.id_category
GROUP BY guide_full_name
ORDER BY guide_full_name;
