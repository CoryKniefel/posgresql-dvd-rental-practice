/* Queries using Basic Join Operations */

/* 1) Display the first and last names of customers along with the titles of movies they have rented. */
select first_name || ' ' || last_name "Full Name", f.title
from customer as c
         inner join rental r using (customer_id)
         inner join inventory i on r.inventory_id = i.inventory_id
         inner join film f on i.film_id = f.film_id;

/* 2) List movies along with the names of their actors (you'll need to join at least three tables here). */

select f.title, a.first_name || ' ' || a.last_name "Actor Full Name", COUNT(a.actor_id) as "Number of Actors"
from film f
         join film_actor fm on f.film_id = fm.film_id
         join actor a on fm.actor_id = a.actor_id;

/* 3) Show all films that were rented in May 2005. */
select distinct f.title
from film f
         join inventory i on f.film_id = i.inventory_id
where i.inventory_id in (select r.inventory_id
                         from rental r
                         where r.rental_date > '2005-05-01'
                           and r.rental_date < '2005-06-01')
order by f.title;








