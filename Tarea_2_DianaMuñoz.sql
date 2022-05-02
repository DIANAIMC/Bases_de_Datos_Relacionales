
create table superhero (
  id_superhero numeric(4,0) constraint pk_superhero primary key,
  name_superhero varchar(100) NOT NULL ,
  mail_superhero varchar(100) NOT NULL 
 );

--
CREATE SEQUENCE superhero_id_superhero_seq START 1 INCREMENT 1 ;
ALTER TABLE superhero ALTER COLUMN id_superhero SET DEFAULT nextval('superhero_id_superhero_seq');
--

INSERT INTO superhero
(name_superhero, mail_superhero)
VALUES
	('Wanda Maximoff','wanda.maximoff@avengers.org'),
	('Pietro Maximoff','pietro@mail.sokovia.ru'),
	('Erik Lensherr','fuck_you_charles@brotherhood.of.evil.mutants.space'),
	('Charles Xavier','i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
	('Anthony Edward Stark','iamironman@avengers.gov'),
	('Steve Rogers','americas_ass@anti_avengers'),
	('The Vision','vis@westview.sword.gov'),
	('Clint Barton','bul@lse.ye'),
	('Natasja Romanov','blackwidow@kgb.ru'),
	('Thor','god_of_thunder-^_^@royalty.asgard.gov'),
	('Logan','wolverine@cyclops_is_a_jerk.com'),
	('Ororo Monroe','ororo@weather.co'),
	('Scott Summers','o@x'),
	('Nathan Summers','cable@xfact.or'),
	('Groot','iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
	('Nebula','idonthaveelektras@complex.thanos'),
	('Gamora','thefiercestwomaninthegalaxy@thanos.'),
	('Rocket','shhhhhhhh@darknet.ru');
	
--Emails validos:
--  (Utilicé cómo criterio aquellos emails que estaban en azul en github)
--	Deben tener arroba y esta no puede estar al inicio
--	No pueden terminar con punto '.', pero debe ten al menos uno despues del '@''
--	No admiten '^'
select s.name_superhero superheroe, s.mail_superhero email_valido
from superhero s
where s.mail_superhero like '%@%._%' 
and s.mail_superhero not like '%@%.' 
and s.mail_superhero not like '%^%'
order by s.id_superhero asc;

-- PARA 0.2 EXTRA --

--El query debe regresar de la tabla superheroes_years_service, lo siguiente:
--	nombre del superhéroe
--	lista separada por comas de los grupos o equipos en donde sirvió
--	total de años de servicio en todos los grupos

create table superheroes_years_service (
  id_superheroes_years_service numeric(4,0) constraint pk_superheroes_years_service primary key,
  name_superhero varchar(100) NOT NULL,
  team_superhero varchar(100) NOT NULL,
  years_service numeric(4,0) NOT NULL 
 );

--
CREATE SEQUENCE superheroes_years_service_id_superheroes_years_service_seq START 1 INCREMENT 1 ;
ALTER TABLE superheroes_years_service ALTER COLUMN id_superheroes_years_service
SET DEFAULT nextval('superheroes_years_service_id_superheroes_years_service_seq');
--

INSERT INTO superheroes_years_service
(name_superhero, team_superhero, years_service)
VALUES
	('Tony Stark','Avengers', 10),
	('Wanda Maximoff','Avengers', 5),
	('Wanda Maximoff','X Men', 3),
	('Erik Lensherr','Acolytes', 10),
	('Erik Lensherr','Brotherhood of Evil Mutants', 12),
	('Natasja Romanov','KGB', 8),
	('Natasja Romanov','Avengers', 10);

select s.name_superhero nombre, 
string_agg(s.team_superhero,', ') as equipos, 
sum(s.years_service) as total_años_servicio
from superheroes_years_service s 
group by s.name_superhero order by sum(s.years_service) desc;

