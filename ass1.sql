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

CREATE VIEW q1 AS SELECT region as state, COUNT(*) as nbreweries FROM locations WHERE locations.country='Australia' GROUP BY region; 

---- Q2

CREATE VIEW q2 AS SELECT name as style, min_abv, max_abv FROM styles WHERE max_abv - min_abv = (SELECT MAX(max_abv - min_abv) FROM styles);

---- Q3

CREATE VIEW q3 AS SELECT DISTINCT ON (styles.name) styles.name as style, MIN(abv) OVER (PARTITION BY styles.name) AS lo_abv, MAX(abv) OVER (PARTITION BY styles.name) AS hi_abv, min_abv, max_abv FROM beers INNER JOIN styles ON beers.style=styles.id;

---- Q4
--
--create or replace view Q4(...)
--as
--...
--;
--
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
