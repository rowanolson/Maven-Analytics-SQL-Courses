/*
CASE STATEMENT
Pull a list of first and last names of all customers and label them based on store id and active status
*/
select 
store_id,
active,
case 
	when store_id = 1 AND active = 1 then 'store_1_active'
    when store_id = 1 AND active = 0 then 'store_1_inactive'
    when store_id = 2 AND active = 1 then 'store_2_active'
    when store_id = 2 AND active = 0 then 'store_2_inactive'
    else 'error'
end as store_and_status
from mavenmovies.customer;

/*
COUNT AND CASE
Create a table to count the number of customers broken down by store_id and active status
*/
select 
	store_id,
	count(case when active = 1 then customer_id else null end) as count_active,
	count(case when active = 0 then customer_id else null end) as count_inactive
from mavenmovies.customer
group by 1;

/*
"Bridging" Tables
List all actors with each title that they appear in
*/
use mavenmovies;
select 
	a.first_name, 
    a.last_name, 
    f.title
from actor as a
inner join film_actor as fa 
	on a.actor_id = fa.actor_id
inner join film as f
	on fa.film_id = f.film_id;
    
/*
Multi-Condition Joins
Pull a list of distinct titles and their descriptions, currently available at store 2
(without using where clause)
*/
use mavenmovies;
select distinct 
	film.title, 
	film.description, 
    inventory.store_id
from film
	inner join inventory
		on film.film_id = inventory.film_id
		and inventory.store_id = 2;
    
/*
UNION
Pull a list of all staff and advisor names and specify
*/
select
	'staff' as type,
    first_name,
    last_name
from staff
UNION
select
	'advisor' as type,
    first_name,
    last_name
from advisor;


# MySQL Data Analysis Maven Analytics 

# SINGLE TABLE QUERIES MID COURSE PROJECT
/* 1
We will need a list of all staff members, including their first and last names, email addresses, and the store
identification number where they work.
*/
select staff_id, first_name, last_name, email, store_id
from mavenmovies.staff;

/* 2
We will need a count of active customers for each of your stores. Separately, please.
*/
select 
	store_id,
	count(case when active = 1 then customer_id else null end) as count_active
from mavenmovies.customer
group by store_id;

/* 3
We will need separate counts of inventory items held at each of your two stores.
*/
select 
	store_id,
    count(inventory_id) as count_inventory
from mavenmovies.inventory
group by store_id;

/* 4
In order to assess the liability of a data breach, we will need you to provide a count of all customer email
addresses stored in the database.
*/
select 
	count(email) as count_email
from mavenmovies.customer;

/* 5
We are interested in how diverse your film offering is as a means of understanding how likely you are to
keep customers engaged in the future. Please provide a count of unique film titles you have in inventory at
each store and then provide a count of the unique categories of films you provide.
*/
select 
	store_id,
    count(distinct(film_id)) as unique_film_titles
from mavenmovies.inventory
group by store_id;

select
	count(distinct(category_id)) as unique_categories
from mavenmovies.category;

/* 6
We are interested in having you put payment monitoring systems and maximum payment processing
restrictions in place in order to minimize the future risk of fraud by your staff. Please provide the average
payment you process, as well as the maximum payment you have processed.
*/
select max(amount) as max_payment, avg(amount) as avg_payment
from mavenmovies.payment;

/* 7
We would like to understand the replacement cost of your films. Please provide the replacement cost for the
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry.
*/
select 
	min(replacement_cost) as min_replacement, 
	max(replacement_cost) as max_replacement, 
    avg(replacement_cost) as avg_replacement
from mavenmovies.film;

/* 8
We would like to better understand what your customer base looks like. Please provide a list of all customer
identification values, with a count of rentals they have made all-time, with your highest volume customers at
the top of the list.
*/
select 
	customer_id,
    count(rental_id) as count_rental
from mavenmovies.rental
group by 1
order by count_rental desc;

# FINAL COURSE PROJECT
/* 1 
My partner and I want to come by each of the stores in person and meet the managers. Please send over
the managers’ names at each store, with the full address of each property (street address, district, city, and
country please).
*/
use mavenmovies;
select
	store.manager_staff_id,
    staff.first_name,
    staff.last_name,
	a.address,
    a.district,
    city.city,
    country.country
from store 
	left join staff	on store.manager_staff_id = staff.staff_id
    left join address a on store.address_id = a.address_id
    left join city on a.city_id = city.city_id
	left join country on city.country_id = country.country_id;

/* 2 
I would like to get a better understanding of all of the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked, including the store_id number, the
inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost.
*/
use mavenmovies;
select
	i.store_id,
    i.inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
from film f
left join inventory i
	on f.film_id = i.film_id;

/* 3
From the same list of films you just pulled, please roll that data up and provide a summary level overview of
your inventory. We would like to know how many inventory items you have with each rating at each store.
*/
use mavenmovies;
select
	i.store_id,
    f.rating,
    count(i.inventory_id) as amount
from inventory i
left join film f
	on i.film_id = f.film_id
group by 1,2
order by 1,2;
    
/* 4
Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement
cost, sliced by store and film category. 
*/
use mavenmovies;
select
	c.name as category,
	count(fc.category_id) as number_of_films,
    avg(f.replacement_cost) as avg_replacement_cost,
    sum(f.replacement_cost) as total_replacement_cost
from inventory i
	left join film f on i.film_id = f.film_id
	left join film_category fc on f.film_id = fc.film_id
	left join category c on fc.category_id = c.category_id
group by 1
order by 4 desc;

/* 5
We want to make sure you folks have a good handle on who your customers are. Please provide a list
of all customer names, which store they go to, whether or not they are currently active, and their full
addresses – street address, city, and country.
*/
use mavenmovies;
select
	c.first_name,
    c.last_name,
    c.store_id,
    case 
		when c.active = 1 then 'active' 
		when c.active = 0 then 'not active' 
		else 'error' 
	end as active_status,
    a.address, 
    city.city,
    country.country
from customer c
join address a
	on c.address_id = a.address_id
left join city
	on a.city_id = city.city_id
left join country
	on city.country_id = country.country_id;
	

/* 6
My partner and I would like to get to know your board of advisors and any current investors. Could you
please provide a list of advisor and investor names in one table? Could you please note whether they are an
investor or an advisor, and for the investors, it would be good to include which company they work with.
*/
use mavenmovies;
select
	'investor' as type,
    first_name,
    last_name,
    company_name
from investor
union
select
	'advisor' as type,
    first_name,
    last_name,
    NULL
from advisor;

/* 7
We would like to understand how much your customers are spending with you, and also to know who your
most valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the
sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value,
with the most valuable customers at the top of the list.
*/
use mavenmovies;
select
	c.first_name,
    c.last_name,
    count(r.rental_id) as total_lifetime_rentals,
    sum(p.amount) as total_payments
from customer c
	left join rental r on c.customer_id = r.customer_id
	left join payment p on r.rental_id = p.rental_id
group by 1, 2
order by total_payments desc;

/* 8 CASE STATEMENT IN GROUP BY
We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of
awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same
questions. Finally, how about actors with just one award? 
*/
use mavenmovies;
select
	case
		when awards = 'Emmy, Oscar, Tony ' then '3 awards'
        when awards in ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then '2 awards'
        else '1 award'
	end as number_of_awards,
    avg(case when actor_id is null then 0 else 1 end) as pct_one_film
from actor_award
group by 1
