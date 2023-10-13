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
group by styles.name,
         styles.min_abv,
         styles.max_abv
having (min(abv) < min_abv or max(abv) > max_abv) and min_abv != max_abv;

---- Q4

create or replace view q4 as
select breweries.name as brewery,
       avg(beers.rating)::numeric(3, 1) as rating
from beers
inner join brewed_by on beers.id = brewed_by.beer
inner join breweries on brewed_by.brewery = breweries.id
where beers.rating is not null
group by breweries.name
having count(beers.id) >= 5
order by rating desc
limit 1;

---- Q5

create or replace function q5(pattern text)
returns table(beer text, container text, std_drinks numeric) as $$
    select beers.name,
           beers.volume || 'ml ' || beers.sold_in as container,
           (beers.volume * beers.abv * 0.0008)::numeric(3, 1) as std_drinks
    from beers
    where beers.name ilike '%' || pattern || '%';
$$ language sql;

---- Q6

create or replace function q6(pattern text)
returns table(country text, first int, nbeers int, rating numeric) as $$
    select locations.country as country,
           MIN(beers.brewed) as first,
           count(*) as nbeers,
           avg(beers.rating)::numeric(3, 1) as rating
    from beers
    inner join brewed_by on brewed_by.beer = beers.id
    inner join breweries on brewed_by.brewery = breweries.id
    inner join locations on locations.id = breweries.located_in
    where locations.country ilike '%' || pattern || '%'
    group by locations.country;
$$ language sql;

---- Q7

create or replace function q7(_beerID int)
returns text as $$
declare
    beerName text;
    ingredient record;
    retval text;
begin
    select beers.name into beerName from beers where beers.id = _beerID;

    if beerName is null then
        return 'No such beer (' || _beerID || ')';
    end if;

    -- Add beer name to returning string.
    retval := '"' || beerName || '"';

    if not exists(select from contains where contains.beer = _beerID) then
        return retval || e'\n' || '  no ingredients recorded';
    end if;

    -- Add ingredient names and itype to returning string.
    retval := retval || e'\n' || '  contains:';
    for ingredient in (
        select ingredients.name, ingredients.itype
        from contains
        inner join ingredients on ingredients.id = contains.ingredient
        where contains.beer = _beerID
        order by ingredients.name
    )
    loop
        retval := retval || e'\n' || '    ' || ingredient.name || ' (' || ingredient.itype || ')';
    end loop;

    return retval;
end;
$$ language plpgsql;

---- Q8

drop type if exists BeerHops cascade;
create type BeerHops as (beer text, brewery text, hops text);

create or replace function q8(pattern text)
returns setof BeerHops as $$
declare
    beer record;
    beer_hops BeerHops;
    prev_id int;
begin
    for beer in (
        select beers.name as beer,
               string_agg(distinct breweries.name, '+' order by breweries.name) as brewery,
               case when ingredients.itype = 'hop' then string_agg(distinct ingredients.name, ',' order by ingredients.name) else 'no hops recorded' end as hops,
               beers.id as id
        from beers
        full join contains on beers.id = contains.beer
        full join ingredients on ingredients.id = contains.ingredient
        inner join brewed_by on brewed_by.beer = beers.id
        inner join breweries on brewed_by.brewery = breweries.id
        where beers.name ilike '%' || pattern || '%'
        group by beers.id, ingredients.itype
        order by beers.id
    )
    loop
        -- Filter out duplicate beers when beer has hop and non-hop ingredients.
        if beer.id = prev_id then
            continue;
        end if;
        prev_id = beer.id;

        return next (beer.beer, beer.brewery, beer.hops)::BeerHops;
    end loop;
end;
$$ language plpgsql;

---- Q9
--
--create or replace function
--    Q9(...) returns ...
--as $$
--...
--$$
--language plpgsql ;
--
