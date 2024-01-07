/* Queries using Aggregation */

/* 1) Find the total amount of payments received by each staff member. */

select p.staff_id, sum(amount) "total receive"
from payment p
group by p.staff_id;

/* 2) Calculate the average rental duration for all films. */
select avg(r.return_date - r.rental_date) as "Average Dureation"
from rental r
WHERE r.return_date IS NOT NULL;;

/* 3) Identify the most popular film category among customers in a certain city. Use city=Ibirit*/
select cat.name, count(cat.name) as rental_count
from rental r
         join inventory i using (inventory_id)
         join film f using (film_id)
         join film_category fc using (film_id)
         join category cat using (category_id)
         join customer cust on r.customer_id = cust.customer_id
         join address a on cust.address_id = a.address_id
         join city on a.city_id = city.city_id
where city = 'Ibirit'
group by cat.name
order by rental_count desc
limit 1;

