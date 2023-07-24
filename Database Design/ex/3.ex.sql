-- library exercise

CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT,
  count INTEGER, rating INTEGER, len INTEGER);


/*
Comando para inserir os dados na tabela track_raw via psql
wget https://www.pg4e.com/tools/sql/library.csv -O - -q | psql -X -c "copy track_raw from stdin delimiter ',' null '' csv quote '\"'" -h pg.pg4e.com -p 5432 -U pg4e_1524897c56 pg4e_1524897c56
*/

select * from track_raw limit 10;