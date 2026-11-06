/*
===============================================================================
Exercise 01
===============================================================================
*/

SELECT
    track_id,
    name,
    composer
FROM track
WHERE composer IS NULL;


/*
===============================================================================
Exercise 02
===============================================================================
*/

SELECT
    track_id,
    name,
    composer
FROM track
WHERE composer IS NOT NULL;


/*
===============================================================================
Exercise 03
===============================================================================
*/

SELECT
    customer_id,
    first_name,
    last_name,
    company
FROM customer
WHERE company IS NULL;


/*
===============================================================================
Exercise 04
===============================================================================
*/

SELECT
    customer_id,
    first_name,
    last_name,
    fax
FROM customer
WHERE fax IS NOT NULL;


/*
===============================================================================
Exercise 05
===============================================================================
*/

SELECT
    track_id,
    name,
    composer
FROM track
WHERE
    composer <> 'AC/DC'
    OR composer IS NULL;


/*
===============================================================================
Exercise 06
===============================================================================
*/

SELECT
    NULL = NULL AS equality_test,
    NULL <> NULL AS inequality_test,
    NULL IS NULL AS is_null_test,
    NULL IS NOT NULL AS is_not_null_test;


/*
===============================================================================
Exercise 07 - Query A
===============================================================================
*/

SELECT
    track_id,
    name,
    composer
FROM track
WHERE composer <> 'AC/DC';


/*
===============================================================================
Exercise 07 - Query B
===============================================================================
*/

SELECT
    track_id,
    name,
    composer
FROM track
WHERE
    composer <> 'AC/DC'
    OR composer IS NULL;