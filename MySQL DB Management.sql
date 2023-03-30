-- Create schema (database)
CREATE SCHEMA myfirstcodeschema DEFAULT CHARACTER SET utf8mb4;

-- Create table
USE myfirstcodeschema; -- or double click on table to the side so it is bold
CREATE TABLE myfirstcodetable (
	myfirstcodetable_id BIGINT NOT NULL, -- only numbers allowed 
    my_character_field VARCHAR(50), -- both text and numbers
    my_text_field TEXT, -- only text values allowed
    my_created_at TIMESTAMP,
    PRIMARY KEY (myfirstcodetable_id)
);

/*
Common MySQL Data Types in this course:
TINYINT Integar (-128 to 127)
SMALLINT Integar (-32768 to 32768)
MEDIUMINT Integar (-8388608 to 8388607)
INT Integar (-2147483648 to 2147483647)
BIGINT Integar (-9223372036854775808 to 9223372036854775807)
FLOAT Decimal (precise to 23 digits)
DOUBLE Decimal (23 to 53 digits)
DECIMAL Decimal (to 65 digits - most precise)

CHAR String (0-255) - fixed length text or numerical
VARCHAR String (0-255) - variable length text or numerical
TINYTEXT String (0-255) - only need text and do not need numerical 
TEXT String (0-65535) - only need text and do not need numerical
DATE YYYY-MM-DD
DATETIME YYYY-MM-DD HH:MM:SS
TIMESTAMP YYYYMMDDHHMMSS
ENUM One of a number of preset options - only meets certain specifications

mysql data types for other data types
*/

/* Assignment 1
1. Create a new schema, called ‘toms_marketing_stuff’
2. Add a table called ‘publishers’, with two columns:
‘publisher_id’ (integer) and ‘publisher_name’ (up to 65 chars)
3. Add another table called ‘publisher_spend’ with 
‘publisher_id’ (integer), ‘month’ (date), and spend (decimal) 
*/

CREATE SCHEMA toms_marketing_stuff DEFAULT CHARACTER SET utf8mb4;

USE toms_marketing_stuff;
CREATE TABLE publishers (
	publisher_id INT NOT NULL,
    publisher_name VARCHAR(65),
    PRIMARY KEY (publisher_id)
);
CREATE TABLE publisher_spend (
	publisher_spend_id VARCHAR(45) NOT NULL,
    publisher_id INT NOT NULL,
    month DATE NOT NULL,
    spend DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (publisher_spend_id)
);

/* 	Altering Tables
ALTER TABLE tablename
ADD COLUMN data type (optional: specify where column appears FIRST or AFTER)
or DROP COLUMN (be very careful when droping columns/tables/schemas!)
*/
ALTER TABLE customer_purchases
DROP COLUMN customer_id;

ALTER TABLE customer_purchases
ADD COLUMN purchase_amount DECIMAL (10,2) AFTER customer_purchase_id;

/* Assignment 2
1. Can you remove the hourly_wage column from the
employees table? (I need it hidden before I can share out)
2. Can you add a column to the employees table called
‘avg_customer_rating’? (decimal to one digit)
*/
USE candystore;
ALTER TABLE employees
DROP COLUMN hourly_wage;

ALTER TABLE employees
ADD COLUMN avg_customer_rating DECIMAL (10,1);

-- Drop Schemas & Tables
USE myfirstschema;
DROP TABLE myfirsttable;
DROP SCHEMA myfirstcodeschema;

/* Assignment 3
1. Drop the table ‘candy_products’. I don’t want my
employees knowing my margins.
2. Drop the schema ‘candystore_old’. This is an old copy
that is now out of date, so we don’t need to maintain it.
*/
USE candystore;
DROP TABLE candy_products;
DROP SCHEMA candystore_old;

-- Inserting records into tables
USE thriftshop;
SELECT * FROM inventory;

INSERT INTO inventory VALUES
(10,'wolf skin hat',1);

INSERT INTO inventory (inventory_id, item_name) VALUES
(14,'wolf skin sneakers');

INSERT INTO inventory (inventory_id, item_name, number_in_stock) VALUES
(11,'fur fox skin',1),
(12,'plaid button up shirt',8),
(13,'flannel zebra jammies',6);

