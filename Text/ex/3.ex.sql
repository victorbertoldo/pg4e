/*Reverse Index in SQL
In this assignment, you will create a table of documents and then produce a reverse index for those documents that identifies each document which contains a particular word using SQL.

FYI: In contrast with the provided sample SQL, you will map all the words in the reverse index to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the inverted index).

*/

--Here is the the psql command to access your database:

--psql -h pg.pg4e.com -p 5432 -U pg4e_14e754e465 pg4e_14e754e465
CREATE TABLE docs01 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);
Here are the one-line documents that you are to insert into docs01:
INSERT INTO docs01 (doc) VALUES
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
-- Here is a sample for the first few expected rows of your reverse index:

SELECT keyword, doc_id FROM invert01 ORDER BY keyword, doc_id LIMIT 10;
/*
keyword    |  doc_id
-----------+--------
a          |    2    
a          |    4    
a          |    5    
a          |    7    
a          |    8    
a          |    9    
actually   |    4    
advanced   |    1    
ah         |    7    
and        |    3    
*/


/*
here is an exemple how to do it:

-- Break the document column into one row per word + primary key
SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(D.doc, ' ')) s(keyword)
ORDER BY id;

-- Lower case it all
SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
ORDER BY id;

DROP TABLE docs_gin CASCADE;
CREATE TABLE docs_gin (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);

DROP TABLE stop_words;
CREATE TABLE stop_words (word TEXT unique);
INSERT INTO stop_words (word) VALUES ('is'), ('this'), ('and');

-- All we do is throw out the words in the stop word list
SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

-- Put the stop-word free list into the GIN
INSERT INTO docs_gin (doc_id, keyword)
SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

SELECT * FROM docs_gin;
*/

-- Now lets insert the transformed data into the invert01 table
INSERT INTO invert01 (keyword, doc_id)
SELECT DISTINCT s.keyword AS keyword, id AS doc_id
FROM docs01 AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
ORDER BY keyword, doc_id;

