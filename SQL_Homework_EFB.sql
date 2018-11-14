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

/** homework 2c find all actors with last name contains letters "LI" order
 rows by last name and first name**/
select actor_id, first_name, last_name from actor
where last_name like '%LI%'
order by last_name, first_name;

-- homework 2d display country id and country for three countries 
select country_id, country from country
where country in ('Afghanistan','Bangladesh','China');

-- homework 3a create column for actor description, type BLOB
alter table actor
add column description blob;

-- homework 3b delete the description column
alter table actor
drop column description;

-- homework 4a List last names of actors and how many have the last name
select last_name, count(*) 
from actor
group by last_name;

-- homework 4b List last name of actors and how many have the last name having count >= 2
select last_name, count(*) as 'Total Actors'
from actor
group by last_name
having count(*) >=2;

-- homework 4c Correct actor harpo williams to groucho williams in actor table
select * from actor
where last_name = "WILLIAMS";

update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";


-- homework 4d 
update actor
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "WILLIAMS";

select * from actor
where last_name = "WILLIAMS";

-- homework 5a Which query can be used to recreate the schema of the address table?
show create table address;  -- be sure to toggle 'wrap cell content' to view the schema
-- You can also see the schema by looking in the information view of MySQL Workbench

-- homework 6a Use Join to display first and last names, address or each staff member
select * from staff;

select staff.first_name,
		staff.last_name,
        address.address,
        address.address2,
        address.district,
        address.city_id,
        address.postal_code
from staff
join address on
address.address_id = staff.address_id;

-- homework 6b Use join to display the total amount rung up by each staff memeber in August 2005

select staff.first_name,
		staff.last_name,
        sum(payment.amount) as 'Total Payments'
from staff
join payment on payment.staff_id = staff.staff_id
where payment.payment_date between "2005-08-01" and "2005-08-31"
group by first_name,last_name;

-- homework 6c Use inner join to display each film and the number of actors listed for each film.  
select film.film_id,
		film.title,
		count(film_actor.actor_id) as "Number of Actors"
from film
inner join film_actor on film.film_id = film_actor.film_id
group by film.film_id;

-- homework 6d How many copies of the film Hunchback Impossible are there in the inventory system? 
select film.film_id,
		film.title,
		count(inventory.film_id) as "Number of Copies"
from film
inner join inventory on film.film_id = inventory.film_id
where film.title = "Hunchback Impossible";

-- homework 6e Join payment, customer, List the total paid by each customer, list alphabetically by last name
select customer.last_name,
		customer.first_name,
        sum(payment.amount) as 'Total Payments'
from customer
join payment on payment.customer_id = customer.customer_id
group by last_name,first_name;

/** 7a. Use subqueries to display the titles of movies starting with the letters 
K and Q whose language is English.**/

select film.title
from film
where film.title like "K%" or film.title like "Q%" and
        language_id in
( select language_id
from language
where language.name = "English") ;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip. --
select actor.first_name,
		actor.last_name
from actor
where actor_id in
	(select actor_id
	from film_actor 
	where film_id in
		(select film_id
		from film
		where title = "Alone Trip"));

/** 7c. You want to run an email marketing campaign in Canada, for which you will need 
the names and email addresses of all Canadian customers. Use joins to retrieve this information.  **/
select customer.first_name,
		customer.last_name,
        customer.email,
        country.country
from customer
join address on address.address_id = customer.address_id
join city on city.city_id = address.address_id
join country on country.country_id = city.country_id
where country.country = "Canada";

/** 7d. Sales have been lagging among young families, and you wish to target all family movies 
for a promotion. Identify all movies categorized as family films. **/
Select * from category;

select film.title,
	   film.rating
from film
where film_id in
	(select film_id
	from film_category
	where category_id in
		(select category_id
		from category 
		where name = 'Family'));
-- Note to self:  Category and rating pairings do not make sense.
-- You can have an R rated film that has a "Family" category.

-- 7e. Display the most frequently rented movies in descending order. --

select film.title,rental.inventory_id, count(*) as num_rentals
from rental
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.inventory_id
group by inventory_id
order by num_rentals desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in. 
select store.store_id, sum(payment.amount) as Revenue
from payment
join staff on payment.staff_id = staff.staff_id
join store on store.store_id = staff.store_id
group by store_id;


/** 7g. Write a query to display for each store its store ID, city, and country. **/
select store.store_id, city.city, country.country
from store
join address on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;

/** 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category,
film_category, inventory, payment, and rental.)**/

select category.name, sum(payment.amount) as Revenue
from payment
join rental on payment.rental_id = rental.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
Limit 5;



/**8a. In your new role as an executive, you would like to have an easy way of viewing
 the Top five genres by gross revenue. Use the solution from the problem above to 
 create a view. If you haven't solved 7h, you can substitute another query to create a view.**/
create view Top_Five_Genres_By_GR
as 
select category.name, sum(payment.amount) as Revenue
from payment
join rental on payment.rental_id = rental.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
Limit 5;

/**8b. How would you display the view that you created in 8a?**/

select * from Top_Five_Genres_By_GR;

/**8c. You find that you no longer need the view top_five_genres. Write a query to delete it.**/
drop view if exists Top_Five_Genres_By_GR;



