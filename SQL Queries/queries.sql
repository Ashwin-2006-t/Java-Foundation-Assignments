-- version 8.x
-- show version();
show databases;
-- creating the database in localhost instance
create database sample_db_nov_2026;

-- select this DB for further operation -- IMP
use sample_db_nov_2026; -- henceforth all the queries will refer to this DB

/*
Engines
- MyISAM
- InnoDB-- transaction, procedures, triggers
*/
show engines;

-- creating a sample table
create table sample_table(
id INT primary key auto_increment,
name varchar(255) not null, -- minimum 255 character(secondry memory)
city varchar(255),
age int, --  not case sensitive (both caps or small case)
points double default 10
);

describe sample_table; -- desc or describe

-- Add a new column to the table
alter table sample_table
add column rating double default 1;

-- Modify the existing column to add a constraint
alter table sample_table
modify column city varchar(255) not null;

-- Rename the column (points --> credits)
alter table sample_table
rename column points to credits;

-- change the column name and constraints at a same time(MODIFY + RENAME)
alter table sample_table
change column city city_name varchar(100); 

-- drop the column (you do loose the data as well)
alter table sample_table
drop column rating;

/*
SQL :

select <attributes> --> Projections (mandatory)
from <table(s)-name> -->(mandatory)
where <condition> -->(optional clause)
group by <grouping function/ grouping attribute>--> (optional clause)
having <condition on grouping function> --> (optional clause)
order by <attribute> ASC | DESC  --> (optional clause)
limit <skip> --> (optional clause)
*/



use lms_db_2026;


-- Insertion
insert into learner (name, user_id, contact_id, address_id) 
values ("Harry Potter",1, null ,null);

insert into user(username, password, role)
values("Harry","harry@123","LEARNER");

select * from user;

insert into contact(primary_contact, main_email)
values("12345678","harry@gmail.com");

insert into address(city)
values ("london");

-- Refrential Integrity of Foreign Keys
insert into learner (name, user_id, contact_id, address_id) 
values ("Harry Potter",1, 1 ,1);

insert into learner (name, user_id, contact_id, address_id) 
values ("Harry Potter",2, 1 ,1);  -- > violating refrential integrity 
/*
0	2	09:58:06	insert into learner (name, user_id, contact_id, address_id) 
 values ("Harry Potter",2, 1 ,1)	
 Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails 
 (`lms_db_2026`.`learner`, CONSTRAINT `fk_learner_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`))	0.016 sec
*/

-- Reuse address - it works right now -----> we need t fix this later (Java validation)
insert into learner (name, user_id, contact_id, address_id) 
values ("Ronal Weasley",1, 1 ,1);
-- Foreign key can be repeated, Primary key cant be repeated 



INSERT INTO contact
(primary_contact, alternate_contact, main_email, secondry_email)
VALUES
('9876543210', NULL, 'john@gmail.com', NULL),
('9876543211', NULL, 'alice@gmail.com', NULL),
('9876543212', NULL, 'rahul@gmail.com', NULL),
('9876543213', NULL, 'david@gmail.com', NULL);


INSERT INTO address (city, state, pincode)
VALUES
('Chennai', 'Tamil Nadu', '600001'),
('Bangalore', 'Karnataka', '560001'),
('Coimbatore', 'Tamil Nadu', '641001'),
('Tiruvannamalai', 'Tamil Nadu', '606601');


INSERT INTO user (username, password, role, is_active)
VALUES
('john123', 'john@123', 'INSTRUCTOR', 1),
('alice123', 'alice@123', 'LEARNER', 1),
('rahul123', 'rahul@123', 'LEARNER', 1),
('david123', 'david@123', 'INSTRUCTOR', 0);

INSERT INTO instructor
(name, salary, user_id, contact_id, address_id)
VALUES
('John Smith', 45000, 2, 2, 2),
('David Kumar', 50000, 5, 5, 5);



INSERT INTO learner
(name, user_id, contact_id, address_id)
VALUES
('Alice', 3, 3, 3),
('Rahul', 4, 4, 4);


SELECT * FROM contact;
SELECT * FROM address;
SELECT * FROM instructor;
SELECT * FROM learner;


/*
shd i alter the table settings to keep user_id as 
unique and let contact and address be shared as they are?
*/

-- alter the table settings to keep user_id unique and let contact and address be shared as thery 
alter table learner
drop primary key,
add primary key (id), -- > 2nd chaning operation
add unique (user_id); -- > 3rd chaning operation

