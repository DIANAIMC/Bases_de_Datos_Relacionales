--Parte de la infraestructura es diseñar contenedores cilíndricos giratorios para facilitar la colocación y 
--extracción de discos por brazos automatizados. Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que 
--el brazo pueda manipular adecuadamente cada cajita, debe estar contenida dentro de un arnés que cambia las 
--medidas a 30cm x 21cm x 8cm para un espacio total de 5040 centímetros cúbicos y un peso de 500 gr por película.

--Se nos ha encargado formular la medida de dichos cilindros de manera tal que quepan todas las copias de los
--Blu-Rays de cada uno de nuestros stores. Las medidas deben ser estándar, es decir, la misma para todas nuestras
--stores, y en cada store pueden ser instalados más de 1 de estos cilindros. Cada cilindro aguanta un peso máximo 
--de 50kg como máximo. El volúmen de un cilindro se calcula de [ésta forma.](volume of a cylinder)

--VOLUMEN DE CADA CILINDRO

with peliculas_x_cilindro as (
	select 5000/50 as peliculas
),
--Altura del cilindro, aquí suponemos que están pegadas todas las películas
altura_cilindro as (
	select 1.5*pc.peliculas as altura  from peliculas_x_cilindro pc
),
--Radio de la base del cilindro, el diametro del cilindro debe ser suficiente para almacenar la película.
--Entrarán exacto si el radio es igual a la mitad de una diagonal de una película
radio_cilindro as (
	select sqrt(power(30/2,2) + power(21/2,2)) as radio
)
 select altura, radio, pi()*power(r."radio",2)*h.altura as volumen from radio_cilindro r, altura_cilindro h;

--CILINDROS NECESARIOS PARA CADA TIENDA

--Cantidad de películas en cada tienda
with num_peliculas as (
	select s.store_id as tienda, count(i.inventory_id) as num_peliculas
 	from inventory i join store s using(store_id)
 	group by s.store_id
 ), 
--Para saber cuantos cilindros necesita cada tienda dividimos el número de películas entre 100
cilindros_x_tienda as (
	select np.tienda, ceiling(np.num_peliculas/100 :: numeric) as num_cilindros
	from num_peliculas np
)
select * 
from cilindros_x_tienda;

