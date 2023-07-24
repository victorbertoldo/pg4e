/*
Entering Many-to-One Data - Automobiles
This application will create two tables, and hand-load a small amount of data in the the tables while properly normalizing the data
*/

CREATE TABLE make (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE model (
  id SERIAL,
  name VARCHAR(128),
  make_id INTEGER REFERENCES make(id) ON DELETE CASCADE,
  PRIMARY KEY(id)
);

-- Insert the following data into your database separating it appropriately into the **make** and **model** tables and setting the **make\_id** foreign key to link each model to its corresponding make.

/*
make	model
Chrysler	Crossfire Coupe
Chrysler	Crossfire Roadster
Chrysler	E Class/New Yorker
Porsche	911 Speedster
Porsche	911 Targa
*/

INSERT INTO make (name) VALUES ('Chrysler');
INSERT INTO make (name) VALUES ('Porsche');

INSERT INTO model (name, make_id) VALUES ('Crossfire Coupe', 1);
INSERT INTO model (name, make_id) VALUES ('Crossfire Roadster', 1);
INSERT INTO model (name, make_id) VALUES ('E Class/New Yorker', 1);
INSERT INTO model (name, make_id) VALUES ('911 Speedster', 2);
INSERT INTO model (name, make_id) VALUES ('911 Targa', 2);

