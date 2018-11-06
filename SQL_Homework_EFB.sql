-- this is the database being used for code below --
use sakila;
-- homework 1a and 1b , select, convert to uppcase, and join first and last names --
select upper(concat(first_name,' ',last_name)) as Actor_Name
from actor;

-- homework 2a  find actor with name Joe
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- homework 2b find all actors with last name contains GEN
select actor_id, first_name, last_name from actor
where last_name like '%GEN%';

-- homework 2c find all actors with last name contains letters "LI" order rows by last name and first name 
select actor_id, first_name, last_name from actor
where last_name like '%LI%'
order by last_name, first_name;

-- homework 2d display country id and country for three countries 
select country_id, country from country
where country in ('Afghanistan','Bangladesh','China');



