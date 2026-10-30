/*
===============================================================================
Exercise 01
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds
FROM track
ORDER BY milliseconds ASC;


/*
===============================================================================
Exercise 02
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds
FROM track
ORDER BY milliseconds DESC;


/*
===============================================================================
Exercise 03
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price
FROM track
ORDER BY
    unit_price DESC,
    name ASC;


/*
===============================================================================
Exercise 04
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds,
    unit_price
FROM track
WHERE unit_price = 0.99
ORDER BY milliseconds DESC;


/*
===============================================================================
Exercise 05
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds
FROM track
ORDER BY
    milliseconds DESC,
    track_id ASC
LIMIT 10;


/*
===============================================================================
Exercise 06
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price
FROM track
ORDER BY
    unit_price DESC,
    track_id ASC
LIMIT 10;


/*
===============================================================================
Exercise 07
===============================================================================
*/

SELECT
    track_id,
    name
FROM track
ORDER BY track_id ASC
LIMIT 10
OFFSET 0;


/*
===============================================================================
Exercise 08
===============================================================================
*/

SELECT
    track_id,
    name
FROM track
ORDER BY track_id ASC
LIMIT 10
OFFSET 10;


/*
===============================================================================
Exercise 09

page = 5
page_size = 20

OFFSET
= (5 - 1) * 20
= 80
===============================================================================
*/

SELECT
    track_id,
    name
FROM track
ORDER BY track_id ASC
LIMIT 20
OFFSET 80;


/*
===============================================================================
Exercise 10
===============================================================================
*/

SELECT
    customer_id,
    first_name,
    last_name,
    country
FROM customer
ORDER BY
    country ASC,
    last_name ASC,
    first_name ASC;


/*
===============================================================================
Exercise 11
===============================================================================
*/

SELECT
    invoice_id,
    customer_id,
    invoice_date,
    total
FROM invoice
ORDER BY
    invoice_date DESC,
    invoice_id DESC
LIMIT 10;


/*
===============================================================================
Exercise 12
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds / 60000.0 AS duration_minutes
FROM track
ORDER BY duration_minutes DESC;