delete from learner where id in (1,3); -- before making unique, delete the duplicate records 


-- making address+id FK as nullable so we can delete that in isolation 
alter table learner
modify address_id int null;

delete from address where id =1;

alter table learner
drop foreign key fk_learner_address1; -- address

alter table learner 
add constraint `fk_learner_address1`
	foreign key  (`address_id`)
	references `lms_db_2026`.`address` (`id`)
    on delete SET NULL;
    
delete from address where id =1; --  sucessfully deleted without deleting learning record


/*
In earler example, when address(parent) is deleted, chid was not deleted as ON delete was 'SET NULL'

In this example, I want to delete the child(learner) when parent(user) is deleted.
*/


-- step 1
alter table learner
drop foreign key fk_learner_user;

-- step 2
alter table learner 
add constraint `fk_learner_user`
	foreign key  (`user_id`)
	references `lms_db_2026`.`user` (`id`)
    on delete CASCADE;

-- step 3
delete from user where id =1;

-- useer gets deleted, learner gets deleted. s it is cascade


/*
Update Op : here we can update the attribute values of all rows except the primary key
So the child table never has a problem with parent row getting updated

For example, updating contact table record does not bother connected learner record.
*/

update contact
	set alternate_contact = '543254325'
where id=1;

-- in case where a completely new record is created in contact(parent ) then foreign key in child table can be updated but this appprach is 
-- is never appreciated

/*
1. What is an orphan record?
An orphan record is a child record that refers to a parent record that does not exist.
In simple words, a child record has lost its parent.

2. Why is UPDATE not recommended?
First, understand that UPDATE itself is not bad. Updating data is completely normal.
What is generally discouraged is unnecessarily updating a primary key that other tables reference.
*/

INSERT INTO contact
(primary_contact, main_email)
VALUES
('9876543454310', 'test@gmail.com');

-- update learner and assign the new contact to it
update learner
	set contact_id = 2
where id=6;


-- select operation
-- Query to fetch all learners
/*
When your fetch child record, U must also fetch the corresponding record of the parent tables.alter
learner has 3 parent tables : user, contact, address.
2 of these are NOT NULL and address can be NULL
*/

select * from learner; -- this give me learner details with FKs which is not of much help

/*
3 ways of combining tables (Parent child relationship)

1. Manual Mapping
2. Joins
3. Nested Queries (Sub-Query)
*/

-- Manual Mapping
select l.id, l.name, c.primary_contact, c.main_email, u.username, u.is_active, a.city
   from learner l, contact c, user u, address a
   where l.user_id = u.id and l.contact_id = c.id and l.address_id = a.id;
-- here issue with manual mapping i shtat if any of the where clause conditions fail, we loose entire info (it displays nothing)



-- JOINS ---------->>>>>>>
-- ==========================================
-- SQL JOINS
-- 1. INNER JOIN
-- 2. LEFT JOIN
-- 3. 
-- ==========================================

-- 1. INNER JOIN
-- Returns only matching records from both tables.
-- If a learner has no address, that learner's
-- entire record will be excluded.
SELECT
    l.id,
    l.name,
    c.primary_contact,
    c.main_email,
    u.username,
    u.is_active,
    a.city
FROM learner l
JOIN user u ON l.user_id = u.id
JOIN contact c ON l.contact_id = c.id
JOIN address a ON l.address_id = a.id;

-- 2. LEFT JOIN
-- Returns all records from the LEFT table (learner).
-- If an address exists, retrieve its details.
-- Otherwise, return NULL for address columns.
-- Hence, learners without addresses are not excluded.

SELECT
    l.id,
    l.name,
    c.primary_contact,
    c.main_email,
    u.username,
    u.is_active,
    a.city
FROM learner l
JOIN user u ON l.user_id = u.id
JOIN contact c ON l.contact_id = c.id
LEFT JOIN address a ON l.address_id = a.id;

-- 3. COALESCE() FUNCTION
-- Returns the first non-NULL value.
-- If city is NULL, display 'Not Provided'.
-- AS city gives the output column an alias.

SELECT
    l.id,
    l.name,
    c.primary_contact,
    c.main_email,
    u.username,
    u.is_active,
    COALESCE(a.city, 'Not Provided') AS city
FROM learner l
JOIN user u ON l.user_id = u.id
JOIN contact c ON l.contact_id = c.id
LEFT JOIN address a ON l.address_id = a.id;

-- 4. COALESCE() EXAMPLES
SELECT COALESCE(NULL, 'Hello');
-- Output: Hello
SELECT COALESCE(NULL, NULL, 'Chennai', 'Bangalore');
-- Output: Chennai


