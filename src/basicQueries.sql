/* VERY Basic Queries  */

/* 1) List all movies with rating of PG-13*/
select *
from film
where rating = 'PG-13'

/* 2) Find all actors with a last name starting with 'C'. */
select *
from actor
where last_name like 'C%'

/* 3) Count the number of films in each rating category */
select rating, count(*)
from film
group by film.rating;



