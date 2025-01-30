# The Complete SQL Bootcamp: Go From Zero To Hero

## SECTION 1 - Preparing the environment  
-- *The practice can be done in another SQL environment as well - in this case, skip this part. - For example, I did it in MySQL.* --

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

### pgAdmin4 installation
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

## SECTION 2 - SQL Statement Fundamentals

### Challenge: SELECT
Use a SELECT statement to grab the first and last names of every customer and their email address.
```sql
SELECT 
  first_name, 
  last_name, 
  email 
FROM customer;
```

### Challenge: SELECT DISTINCT
Use what you've learned about SELECT DISTINCT to retrieve the distinct rating types our films could have in our database.
```sql
SELECT
  DISTINCT(rating)
FROM film;
```

### Challenge: SELECT WHERE
A customer forgot their wallet at our store! We need to track down their email to inform them. What is the email for the customer with the name Nancy Thomas?
```sql
SELECT 
  email 
FROM customer
  WHERE first_name = 'Nancy' 
  AND last_name = 'Thomas';
```
A customer wants to know what the movie "Outlaw Hanky" is about. Could you give them the description for the movie "Outlaw Hanky"?
```sql
SELECT 
  description
FROM film
  WHERE title = 'Outlaw Hanky';
```
A customer is late on their movie return, and we've mailed them a letter to their address at '259 Ipoh Drive'. We should also call them on the phone to let them know. Can you get the phone number for the customer who lives at '259 Ipoh Drive'?
```sql
SELECT 
  phone 
FROM address
  WHERE address = '259 Ipoh Drive';
```

### Challenge: ORDER BY
We want to reward our first 10 paying customers. What are the customer ids of the first 10 customers who created a payment?
```sql
SELECT 
  customer_id 
FROM payment 
  ORDER BY payment_date ASC 
  LIMIT 10;
```
A customer wants to quickly rent a video to watch over their short lunch break. What are the titles of the 5 shortest (in length of runtime) movies?
```sql
SELECT 
  title, 
  length
FROM film	
  ORDER BY length ASC
  LIMIT 5;
```
If the previous customer can watch any movie that is 50 minutes or less in run time, how many options does she have?
```sql
SELECT 
  COUNT(*) 
FROM film
  WHERE LENGTH <= 50;
```

### General challenge 1
How many payment transactions where greater than $5.00?
```sql
SELECT 
  COUNT(amount)
FROM payment 
  WHERE amount > 5.00;
```
How many actors have a first name that starts with the latter P?
```sql
SELECT 
  COUNT(first_name)
FROM actor
  WHERE first_name LIKE 'P%';
```
How many unique districts are our customers from?
```sql
SELECT 
  COUNT(DISTINCT(district))
FROM address;
```
Retrieve the list of names for those distinct districts from the previous question.
```sql
SELECT 
  DISTINCT(district)
FROM address;
```
How many films have a rating of R and a replacement cost between $5 and $15?
```sql
SELECT 
  COUNT(title)
FROM film
  WHERE rating = 'R'
  AND replacement_cost BETWEEN 5.00 AND 15.00;
```
How many films have the word Truman somewhere in the title?
```sql
SELECT 
  COUNT(title)
FROM film
  WHERE title LIKE '%Truman%';
```

## Section 3: GROUP BY Statements

### GROUP BY - Challenge
We have two staff members, with Staff IDs 1 and 2. We want to give a bonus to the staff member that handled the most payments. (Most in terms of number of payments processed, not total dollar amount). How many payments did each staff member handle and who gets the bonus?
```sql
SELECT 
  staff_id, 
  COUNT(amount)
FROM payment
  GROUP BY staff_id
  ORDER BY COUNT(amount) DESC;
```
Corporate HQ is conducting a study on the relationship between replacement cost and a movie MPAA rating (e.g.G, PG, R, etc..). What is the average replacement cost per MPAA rating? Note: You many need to expand the AVG column to view correct results.
```sql
SELECT 
  rating, 
  ROUND(AVG(replacement_cost), 4)
FROM film 
  GROUP BY rating
  ORDER BY AVG(replacement_cost) DESC;
```
We are running a promotion to reward our top 5 customers with coupons. What are the customer ids of the top 5 customers by total spend?
```sql
SELECT 
  customer_id,
  SUM(amount)
FROM payment 
  GROUP BY customer_id 
  ORDER BY SUM(amount) DESC
  LIMIT 5;
```

### HAVING - Challenge Tasks
We are launching a platinum service for our most loyal customers. We will assign platinum status to customers that have had 40 or more transaction payments. What customer_ids are eligible for platinum status?
```sql
SELECT 
  customer_id, 
  COUNT(amount)
FROM payment
  GROUP BY customer_id
  HAVING COUNT(amount) >= 40
  ORDER BY COUNT(amount) DESC;
```

## SECTION 4 - Assessment Test 1
Complete The Following Tasks!

1.	Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.
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
2.	How many films begin with the letter J?
```sql
SELECT 
  COUNT(title)
FROM film
  WHERE title LIKE 'J%';
```
3.	What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?
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

## Section 5: JOINS

### JOIN Challenge Tasks
California sales tax laws have changed and we need to alert our customers to this through email. What are the emails of the customers who live in California?
```sql
SELECT 
  address.district,
  customer.email
FROM customer 
JOIN address ON customer.address_id = address.address_id
    WHERE address.district = 'California';
```
A customer walks in and is a huge fan of the actor "Nick Wahlberg" and wants to know which movies he is in. Get a list of all the movies "Nick Wahlberg" has been in.
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