/* UPDATING RECORDS
UPDATE table
SET 
WHERE (optional) but if you do not use where clause, update will process on all records
*/
UPDATE inventory
SET number_in_stock = 0 -- we sold out
WHERE inventory_id = 9;

/* Assignment 4
Exciting news! I have hired two new employees, who both
started on March 15th, 2020. They are both clerks. Their
names are Charles Munger and William Gates. Could you add
them to the employees table for me?
Could you also update the avg_customer_rating column? The
average ratings for employees 1-6 are 4.8, 4.6, 4.75, 4.9, 4.75,
and 4.2, respectively. The two new clerks are both at 5.0. 
*/
USE candystore;
SELECT * FROM employees;
INSERT INTO employees VALUES
(7, 'Charles', 'Munger', '2020-03-15', 'Clerk', NULL),
(8, 'William', 'Gates', '2020-03-15', 'Clerk', NULL);

UPDATE employees SET avg_customer_rating = 4.8 WHERE employee_id = 1;
UPDATE employees SET avg_customer_rating = 4.6 WHERE employee_id = 2;
UPDATE employees SET avg_customer_rating = 4.75 WHERE employee_id = 3;
UPDATE employees SET avg_customer_rating = 4.9 WHERE employee_id = 4;
UPDATE employees SET avg_customer_rating = 4.75 WHERE employee_id = 5;
UPDATE employees SET avg_customer_rating = 4.2 WHERE employee_id = 6;
UPDATE employees SET avg_customer_rating = 5.0 WHERE employee_id = 7;
UPDATE employees SET avg_customer_rating = 5.0 WHERE employee_id = 8;

/* DELETE RECORDS and ROLLBACK/COMMIT
DELETE FROM tablename
WHERE (optional) but if you do not use where clause, delete will process on all records
*/
USE thriftshop;
SELECT * FROM inventory;

SELECT @@autocommit; -- allows you to make temporary changes until you commit
SET autocommit = 0; -- set as off (can use 0 or OFF)
SET autocommit = 1; -- set as on (can use 1 or ON)

DELETE FROM inventory
WHERE inventory_id = 7;

ROLLBACK; -- undos the last statement
COMMIT; -- commits the changes

/* TRUNCATE TABLE
TRUNCATE TABLE tablename
remove all records from a table but preserve the table structure
similar to DELETE without a WHERE clause but TRUNCATE cannot ROLLBACK
DATA DEFINITION LANGUAGE (DDL) - used to create or modify the structure of a database
		CREATE, ALTER, DROP, TRUNCATE
DATA MANIPULATION LANGUAGE (DML) - used to add, modify, or delete data records
		INSERT, UPDATE, DELETE
DATA QUERY LANGUAGE (DQL) - used to query data (often considered part of DML)
		SELECT, SHOW, HELP
DATA CONTROL LANGUAGE (DCL) - used to grant and revoke permissions
		GRANT, REVOKE
DATA TRANSACTION LANGUAGE (DTL) - used to manage transactions
		START TRANSACTION, COMMIT, ROLLBACK
*/
USE thriftshop;
SELECT * FROM customers; 
SELECT @@autocommit;
SET autocommit = OFF;
DELETE FROM customers
WHERE customer_id BETWEEN 1 and 6;
ROLLBACK;
TRUNCATE TABLE customers; -- data cannot rollback with truncate

/* Assignment 5
I have a situation I need your help with. One of my employees,
Margaret Simpson, was recently caught generating fake
customer reviews to boost her score. I would like you to…
1. Delete her record from the employees table
2. Remove all data from the customer reviews table but
preserve the table structure (we want to start fresh)
*/
USE candystore;
SELECT @@autocommit;
SET autocommit = OFF;
SELECT * FROM employees;

DELETE FROM employees
WHERE employee_id = 4;
COMMIT;

SELECT * FROM customer_reviews;
TRUNCATE TABLE customer_reviews;

