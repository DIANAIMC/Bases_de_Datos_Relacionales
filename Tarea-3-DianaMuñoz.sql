--CÓMO OBTENEMOS TODOS LOS NOMBRES Y CORREOS DE NUESTROS CLIENTES CANADIENSES PARA 
--UNA CAMPAÑA?
--Solución con where
select c.first_name || ' ' || c.last_name as nombres, c.email correos, c3.country pais
from customer c join address a using (address_id)
join city c2 using (city_id)
join country c3 using (country_id)
where c3.country = 'Canada'
order by 1 asc;
--Solución con group by y having
select c.first_name || ' ' || c.last_name as nombres, c.email correos, c3.country pais
from customer c join address a using (address_id)
join city c2 using (city_id)
join country c3 using (country_id)
group by c.customer_id, c3.country_id 
having c3.country = 'Canada'
order by 1 asc;

--¿QUÉ CLIENTE HA RENTADO MÁS DE NUESTRA SECCIÓN DE ADULTOS? *Hacerlo con max
--POR UNIDADES
--Usando where
select c.first_name || ' ' || c.last_name full_name, count(r.customer_id)
from film f join inventory i using(film_id) 
join rental r using(inventory_id)
join customer c using(customer_id)
where f.rating = 'NC-17'
group by c.customer_id 
order by 2 desc
limit 1;
--Usando having
select c.first_name || ' ' || c.last_name nombre, count(r.customer_id) as total
from film f join inventory i using(film_id) 
join rental r using(inventory_id)
join customer c using(customer_id)
group by c.customer_id, f.rating  
having f.rating = 'NC-17'
order by 2 desc
limit 1;

--*NOTA: Al usar estas 2 formas salieron 2 personas diferentes, resulta que hay 2 personas que han rentado
--el mismo número de películas y ese es el máximo, por tanto, cualquier respuesta estaría bien.

--POR TOTAL EN $$
select c.first_name || ' ' || c.last_name nombre, sum(p.amount) as total
from film f join inventory i using(film_id) 
join rental r using(inventory_id)
join customer c using(customer_id)
join payment p using (customer_id)
where f.rating = 'NC-17'
group by c.customer_id 
order by 2 desc
limit 1;

--¿QUÉ PELÍCULAS SON LAS MÁS RENTADAS EN TODAS NUESTRAS STORES?
--*NOTA: Aunque sean 2 tiendas es más fácil identificar a la tienda por pais que por id
select distinct on (s.store_id) s.store_id tienda, c2.country pais, f.title pelicula, count(f.film_id) as total 
from film f join inventory i using(film_id)
join rental r using(inventory_id)
join store s using (store_id)
join address a using (address_id)
join city c using (city_id)
join country c2 using (country_id)
group by s.store_id, c2.country_id, f.film_id
order by 1,4 desc;

--¿CUÁL ES NUESTRO REVENUE POR STORE?
--*NOTA: Aunque sean 2 tiendas es más fácil identificar a la tienda por pais que por id
select i.store_id tienda, c2.country pais, sum(p.amount)
from inventory i join rental r using(inventory_id)
join payment p using(rental_id)
join store s using (store_id)
join address a using (address_id)
join city c using (city_id)
join country c2 using (country_id)
group by i.store_id, c2.country 
order by 1 asc;
