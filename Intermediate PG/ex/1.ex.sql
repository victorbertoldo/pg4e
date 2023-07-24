CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;


/*
In this exercise you will add a column to your pg4e_debug table. The column can be any type you like - like INTEGER. neon217.

The auto grader will run the folowing command:

SELECT neon217 FROM pg4e_debug LIMIT 1;
*/

ALTER TABLE pg4e_debug ADD COLUMN neon217 INTEGER;