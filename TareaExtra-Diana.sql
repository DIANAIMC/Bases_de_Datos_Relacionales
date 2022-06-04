--Una de las métricas para saber si un cliente es bueno, aparte de la suma y el promedio de sus pagos, es si tenemos 
--una progresión consistentemente creciente en los montos.

--Debemos calcular para cada cliente su promedio mensual de deltas en los pagos de sus órdenes en la tabla 
--order_details en la BD de Northwind, es decir, la diferencia entre el monto total de una orden en tiempo t 
--y el anterior en t-1, para tener la foto completa sobre el customer lifetime value de cada miembro de nuestra
-- cartera.

--Obtenemos los pagos de los clientes
with pagos as (  
	select c.company_name, o.customer_id, o.order_date as fecha, sum(od.quantity*od.unit_price*(1 - od.discount)) :: numeric as pago_t
	from order_details od join orders o using (order_id)
	join customers c using (customer_id)
	group by c.company_name, o.customer_id, fecha
	order by 1,3
), 
--Obtenemos la diferencia de los pagos usando window functions 
deltas as ( 
	select *, lag(p.pago_t, 1, 0.0) over w as pago_tmenos1, p.pago_t - lag(p.pago_t, 1, 0.0) over w as delta
	from pagos p
	window w as (partition by p.customer_id)
)
--Agrupamos las deltas por cliente, año y mes, sacamos el promedio de las delta en el mes
select d.company_name as nombre_empresa, extract(year from d.fecha) as año, extract(month from d.fecha) as mes, avg(d.delta) as promedio_mes_deltas
from deltas d
group by d.company_name, extract(year from d.fecha), extract(month from d.fecha)
order by 1,2,3;
