# Prompt 1 Tables
##########################

DROP DATABASE IF EXISTS students;
CREATE DATABASE IF NOT EXISTS students;
USE students;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS class,
                     student,
                     enrollment;

CREATE TABLE class (
    class_id    INT             NOT NULL,
    class_name  VARCHAR(16)     NOT NULL,
    PRIMARY KEY (class_id),
    UNIQUE  KEY (class_name)
);

CREATE TABLE student (
    student_id  INT             NOT NULL,
    first_name  VARCHAR(16)		NOT NULL,
    last_name	VARCHAR(16)		NOT NULL,
    PRIMARY KEY (student_id)
);

CREATE TABLE enrollment (
    class_id    INT     		NOT NULL,
    student_id  INT     		NOT NULL,
    semester  	VARCHAR(16)    	NOT NULL,
    grade  		VARCHAR(2),
    FOREIGN KEY (class_id)  	REFERENCES class (class_id),
    FOREIGN KEY (student_id)  	REFERENCES student (student_id),
    PRIMARY KEY (class_id, student_id, semester)
);

INSERT INTO class
	(class_id, class_name)
VALUES
	(101, 'Geometry'),
	(102, 'English'),
	(103, 'Physics');

INSERT INTO student
	(student_id, first_name, last_name)
VALUES
	(500, 'Robert', 'Smith'),
	(762, 'Frank', 'Carter'),
	(881, 'Joseph', 'Evans'),
	(933, 'Anne', 'Baker');

INSERT INTO enrollment
	(class_id, student_id, semester, grade)
VALUES
	(101, 500, 'Fall 2019', 'A'),
	(102, 500, 'Fall 2019', 'B'),
	(103, 762, 'Fall 2019', 'F'),
	(101, 881, 'Spring 2020', 'B'),
	(102, 881, 'Fall 2020', 'B'),
	(103, 762, 'Spring 2021', NULL);

# Prompt 1 Questions
##########################

# Answer the following questions by constructing a single query without using subqueries, unless otherwise instructed.

#1- Write a query to retrieve all columns from the Enrollment table where the grade of A or B was assigned.
# ---------------

SELECT *
	FROM enrollment
	WHERE grade IN ('A','B');

#2- Write a query to return the first and last names of each student who has taken Geometry.
# ---------------
SELECT s.first_name, s.last_name
	FROM student s
	JOIN enrollment e
	ON s.student_id = e.student_id
	JOIN class c
	ON c.class_id = e.class_id
	WHERE c.class_name = 'Geometry';

#3- Write a query to return all rows from the Enrollment table where the student has not been given a failing grade (F).  
# Include any rows where the grade has not yet been assigned.
# ---------------
SELECT *
	FROM enrollment
	WHERE grade != 'F'
		OR grade IS NULL;

#4- Write a query to return the first and last names of every student in the Student table. 
# If a student has ever enrolled in English, please specify the grade that they received.  
# You need only include the Enrollment and Student tables, and may specify the class_id value of 102 for the English class.
# ---------------
SELECT s.first_name, s.last_name, (e.grade) english_grade
	FROM student s
	JOIN enrollment e
	ON s.student_id = e.student_id
	WHERE e.class_id = 102;

#5- Write a query to return the total number of students who have ever been enrolled in each of the classes.
# ---------------
SELECT c.class_name, count(*) enrolled_students
	FROM class c 
	JOIN enrollment e 
	ON c.class_id = e.class_id
	GROUP BY c.class_name;

#6- Write a statement to modify Robert Smith’s grade for the English class from a B to a B+.  
# Specify the student by his student ID, which is 500, and the English class by class ID 102.
# ---------------
UPDATE enrollment
	SET grade = 'B+'
	WHERE class_id = 102
		AND student_id = 500;

#7- Create an alternate statement to modify Robert Smith’s grade in English, but for this version specify the student by first/last name, not by student ID.  
# This will require the use of a subquery.
# ---------------
UPDATE enrollment
	SET grade = 'B+'
	WHERE class_id = 102
		AND student_id = (SELECT student_id 
			FROM student
			WHERE first_name = 'Robert' 
				AND last_name = 'Smith');

#8- A new student name Michael Cronin enrolls in the Geometry class.  
# Construct a statement to add the new student to the Student table 
# (you can pick any value for the student_id, as long as it doesn’t already exist in the table).
# ---------------
INSERT INTO student
	(student_id, first_name, last_name)
VALUES
	(420, 'Michael', 'Cronin');

#9- Add Michael Cronin’s enrollment in the Geometry class to the Enrollment table.  
# You may only specify names (e.g. “Michael”, “Cronin”, “Geometry”) and not numbers (e.g. student_id, class_num) in your statement. 
# You may use subqueries if desired, but the statement can also be written without the use of subqueries. Use ‘Spring 2020’ for the semester value.
# ---------------
INSERT INTO enrollment
	(class_id, student_id, semester, grade)
VALUES
	((SELECT class_id FROM class WHERE class_name = 'Geometry'), (SELECT student_id FROM student WHERE first_name = 'Michael' AND last_name = 'Cronin'), 'Spring 2020', NULL);

#10- Write a query to return the first and last names of all students who have not enrolled in any class.  Use a correlated subquery against the Enrollment table.
# ---------------
# SQL Correlated Subqueries are used to select data from a table referenced in the outer query. The subquery is known as a correlated because the subquery is related to the outer query.

# this not a correlated sub queries (I couldn't find how to make it correlated)
SELECT s.first_name, s.last_name
	FROM student s
	LEFT JOIN enrollment e
	ON s.student_id = e.student_id
	WHERE e.class_id IS NULL; 

#11- Return the same results as the previous question (first and last name of all students who have not enrolled in any class), but formulate your query using a non-correlated subquery against the Enrollment table.
# ---------------
# In non correlated subquery, inner query doesn't depend on outer query and can run as stand alone query
SELECT first_name, last_name
	FROM student
	WHERE student_id NOT IN (
SELECT student_id
	FROM enrollment
	GROUP BY student_id);

#12- Write a statement to remove any rows from the Student table where the person has not enrolled in any classes.  You may use either a correlated or non-correlated subquery against the Enrollment table.
# ---------------
DELETE FROM student s 
WHERE s.student_id NOT IN (
	SELECT student_id
		FROM enrollment
		GROUP BY student_id);

