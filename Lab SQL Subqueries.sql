-- Lab | SQL Subqueries
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select b.title, count(a.inventory_id) as 'Nº of copies' from sakila.inventory a
left join sakila.film b on a.film_id=b.film_id
where b.title = "Hunchback Impossible"
group by a.film_id;

-- 2. List all films whose length is longer than the average of all the films.
select avg(length) from sakila.film;

select title, length from sakila.film
where length>(
select avg(length) from sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select c.first_name, c.last_name from sakila.film_actor a
left join sakila.film b on a.film_id = b.film_id
join sakila.actor c on a.actor_id=c.actor_id
where b.title = "Alone Trip";

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select category_id from sakila.category
where name="Family";

select a.title from sakila.film a
right join sakila.film_category b on a.film_id = b.film_id
where b.category_id in (
select category_id from sakila.category
where name="Family");

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, last_name, email from sakila.customer
where address_id in (
select address_id from sakila.address
where city_id in (
select city_id from sakila.city
where country_id in (
select country_id from sakila.country
where country = "Canada"
)
)
);

select a.first_name, a.last_name, a.email from sakila.customer a
join sakila.address b on a.address_id = b.address_id
join sakila.city c on b.city_id=c.city_id
join sakila.country d on c.country_id=d.country_id
where d.country="Canada";

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select first_name, last_name from sakila.actor
where actor_id in (
select id_actor from (
select b.actor_id as id_actor, count(b.film_id) as films_starred from sakila.film a
left join sakila.film_actor b on a.film_id=b.film_id
left join sakila.actor c on b.actor_id=c.actor_id
group by b.actor_id
order by films_starred desc
limit 1) sub1
);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.
select first_name, last_name from sakila.customer
where customer_id in (
select id from
(
select a.customer_id as id, sum(b.amount) as sum_of_payments 
from sakila.customer as a
left join sakila.payment as b on a.customer_id=b.customer_id
group by a.customer_id
order by sum_of_payments desc
limit 1
) sub1
);


-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select avg(amount) as avg_payment from sakila.payment;

select a.first_name, a.last_name, b.amount from sakila.customer as a
left join sakila.payment as b on a.customer_id=b.customer_id;

select a.first_name, a.last_name, b.amount from sakila.customer as a
left join sakila.payment as b on a.customer_id=b.customer_id
where b.amount > (
select avg(amount) as avg_payment from sakila.payment
)
order by b.amount;



