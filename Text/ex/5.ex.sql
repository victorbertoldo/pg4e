/*
String Array GIN Index
In this assignment, you will create a table of documents and then produce a GIN-based text[] reverse index for those documents that identifies each document which contains a particular word using SQL.

FYI: In contrast with the provided sample SQL, you will map all the words in the GIN index to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the GIN index).
The goal of this assignment is to run these queries:

SELECT id, doc FROM docs03 WHERE '{understanding}' <@ string_to_array(lower(doc), ' ');
EXPLAIN SELECT id, doc FROM docs03 WHERE '{understanding}' <@ string_to_array(lower(doc), ' ');
and (a) get the correct document(s) and (b) use the GIN index (i.e. not use a sequential scan).
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE INDEX array03 ON docs03 USING gin(...);
If you get an operator class error on your CREATE INDEX check the instructions below for the solution.

Here are the one-line documents that you are to insert into docs03:

INSERT INTO docs03 (doc) VALUES
('skimming more advanced material without fully understanding the details'),
('you can get a better understanding of the why of programming By'),
('reviewing previous material and even redoing earlier exercises you will'),
('realize that you actually learned a lot of material even if the material'),
('you are currently staring at seems a bit impenetrable'),
('Usually when you are learning your first programming language there are'),
('a few wonderful Ah Hah moments where you can look up from pounding'),
('away at some rock with a hammer and chisel and step away and see that'),
('you are indeed building a beautiful sculpture'),
('If something seems particularly hard there is usually no value in');
You should also insert a number of filler rows into the table to make sure PostgreSQL uses its index:

INSERT INTO docs03 (doc) SELECT 'Neon ' || generate_series(10000,20000);
It might take from a few seconds to a minute or two before PostgreSQL catches up with its indexing. The autograder won't work if the index is incomplete. If the EXPLAIN command says that it is using Seq Scan - the index has not completed yet. Run the above EXPLAIN multiple times if necessary until you verify that PostgreSQL has finished making the index:

pg4e=> EXPLAIN SELECT id, doc FROM docs03 WHERE '{understanding}' <@ string_to_array(lower(doc), ' ');
                                   QUERY PLAN
--------------------------------------------------------------------------------
 Seq Scan on docs03  (cost=0.00..177.24 rows=35 width=36)
 Filter: ('{understanding}'::text[] <@ string_to_array(lower(doc), ' '::text))
(2 rows)


TIME PASSES......


pg4e=> EXPLAIN SELECT id, doc FROM docs03 WHERE '{understanding}' <@ string_to_array(lower(doc), ' ');
                                        QUERY PLAN
------------------------------------------------------------------------------------------
 Bitmap Heap Scan on docs03  (cost=12.02..21.97 rows=3 width=15)
 Recheck Cond: ('{understanding}'::text[] <@ string_to_array(lower(doc), ' '::text))
   ->  Bitmap Index Scan on array03  (cost=0.00..12.02 rows=3 width=0)
   Index Cond: ('{understanding}'::text[] <@ string_to_array(lower(doc), ' '::text))
(4 rows)

pg4e=>
References
Here are some links on monitoring the building of indexes:

PostgreSQL Wiki: Index Maintenance

Stackoverflow: Monitoring Progress of Index Construction in PostgreSQL
*/

create table docs03 (id serial, doc text, primary key(id));

create index array03 on docs03 using gin(string_to_array(lower(doc), ' '));

insert into docs03 (doc) values
('skimming more advanced material without fully understanding the details'),
('you can get a better understanding of the why of programming By'),
('reviewing previous material and even redoing earlier exercises you will'),
('realize that you actually learned a lot of material even if the material'),
('you are currently staring at seems a bit impenetrable'),
('Usually when you are learning your first programming language there are'),
('a few wonderful Ah Hah moments where you can look up from pounding'),
('away at some rock with a hammer and chisel and step away and see that'),
('you are indeed building a beautiful sculpture'),
('If something seems particularly hard there is usually no value in');

insert into docs03 (doc) select 'Neon ' || generate_series(10000,20000);

select id, doc from docs03 where '{understanding}' <@ string_to_array(lower(doc), ' ');

explain select id, doc from docs03 where '{understanding}' <@ string_to_array(lower(doc), ' ');

explain select id, doc from docs03 where '{understanding}' <@ string_to_array(lower(doc), ' ');


