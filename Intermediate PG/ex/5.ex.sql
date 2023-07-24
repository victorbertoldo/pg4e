-- Unesco Heritage Sites Many-to-One
/*
In this assignment you will read some Unesco Heritage Site data in 
comma-separated-values (CSV) format and produce properly normalized tables as specified below. 
Once you have placed the proper data in the tables, press the button below to check your answer.
*/

-- Here is the structure of the tables you will need for this assignment:

DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

/*
... More tables needed
To load the CSV data for this assignment use the following copy command. Adding HEADER causes the CSV loader to skip the first line in the CSV file. The \copy command must be one long line.
\copy unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM 'whc-sites-2018-small.csv' WITH DELIMITER ',' CSV HEADER;
*/

-- load data from csv file into unesco_raw table using \copy

-- wget https://www.pg4e.com/tools/sql/whc-sites-2018-small.csv -O - -q | psql -X -c "copy unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM stdin delimiter ','  null '' csv header quote '\"'" -h pg.pg4e.com -p 5432 -U pg4e_3b5fb71522 pg4e_3b5fb71522

/*
Normalize the data in the unesco_raw table by adding the entries to each of the lookup tables (category, etc.) and then adding the foreign key columns to the unesco_raw table. Then make a new table called unesco that removes all of the un-normalized redundant text columns like category.
If you run the program multiple times in testing or with different files, make sure to empty out the data before each run.
*/

-- Create the category table
DROP TABLE IF EXISTS category;
CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- Create the iso table
DROP TABLE IF EXISTS iso;
CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- Create the region table
DROP TABLE IF EXISTS region;
CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- Create the state table
DROP TABLE IF EXISTS state;
CREATE TABLE state (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- Create the unesco table
DROP TABLE IF EXISTS unesco;
CREATE TABLE unesco (
  id SERIAL,
  name VARCHAR(256),
  description TEXT,
  justification TEXT,
  year INTEGER,
  longitude FLOAT,
  latitude FLOAT,
  area_hectares FLOAT,
  category_id INTEGER,
  state_id INTEGER,
  region_id INTEGER,
  iso_id INTEGER,
  PRIMARY KEY(id)
);

-- Insert data into category table
INSERT INTO category (name)
  SELECT DISTINCT category
  FROM unesco_raw;

-- Insert data into iso table
INSERT INTO iso (name)
  SELECT DISTINCT iso
  FROM unesco_raw;

-- Insert data into region table
INSERT INTO region (name)
  SELECT DISTINCT region
  FROM unesco_raw;

-- Insert data into state table
INSERT INTO state (name)
  SELECT DISTINCT state
  FROM unesco_raw;

-- Insert data into unesco table
INSERT INTO unesco (name, description, justification, year, longitude, latitude, area_hectares, category_id, state_id, region_id, iso_id)
  SELECT unesco_raw.name, description, justification, year, longitude, latitude, area_hectares, category.id, state.id, region.id, iso.id
  FROM unesco_raw
  JOIN category ON unesco_raw.category = category.name
  JOIN state ON unesco_raw.state = state.name
  JOIN region ON unesco_raw.region = region.name
  JOIN iso ON unesco_raw.iso = iso.name;

-- Check the data in the unesco table
SELECT * FROM unesco;

-- Check the data in the category table
SELECT * FROM category;

SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY state.name, unesco.name
  LIMIT 3;

-- The expected result of this query on your database is:
| Name | Year |	Category |	State |	Region | iso |
| --- | --- | --- | --- | --- | --- |
| Cultural Landscape and Archaeological Remains of the Bamiyan Valley |	2003 |	Cultural |	Afghanistan	Asia and the Pacific |	af
| Minaret and Archaeological Remains of Jam	2002	Cultural	Afghanistan	Asia and the Pacific	af
| Butrint	1992	Cultural	Albania	Europe and North America	al
