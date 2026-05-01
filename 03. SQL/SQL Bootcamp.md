# The Complete SQL Bootcamp: Go From Zero To Hero

## SECTION 1 - Preparing the Environment

### PostgreSQL Installation 

- Add the PostgreSQL repository to the sources.list file:
  ```sh
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  ```
- Download the PostgreSQL signing key and add it to the system:
  ```sh
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  ```
- Update the list of available packages:
  ```sh
  sudo apt-get update
  ```
- Install the desired version of PostgreSQL:
  ```sh
  sudo apt-get -y install postgresql
  ```

### pgAdmin4 Installation

- Install curl:
  ```sh
  sudo apt install curl
  ```
- Install the public key to the repository:
  ```sh
  curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
  ```
- Create the repository configuration file:
  ```sh
  sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
  ```
- Install for Desktop and Web modes:
  ```sh
  sudo apt install pgadmin4
  ```
- After installing PostgreSQL and pgAdmin4, simply perform the initial user and connection configurations as desired.

---

## SECTION 2 - SQL Statement Fundamentals

### Challenge: SELECT
Retrieve the first and last names of every customer along with their email address.
```sql
SELECT 
  first_name, 
  last_name, 
  email 
FROM customer;
```

### Challenge: SELECT DISTINCT
Retrieve the distinct rating types for films in the database.
```sql
SELECT DISTINCT(rating)
FROM film;
```

### COUNT
Return the number of rows in the table.
```sql
SELECT COUNT(name) FROM table;
SELECT COUNT(choice) FROM table;
SELECT COUNT(*) FROM table;
```

### COUNT(DISTINCT)
How many unique amounts are in the payment table?
```sql
SELECT COUNT(DISTINCT amount) 
FROM payment;
```

### Challenge: SELECT WHERE
Find the email of a customer named Nancy Thomas.
```sql
SELECT email 
FROM customer
WHERE first_name = 'Nancy' AND last_name = 'Thomas';
```
Retrieve the description of the movie "Outlaw Hanky".
```sql
SELECT description
FROM film
WHERE title = 'Outlaw Hanky';
```
Find the phone number of a customer living at '259 Ipoh Drive'.
```sql
SELECT phone 
FROM address
WHERE address = '259 Ipoh Drive';
```

### Challenge: ORDER BY & LIMIT
Retrieve the customer IDs of the first 10 paying customers.
```sql
SELECT customer_id 
FROM payment 
ORDER BY payment_date ASC 
LIMIT 10;
```
Retrieve the titles of the 5 shortest movies.
```sql
SELECT title, length
FROM film
ORDER BY length ASC
LIMIT 5;
```
Count the number of movies with a runtime of 50 minutes or less.
```sql
SELECT COUNT(*) 
FROM film
WHERE LENGTH <= 50;
```

### BETWEEN
Find the total number of transactions between $8 and $9.
```sql
SELECT COUNT(*) FROM payment
WHERE amount BETWEEN 8 AND 9;
```
Find the total number of payments between a date range.
```sql
SELECT COUNT(*) FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-14';
```

### IN
Use the IN operator to check if a value is in a list.
```sql
SELECT * FROM customer
WHERE first_name IN ('John', 'Jake', 'Julie');
```

### LIKE and ILIKE
Pattern matching with wildcard characters:
- `%` Matches any sequence of characters
- `_` Matches any single character
- `LIKE` is case-sensitive, while `ILIKE` is case-insensitive

Find all Mission Impossible films.
```sql
WHERE title LIKE 'Mission Impossibe_'
```
Find names starting with 'J'.
```sql
WHERE name LIKE 'J%'
```
Find names containing 'her' after the first letter.
```sql
WHERE name LIKE '_her%'
```
Find customers whose first name starts with 'A' and last name does not start with 'B'.
```sql
SELECT * FROM customer
WHERE first_name LIKE 'A%' AND last_name NOT LIKE 'B%'
ORDER BY last_name;
```

---

## General Challenges

### How many payment transactions were greater than $5.00?
```sql
SELECT COUNT(amount)
FROM payment 
WHERE amount > 5.00;
```

### How many actors have a first name that starts with 'P'?
```sql
SELECT COUNT(first_name)
FROM actor
WHERE first_name LIKE 'P%';
```

### How many unique districts are our customers from?
```sql
SELECT COUNT(DISTINCT district)
FROM address;
```
**Retrieve the list of names for those distinct districts.**
```sql
SELECT DISTINCT(district)
FROM address;
```

