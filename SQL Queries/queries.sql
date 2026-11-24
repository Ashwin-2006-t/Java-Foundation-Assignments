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