-- giving proper info to app e.g. is_active
SELECT
    l.id,
    l.name,
    c.primary_contact,
    c.main_email,
    u.username,
    CASE u.is_active
    WHEN 1 THEN 'ENABLED'
    WHEN 0 THEN 'DISABLED'
    ELSE 'UNKNOWN' 
    END 
    as learner_status,
    COALESCE(a.city, 'Not Provided') AS city
FROM learner l
JOIN user u ON l.user_id = u.id
JOIN contact c ON l.contact_id = c.id
LEFT JOIN address a ON l.address_id = a.id;


-- inserting records in course table but since it has instructor id and department id a s foreign keys , we start from ther
-- but instructor also has FK from user, contact and address tables so lets start from there

insert into user(username, password, role) values ('Albus Dumbleres','ablbus@432','INSTRUCTOR');

INSERT INTO contact
(primary_contact, main_email)
VALUES
('9876543454310', 'test@gmail.com');

insert into address(city, pincode) values ('MUMBAI','543242');

insert into instructor(name, salary, contact_id, user_id,address_id)
values ("Albus Dumbleres",'2500000',6,7,7);

insert into department(name) values ('programming'),('product management'); -- multiple inserts

insert into course(name, fees, instructor_id, department_id) values ('SQL Programming', 3500,7,1);

-- Query to fetch info abour the course
select c.id as Course_id, c.name as course_name , c.fees as FEES, i.name as Instructor_name, d.name as department_name
from course c
JOIN instructor i ON c.instructor_id = i.id
JOIN department d ON c.department_id = d.id;

/*
+-----------+-----------------+------+-----------------+-----------------+
| Course_id | course_name     | FEES | Instructor_name | department_name |
+-----------+-----------------+------+-----------------+-----------------+
|         1 | SQL Programming | 3500 | Albus Dumbleres | programming     |
+-----------+-----------------+------+-----------------+-----------------+
*/

-- =========================================
-- GROUP BY
-- =========================================

-- Select the database
USE lms_db_2026;

-- 1. Display all courses handled by instructor ID = 7
-- JOIN connects instructor and course using instructor ID
-- WHERE filters only instructor ID 7
SELECT c.*, i.name
FROM instructor i
JOIN course c ON i.id = c.instructor_id
WHERE i.id = 7;

-- 2. Insert sample courses for different instructors
-- Each course is assigned to an instructor using instructor_id
INSERT INTO course (name, fees, instructor_id, department_id)
VALUES
('Java Programming', 4000, 5, 1),
('Python Programming', 4500, 5, 1),
('Web Development', 5000, 6, 2),
('Database Management', 3500, 6, 2),
('Spring Boot', 6000, 7, 1),
('Data Structures', 4000, 7, 1),
('Machine Learning', 7000, 8, 2);

-- 3. Display the number of courses handled by each instructor ID
-- COUNT(*) counts the number of courses
-- GROUP BY groups courses having the same instructor ID
SELECT instructor_id, COUNT(*) AS total_courses
FROM course
GROUP BY instructor_id;

-- 4. Display instructor name and number of courses handled
-- JOIN connects instructor and course
-- COUNT(c.id) counts the courses for each instructor
-- GROUP BY groups the result based on instructor ID and name
SELECT
    i.name AS instructor_name,
    COUNT(c.id) AS total_courses
FROM instructor i
JOIN course c
    ON i.id = c.instructor_id
GROUP BY i.id, i.name;


-- --------------------------------
-- Aggregate function
-- --------------------------------

-- SELECT *
-- FROM instructor i
-- JOIN course c
--     ON i.id = c.instructor_id
-- JOIN department d
--     ON c.department_id = d.id;

-- Display average instructor salary in each department

SELECT
    d.name AS department_name,
    AVG(i.salary) AS average_salary
FROM instructor i
JOIN course c
    ON i.id = c.instructor_id
JOIN department d
    ON c.department_id = d.id
GROUP BY
    d.id,
    d.name;
    
-- Display average course fee for each instructor
-- in each department

SELECT
    i.name AS instructor_name,
    d.name AS department_name,
    AVG(c.fees) AS average_fees
FROM instructor i
JOIN course c
    ON i.id = c.instructor_id
JOIN department d
    ON c.department_id = d.id
GROUP BY
    i.id, i.name, d.id, d.name;
    


