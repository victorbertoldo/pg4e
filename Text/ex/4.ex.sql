/*
Reverse Index (with stop words) in SQL
In this assignment, you will create a table of documents and then produce a reverse index with stop words for those documents that identifies each document which contains a particular word using SQL.
*/
CREATE TABLE docs02 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert02 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs02(id) ON DELETE CASCADE
);

-- If you already have the above tables created and the documents inserted from a prior assignment, you can just delete all the rows from the reverse index and recreate them following the rules of stop words:

DELETE FROM invert02;

-- Here are the one-line documents that you are to insert into docs02:
INSERT INTO docs02 (doc) VALUES
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

-- Here are your stop words:

CREATE TABLE stop_words (word TEXT unique);

INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');
-- Here is a sample for the first few expected rows of your reverse index:

SELECT keyword, doc_id FROM invert02 ORDER BY keyword, doc_id LIMIT 10;
/*
keyword    |  doc_id
-----------+--------
actually   |    4    
advanced   |    1    
ah         |    7    
and        |    3    
and        |    8    
away       |    8    
beautiful  |    9    
better     |    2    
bit        |    5    
building   |    9    
*/
/*
Heres an exemple to how to insert data in a inverted index table without stop words:
-- Inverted string index with stop words using SQL

-- If we know the documents contain natural language, we can optimize indexes

-- (1) Ignore the case of words in the index and in the query
-- (2) Don't index low-meaning "stop words" that we will ignore
-- if they are in a search query

DROP TABLE docs CASCADE;
CREATE TABLE docs (id SERIAL, doc TEXT, PRIMARY KEY(id));
INSERT INTO docs (doc) VALUES
('This is SQL and Python and other fun teaching stuff'),
('More people should learn SQL from UMSI'),
('UMSI also teaches Python and also SQL');
SELECT * FROM docs;

--- https://stackoverflow.com/questions/29419993/split-column-into-multiple-rows-in-postgres

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

-- Now lets insert the data without stop words inside the table invert02:

INSERT INTO invert02 (keyword, doc_id)
SELECT DISTINCT s.keyword AS keyword, id
FROM docs02 AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;