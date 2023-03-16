-- Database: dvdrental

-- DROP DATABASE IF EXISTS dvdrental;

CREATE DATABASE dvdrental
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
	SELECT * FROM film;
	SELECT DISTINCT rating FROM film;
	SELECT COUNT(*) FROM film;
	SELECT COUNT(DISTINCT rental_rate) FROM film;
	SELECT * FROM payment;
	SELECT COUNT(DISTINCT amount) FROM payment;
	
    SELECT COUNT(first_name) FROM customer
	WHERE first_name='Jared';
	
	SELECT email FROM customer
	WHERE first_name='Nancy' AND last_name='Thomas';
	
	SELECT description FROM film
	WHERE title='Outlaw Hanky';
	
	SELECT phone FROM address
	WHERE address='259 Ipoh Drive';
	
	SELECT customer_id FROM payment
	ORDER BY payment_date
	LIMIT 10;
	
	SELECT title FROM film
	ORDER BY length
	LIMIT 5;
	
	SELECT COUNT(title) FROM film
	WHERE length<=50;
	
	SELECT COUNT(*) FROM payment
	WHERE amount >5.00;
	
	SELECT COUNT(*) FROM actor
	WHERE first_name LIKE 'P%';
	
	SELECT COUNT(DISTINCT district) FROM address;
	
	SELECT DISTINCT district FROM address;
	
	SELECT COUNT(*) FROM film
	WHERE rating='R' 
	AND replacement_cost BETWEEN 5 AND 15;
	
	SELECT COUNT(*) FROM film
	WHERE title LIKE '%Truman%';
	
	SELECT customer_id, SUM(amount) FROM payment
	GROUP BY customer_id
	ORDER BY SUM(amount);
	
	SELECT DATE(payment_date), SUM(amount) FROM payment
	GROUP BY DATE(payment_date)
	ORDER BY SUM(amount);
	
	SELECT * FROM staff;
	SELECT * FROM payment;
	
	SELECT staff_id, COUNT(*) FROM payment
	GROUP BY staff_id;
	
	SELECT * FROM film;
	SELECT rating, ROUND(AVG(replacement_cost),2)  FROM film
	GROUP BY rating;
	
	SELECT * FROM payment;
	SELECT customer_id, SUM(amount) FROM payment
	GROUP BY customer_id
	ORDER BY SUM(amount) DESC
	LIMIT 5;
	
	SELECT * FROM payment;
	SELECT customer_id, COUNT(*) FROM payment
	GROUP BY customer_id
	HAVING COUNT(*)>=40;
	
	SELECT * FROM payment;
	SELECT customer_id, SUM(amount) FROM payment
	WHERE staff_id=2
	GROUP BY customer_id
	HAVING SUM(amount)>100;
	
	-- ASSESSMENT TEST1------------
	SELECT customer_id, SUM(amount) FROM payment
	WHERE staff_id=2
	GROUP BY customer_id
	HAVING SUM(amount)>110;
	
    SELECT COUNT(*) FROM film
	WHERE title LIKE 'J%';
	
	SELECT  first_name, last_name FROM customer
	WHERE first_name LIKE 'E%'
	AND address_id<500
	ORDER BY customer_id DESC
	LIMIT 1;
	
	-- ---------------------------
	SELECT * FROM film;
	SELECT * FROM inventory;
	SELECT film.film_id, title, inventory_id, store_id FROM film
	LEFT JOIN inventory ON inventory.film_id=film.film_id
	WHERE inventory.film_id IS null;
	
	SELECT district, email FROM address
	INNER JOIN customer 
	ON  address.address_id=customer.address_id
	WHERE district='California';
	
   
    SELECT title,first_name, last_name  
    FROM film
    INNER JOIN film_actor
    ON film.film_id = film_actor.film_id
    INNER JOIN actor
    ON film_actor.actor_id = actor.actor_id
    WHERE first_name='Nick' AND last_name='Wahlberg';
	
	SELECT EXTRACT(YEAR FROM payment_date) AS payment_year
	FROM payment;
	
	SELECT AGE(payment_date) FROM payment;
	
	SELECT TO_CHAR(payment_date, 'MM/dd/YYYY') FROM payment;
	SELECT TO_CHAR(payment_date, 'DD.MM.YYYY') FROM payment;
	
	SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) AS payment_month
	FROM payment;
	
	SELECT COUNT(*)	FROM payment
	WHERE EXTRACT(dow FROM payment_date)=1
	
	SELECT UPPER(first_name) || ' ' || UPPER(last_name) AS full_name
	FROM customer;
	
	SELECT LOWER(LEFT(first_name,1)) || LOWER(last_name) || 'gmail.com' AS custom_email
	FROM customer;
	
	SELECT * FROM film;
	SELECT title, rental_rate FROM film
	WHERE rental_rate>(SELECT AVG(rental_rate) FROM film);
	
	
	SELECT first_name, last_name FROM customer AS c
	WHERE EXISTS
	(SELECT * FROM payment AS p
	WHERE p.customer_id=c.customer_id
	AND amount > 11);
	
	-- Find pairs of films with the same length
	SELECT f1.title, f2.title, f1.length 
	FROM film AS f1
	INNER JOIN film AS f2 ON
	f1.film_id!=f2.film_id
	AND f1.length=f2.length;