-- Insert sample enrollment records
-- learner_id represents the enrolled learner
-- course_id represents the selected course
-- date_of_enroll represents the enrollment date
INSERT INTO learner_course
(learner_id, course_id, date_of_enroll, amount_paid, coupon, discount)
VALUES
(6, 1, '2026-11-20', 3500, 'NEW10', '10%'),
(7, 1, '2026-11-21', 3500, NULL, NULL),
(10, 1, '2026-11-22', 3000, 'SAVE500', '500'),
(6, 2, '2026-11-23', 4000, NULL, NULL),
(7, 2, '2026-11-24', 3800, 'JAVA5', '5%'),
(10, 3, '2026-11-25', 4500, NULL, NULL);


-- 3. Display all enrollment records
SELECT *
FROM learner_course;

-- 4. Display total learners enrolled in each course
-- JOIN connects course and learner_course
-- COUNT() counts the enrolled learners
-- LEFT JOIN includes courses with zero enrollments
-- GROUP BY groups learners based on each course
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name;


-- Display courses having at least 2 enrolled learners and ASC or DESC order
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name
HAVING COUNT(lc.learner_id) >= 2
ORDER BY total_learners ASC
limit 2;




-- =============================================
-- LEFT JOIN AND RIGHT JOIN PRACTICE
-- Database: lms_db_2026
-- =============================================
-- =============================================
-- 1. DISPLAY ALL COURSES
-- =============================================
SELECT * FROM course;
-- =============================================
-- 2. INSERT LEARNER ENROLLMENTS
-- Cloud Computing (ID: 9) - 2 learners
-- Cyber Security (ID: 10) - 1 learner
-- =============================================
INSERT INTO learner_course
(learner_id, course_id, date_of_enroll, amount_paid, coupon, discount)
VALUES
(6, 9, '2026-11-25', 5500, NULL, NULL),
(7, 9, '2026-11-25', 5500, NULL, NULL),
(10, 10, '2026-11-25', 6000, NULL, NULL);
-- =============================================
-- 3. VERIFY LEARNER ENROLLMENTS
-- =============================================
SELECT * FROM learner_course;
-- =============================================
-- 4. LEFT JOIN
-- Display all courses and their enrollments
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    lc.learner_id,
    lc.amount_paid
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id;
-- =============================================
-- 5. RIGHT JOIN
-- Display all courses and their enrollments
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    lc.learner_id,
    lc.amount_paid
FROM learner_course lc
RIGHT JOIN course c
    ON lc.course_id = c.id;
-- =============================================
-- 6. LEFT JOIN WITH GROUP BY AND COUNT
-- Count the number of learners in each course
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name;

-- =============================================
-- 7. RIGHT JOIN WITH GROUP BY AND COUNT
-- Count the number of learners in each course
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM learner_course lc
RIGHT JOIN course c
    ON lc.course_id = c.id
GROUP BY c.id, c.name;

-- LEFT and RIGHT are same, except it depends on the sequence of join.

-- =============================================
-- 8. HAVING
-- Display courses having at least 2 learners
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name
HAVING COUNT(lc.learner_id) >= 2;
-- =============================================
-- 9. ORDER BY
-- Sort courses by learner count (ascending)
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name
ORDER BY total_learners ASC;
-- =============================================
-- 10. DISPLAY ONLY COURSES WITH ZERO LEARNERS
-- =============================================
SELECT
    c.id AS course_id,
    c.name AS course_name,
    COUNT(lc.learner_id) AS total_learners
FROM course c
LEFT JOIN learner_course lc
    ON c.id = lc.course_id
GROUP BY c.id, c.name
HAVING COUNT(lc.learner_id) = 0;


-- Insert track records
INSERT INTO track (name)
VALUES
('Java Programming'),
('Product Mgmt'),
('App Development');

-- Insert course and track relationships

INSERT INTO course_track (course_id, track_id)
VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 3),
(4, 2),
(5, 2);


-- -------------------------
-- SELF JOIN
-- ------------------------

-- Add lead_id column to instructor table
ALTER TABLE instructor
ADD COLUMN lead_id INT NULL;

-- Reference the instructor table itself
ALTER TABLE instructor
ADD CONSTRAINT fk_instructor_lead
FOREIGN KEY (lead_id)
REFERENCES instructor (id);

-- Insert additional instructors
INSERT INTO instructor
(name, salary, user_id, contact_id, address_id, lead_id)
VALUES
('Harry Potter', 60000, 2, 2, 2, 6),
('Ron Weasley', 55000, 5, 5, 5, 6),
('Hermione Granger', 65000, 7, 6, 7, 7);

