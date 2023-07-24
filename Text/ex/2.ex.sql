/*
Regular Expressions
In this assignment you will create a regular expression to retrieve a subset data from the purpose column of the taxdata table in the readonly database (access details below). Write a regular expressions to retrieve that meet the following criteria:

Lines that are all upper case letters and spaces and nothing else

As an example (not the solution to this assignment), if you were looking for lines where the very first character was an upper case character letter you would run the following query:
*/
SELECT purpose FROM taxdata WHERE purpose ~ '^[A-Z]' ORDER BY purpose DESC LIMIT 3;

/*
The autograder will add all the SQL - all you need is to enter the appropriate regular expression below.
Enter a regular expression like ^[A-Z]...
*/

^[A-Z ]+$

/*
Here are the first few lines:

YOUTH WRITING WORKSHOPS ACADEMIC SUPPORT
YOUTH WRESTLING CLUB SUPPORTED YOUTH WRESTLING
YOUTH WORK THERAPY PROGRAMS
Here are access details for a readonly database:


psql -h pg.pg4e.com -p 5432 -U readonly readonly
Here is the schema for the taxdata table:

readonly=# \d+ taxdata
  Column  |          Type          |
----------+------------------------+
 id       | integer                |
 ein      | integer                |
 name     | character varying(255) |
 year     | integer                |
 revenue  | bigint                 |
 expenses | bigint                 |
 purpose  | text                   |
 ptid     | character varying(255) |
 ptname   | character varying(255) |
 city     | character varying(255) |
 state    | character varying(255) |
 url      | character varying(255) |
 */