/* Identify customers who have rented the same movie more than once, and include their addresses */
-- Use a CTE to do the heavy lifting of finding the customers that have duplicate rentals of the same film
-- One benefit of writing the query this way is that it separates the logic of finding relevant customers from looking up their address
-- Another potential benefit is it may be more efficient to run the query this way, as adding the address column would increase the granularity of the grouping
with CustomersWithDuplicateFilmRentals as (select c.first_name || ' ' || c.last_name as full_name,
                                                  c.customer_id,
                                                  f.film_id,
                                                  f.title,
                                                  count(f.film_id)
                                           from customer c
                                                    join rental r using (customer_id)
                                                    join inventory i on r.inventory_id = i.inventory_id
                                                    join film f on i.film_id = f.film_id
                                           group by full_name, c.customer_id, f.film_id, f.title
                                           having count(f.film_id) > 1)
select cdfr.full_name, cdfr.title, cdfr.customer_id, city.city, country.country
from CustomersWithDuplicateFilmRentals as cdfr
-- now join in the address related tables
         join customer c on cdfr.customer_id = c.customer_id
         join address add on c.address_id = add.address_id
         join city on add.city_id = city.city_id
         join country on city.country_id = country.country_id;

-- Another option is to use a subquery rather than a CTE. I like the CTE better.

select cdfr.full_name, cdfr.title, cdfr.customer_id, city.city, country.country
from (select c.first_name || ' ' || c.last_name as full_name,
             c.customer_id,
             f.film_id,
             f.title,
             count(f.film_id)
      from customer c
               join rental r using (customer_id)
               join inventory i on r.inventory_id = i.inventory_id
               join film f on i.film_id = f.film_id
      group by full_name, c.customer_id, f.film_id, f.title
      having count(f.film_id) > 1) as cdfr
         join customer c on cdfr.customer_id = c.customer_id
         join address add on c.address_id = add.address_id
         join city on add.city_id = city.city_id
         join country on city.country_id = country.country_id;
