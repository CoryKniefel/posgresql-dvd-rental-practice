/* Queries using Subqueries and Common Table Expressions (CTEs) */

/* Find the movies that have never been rented out.
   The benefit of this approach is that this subquery doesn't include inventory items that have not been rented,
   primarily because it uses an inner join.
   If a subquery isn't used and only left joins were used to join film, inventory, rental, then use a null check
   on rental.rental_id, then for inventory items that were never rented would be included. It's possible to have
   5 copies of the same film in inventory and have 1 or more that has not been rented.
   */
select f.title
from film f
where f.film_id not in (select distinct i.film_id
                        from rental r
                                 join inventory i on r.inventory_id = i.inventory_id);


/* List customers who have spent more than the average expenditure on rentals. */
-- Using aggregation in having clause.
select c.last_name, avg(p.amount) as average_payment
from payment p
         join customer c on p.customer_id = c.customer_id
group by c.last_name
having avg(p.amount) > (select avg(p.amount) from payment p);

-- using CTE
with CustomerAverage as (select c.last_name, c.customer_id, avg(p.amount) as average_payment
                         from payment p
                                  join customer c on p.customer_id = c.customer_id
                         group by c.last_name, c.customer_id)
select last_name, average_payment
from CustomerAverage
where average_payment > (select avg(payment.amount) from payment)
order by last_name;


/* Determine the top 5 most frequently rented films.*/
with FilmRentalCounts as (
    select film.title, count(rental.inventory_id) as rental_count from rental
             join inventory using(inventory_id)
             join film using(film_id)
    group by film.title
)
select * from FilmRentalCounts
order by rental_count desc
limit 5;