### How many films have a rating of 'R' and a replacement cost between $5 and $15?
```sql
SELECT COUNT(title)
FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5.00 AND 15.00;
```

### How many films have the word 'Truman' somewhere in the title?
```sql
SELECT COUNT(title)
FROM film
WHERE title LIKE '%Truman%';
```

---

# Section 3: GROUP BY Statements

## GROUP BY - Challenge

### 1. We have two staff members, with Staff IDs 1 and 2. We want to give a bonus to the staff member that handled the most payments. (Most in terms of number of payments processed, not total dollar amount). How many payments did each staff member handle and who gets the bonus?

```sql
SELECT 
  staff_id, 
  COUNT(amount)
FROM payment
  GROUP BY staff_id
  ORDER BY COUNT(amount) DESC;
```

### 2. Corporate HQ is conducting a study on the relationship between replacement cost and a movie MPAA rating (e.g. G, PG, R, etc.). What is the average replacement cost per MPAA rating? Note: You may need to expand the AVG column to view correct results.

```sql
SELECT 
  rating, 
  ROUND(AVG(replacement_cost), 4)
FROM film 
  GROUP BY rating
  ORDER BY AVG(replacement_cost) DESC;
```

### 3. We are running a promotion to reward our top 5 customers with coupons. What are the customer IDs of the top 5 customers by total spend?

```sql
SELECT 
  customer_id,
  SUM(amount)
FROM payment 
  GROUP BY customer_id 
  ORDER BY SUM(amount) DESC
  LIMIT 5;
```

## HAVING - Challenge Tasks

### 1. We are launching a platinum service for our most loyal customers. We will assign platinum status to customers that have had 40 or more transaction payments. What customer_ids are eligible for platinum status?

```sql
SELECT 
  customer_id, 
  COUNT(amount)
FROM payment
  GROUP BY customer_id
  HAVING COUNT(amount) >= 40
  ORDER BY COUNT(amount) DESC;
```
---

# SECTION 4 - Assessment Test 1

## Complete The Following Tasks!

### 1. Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.

```sql
SELECT 
  customer_id, 
  SUM(amount)
FROM payment 
  WHERE staff_id = 2
  GROUP BY customer_id
  HAVING SUM(amount) >= 110.00
  ORDER BY SUM(amount) DESC;
```

### 2. How many films begin with the letter J?

```sql
SELECT 
  COUNT(title)
FROM film
  WHERE title LIKE 'J%';
```

### 3. What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?

```sql
SELECT
  first_name,
  last_name
FROM customer
  WHERE first_name LIKE 'E%'
  AND address_id < 500
  ORDER BY customer_id DESC
  LIMIT 1;
```
---

# Section 5: JOINS

## JOIN Challenge Tasks

