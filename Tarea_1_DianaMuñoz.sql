--DIANA MUÑOZ
--
--			EJERCICIOS DE TAREA 1 QUERIES			--
--
--¿Qué contactos de proveedores tiene la posición de sales representative?
select s.contact_name as sales_representative from suppliers s where s.contact_title = 'Sales Representative';

--¿Qué contactos de proveedores no son marketing managers?
select s.contact_name as marketing_manager from suppliers s where s.contact_title != 'Marketing Manager';

--¿Cuáles ordenes no vienen de clientes de Estados Unidos?*** con join
select o.order_id,  c.country as pais_cliente from orders o, customers c
where c.country != 'USA';

--¿Qué productos de los que transportamos son quesos? 
--Solo los que se están transportando, distinct elimina repetidos
select distinct p.product_id, p.product_name as quesos from categories c 
join products p using (category_id) 
join order_details od using (product_id)
join orders o using (order_id) where shipped_date is not null 
and c.description = 'Cheeses';

--¿Qué ordenes van a Bélgica o Francia?
select o.order_id, o.ship_country as ordenes_a_Belgica_o_Francia from orders o 
where (o.ship_country = 'France' or o.ship_country = 'Belgium') and shipped_date is null ;

--¿Qué ordenes van a LATAM?
select o.order_id, o.ship_country as ordenes_a_LATAM from orders o where o.ship_country 
in ('Mexico','Argentina','Brazil','Venezuela') and shipped_date is null;

--¿Qué ordenes NO van a LATAM?
select o.order_id, o.ship_country as ordenes_no_LATAM from orders o where o.ship_country 
not in ('Mexico','Argentina','Brazil','Venezuela') and shipped_date is null;

--Necesitamos los nombre completos de los empleados, nombres y apellidos unidos en un mismo registro***
select concat(e.first_name, ' ', e.last_name) as nombre_clientes  from employees e;

--¿Cuánta lana tenemos en el inventario?
select sum(p.unit_price*p.units_in_stock) as dinero_inventario from products p where p.units_in_stock != 0;

--¿Cúantos clientes tenemos de cada país?***group by
select c.country, count(c.contact_name)  from customers c group by c.country;
--select c.country  from customers c;

--			EJERCICIOS DE TAREA 1 CONTINUACIÓN		--

--Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.
select e.first_name nombres, e.last_name apellidos, age(e.birth_date) edad_exacta  
from employees e;

--¿Cuál es la orden más reciente por cliente? 
--Orden más reciente por cliente 
select c.contact_name, max(o.order_date) 
from orders o join customers c on (c.customer_id = o.customer_id)
group by c.contact_name;  

--¿De nuestros clientes, qué función desempeñan y cuántos son? 
select c.contact_title posición , count(c.contact_title) total 
from customers c
group by c.contact_title
order by conteo desc;

--¿Cuántos productos tenemos de cada categoría? 
select c.category_name, count(p.category_id)
from products p join categories c on(c.category_id = p.category_id)
group by p.category_id, c.category_name
order by p.category_id asc;

--¿Cómo podemos generar el reporte de reorder? 
select reorder_level,  product_name, product_id, units_in_stock 
from products p order by reorder_level desc;

--¿A donde va nuestro envío más voluminoso?
select od.quantity, o.ship_country 
from order_details od join orders o on (od.order_id = o.order_id)
order by od.quantity desc limit 1;

--¿Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
--Lo hice con el criterio de cuanto unidades de producto pide
select o.customer_id, sum(od.quantity) as unidades_totales,
CASE
    WHEN sum(od.quantity) > 500000 THEN 'bueno'
    WHEN sum(od.quantity) < 200000 THEN 'malo'
    else 'regular'
end as calificacion
from order_details od, orders o group by o.customer_id 
order by unidades_totales desc;

--¿Qué colaboradores chambearon durante las fiestas de navidad?
select e.first_name, e.last_name, e.employee_id
from orders o join employees e on (o.employee_id = e.employee_id)
where (extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25)
or (extract(month from o.order_date) = 12 and extract(day from o.order_date) = 25) group by e.employee_id ;

--¿Qué productos mandamos en navidad?
select p.product_name from products p 
join order_details od on (p.product_id = od.product_id) 
join orders o on (od.order_id = o.order_id)
where extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25;

--¿Qué país recibe el mayor volumen de producto?
select o.ship_country , sum(od.quantity) as suma_productos
from orders o join order_details od on o.order_id = od.order_id
group by o.ship_country
order by suma_productos desc limit 1;