/* DATABASE DESIGN
Cardinality refers to the uniqueness of values in a column of a table 
and is commonly used to describe how two tables relate
	(one-to-one, one-to-many, or many-to-many)
	PRIMARY (ONE) - always unique
	FOREIGN (MANY) - non-unique and can repeat
create one-to-many relationship by connecting foreign key to a primary key in another table

Normalization: process of structuring tables and columns in a relational 
(multiple related tables) database to minimize redundancy and preserve data integrity
Benefits:	Eliminate duplicate data (storage and query process more efficient)
			Reduce errors and anomalies (restrict data structure and prevent human errors)

*/
-- Normalizing a table
USE mavenfuzzyfactorymini;
SELECT * FROM website_pageviews_non_normalized;

CREATE TABLE website_pageviews_normalized
SELECT
	website_pageview_id,
    created_at,
    website_session_id,
    pageview_url
FROM website_pageviews_non_normalized;
SELECT * FROM website_pageviews_normalized;

CREATE TABLE website_sessions_normalized
SELECT DISTINCT
	website_session_id,
    session_created_at,
    user_id,
    is_repeat_session,
    utm_source,
    utm_campaign,
    utm_content,
    device_type,
    http_referer
FROM website_pageviews_non_normalized;
SELECT * FROM website_sessions_normalized;

/* Assignment 6
Make sure the 3 tables are normalized
*/

USE onlinelearningschool;
SELECT * FROM courses;
SELECT * FROM course_ratings;
SELECT * FROM course_ratings_summaries;

ALTER TABLE course_ratings
DROP COLUMN course_name; -- redundant data found in courses

ALTER TABLE course_ratings
DROP COLUMN instructor; -- redundant data found in courses

/* ENHANCED ENTITY RELATIONSHIP (EER) MODELS
EER diagrams visually model the relationship between tables 
and the constraints within those tables
EER diagrams can map out things like:
- which tables are in the database
- which columns exist in each table
- the data types of the various columns
- primary and foreign keys within tables
- relationship cardinality between tables
- constraints on columns (i.e. non-null)
Symbols:
yellow key - primary key
red diamond - foreign key
blue diamond - not null
unfilled blue diamond - can be null
*/

-- Assignment 7 build an EER diagram of the onlinelearningschool schema - Found in another file

-- MID COURSE PROJECT
/* Question 1 
Take a look at the mavenmoviesmini schema. What do you notice about it? How many tables are there?
What does the data represent? What do you think the current schema? 

mavenmoviesmini schema only has one table to start. This means there is a lot of redundant data 
that can be cleaned up by normalizing the data into multiple tables. 
*/

/* Question 2
If you wanted to break out the data from the inventory_non_normalized table into multiple tables, how
many tables do you think would be ideal? What would you name those tables?

I would break the data from the inventory_non_normalized table into 3 tables:
inventory (inventory_id, film_id, store_id)
film (film_id, title, description, release_year, rental_rate, rating)
store (store_id, store_manager_first_name, store_manager_last_name, store_address, store_city, store_district)
*/

/* Question 3
Based on your answer from question #2, create a new schema with the tables you think will best serve this
data set. You can use SQL code or Workbench’s UI tools (whichever you feel more comfortable with).
*/
CREATE SCHEMA mavenmoviesmini_normalized DEFAULT CHARACTER SET utf8mb4;

CREATE TABLE mavenmoviesmini_normalized.mavenmoviesmini_non_normalized
SELECT *
FROM mavenmoviesmini.inventory_non_normalized;

USE mavenmoviesmini_normalized;
SELECT * FROM mavenmoviesmini_non_normalized;

/* Question 4
Next, use the data from the original schema to populate the tables in your newly optimized schema
(TIP: Revisit the video on database normalization again if you get stuck) 
*/
DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory
SELECT
	inventory_id,
	film_id,
	store_id
FROM mavenmoviesmini_non_normalized;
SELECT * FROM inventory;

DROP TABLE IF EXISTS film;
CREATE TABLE film
SELECT DISTINCT
	film_id,
	title,
	description,
	release_year,
	rental_rate,
	rating
FROM mavenmoviesmini_non_normalized;
SELECT * FROM film;

DROP TABLE IF EXISTS store;
CREATE TABLE store
SELECT DISTINCT
	store_id,
	store_manager_first_name,
	store_manager_last_name,
	store_address,
	store_city,
	store_district
