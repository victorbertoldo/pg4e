CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;

CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE ages ( 
  name VARCHAR(128), 
  age INTEGER
);

DELETE FROM ages;
INSERT INTO ages (name, age) VALUES ('Eryn', 27);
INSERT INTO ages (name, age) VALUES ('Gideon', 25);
INSERT INTO ages (name, age) VALUES ('Karen', 36);
INSERT INTO ages (name, age) VALUES ('Lucyanne', 33);
INSERT INTO ages (name, age) VALUES ('Rubin', 15);

SELECT * FROM ages;