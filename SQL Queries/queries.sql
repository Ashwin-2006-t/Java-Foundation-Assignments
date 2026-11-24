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
values ("Harry Potter",2, 1 ,1);

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

