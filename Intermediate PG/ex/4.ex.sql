-- Musical Tracks Many-to-One

/*
Logging in to the database and load the csv data

wget https://www.pg4e.com/tools/sql/library.csv -O - -q | psql -X -c "copy track_raw from stdin delimiter ',' null '' csv quote '\"'" -h pg.pg4e.com -p 5432 -U pg4e_3b5fb71522 pg4e_3b5fb71522
*/
-- Here is the structure of the tables you will need for this assignment:
DROP TABLE IF EXISTS album cascade;
CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
DROP TABLE IF EXISTS track cascade;
CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER);

-- We will ignore the artist field for this assignment and focus on the many-to-one relationship between tracks and albums.
-- to insert the data from the csv file keeping the len column with null value as default

-- wget https://www.pg4e.com/tools/sql/library.csv -O - -q | psql -X -c "copy track_raw(title, artist, album, album_id, count, rating) from stdin delimiter ',' null '' csv quote '\"'" -h pg.pg4e.com -p 5432 -U pg4e_3b5fb71522 pg4e_3b5fb71522


-- If you run the program multiple times in testing or with different files, make sure to empty out the data before each run.
-- com/tools/sql/library.csv?PHPSESSID=420fc8c825abc53a81afd5904e49c09a%22) file into the **track_raw** table using the **\\copy** command. Then write SQL commands to insert all of the distinct albums into the **album** table (creating their primary keys) and then set the **album_id** in the **track_raw** table using an SQL query like:

-- Now lets populate the album table with the data from raw_track table

INSERT INTO album (title)
    SELECT DISTINCT album FROM track_raw ORDER BY album;

-- Now lets populate the track table with the data from raw_track table

INSERT INTO track (title, len, rating, count, album_id)
    SELECT track_raw.title, len, rating, count, album.id
        FROM track_raw JOIN album ON track_raw.album = album.title;

-- Load this [CSV data](https://www.pg4e.
UPDATE track_raw SET album_id = (SELECT album.id FROM album WHERE album.title = track_raw.album);

-- Then use a **INSERT ... SELECT** statement to copy the corresponding data from the **track_raw** table to the **track** table, effectively dropping the **artist** and **album** text fields.

--To grade this assignment, the auto-grader will run a query like this on your database and look for the data it expects to see:

SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3; 

--The expected result of this query on your database is:

| track | album |
| ---------------------- | ------------------------- |
| A Boy Named Sue (live) | The Legend Of Johnny Cash |
| A Brief History of Packets | Computing Conversations |
| Aguas De Marco | Natural Wonders Music Sampler 1999 |

--Once you have added the data successfully, run the following SQL command:

SELECT album.title, COUNT(track.title) AS count, AVG(track.len) AS average
    FROM album JOIN track ON album.id = track.album_id
    GROUP BY album.title ORDER BY count DESC LIMIT 3;