-- Assign John Smith (ID: 5) as the lead of David Kumar and Albus Dumbleres
UPDATE instructor
SET lead_id = 5
WHERE id IN (6, 7);

-- Display instructor name and their lead name -------------------------(SELF JOIN)-------------------------------------------------------------------
SELECT
    i.id AS instructor_id,
    i.name AS instructor_name,
	coalesce(l.name,'- No Lead -')  AS lead_name
FROM instructor i -- PK
LEFT JOIN instructor l -- FK
    ON i.lead_id = l.id;
    
-- count number of instructor working under each lead 
SELECT
    l.id AS lead_id,
    COALESCE(l.name, '-No Lead-') AS lead_name,
    COUNT(i.id) AS total_instructors
FROM instructor i
LEFT JOIN instructor l
    ON i.lead_id = l.id
GROUP BY l.id, l.name;


use lms_db_2026;

/*
===========================================================
TOPIC: SUBQUERY, IN, EXISTS AND FAN-OUT PROBLEM
===========================================================
QUESTION:
Display the instructors whose salary is greater than
the average salary of instructors teaching in the
Programming department.

TABLES:
1. instructor
2. course
3. department
*/
/*
-----------------------------------------------------------
PART 1: UNDERSTANDING A NORMAL SUBQUERY
-----------------------------------------------------------
Example question:
Display instructors whose salary is greater than
the overall average salary of all instructors.

STEP 1: Calculate average salary.
*/
SELECT AVG(salary)
FROM instructor;

/*
STEP 2: Use the above query as a SUBQUERY.
The inner query calculates the average salary.
The outer query compares each instructor's salary
with the calculated average.
*/
SELECT i.name, i.salary
FROM instructor i
WHERE i.salary > (
    SELECT AVG(i2.salary)
    FROM instructor i2
);

/*
HOW IT WORKS:

Inner query:
SELECT AVG(i2.salary)
FROM instructor i2

Calculates the average salary.

Outer query:
SELECT i.name, i.salary
FROM instructor i

Displays instructors whose salary is greater
than the average salary.

A SUBQUERY is a query written inside another query.
*/
/*
===========================================================
PART 2: FIND INSTRUCTORS TEACHING IN PROGRAMMING DEPARTMENT
===========================================================
STEP 1: Use JOIN to connect the three tables.

instructor -> course -> department
*/
SELECT
    i.id,
    i.name,
    i.salary
FROM instructor i
JOIN course c
    ON i.id = c.instructor_id
JOIN department d
    ON c.department_id = d.id
WHERE d.name = 'Programming';

/*
EXPECTED OBSERVATION:

Suppose the output is:

id   name    salary
1    Albus   60000
1    Albus   60000
2    Harry   50000

WHY IS ID 1 REPEATED?

Because Albus teaches multiple courses in
the Programming department.

This is called FAN-OUT.

The JOIN produces duplicate instructor records.
*/


/*
===========================================================
PART 3: SOLVING DUPLICATES USING IN
===========================================================

STEP 1: Fetch instructor IDs teaching in Programming.

The inner query may return:

1
1
2

STEP 2: Use IN to check whether the instructor ID
belongs to the returned list.

IN checks whether an ID matches ANY value in the list.
*/
SELECT
    i.id,
    i.name,
    i.salary
FROM instructor i
WHERE i.id IN (
    SELECT i2.id
    FROM instructor i2
    JOIN course c
        ON i2.id = c.instructor_id
    JOIN department d
        ON c.department_id = d.id
    WHERE d.name = 'Programming'

);

/*
IMPORTANT:

Inner query returns:

1
1
2

Outer query checks:

Is instructor ID 1 in the list? YES
Is instructor ID 2 in the list? YES
Is instructor ID 3 in the list? NO

Even though ID 1 appears twice in the subquery,
the outer instructor row is returned only once.

IN avoids duplicate outer instructor rows.

NOTE:
IN does not remove duplicates from the inner query.
It simply checks membership in the returned list.
*/


/*
===========================================================
PART 4: FINAL QUESTION USING IN AND AVG()
===========================================================

QUESTION:
Display instructors whose salary is greater than
the average salary of instructors teaching in
the Programming department.

STEP 1: Identify instructors belonging to Programming.

STEP 2: Calculate their average salary.

STEP 3: Display instructors earning more than that average.
*/

SELECT
    i.name,
    i.salary
