-- COMP3311 23T3 Assignment 1
--
-- Fill in the gaps ("...") below with your code
-- You can add any auxiliary views/function that you like
-- but they must be defined in this file *before* their first use
-- The code in this file *MUST* load into an empty database in one pass
-- It will be tested as follows:
-- createdb test; psql test -f ass1.dump; psql test -f ass1.sql
-- Make sure it can load without error under these conditions

-- Put any views/functions that might be useful in multiple questions here



---- Q1

create or replace view q1 as
select region as state,
       count(*) as nbreweries
from breweries
inner join locations on locations.id = breweries.located_in
where locations.country = 'Australia'
group by region; 

---- Q2

create or replace view q2 as
select name as style,
       min_abv,
       max_abv
from styles
where max_abv - min_abv = (select max(max_abv - min_abv) from styles);

---- Q3

create or replace view q3 as
select styles.name as style,
       min(abv) as lo_abv,
       max(abv) as hi_abv,
       min_abv,
       max_abv
from beers
inner join styles on beers.style = styles.id
group by styles.name, styles.min_abv, styles.max_abv
having (min(abv) < min_abv or max(abv) > max_abv) and min_abv != max_abv;

---- Q4

create or replace view q4 as
select breweries.name as brewery,
       avg(beers.rating)::numeric(3, 1) as rating,
from beers
inner join brewed_by on beers.id = brewed_by.beer
inner join breweries on brewed_by.brewery = breweries.id
where beers.rating is not null
group by breweries.name
having count(beers.id) >= 5;

create or replace view qq4 as
select breweries.name as brewery
from (
	select brewed_by.beer as beer, avg(
	from brewed_by
    )
    inner join beers
    where beers.rating is not null
)


---- Q5

create or replace function q5(pattern text)
returns table(beer text, container text, std_drinks numeric(3, 1)) as $$
    select beers.name,
           beers.volume || 'ml ' || beers.sold_in as container,
           (beers.volume * beers.abv * 0.0008)::numeric(3, 1) as std_drinks
    from beers
    where beers.name ilike '%' || pattern || '%';
$$ language sql;

---- Q6
--
--create or replace function
--    Q6(...) returns ...
--as $$
--...
--$$
--language sql ;
--
---- Q7
--
--create or replace function
--    Q7(...) returns ...
--as $$
--...
--$$
--language plpgsql ;
--
---- Q8
--
--create or replace function
--    Q8(...) returns ...
--as $$
--...
--$$
--language plpgsql ;
--
---- Q9
--
--create or replace function
--    Q9(...) returns ...
--as $$
--...
--$$
--language plpgsql ;
--
