/*
Load the mbox table from link: https://pg4e.com/lectures/mbox-short.txt

with wget + copy of psql

*/

wget -q -O - "$@" https://pg4e.com/lectures/mbox-short.txt | psql -X -c "copy mbox from stdin delimiter E'\007'" -h pg.pg4e.com -p 5432 -U pg4e_3b5fb71522 pg4e_3b5fb71522
\copy mbox FROM PROGRAM 'wget -q -O - "$@" https://www.pg4e.com/lectures/mbox-short.txt' with delimiter E'\007';