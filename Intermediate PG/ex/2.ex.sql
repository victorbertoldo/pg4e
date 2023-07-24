/*
Using SELECT DISTINCT
In this assignment you are to find the distinct values in the state column of the taxdata table in ascending order. Your query should only return these five rows (i.e. inclide a LIMIT clause):
*/

SELECT DISTINCT state
FROM taxdata
ORDER BY state ASC
LIMIT 5;