FROM instructor i
WHERE i.salary > (

    SELECT AVG(i2.salary)
    FROM instructor i2

    WHERE i2.id IN (

        SELECT i3.id
        FROM instructor i3
        JOIN course c
            ON i3.id = c.instructor_id
        JOIN department d
            ON c.department_id = d.id
        WHERE d.name = 'Programming'

    )

);

/*
HOW IT WORKS:

INNERMOST QUERY:
Finds instructors teaching in Programming.

Example output:
1
1
2

IN:
Checks which instructor IDs belong to that list.

AVG():
Calculates average salary using the matching
instructor rows from the instructor table.

OUTER QUERY:
Displays instructors whose salary is greater
than the calculated average.

IN avoids duplicate outer instructor rows.
*/


/*
===========================================================
PART 5: UNDERSTANDING EXISTS
===========================================================

EXISTS checks whether at least one matching record
is available.

It returns:
TRUE  -> At least one matching row exists.
FALSE -> No matching row exists.

Unlike JOIN, EXISTS does not multiply outer rows.
*/


/*
METHOD 1: SELECT 1

SELECT 1 returns a constant value for every
matching row.

It does not perform the matching.

WHERE performs the matching.
EXISTS checks whether rows are returned.
*/

SELECT
    i.name,
    i.salary
FROM instructor i
WHERE EXISTS (

    SELECT 1
    FROM course c
    JOIN department d
        ON c.department_id = d.id
    WHERE c.instructor_id = i.id
      AND d.name = 'Programming'

);


/*
EXAMPLE:

Albus teaches 3 Programming courses.

Inner query returns:

1
1
1

EXISTS checks:
Are there any matching rows?

YES -> TRUE

Albus appears only once in the outer result.
*/


/*
-----------------------------------------------------------
METHOD 2: SELECT *
-----------------------------------------------------------

SELECT * returns all columns from matching rows.

EXISTS does not need those actual column values.
It only checks whether at least one row exists.
*/

SELECT
    i.name,
    i.salary
FROM instructor i
WHERE EXISTS (

    SELECT *
    FROM course c
    JOIN department d
        ON c.department_id = d.id
    WHERE c.instructor_id = i.id
      AND d.name = 'Programming'

);


/*
-----------------------------------------------------------
METHOD 3: SELECT c.id
-----------------------------------------------------------

SELECT c.id returns the course ID of matching rows.

EXISTS checks whether at least one matching row exists.
*/

SELECT
    i.name,
    i.salary
FROM instructor i
WHERE EXISTS (

    SELECT c.id
    FROM course c
    JOIN department d
        ON c.department_id = d.id
    WHERE c.instructor_id = i.id
      AND d.name = 'Programming'

);


/*
IMPORTANT:

All three methods give the same result inside EXISTS:

1. SELECT 1
2. SELECT *
3. SELECT c.id

The matching is performed by:

WHERE c.instructor_id = i.id

EXISTS only checks whether matching rows exist.

SELECT 1 is preferred because we only need to
check existence, not retrieve actual data.
*/


/*
===========================================================
PART 6: FAN-OUT PROBLEM WHILE CALCULATING AVG()
===========================================================

PROBLEM:

If we directly calculate AVG() using JOIN,
duplicate instructor records can affect the average.

Example JOIN output:

Albus  60000
Albus  60000
Harry  50000
Albus  60000

Incorrect average:

(60000 + 60000 + 50000 + 60000) / 4 = 57500

Correct average:

(60000 + 50000) / 2 = 55000
*/


/*
INCORRECT APPROACH:

JOIN creates multiple rows for instructors
who teach multiple courses.

AVG() counts the repeated salary values.
*/

SELECT AVG(i.salary) AS incorrect_average
FROM instructor i
JOIN course c
    ON i.id = c.instructor_id
JOIN department d
    ON c.department_id = d.id
WHERE d.name = 'Programming';


/*
===========================================================
PART 7: SOLVING FAN-OUT USING EXISTS
===========================================================

QUESTION:

Display instructors whose salary is greater than
the average salary of instructors teaching in
the Programming department.

STEP 1:
Start with the instructor table.

STEP 2:
Use EXISTS to check whether each instructor teaches
at least one course in Programming.

STEP 3:
Calculate AVG() using the matching instructor rows.

STEP 4:
Compare each instructor's salary with that average.
*/

SELECT
    i.name,
    i.salary
FROM instructor i
WHERE i.salary > (

    SELECT AVG(i2.salary)
    FROM instructor i2

    WHERE EXISTS (

        SELECT 1
        FROM course c
        JOIN department d
            ON c.department_id = d.id

        WHERE c.instructor_id = i2.id
          AND d.name = 'Programming'

    )

);