FROM mavenmoviesmini_non_normalized;
SELECT * FROM store;

DROP TABLE mavenmoviesmini_non_normalized;

-- Solution video's way of populating new tables (requires tables to be made first)
USE mavenmoviesmini_normalized;
INSERT INTO inventory (inventory_id, film_id, store_id)
SELECT DISTINCT inventory_id, film_id, store_id
FROM mavenmoviesmini.inventory_non_normalized;
SELECT * FROM inventory;

/* Question 5
Make sure your new tables have the proper primary keys defined and that applicable foreign keys are added.
Add any constraints you think should apply to the data as well (unique, non-NULL, etc.)
*/
-- Done through Workbench's UI tools

/* Question 6
Finally, after doing all of this technical work, write a brief summary of what you have done, in a way that your
non-technical client can understand. Communicate what you did, and why your new schema design is better. 

I have broken the one initial table into a 3 relational tables. This elimates duplicate data so that 
there is more storage is available and can reduce errors. 

The biggest impact you will see is that there is only two stores now listed in the store table, so there are only two records needed. 
Before, this information was repeated across hundreds of records.
*/

/* 
USING INDEXES
The best way to improve the performance of SELECT operations is to create indexes on one or more of the columns
that are tested in the query. The index entries act like pointers to the table rows, allowing the query to quickly 
determine which rows match a condition in the WHERE clause, and retrieve the other column values for these rows. 
All MySQL data types can be indexed.
- Can create indexes via UI tools or SQL code. In MySQL, the Primary Key and any Foreign Key you create on a table
is always an index automatically.
UNIQUE CONSTRAINT
Adding a unique constraint can be done via Workbench's UI or SQL code
Including a unique constraint on columns that should not repeat is a good way to ensure data integrity,
and is a good best practice
NON-NULL CONSTAINT
We may want certian columns to be populated with a value for every single record that ever gets written
We can prescribe this by applying a NON-NULL contraint to a certain column, which requires all records to have a value in that column
If the NON-NULL constraint is on a column, and someone tries to INSERT a record without including a value for the column, the INSERT will fail

Question: why do you not put a unique constraint on a primary key?
You do not have to put a unique restraint because there is already one built in for a primary key so it is just redundant to add another
*/
/* STORED PROCEDURES
MySQL gives us the ability to store and call frequently used queries on the server. These are referred to as "procedures" or "stored procedures"
Benefits include more efficient query writing and query performance, and ability to share complex procedures more easily between analysts and other db users
*/
-- simple procedure example:
USE thriftshop;
SELECT * FROM inventory;

-- changing the delimiter so that full query can run without being interupted by the stored procedure ; (the default delimiter is ; and you need the delimiter in procedure)
DELIMITER $$ 
-- creating the procedure
CREATE PROCEDURE sp_selectAllInventory()
BEGIN
	SELECT * FROM inventory;
END $$
-- changing the delimiter back to the default
DELIMITER ;

-- calling the procedure that we have created
CALL sp_selectAllInventory();

-- if we later want to DROP the procedure, we can use this...
DROP PROCEDURE IF EXISTS sp_selectAllInventory;

/* Assignment 8
As we scale up, I would like a very quick way to query how many orders each of our staff members has served, all-time.
I am not a database pro, so I need this to be as simple as possible. Something like the following would be ideal…
CALL sp_staffOrdersServed; 
*/
USE sloppyjoes;
SELECT * FROM customer_orders;

DELIMITER //
CREATE PROCEDURE sp_staffOrdersServed()
BEGIN
	SELECT 
		staff_id,
        COUNT(order_id) AS orders_served
    FROM customer_orders
    GROUP BY staff_id;
END //

DELIMITER ;
CALL sp_staffOrdersServed;

DROP PROCEDURE IF EXISTS sp_staffOrdersServed;

/* TRIGGERS
MySQL allows us to create Triggers, where we can prescribe certain actions on a table to trigger one or more other actions to occur.
We may prescribe that our triggered action occurs either BEFORE or AFTER an INSERT, UPDATE, or a DELETE.
Triggers are a very common way to make sure related tables remain in sync as they are updated over time.
*/
USE thriftshop;
SELECT * FROM inventory;
SELECT * FROM customer_purchases;

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON customer_purchases
FOR EACH ROW
	UPDATE inventory
		-- subtracting an item for each purchase
        SET number_in_stock = number_in_stock - 1
	WHERE inventory_id = NEW.inventory_id;
    
