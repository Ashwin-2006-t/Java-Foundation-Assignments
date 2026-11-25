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