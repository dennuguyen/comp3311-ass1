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

CREATE OR REPLACE VIEW q1 AS
SELECT region as state,
       COUNT(*) AS nbreweries
FROM breweries
INNER JOIN locations ON locations.id = breweries.located_in
WHERE locations.country = 'Australia'
GROUP BY region; 

---- Q2

CREATE OR REPLACE VIEW q2 AS
SELECT name as style,
       min_abv,
       max_abv
FROM styles
WHERE max_abv - min_abv = (SELECT MAX(max_abv - min_abv) FROM styles);

---- Q3

CREATE OR REPLACE VIEW q3 AS
SELECT styles.name as style,
       MIN(abv) AS lo_abv,
       MAX(abv) AS hi_abv,
       min_abv,
       max_abv
FROM beers
INNER JOIN styles ON beers.style = styles.id
GROUP BY styles.name, styles.min_abv, styles.max_abv
HAVING (MIN(abv) < min_abv OR MAX(abv) > max_abv)
AND min_abv != max_abv;

--CREATE OR REPLACE VIEW q3 AS SELECT styles.name as style, MIN(abv) AS lo_abv, MAX(abv) AS hi_abv, min_abv, max_abv FROM beers INNER JOIN styles ON beers.style=styles.id GROUP BY styles.name, styles.min_abv, styles.max_abv ORDER BY styles.name;

---- Q4

CREATE OR REPLACE VIEW q4 AS SELECT breweries.name AS brewery, CAST(AVG(beers.rating) AS NUMERIC(3, 1)) AS rating FROM beers INNER JOIN brewed_by ON beers.id = brewed_by.beer INNER JOIN breweries ON brewed_by.brewery = breweries.id WHERE beers.rating IS NOT NULL GROUP BY breweries.name HAVING COUNT(beers.id) >= 5;

---- Q5
--
--create or replace function
--    Q5(...) returns ...
--as $$
--...
--$$
--language sql ;
--
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