INSERT INTO customer_purchases VALUES
(13,NULL,3,NULL), -- inventory_id = 3, velour jumpsuit
(14,NULL,4,NULL) -- inventory_id = 4, house slippers
;
SELECT * FROM inventory;

/* Assignment 9
Is there any way we could automatically update the number of
orders served in the staff table anytime we serve another
order and a record is written to the customer_orders table? 
*/
USE sloppyjoes;
SELECT * FROM customer_orders;
SELECT * FROM staff;

DROP TRIGGER IF EXISTS staffUpdateOrdersServed;
CREATE TRIGGER staffUpdateOrdersServed
AFTER INSERT ON customer_orders
FOR EACH ROW
	UPDATE staff
		-- subtracting an item for each purchase
        SET orders_served = orders_served + 1
	WHERE staff.staff_id = NEW.staff_id;
    
INSERT INTO customer_orders VALUES
(21,1,10.98), -- order_id = 21, staff_id = 1, order_total = 5.98
(22,2,5.99),
(23,2,7.99),
(24,2,12.97)
;

SELECT * FROM customer_orders;
SELECT * FROM staff;

/* SERVER MANAGEMENT
The administration tab gives us options to monitor and control the status of the MySQL Server we are connected to
The Server Status view gives us a quick view of our Server
Go to Adminstration instead of Schemas tab to the left. Click Server Status and look at overview and then you can go to Startup / Shutdown to change

USER MANAGEMENT
Workbench makes it easy for us to add Users and to manage their Privileges
Users can be granted varying levels of permissions. At one end of the spectrum, you could create a user that can only
SELECT, and at the other end of the spectrum is the DBA role, which carries all privelages
Go to Administration and then Users and Privelages 
*/

-- FINAL COURSE PROJECT
/* Question 1
Bubs wants you to track information on his customers (first name, last name, email), his employees (first
name, last name, start date, position held), his products, and the purchases customers make (which customer,
when it was purchased, for how much money). Think about how many tables you should create. Which data
goes in which tables? How should the tables relate to one another? 

customers (customer_id, first_name, last_name, email)
employees (employee_id, first_name, last_name, start_date, position)
products (product_id, product_name)
purchases (purchase_id, customer_id, product_id, purchase_date, purchase_amount)
*/
/* Question 2
Given the database design you came up with, use Workbench to create an EER diagram of the database.
Include things like primary keys and foreign keys, and anything else you think you should have in the tables.
Make sure to use reasonable data types for each column.
*/
-- Done through Workbench's UI tools
/* Question 3
Create a schema called bubsbooties. Within that schema, create the tables that you have diagramed out. Make
sure they relate to each other, and that they have the same reasonable data types you selected previously. 
*/
-- Done through Workbench's UI tools
/* Question 4
Add any constraints you think your tables’ columns should have. Think through which columns need to be
unique, which ones are allowed to have NULL values, etc. 
*/
-- Done through Workbench's UI tools
/* Question 5
Insert at least 3 records of data into each table. The exact values do not matter, so feel free to make them
up. Just make sure that the data you insert makes sense, and that the tables tie together. 
*/
USE bubsbooties;
INSERT INTO customers VALUES
(1,"Mary","Jane","maryjane@gmail.com"),
(2,"Bob","Williams","bob.w@gmail.com"),
(3,"Hope","Philips","hp123@gmail.com");

INSERT INTO employees VALUES
(1,"Billy","Joe",'2016-02-14','manager'),
(2,"Kelly","Meyers",'2019-10-31','cashier'),
(3,"Helen","Richards",'2020-04-01','cashier');
-- products (product_id, product_name)
-- purchases (purchase_id, customer_id, product_id, purchase_date, purchase_amount)

/* Question 6
Create two users and give them access to the database. The first user, TuckerReilly, will be the DBA, and should
get full database administrator privileges. The second user, EllaBrody, is an Analyst, and only needs read access.
*/
-- Done through Workbench's UI tools