/*
===========================================================
HOW THE FINAL EXISTS QUERY WORKS
===========================================================

OUTER QUERY:
SELECT i.name, i.salary
FROM instructor i

Takes instructors from the instructor table.

INNER EXISTS:
Checks whether the instructor teaches at least
one course in the Programming department.

EXISTS:
Even if Albus teaches 3 Programming courses,
he is considered only once in the outer instructor set.

AVG():
Calculates the average salary using the matching
instructor records.

FINAL COMPARISON:
Displays instructors whose salary is greater
than the calculated average.

===========================================================
FINAL REVISION
===========================================================

SUBQUERY:
A query inside another query.

JOIN:
Combines matching records from multiple tables.

FAN-OUT:
One instructor produces multiple rows after JOIN
because of multiple matching courses.

IN:
Checks whether a value matches any value in a list.

EXISTS:
Checks whether at least one matching record exists.

SELECT 1:
Returns a constant value. Used when we only need
to check whether a matching row exists.

SELECT *:
Selects all columns.

SELECT c.id:
Selects the course ID.

AVG():
Calculates the average of selected values.

IMPORTANT DIFFERENCE:

IN:
Checks whether a value belongs to a returned list.

EXISTS:
Checks whether matching rows are available.

BOTH can help avoid duplicate outer rows.

EXISTS is particularly useful when we only need
to check a relationship without joining all matching
rows into the outer result.
*/
/*
Operator		Simple meaning
IN				Is this value present in the given list?
EXISTS			Does at least one matching row exist?
NOT IN			Is this value absent from the given list?
NOT EXISTS		Does no matching row exist?
*/




-- Nested - Sub-Queries 
/*
IN 
where exists 
ALL 
ANY
=
*/

-- display instructors earning more than ALL the instructor working in 'programming' department 
select i.name
from instructor i 
where i.salary > ALL (select i.salary from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='programming');
/*
Outer i refers to the instructor table in the outer query.
Inner i refers to the instructor table in the inner query.
*/

-- we don't usually use this ALL as this is similar to using max grouping Fn 
select i.name
from instructor i 
where i.salary >  (select max(i.salary) from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='programming');

-- display instructors earning more than atleast one instructor from 'product management' department 
select i.name
from instructor i 
where i.salary > ANY (select i.salary from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='product management');
 -- OR   ----                    
select i.name
from instructor i 
where i.salary >  (select min(i.salary) from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='product management');
                         

-- IN 
-- display all learners living in following cities ['london', 'mumbai']
select l.name
from learner l JOIN address a ON l.address_id = a.id
where a.city IN ('London', 'Mumbai');

-- using subquery 
select l.name
from learner l
where l.address_id IN (select a.id 
						from address a 
						where a.city IN ('London', 'Mumbai')); 
-- 7 = [8,9,1,2]

-- display learner that have enrolled in course name as Java Programming. do this using sub query 
select l.name
from learner l
where l.id IN 
			(select lc.learner_id 
            from learner_course lc 
            where lc.course_id = (select c.id -- '=' here works because we r guarateed to get single id as c.name is unique
								  from course c 
                                   where c.name="java programming")); 

select l.name
from learner l
where l.id IN 
			(select lc.learner_id 
            from learner_course lc 
            where lc.course_id IN ( select c.id 
									from course c 
									where c.name="java programming"));
                                    
                                    
-- window functions : rank(), dense_rank(), row_number() 
-- All three are used to assign numbers to rows based on a particular order, such as course fees, instructor salaries, marks, etc.
/*
+----+--------------------+------+---------------+---------------+
| id | name               | fee  | instructor_id | department_id |
+----+--------------------+------+---------------+---------------+
|  1 | SQL programming    | 3500 |             1 |             1 |
|  2 | JAVA programming   | 6500 |             1 |             1 |
|  3 | SPRING Framework   | 8500 |             2 |             1 |
|  4 | Product Management | 9500 |             3 |             2 |
|  5 | ITA cert 1         | 2345 |             4 |             2 |
|  6 | Scrum A-Z          | 6000 |             3 |             2 |
+----+--------------------+------+---------------+---------------+
*/
-- display the courses and their ranks as per the fee 
select c.name, c.fees , RANK() OVER (order by fees DESC) as rnk
from course c;

