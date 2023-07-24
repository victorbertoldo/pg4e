-- Create the following tables.
DROP TABLE student CASCADE;
CREATE TABLE student (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE course CASCADE;
CREATE TABLE course (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE roster CASCADE;
CREATE TABLE roster (
    id SERIAL,
    student_id INTEGER REFERENCES student(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES course(id) ON DELETE CASCADE,
    role INTEGER,
    UNIQUE(student_id, course_id),
    PRIMARY KEY (id)
);

/*
Course Data
You will normalize the following data (each user gets different data), and insert the following data items into your database, creating and linking all the foreign keys properly. Encode instructor with a role of 1 and a learner with a role of 0.

Corinne, si106, Instructor
Bezalel, si106, Learner
Hubert, si106, Learner
Madelyn, si106, Learner
Sheigh, si106, Learner
Vladislav, si110, Instructor
Carley, si110, Learner
Connie, si110, Learner
Mallissaa, si110, Learner
Orin, si110, Learner
Noah, si206, Instructor
Cori, si206, Learner
Erencem, si206, Learner
Salihah, si206, Learner
Tamarah, si206, Learner

You can test to see if your data has been entered properly with the following SQL statement.

SELECT student.name, course.title, roster.role
    FROM student 
    JOIN roster ON student.id = roster.student_id
    JOIN course ON roster.course_id = course.id
    ORDER BY course.title, roster.role DESC, student.name;
The order of the data and number of rows that comes back from this query should be the same as above. There should be no missing or extra data in your query.
*/

-- Insert data into the tables.
INSERT INTO student (name) VALUES ('Corinne');
INSERT INTO student (name) VALUES ('Bezalel');
INSERT INTO student (name) VALUES ('Hubert');
INSERT INTO student (name) VALUES ('Madelyn');
INSERT INTO student (name) VALUES ('Sheigh');
INSERT INTO student (name) VALUES ('Vladislav');
INSERT INTO student (name) VALUES ('Carley');
INSERT INTO student (name) VALUES ('Connie');
INSERT INTO student (name) VALUES ('Mallissaa');
INSERT INTO student (name) VALUES ('Orin');
INSERT INTO student (name) VALUES ('Noah');
INSERT INTO student (name) VALUES ('Cori');
INSERT INTO student (name) VALUES ('Erencem');
INSERT INTO student (name) VALUES ('Salihah');
INSERT INTO student (name) VALUES ('Tamarah');

INSERT INTO course (title) VALUES ('si106');
INSERT INTO course (title) VALUES ('si110');
INSERT INTO course (title) VALUES ('si206');

INSERT INTO roster (student_id, course_id, role) VALUES (1, 1, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (2, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (3, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (4, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (5, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (6, 2, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (7, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (8, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (9, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (10, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (11, 3, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (12, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (13, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (14, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (15, 3, 0);

-- Test the data.
SELECT student.name, course.title, roster.role
    FROM student 
    JOIN roster ON student.id = roster.student_id
    JOIN course ON roster.course_id = course.id
    ORDER BY course.title, roster.role DESC, student.name;
