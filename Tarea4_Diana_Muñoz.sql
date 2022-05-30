--Esta tarea fue hecha en conjunto con Ruben, Adaya, Mariel y yo.

--Una aplicación frecuente de Ciencia de Datos aplicada a la industria del microlending es el de calificaciones crediticias
--(credit scoring). Puede interpretarse de muchas formas: propensión a pago, probabilidad de default, etc. La intuición nos 
--dice que las variables más importantes son el saldo o monto del crédito, y la puntualidad del pago; sin embargo, otra 
--variable que frecuentemente escapa a los analistas es el tiempo entre cada pago. La puntualidad es una pésima variable 
--para anticipar default o inferir capacidad de pago de micropréstamos, por su misma naturaleza. Si deseamos examinar la 
--viabilidad de un producto de crédito para nuestras videorental stores:

CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;

--1. Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
set intervalstyle = 'postgres_verbose';
select c.first_name||' '||c.last_name  as customer, (max(p.payment_date) - min(p.payment_date))/(count(*)) as tiempo_promedio_entre_pagos 
from payment p join customer c using(customer_id)
group by  customer_id 
order by tiempo_promedio_pagos ;

--2. Sigue una distribución normal?
select extract(epoch from (max(p.payment_date) - min(p.payment_date))/(count(*)) ) as tiempo_promedio_int
from payment p 
group by customer_id ;

select *
from histogram('(select extract(epoch from (max(p.payment_date) - min(p.payment_date))/(count(*)) ) as tiempo_promedio
from payment p 
group by customer_id
order by tiempo_promedio) as x', 'tiempo_promedio');

--No, no es una distribución

--3. Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
set intervalstyle = 'postgres_verbose';
select c.first_name||' '||c.last_name  as customer, (max(r.rental_date) - min(r.rental_date))/(count(*)) as tiempo_promedio_rentas,  (max(p.payment_date) - min(p.payment_date))/(count(*)) as tiempo_promedio_pagos, (max(r.rental_date) - min(r.rental_date))/(count(*)) - (max(p.payment_date) - min(p.payment_date))/(count(*)) as diferencia
from payment p join customer c using(customer_id) join rental r using(customer_id)
group by  customer_id 
order by tiempo_promedio_rentas;