/*
Product Management	9500	1
SPRING Framework	8500	2
JAVA programming	6500	3
Scrum A-Z			6500	3
SQL programming		3500	5
ITA cert 1			2345	6
*/
update course SET fee=6500 where id=6;
-- rank() skips the sequence -- above it has skipped rank 4

select c.name, c.fees , DENSE_RANK() OVER (order by fees DESC) as rnk
from course c;

/*
Product Management	9500	1
SPRING Framework	8500	2
JAVA programming	6500	3
Scrum A-Z			6500	3
SQL programming		3500	4
ITA cert 1			2345	5
*/
-- dense rank does not skip seq. 

select c.name , c.fees,
row_number() OVER (order by c.fees ASC) as row_num ,
RANK() OVER (order by fees DESC) as rnk, 
DENSE_RANK() OVER (order by fees DESC) as dense_rnk
from course c; 


-- TODO: compute ranks by instructor salaries. ASC & DESC
-- Rank instructors from lowest salary to highest salary
SELECT
    i.name,
    i.salary,
    RANK() OVER (ORDER BY i.salary ASC) AS salary_rank
FROM instructor i;


-- Rank courses department-wise based on fees
-- Lowest fee gets Rank 1
-- Ranking restarts from 1 for every department

-- PARTITION BY divides the rows of a table into separate groups based on a specified column and performs the window function independently within each group.
SELECT
    c.name,
    c.fees,
    c.department_id,

    DENSE_RANK() OVER (
        PARTITION BY c.department_id
        ORDER BY c.fees ASC
    ) AS dense_rank_no

FROM course c;



-- =====================================================
-- DATABASE: lms_db_2026
-- TOPIC: STORED PROCEDURES
-- =====================================================

USE lms_db_2026;


-- =====================================================
-- 1. SIMPLE STORED PROCEDURE
-- Display all courses
-- =====================================================

-- A stored procedure is a reusable box containing SQL queries.

DROP PROCEDURE IF EXISTS all_courses;

DELIMITER $$

CREATE PROCEDURE all_courses()
BEGIN
    SELECT *
    FROM course;
END $$

DELIMITER ;

-- Display all stored procedures in this database
SHOW PROCEDURE STATUS
WHERE db = 'lms_db_2026';

-- Execute the procedure
CALL all_courses();


-- =====================================================
-- 2. STORED PROCEDURE WITH IN PARAMETER
-- Display courses belonging to a particular department
-- =====================================================

DROP PROCEDURE IF EXISTS courses_by_dept_id;

DELIMITER $$

CREATE PROCEDURE courses_by_dept_id(IN p_deptId INT)
BEGIN
    SELECT c.id, c.name
    FROM course c
    WHERE c.department_id = p_deptId;
END $$

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE db = 'lms_db_2026';

-- Pass department ID = 1
CALL courses_by_dept_id(1);

-- Pass department ID = 2
CALL courses_by_dept_id(2);


-- =====================================================
-- 3. STORED PROCEDURE WITH IN AND OUT PARAMETERS
-- Calculate total fees of courses belonging to a track
-- =====================================================

DROP PROCEDURE IF EXISTS sum_course_fee_by_track_id;

DELIMITER $$

CREATE PROCEDURE sum_course_fee_by_track_id(
    IN p_trackId INT,
    OUT p_sum INT
)
BEGIN
    SELECT SUM(c.fees)
    INTO p_sum
    FROM course c
    JOIN course_track ct
        ON c.id = ct.course_id
    WHERE ct.track_id = p_trackId;
END $$

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE db = 'lms_db_2026';

-- Pass track ID = 2 and receive the result in @sum
CALL sum_course_fee_by_track_id(2, @sum);

-- Display the output variable
SELECT @sum AS total_course_fee;


-- =====================================================
-- 4. STORED PROCEDURE WITH INOUT PARAMETER
-- Receive track ID and replace it with the total course fee
-- =====================================================

DROP PROCEDURE IF EXISTS sum_course_fee_by_track_id_inout;

DELIMITER $$

CREATE PROCEDURE sum_course_fee_by_track_id_inout(
    INOUT p_val INT
)
BEGIN
    SELECT SUM(c.fees)
    INTO p_val
    FROM course c
    JOIN course_track ct
        ON c.id = ct.course_id
    WHERE ct.track_id = p_val;
END $$

DELIMITER ;

-- Assign initial track ID
SET @val = 2;

-- Pass the variable into the procedure
CALL sum_course_fee_by_track_id_inout(@val);

-- Display the modified value
SELECT @val AS total_course_fee;