## Section 6: Advanced SQL Commands

### Timestamps and Extract - Challenge
During which months did payments occur? Format your answer to return back the full month name.
```sql
SELECT 
  DISTINCT(TO_CHAR(payment_date, 'MONTH')) AS payment_month
FROM payment;
```
How many payments occurred on a Monday?
```sql
SELECT 
  COUNT(payment_date)
FROM payment 
  WHERE EXTRACT(DOW FROM payment_date) = 1;
```

## SECTION 7 - Assessment Test 2

1. How can you retrieve all the information from the cd.facilities table?
   ```sql
   SELECT * 
   FROM cd.facilities;
   ```

2. You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?
   ```sql
   SELECT 
     name, 
     membercost
   FROM cd.facilities;
   ```

3. How can you produce a list of facilities that charge a fee to members?
   ```sql
   SELECT 
     name
   FROM cd.facilities
     WHERE membercost > 0;
   ```

4. How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
   ```sql
   SELECT 
     facid, 
     name, 
     membercost, 
     monthlymaintenance
   FROM cd.facilities 
     > 0
     AND membercost < ((1/50.0) * monthlymaintenance);
   ```

5. How can you produce a list of all facilities with the word 'Tennis' in their name?
   ```sql
   SELECT * 
   FROM cd.facilities
     WHERE name LIKE '%Tennis%';
   ```

6. How can you **retrieve the details of facilities with ID 1 and **5? Try to do it without using the OR operator.
   ```sql
   SELECT * 
   FROM cd.facilities
     WHERE facid = 1
   UNION
   SELECT * 
   FROM cd.facilities 
     WHERE facid = 5;
   SELECT * 
   FROM cd.facilities 
     WHERE facid IN (1, 5);
   ```

7. How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.
   ```sql
   SELECT 
     memid, 
     surname, 
     firstname, 
     joindate
   FROM cd.members
     WHERE joindate > '2012/09/01';
   ```

8. How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.
   ```sql
   SELECT 
     DISTINCT surname 
   FROM cd.members
     ORDER BY surname
     LIMIT 10;
   ```

9. You'd like to get the signup date of your last member. How can you retrieve this information?
   ```sql
   SELECT 
     joindate
   FROM cd.members
     ORDER BY joindate DESC
     LIMIT 1;
   SELECT 
     MAX(joindate)
   FROM cd.members;
   ```

10. Produce a count of the number of facilities that have a cost to guests of 10 or more.
    ```sql
    SELECT 
      COUNT(*) 
    FROM cd.facilities 
      WHERE guestcost >= 10;
    ```

11. Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
    ```sql
    SELECT 
      facid, 
      SUM(slots) AS total_slots
    FROM cd.bookings
      WHERE starttime BETWEEN '2012/09/01' AND '2012/09/30'
      GROUP BY facid
      ORDER BY SUM(slots);
    SELECT 
      facid, 
      SUM(slots) AS total_slots
    FROM cd.bookings 
      WHERE starttime >= '2012-09-01'
      AND starttime <= '2012-10-01'
      GROUP BY facid ORDER BY SUM(slots);
    ```

12. Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.
    ```sql
    SELECT 
      facid, 
      SUM(slots)
    FROM cd.bookings
      GROUP BY facid
      HAVING SUM(slots) > 1000
      ORDER BY facid;
    ```

13. How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
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

14. How can you produce a list of the start times for bookings by members named 'David Farrell'?
    ```sql
    SELECT 
      cd.bookings.starttime
    FROM cd.bookings 
    JOIN cd.members ON cd.bookings.memid = cd.members.memid
      WHERE firstname LIKE 'David' AND surname LIKE 'Farrell';
    ```

## SECTION 8 - Assessment Test 3

Complete the following task:
Create a new database called "School" this database should have two tables: teachers and students.
The students table should have columns for student_id, first_name, last_name, homeroom_number, phone, email, and graduation year.
The teachers table should have columns for teacher_id, first_name, last_name, homeroom_number, department, email, and phone.
The constraints are mostly up to you, but your table constraints do have to consider the following:
1. We must have a phone number to contact students in case of an emergency.
2. We must have ids as the primary key of the tables
3. Phone numbers and emails must be unique to the individual.
Once you've made the tables, insert a student named Mark Watney (student_id=1) who has a phone number of 777-555-1234 and doesn't have an email. He graduates in 2035 and has 5 as a homeroom number.
Then insert a teacher names Jonas Salk (teacher_id = 1) who as a homeroom number of 5 and is from the Biology department. His contact info is: jsalk@school.org and a phone number of 777-555-4321.
```sql
CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50), 
	last_name VARCHAR(50), 
	homeromm_number INTEGER,
	departament VARCHAR(100),
	email VARCHAR(100) UNIQUE, 
	phone VARCHAR(14) UNIQUE 
);

CREATE TABLE students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50), 
	homerrom_number INTEGER, 
	phone VARCHAR(14) UNIQUE, 
	email VARCHAR(100) UNIQUE, 
	graduation_year INTEGER
);

INSERT INTO students(
	first_name, 
	last_name, 
	phone, 
	graduation_year, 
	homer5
);

INSERT INTO teachers(
	first_name, 
	last_name, 
	homeroom_number, 
	departament, 
	email, 
	phone)
VALUES (
	'Jonas', 
	'Salk', 
	5, 
	'Biologia', 
	'jsalk@school.org', 
	'777-555-4321');
```

## SECTION 9 - CASE - Challenge Task

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