![image](https://github.com/user-attachments/assets/e2c48148-dc6d-435c-bf13-f674b58d79b1)


### 1. California sales tax laws have changed and we need to alert our customers to this through email. What are the emails of the customers who live in California?

```sql
SELECT 
  address.district,
  customer.email
FROM customer 
JOIN address ON customer.address_id = address.address_id
  WHERE address.district = 'California';
```

### 2. A customer walks in and is a huge fan of the actor "Nick Wahlberg" and wants to know which movies he is in. Get a list of all the movies "Nick Wahlberg" has been in.

```sql
SELECT 
  film.title,
  actor.first_name,
  actor.last_name
FROM film_actor 
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
  WHERE actor.first_name = 'Nick'
  AND actor.last_name = 'Wahlberg';
```
---

# Section 6: Advanced SQL Commands

## Timestamps and Extract - Challenge

### 1. During which months did payments occur?  
Format your answer to return back the full month name.

```sql
SELECT 
  DISTINCT(TO_CHAR(payment_date, 'MONTH')) AS payment_month
FROM payment;
```

### 2. How many payments occurred on a Monday?

```sql
SELECT 
  COUNT(payment_date)
FROM payment 
  WHERE EXTRACT(DOW FROM payment_date) = 1;
```

## Mathematical Functions and Operations

### Use case: % calculation

```sql
SELECT ROUND(rental_rate/replacement_cost, 2)*100 AS percent_cost
FROM film;
```

## String Function Operators

Allows you to edit, combine, and alter text data columns.

### Use case: Concatenate the first name with last name

```sql
SELECT UPPER(first_name) || ' ' || UPPER(last_name) AS full_name
FROM customer;
```

### Use case: Create a customized email for all customers

```sql
SELECT LOWER(first_name) || LOWER(last_name) || '@gmail.com' AS custom_email
FROM customer;
```

## SUBQUERY

Allows you to construct complex queries, performing a query on the results of another query. Note: The subquery always happens first.

### SUBQUERY with IN operator

Use case: Find the film titles that have been returned between certain set of dates.

```sql
SELECT film_id, title
FROM film
WHERE film_id IN
(SELECT inventory.film_id
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY film_id;
```

### SUBQUERY with EXISTS operator

Use case: Find customers who have at least one payment whose amount is greater than 11.

```sql
SELECT first_name, last_name
FROM customer AS c
WHERE EXISTS
(SELECT * FROM payment AS p
WHERE p.customer_id = c.customer_id
AND amount > 11);
```
---

# SECTION 7 - Assessment Test 2

### 1. How can you retrieve all the information from the cd.facilities table?

```sql
SELECT * 
FROM cd.facilities;
```

### 2. You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?

```sql
SELECT 
  name, 
  membercost
FROM cd.facilities;
```

### 3. How can you produce a list of facilities that charge a fee to members?

```sql
SELECT 
  name
FROM cd.facilities
  WHERE membercost > 0;
```

### 4. How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

```sql
SELECT 
  facid, 
  name, 
  membercost, 
  monthlymaintenance
FROM cd.facilities 
  WHERE membercost > 0
  AND membercost < ((1/50.0) * monthlymaintenance);
```

### 5. How can you produce a list of all facilities with the word 'Tennis' in their name?

```sql
SELECT * 
FROM cd.facilities
  WHERE name LIKE '%Tennis%';
```

### 6. How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

```sql
SELECT * 
FROM cd.facilities
  WHERE facid = 1
UNION
SELECT * 
FROM cd.facilities 
  WHERE facid = 5;
```

```sql
SELECT * 
FROM cd.facilities 
  WHERE facid IN (1, 5);
```

### 7. How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

```sql
SELECT 
  memid, 
  surname, 
  firstname, 
  joindate
FROM cd.members
  WHERE joindate > '2012/09/01';
```

### 8. How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.

```sql
SELECT 
  DISTINCT surname 
FROM cd.members
  ORDER BY surname
  LIMIT 10;
```

### 9. You'd like to get the signup date of your last member. How can you retrieve this information?

```sql
SELECT 
  joindate
FROM cd.members
  ORDER BY joindate DESC
  LIMIT 1;
```

```sql
SELECT 
  MAX(joindate)
FROM cd.members;
```

### 10. Produce a count of the number of facilities that have a cost to guests of 10 or more.

```sql
SELECT 
  COUNT(*) 
FROM cd.facilities 
  WHERE guestcost >= 10;
```

### 11. Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

```sql
SELECT 
  facid, 
  SUM(slots) AS total_slots
FROM cd.bookings
  WHERE starttime BETWEEN '2012/09/01' AND '2012/09/30'
  GROUP BY facid
  ORDER BY SUM(slots);
```

```sql
SELECT 
  facid, 
  SUM(slots) AS total_slots
FROM cd.bookings 
  WHERE starttime >= '2012-09-01'
  AND starttime <= '2012-10-01'
  GROUP BY facid ORDER BY SUM(slots);
```

### 12. Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.

```sql
SELECT 
  facid, 
  SUM(slots)
FROM cd.bookings
  GROUP BY facid
  HAVING SUM(slots) > 1000
  ORDER BY facid;
```

### 13. How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

```sql
SELECT 
  cd.bookings.starttime AS start, 
  cd.facilities.name 	
FROM cd.facilities 
JOIN cd.bookings ON cd.bookings.facid = cd.facilities.facid 
  WHERE cd.facilities.facid IN (0, 1)
  AND cd.bookings.starttime >= '2012-09-21'
  AND cd.bookings.starttime < '2012-09-22'
  ORDER BY cd.bookings.starttime;
```

### 14. How can you produce a list of the start times for bookings by members named 'David Farrell'?

```sql
SELECT 
  cd.bookings.starttime
FROM cd.bookings 
JOIN cd.members ON cd.bookings.memid = cd.members.memid
  WHERE firstname LIKE 'David' AND surname LIKE 'Farrell';
```
---

# SECTION 8 – Creating Databases and Tables

### Data Types
Most common data types:
- **Boolean**: True or False
- **Character**: char, varchar, and text
- **Numeric**: integer and floating-point numbers
- **Temporal**: date, time, timestamp, and interval

### Primary and Foreign Keys
- **Primary Key [PK]**: A column or a group of columns used to identify a row uniquely in a table.
- **Foreign Key [FK]**: A field or group of fields in a table that uniquely identifies a row in another table that references the primary key of the other table. A table can have multiple foreign keys depending on its relationships with other tables.

### Constraints
Constraints are the rules enforced on data columns in a table to prevent invalid data from being entered into the database, ensuring the accuracy and reliability of the data.
Two main types:
- **Column Constraints**: Constrains the data in a single column to adhere to certain conditions.
- **Table Constraints**: Applied to the entire table rather than just an individual column.

Most common constraints used:
- **NOT NULL**: Ensures that a column cannot have null.
- **UNIQUE**: Ensures that all values in a column are different.
- **PRIMARY KEY**: Uniquely identifies each row/record in a database table.
- **FOREIGN KEY**: Constrains data based on columns in another table.
- **CHECK**: Ensures that all values in a column satisfy certain conditions.
- **EXCLUSION**: Ensures that if any two rows are compared on the specified column or expression using the specified operator, not all comparisons return TRUE.
- **CHECK (condition)**: Checks a condition when inserting or updating data.
- **REFERENCES**: Constrains the value stored in the column that must exist in a column in another table.
- **UNIQUE (column_list)**: Forces the values stored in the columns listed inside the parentheses to be unique.
- **PRIMARY KEY (column_list)**: Allows you to define a primary key that consists of multiple columns.

### CREATE Table
```sql
CREATE TABLE account(
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL, 
    email VARCHAR(250) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

CREATE TABLE job (
    job_id SERIAL PRIMARY KEY, 
    job_name VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE account_job (
    user_id INTEGER REFERENCES account(user_id),
    job_id INTEGER REFERENCES job(job_id),
    hire_date TIMESTAMP
);

CREATE TABLE information (
    info_id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL, 
    person VARCHAR(50) NOT NULL UNIQUE
);
```

### INSERT
```sql
INSERT INTO account 
    (username, password, email, created_on)
VALUES 
    ('Jose', 'password', 'jose@mail.com', CURRENT_TIMESTAMP);

INSERT INTO job 
    (job_name)
VALUES
    ('Astronaut');

INSERT INTO job 
    (job_name)
VALUES 
    ('President');

INSERT INTO account_job 
    (user_id, job_id, hire_date)
VALUES 
    (1, 1, CURRENT_TIMESTAMP);
```

### UPDATE
```sql
SELECT * 
FROM account;

UPDATE account 
    SET last_login = CURRENT_TIMESTAMP;

UPDATE account 
    SET last_login = CREATED_ON;

SELECT * 
FROM account_job;

UPDATE account_job 
    SET hire_date = account.created_on 
FROM account 
    WHERE account_job.user_id = account.user_id;

UPDATE account 
    SET last_login = CURRENT_TIMESTAMP 
    RETURNING email, created_on, last_login;
```

### DELETE
```sql
DELETE 
FROM job 
    WHERE job_id = 4
    RETURNING job_id, job_name;
```

### ALTER Table
Allows for changes to an existing table structure:
- Adding, dropping, or renaming columns
- Changing data type
- Setting DEFAULT values for a column
- Adding CHECK constraints
- Renaming table

```sql
SELECT * 
FROM information;

SELECT * 
FROM new_info;

ALTER TABLE information 
    RENAME TO new_info;

ALTER TABLE new_info 
    RENAME COLUMN person TO people;

ALTER TABLE new_info 
    ALTER COLUMN people DROP NOT NULL;
    
ALTER TABLE new_info 
    ALTER COLUMN people SET NOT NULL;
```

### DROP Table
```sql
ALTER TABLE new_info 
    DROP COLUMN people;

SELECT * 
FROM new_info;

ALTER TABLE new_info 
    DROP COLUMN IF EXISTS people;
```

### CHECK Constraint
Allows for more customized constraints that adhere to a certain condition, such as ensuring all inserted integer values fall below a certain threshold.

```sql
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    birthdate DATE CHECK(birthdate > '1900-01-01'), 
    hire_date DATE CHECK(hire_date > birthdate), 
    salary INTEGER CHECK(salary > 0)
);

INSERT INTO employees(
    first_name,
    last_name, 
    birthdate, 
    hire_date, 
    salary)
VALUES (
    'Sammy', 
    'Smith', 
    '1990-11-03', 
    '2010-01-01', 
    100
);
```

---

# SECTION 9 – Assessment Test 3

Complete the following task:  
Create a new database called "School." This database should have two tables: teachers and students.  
The students table should have columns for student_id, first_name, last_name, homeroom_number, phone, email, and graduation year.  
The teachers table should have columns for teacher_id, first_name, last_name, homeroom_number, department, email, and phone.  
The constraints are mostly up to you, but your table constraints must consider the following:
1. We must have a phone number to contact students in case of an emergency.
2. We must have IDs as the primary key of the tables.
3. Phone numbers and emails must be unique to the individual.

Once you've made the tables, insert a student named Mark Watney (student_id = 1) who has a phone number of 777-555-1234 and doesn't have an email. He graduates in 2035 and has 5 as a homeroom number.  
Then insert a teacher named Jonas Salk (teacher_id = 1) who has a homeroom number of 5 and is from the Biology department. His contact info is: jsalk@school.org and a phone number of 777-555-4321.

```sql
CREATE TABLE teachers(
    teacher_id SERIAL PRIMARY KEY, 
    first_name VARCHAR(50), 
    last_name VARCHAR(50), 
    homeroom_number INTEGER,
    department VARCHAR(100),
    email VARCHAR(100) UNIQUE, 
    phone VARCHAR(14) UNIQUE
);

CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50), 
    homeroom_number INTEGER, 
    phone VARCHAR(14) UNIQUE, 
    email VARCHAR(100) UNIQUE, 
    graduation_year INTEGER
);

INSERT INTO students(
    first_name, 
    last_name, 
    phone, 
    graduation_year, 
    homeroom_number)
VALUES (
    'Mark', 
    'Watney', 
    '777-555-1234', 
    '2035',
    5
);

INSERT INTO teachers(
    first_name, 
    last_name, 
    homeroom_number, 
    department, 
    email, 
    phone)
VALUES (
    'Jonas', 
    'Salk', 
    5, 
    'Biology', 
    'jsalk@school.org', 
    '777-555-4321');
```

---

# SECTION 10 – Conditional Expressions and Procedures

### CASE - Challenge Task
We want to know and compare the various amounts of films we have per movie rating.

```sql
SELECT 
    SUM(CASE rating 
          WHEN 'R' THEN 1
          ELSE 0
    END) AS r,
    SUM(CASE rating 
          WHEN 'PG' THEN 1
          ELSE 0
    END) AS pg,
    SUM(CASE rating 
          WHEN 'PG-13' THEN 1
          ELSE 0
    END) AS pg13s
FROM film;
```

### COALESCE
Accepts an unlimited number of arguments and returns the first argument that is not null. If all arguments are null, the function returns null.
```sql
SELECT COALESCE(1, 2); -> returns 1
SELECT COALESCE(NULL, 2, 3); -> returns 2
```

### CAST
Converts from one data type to another.
```sql
SELECT CAST('5' AS INTEGER);
```

### NULLIF
Takes in two inputs and returns null if both are equal; otherwise, it returns the first argument passed.
```sql
NULLIF(10, 10); -> returns NULL
NULLIF(10, 12); -> returns 10
```

### VIEWS
Create a view that allows you to quickly see the query, which is a simple call as if it were a table that already existed. This is very useful when you use the same query repeatedly in a project.

```sql
CREATE VIEW customer_info AS 
SELECT 
    first_name, 
    last_name, 
    address 
FROM customer 
JOIN address ON customer.address_id = address.address_id;

SELECT * 
FROM customer_info;

CREATE OR REPLACE VIEW customer_info AS 
SELECT 
    first_name, 
    last_name, 
    address, 
    district 
FROM customer 
JOIN address ON customer.address_id = address.address_id; 

SELECT * 
FROM customer_info;

DROP VIEW IF EXISTS customer_info;

ALTER VIEW customer_info RENAME TO c_info;
```

### IMPORT AND EXPORT
*In PgAdmin*
Import data from a CSV or text file into an already existing table.

```sql
CREATE TABLE simple(
    a INTEGER,
    b INTEGER,
    c INTEGER
);

SELECT * 
FROM simple;

COPY simple 
FROM '.......csv' WITH DELIMITER ',' CSV HEADER;
```

