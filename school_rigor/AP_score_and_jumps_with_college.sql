-- courses taken by student
SELECT psid, COUNT(student_number) 
INTO Holds
FROM grades
WHERE term_id >= 3000 AND class_of = 2021 AND course_number NOT IN (702, 674)
GROUP BY psid
;

-- count of students in course
SELECT course_number, Course_Name, count(student_number) FROM grades
WHERE class_of = 2021 AND term_id >= 3000
GROUP BY Course_Number, course_name
ORDER BY Course_Number, Course_name
;

-- all grades from 2011
SELECT * FROM grades WHERE class_of = 2011
ORDER BY student_number, grade_level;

SELECT count AS total, COUNT(psid)
FROM holds
GROUP BY total
ORDER BY total;

ALTER TABLE grades RENAME COLUMN term_id TO school_year;

--counts of grades earned by course
SELECT 
	c.Dept, 
	g.Teacher, 
	g.Course_Number,
	(CASE 
	WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN g.Grade IN ('F') THEN 'F'	
	END) AS Grade,
	COUNT(g.Student_Number)
FROM grades AS g
INNER JOIN courses AS c
ON (c.Course_Name = g.Course_Name)
WHERE 
	(CASE 
	WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN g.Grade IN ('F') THEN 'F'	
	END) IS NOT NULL
	AND g.Fall_year <= 2019
	AND c.Dept = 5
	--AND c.Course_Number IN (520)
	AND g.Teacher IS NOT NULL
GROUP BY
	g.Course_Number, c.Dept,  g.Teacher, 
	CASE 
	WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN g.Grade IN ('F') THEN 'F'		
	END
ORDER BY
	c.Dept, g.Course_Number, g.Teacher, 
	CASE 
	WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN g.Grade IN ('F') THEN 'F'	
	END;

SELECT * FROM grades;


-- percent breakdown by course
SELECT 
g.Course_Number, 
g.Teacher,
(COUNT(CASE WHEN g.Grade IN ('A+', 'A', 'A-') THEN 1 END)) * 100 / COUNT(*) AS "A%",
(COUNT(CASE WHEN g.Grade IN ('B+', 'B', 'B-') THEN 1 END)) * 100 / COUNT(*) AS "B%",
(COUNT(CASE WHEN g.Grade IN ('C+', 'C', 'C-') THEN 1 END)) * 100 / COUNT(*) AS "C%",
(COUNT(CASE WHEN g.Grade IN ('D+', 'D', 'D-') THEN 1 END)) * 100 / COUNT(*) AS "D%",
(COUNT(CASE WHEN g.Grade IN ('F') THEN 1 END)) * 100 / COUNT(*) AS "F%",
ROUND(AVG(g.GPA_Point), 2) AS GPA, 
CAST(AVG(g.Percent_Grade) AS DECIMAL(5, 2)) AS Avg_Grade, 
--COUNT(DISTINCT g.SectionID) AS Sections,
COUNT(DISTINCT g.Student_Number) AS Students
--CAST((COUNT(DISTINCT g.PSID) / COUNT(DISTINCT g.SectionID)) AS DECIMAL(4, 2)) AS avg_students,
--'Q1 2021-2022' AS "term"
FROM grades AS g
LEFT JOIN courses AS c
ON (g.course_Name = c.course_name)
WHERE
--c.course_number NOT IN (9115, 9111, 773, 774)
--c.dept = 7
g.Course_Number NOT IN(870, 719, 920, 576) AND
g.Course_Number BETWEEN 100 AND 200
GROUP BY 
g.Course_Number,
g.Teacher
ORDER BY g.Course_Number, (COUNT(CASE WHEN g.Grade IN ('A+', 'A', 'A-') THEN 1 END)) * 100 / COUNT(*) DESC;

-- students with A in course 337
SELECT COUNT(*) 
FROM q1grades 
WHERE Course_Number = 337 
AND (grade_level = 9 OR grade_level = 10 OR grade_level = 11) 
AND percent_grade > 90;

--percent grade earned by course
SELECT grade_level, ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) FROM grades WHERE Course_Number = 735
GROUP BY grade_level;

-- count of kids who jump from PCH to BC
SELECT q1.Course_Number, q.Course_Number, q1.Grade_level, COUNT(DISTINCT q1.Student_Number) FROM q1grades AS q1
LEFT JOIN grades AS q
ON (q1.PSID = q.PSID)
WHERE q1.Course_Number = 341 AND q.Course_Number = 337 AND q1.Term_ID = 3101
GROUP BY q1.Course_Number, q.Course_Number, q1.Grade_Level
ORDER BY q1.Course_Number;

-- grades not stored
SELECT * FROM q1grades WHERE grade IS NULL;

-- change from store code to year of course taken
UPDATE grades
SET Fall_year = 2021
WHERE Fall_year = 3102;

--rename store code column
ALTER TABLE grades
RENAME COLUMN school_year TO Fall_year;

-- change column type to int from text
ALTER TABLE grades
ALTER COLUMN school_year TYPE INT
USING school_year::integer;

WITH total AS (SELECT COUNT(Student_Number) AS totalq FROM q1grades GROUP BY Student_Number)
SELECT AVG(totalq) FROM total;

--count of students in 364
SELECT term_id, count(*) FROM grades WHERE Course_Number = 364 AND store_code = 'S1'
GROUP BY term_id;

-- course names repeated?
SELECT course_name FROM courses
GROUP BY Course_name
HAVING (COUNT(course_name) > 1)
;

-- verify course names repeated
SELECT course_number FROM courses WHERE course_name LIKE 'Art History AP' 
OR course_name LIKE 'British Literature 2' OR course_name LIKE 'Weight Training' OR course_name LIKE 'Acting 1';

--Grades by department since class of 2011
SELECT class_of, grade_level, 
	(CASE 
	WHEN course_number BETWEEN 100 AND 199 THEN 'English' 
	WHEN course_number BETWEEN 200 AND 299 THEN 'S Science' 
	WHEN course_number BETWEEN 300 AND 399 THEN 'Math' 
	WHEN course_number BETWEEN 400 AND 499 THEN 'MCL' 
	WHEN course_number BETWEEN 500 AND 599 THEN 'Science'	
	END) AS subject,
ROUND(AVG(GPA_Point), 2) AS GPA, 
CAST(AVG(Percent_Grade) AS DECIMAL(5, 2)) AS Avg_Grade,
COUNT(*)
FROM grades
WHERE course_number BETWEEN 500 AND 600 AND course_number NOT IN(115, 576, 113, 674, 672, 671)
GROUP BY class_of, grade_level, (CASE 
	WHEN course_number BETWEEN 100 AND 199 THEN 'English' 
	WHEN course_number BETWEEN 200 AND 299 THEN 'S Science' 
	WHEN course_number BETWEEN 300 AND 399 THEN 'Math' 
	WHEN course_number BETWEEN 400 AND 499 THEN 'MCL' 
	WHEN course_number BETWEEN 500 AND 599 THEN 'Science'	
	END)
ORDER BY GPA DESC
--class_of, grade_level, (CASE 
--	WHEN course_number BETWEEN 100 AND 199 THEN 'English' 
--	WHEN course_number BETWEEN 200 AND 299 THEN 'S Science' 
--	WHEN course_number BETWEEN 300 AND 399 THEN 'Math' 
--	WHEN course_number BETWEEN 400 AND 499 THEN 'MCL' 
--	WHEN course_number BETWEEN 500 AND 599 THEN 'Science'	
--	END)
;

-- science courses for juniors in class of 2023
SELECT * FROM grades WHERE (course_number BETWEEN 500 AND 600) AND grade_level = 11 AND class_of = 2023;

CREATE TABLE Q1grades
	(Student_Number INT NOT NULL,
	 Class_Of INT,
	 Last_First VARCHAR,
	 Course_Name VARCHAR,
	 Course_Number INT,
	 Credits REAL,
	 Grade VARCHAR,
	 Grade_Level INT,
	 PSID INT,
	 Teacher VARCHAR,
	 GPA_Point INT,
	 Percent_Grade REAL,
	 Store_Code VARCHAR,
	 Exclude_GPA BOOLEAN,
	 GPA_Added BOOLEAN,
	 SectionID INT,
	 Exclude_Transcripts BOOLEAN,
	 Term_ID INT,
	 PRIMARY KEY (student_number, Course_Number)
	 );

-- something in case not working
SELECT PCH.fall_year, PCH.Grade_level, 	
	(CASE
	WHEN BC.Grade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN BC.Grade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN BC.Grade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN BC.Grade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN BC.Grade IN ('F') THEN 'F' END),
	COUNT(DISTINCT PCH.Student_Number)
FROM PCH
INNER JOIN BC
ON (PCH.student_number = BC.Student_number)
WHERE ((BC.Course_Number = 341 AND BC.Grade_level = 10) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 9))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
--AND q1.Term_ID = 3101
GROUP BY PCH.fall_year, PCH.Grade_Level, BC.grade
ORDER BY PCH.fall_year, PCH.Grade_Level, BC.grade;

--selecting students who jump 337 to 341
SELECT PCH.fall_year, PCH.Grade_level, BC.grade_level,	
	COUNT(DISTINCT PCH.Student_Number),
	ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY PCH.fall_year), 2)
FROM PCH
INNER JOIN BC
ON (PCH.student_number = BC.Student_number)
WHERE (BC.Course_Number = 341 AND BC.Grade_level = 10 AND PCH.Course_Number = 337 AND PCH.Grade_level = 9)
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
AND BC.Store_code = 'S1' AND PCH.store_code = 'S1'
GROUP BY PCH.fall_year, PCH.Grade_Level, BC.grade_level
ORDER BY PCH.fall_year, PCH.Grade_Level;

--merging into new table for 337 to 341
SELECT PCH.student_number, PCH.class_of, PCH.last_first, PCH.course_number AS PCHcourse, PCH.grade_level AS PCHgrade_level, PCH.grade AS PCHgrade, PCH.fall_year AS PCHfall_year,
BC.fall_year AS BCfall_year, BC.grade_level AS BCgrade_level, BC.course_number AS BCcourse, BC.grade AS BCgrade
--INTO PCHTOBC
FROM PCHS1 AS PCH
INNER JOIN BCS1 AS BC
ON (PCH.student_number = BC.Student_number)
WHERE ((BC.Course_Number = 341 AND BC.Grade_level = 10 AND PCH.Course_Number = 337 AND PCH.Grade_level = 9))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
;

--Overall numbers by fall of PCH year
SELECT PCH.fall_year,	
	COUNT(DISTINCT PCH.Student_Number)
FROM PCHS1 AS PCH
INNER JOIN BCS1 AS BC
ON (PCH.student_number = BC.Student_number)
WHERE ((BC.Course_Number = 341 AND BC.Grade_level = 10 AND PCH.Course_Number = 337 AND PCH.Grade_level = 9))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
GROUP BY PCH.fall_year
ORDER BY PCH.fall_year;

--Overall number by PCH grade level
SELECT PCH.Grade_level,	
	COUNT(DISTINCT PCH.Student_Number),
	ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2)
FROM PCHS1 AS PCH
INNER JOIN BCS1 AS BC
ON (PCH.student_number = BC.Student_number)
WHERE ((BC.Course_Number = 341 AND BC.Grade_level = 10 AND PCH.Course_Number = 337 AND PCH.Grade_level = 9))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
GROUP BY PCH.Grade_Level
ORDER BY PCH.Grade_Level;

--Overall numbers with fall year and grade levels
SELECT PCH.fall_year, PCH.Grade_level, BC.grade_level,	
	COUNT(DISTINCT PCH.Student_Number),
	ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY PCH.fall_year), 2)
FROM PCHS1 AS PCH
INNER JOIN BCS1 AS BC
ON (PCH.student_number = BC.Student_number)
WHERE ((BC.Course_Number = 341 AND BC.Grade_level = 10 AND PCH.Course_Number = 337 AND PCH.Grade_level = 9))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 11) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 10))
OR ((BC.Course_Number = 341 AND BC.Grade_level = 12) AND (PCH.Course_Number = 337 AND PCH.Grade_level = 11))
GROUP BY PCH.fall_year, PCH.Grade_Level, BC.grade_level
ORDER BY PCH.fall_year, PCH.Grade_Level;

--overall with fall PCH, grade levels, and grades
SELECT PCHfall_year, PCHgrade_level, 
	(CASE
	WHEN PCHGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN PCHGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN PCHGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN PCHGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN PCHGrade IN ('F') THEN 'F' END) AS "Grade in PCH", 
	(CASE
	WHEN BCGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN BCGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN BCGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN BCGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN BCGrade IN ('F') THEN 'F' END) AS "Grade in BC",
	COUNT(student_number), ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY PCHfall_year, PCHgrade_level), 2)
FROM PCHTOBC
GROUP BY PCHfall_year, PCHgrade_level, 
	(CASE
	WHEN PCHGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN PCHGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN PCHGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN PCHGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN PCHGrade IN ('F') THEN 'F' END), 
	(CASE
	WHEN BCGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN BCGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN BCGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN BCGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN BCGrade IN ('F') THEN 'F' END)
ORDER BY PCHfall_year, PCHgrade_level, 
	(CASE
	WHEN PCHGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN PCHGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN PCHGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN PCHGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN PCHGrade IN ('F') THEN 'F' END), 
	(CASE
	WHEN BCGrade IN ('A+', 'A', 'A-') THEN 'A' 
	WHEN BCGrade IN ('B+', 'B', 'B-') THEN 'B' 
	WHEN BCGrade IN ('C+', 'C', 'C-') THEN 'C' 
	WHEN BCGrade IN ('D+', 'D', 'D-') THEN 'D' 
	WHEN BCGrade IN ('F') THEN 'F' END);

-- what is course 113?
SELECT * FROM grades WHERE course_number = 113;

-- all core courses
SELECT course_number, course_name FROM grades WHERE course_number BETWEEN 100 AND 700
GROUP BY course_number, course_name ORDER BY course_number;

-- percent of freshmen into which math course?
SELECT class_of, course_number, COUNT(*), ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY class_of), 2) FROM grades WHERE course_number IN(310, 320, 321, 331, 337) AND grade_level = 9
GROUP BY class_of, course_number ORDER BY class_of DESC, course_number;

-- percent of frosh students in A2H or PCH by grade
SELECT course_number, grade, COUNT(*), ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY course_number), 2) FROM q1grades WHERE grade_level = 9 AND course_number IN(331, 337)
GROUP BY course_number, grade ORDER BY course_number, grade;

-- grades for BC
SELECT grade, COUNT(*) FROM q1grades 
WHERE course_number = 341 AND grade_level IN (9, 10, 11) GROUP BY grade;

-- kids in A1
SELECT DISTINCT student_number, class_of 
INTO A1 FROM grades WHERE course_number = 310;

DROP TABLE A1;

-- A1 kids in A2 and chem
SELECT A1.student_number, g.course_number, g.store_code, g.grade
FROM A1
INNER JOIN grades AS g
ON (A1.student_number = g.student_number)
WHERE g.course_number IN (330, 331, 366, 530, 531)
GROUP BY A1.student_number, g.course_number, g.store_code, g.grade
ORDER BY A1.student_number;

-- how did A1 kids do in A2 and chem
SELECT A1.class_of, g.grade_level,
ROUND((AVG(CASE WHEN g.course_number IN (330, 331, 366) THEN g.gpa_point END)), 2) AS "A2 GPA",
ROUND((AVG(CASE WHEN g.course_number IN (530, 531) THEN g.gpa_point END)), 2) AS "Chem GPA"
FROM A1
INNER JOIN grades AS g
ON (A1.student_number = g.student_number)
GROUP BY A1.class_of, g.grade_level
ORDER BY A1.class_of;

-- A1 to chem
SELECT * FROM grades AS g
INNER JOIN A1
ON (A1.student_number = g.student_number)
WHERE g.class_of = 2023 AND g.course_number IN (530, 531);

-- kids in A1 to chem as sophomore
SELECT g.class_of, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN A1
ON (A1.student_number = g.student_number)
WHERE g.grade_level = 10 AND g.course_number IN (530, 531)
GROUP BY g.class_of;

-- grades for APES by grade level
SELECT g.class_of, 
ROUND((AVG(CASE WHEN g.grade_level = 11 THEN g.gpa_point END)), 2) AS "11th grader GPA",
ROUND((AVG(CASE WHEN g.grade_level = 12 THEN g.gpa_point END)), 2) AS "12th grader GPA"
FROM grades AS g
INNER JOIN APES
ON (APES.student_number = g.student_number)
GROUP BY g.class_of;

-- AP score and gpa by grade level APES
SELECT g.class_of, 
ROUND((AVG(CASE WHEN g.grade_level = 11 THEN APESAP.SCORE END)), 2) AS "11th grader GPA",
ROUND((AVG(CASE WHEN g.grade_level = 12 THEN APESAP.SCORE END)), 2) AS "12th grader GPA",
ROUND((AVG(CASE WHEN g.grade_level = 11 THEN g.gpa_point END)), 2) AS "11th grader GPA",
ROUND((AVG(CASE WHEN g.grade_level = 12 THEN g.gpa_point END)), 2) AS "12th grader GPA"
FROM grades AS g
INNER JOIN APESAP
ON (APESAP.student_number = g.student_number)
WHERE g.course_number = 545
GROUP BY g.class_of;

--GPA in APES
SELECT class_of, AVG(gpa_point) FROM grades WHERE course_number = 545
GROUP BY class_of;

CREATE TABLE APESAP
(student_number INT,
YEAR INT,
TEST_ID INT,
SCORE INT,
PRIMARY KEY (student_number));

--query for 531 to 541 GL 10 to 11
SELECT student_number, grade_level, course_number, class_of INTO chemh10 FROM grades WHERE grade_level = 10 AND course_number = 531 AND store_code = 'S1';

SELECT student_number, grade_level, course_number, class_of INTO bioAP11 FROM grades WHERE grade_level = 11 AND course_number = 541 AND store_code = 'S1';

SELECT student_number, grade_level, course_number, class_of INTO bioH11 FROM grades WHERE grade_level = 11 AND course_number = 521 AND store_code = 'S1';

SELECT student_number, grade_level, course_number, class_of INTO bioH10 FROM grades WHERE grade_level = 10 AND course_number = 521 AND store_code = 'S1';

SELECT student_number, grade_level, course_number, class_of INTO chemh11 FROM grades WHERE grade_level = 11 AND course_number = 531 AND store_code = 'S1';

-- jumps from chem to bio
SELECT c.student_number, c.grade_level AS chem_grade, c.course_number AS chem_number, b.grade_level AS bio_grade, b.course_number AS bio_number, c.class_of
INTO chemhTObioAP
FROM chemh10 AS c 
INNER JOIN bioAP11 b
ON (c.student_number = b.student_number);

SELECT c.student_number, c.grade_level AS chem_grade, c.course_number AS chem_number, b.grade_level AS bio_grade, b.course_number AS bio_number, c.class_of
INTO chemhTObioH
FROM chemh10 AS c 
INNER JOIN bioH11 b
ON (c.student_number = b.student_number);

SELECT c.student_number, c.grade_level AS chem_grade, c.course_number AS chem_number, b.grade_level AS bio_grade, b.course_number AS bio_number, c.class_of
INTO biohTOchemh
FROM chemh11 AS c 
INNER JOIN bioH10 b
ON (c.student_number = b.student_number);

SELECT class_of, COUNT(student_number)
FROM chemhTObioAP
GROUP BY class_of
ORDER BY class_of;


CREATE TABLE APscores
	(Student_Number INT NOT NULL,
	 Class_Of INT,
	 Last VARCHAR,
	 First VARCHAR,
	 exam_year INT,
	 exam_code INT,
	 exam_grade INT,
	 PRIMARY KEY (student_number, exam_code, exam_year)
	 );

CREATE TABLE APtests
	(exam_code INT,
	course VARCHAR,
	PRIMARY KEY (exam_code)
	);

	SELECT * FROM q1grades;

SELECT student_number, last_first, grade_level, course_name
FROM q1grades WHERE course_number BETWEEN 700 AND 715;

SELECT student_number, course_number INTO chem10 FROM grades 
WHERE course_number = 530 AND grade_level = 10 AND store_code = 'S1';

--chemH 10th to bio level
SELECT g.class_of, g.course_number, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN chemh10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number IN (520, 521, 541) AND g.grade_level = 11
GROUP BY g.class_of, g.course_number;

--chemH 10th to bio level
SELECT g.class_of, g.course_number, COUNT(DISTINCT g.student_number) FROM q1grades AS g
INNER JOIN chemh10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number IN (520, 521, 541) AND g.grade_level = 11
GROUP BY g.class_of, g.course_number;

-- chem 10th to bio level
SELECT g.class_of, g.course_number, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN chem10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number IN (520, 521, 541) AND g.grade_level = 11
GROUP BY g.class_of, g.course_number;

-- chem 10th to bio level
SELECT g.class_of, g.course_number, COUNT(DISTINCT g.student_number) FROM q1grades AS g
INNER JOIN chem10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number IN (520, 521, 541) AND g.grade_level = 11
GROUP BY g.class_of, g.course_number;

SELECT student_number, course_number INTO bioorbioh10 FROM grades
WHERE course_number IN (520, 521) AND grade_level = 10;

--bioh or bio 10th to chem h
SELECT g.class_of, ch.course_number, g.course_number, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN bioorbioh10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number = 531 AND g.grade_level = 11
GROUP BY g.class_of, ch.course_number, g.course_number;

--bioh or bio 10th to chem h
SELECT g.class_of, ch.course_number, COUNT(DISTINCT g.student_number) FROM q1grades AS g
INNER JOIN bioorbioh10 AS ch
ON(g.student_number = ch.student_number)
WHERE g.course_number = 531 AND g.grade_level = 11
GROUP BY g.class_of, ch.course_number;

SELECT DISTINCT b.student_number FROM bioorbioh10 AS b
INNER JOIN q1grades AS q1
ON (q1.student_number = b.student_number)
WHERE q1.class_of = 2023 AND q1.course_number = 531 AND q1.grade_level = 11;


SELECT student_number, course_number INTO bioAP11 FROM grades
WHERE course_number = 541 AND grade_level = 11 AND store_code = 'S1';

--bioAP 11th to APES
SELECT g.class_of, b.course_number, g.course_number, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN bioAP11 AS b
ON(g.student_number = b.student_number)
WHERE g.course_number = 545 AND g.grade_level = 12
GROUP BY g.class_of, b.course_number, g.course_number;

--bioAP 11th to APES
SELECT g.class_of, b.course_number, COUNT(DISTINCT g.student_number) FROM q1grades AS g
INNER JOIN bioAP11 AS b
ON(g.student_number = b.student_number)
WHERE g.course_number = 545 AND g.grade_level = 12
GROUP BY g.class_of, b.course_number;

--students who took bio AP as juniors who took apes as senior
INSERT INTO bioaptoapes
SELECT DISTINCT g.student_number FROM q1grades AS g
INNER JOIN bioAP11 AS b
ON(g.student_number = b.student_number)
WHERE g.course_number = 545 AND g.grade_level = 12;

SELECT * FROM bioaptoapes
ORDER BY student_number DESC;


-- kids who take APES as senior from BIO AP
SELECT g.student_number, SUM(CASE WHEN (g.course_number BETWEEN 500 AND 600 AND g.grade_level = 12) THEN 1 ELSE 0 END)
FROM q1grades AS g
INNER JOIN bioaptoapes AS b
ON(g.student_number = b.student_number)
GROUP BY g.student_number
ORDER BY SUM(CASE WHEN (g.course_number BETWEEN 500 AND 600 AND g.grade_level = 12 AND g.store_code = 'S1') THEN 1 ELSE 0 END) DESC;

SELECT * FROM grades WHERE student_number = 221414 AND course_number BETWEEN 500 AND 600 AND grade_level = 12;

-- math for 11th graders in Bio AP
SELECT g.course_name, COUNT(DISTINCT g.student_number) FROM grades AS g
INNER JOIN bioAP11 AS b
ON (g.student_number = b.student_number)
WHERE g.course_number BETWEEN 300 AND 400 AND g.grade_level = 11
GROUP BY g.course_name;

SELECT * FROM aptests;

SELECT * FROM grades;

-- AP score schema
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='apscores';


--achievement on AP bio
SELECT s.exam_grade, s.exam_year, g.grade_level, COUNT(*) FROM apscores AS s 
INNER JOIN grades AS g
ON (s.student_number = g.student_number)
WHERE s.exam_code = 20 AND g.course_number = 541 AND g.store_code = 'S1'
GROUP BY s.exam_year, s.exam_grade, g.grade_level
ORDER BY s.exam_year, s.exam_grade, g.grade_level;

--AP scores
SELECT g.class_of, g.grade_level, ROUND(CAST(AVG(g.percent_grade)AS NUMERIC), 2) AS "Ave percent", ROUND(AVG(g.gpa_point), 2) AS "Ave GPA", ROUND(AVG(ts.exam_grade), 2) AS "Ave AP score", COUNT(ts.student_number) AS "Number of Tests" FROM grades AS g
INNER JOIN apscores AS ts
ON (g.student_number = ts.student_number)
WHERE g.course_number = 545 AND g.store_code = 'S1' AND ts.exam_code = 40
GROUP BY g.class_of, g.grade_level
ORDER BY g.class_of, g.grade_level;

--count of students in chem as sophomore
SELECT COUNT(*) FROM q1grades WHERE course_number = 530 AND grade_level = 10;

-- broken out by grade
SELECT class_of, COUNT(*) FROM grades WHERE course_number = 530 AND grade_level = 10
GROUP BY class_of;

DROP TABLE apesap;

SELECT student_number INTO APESAP FROM apscores WHERE exam_code = 40;

-- student AP count who took APES
SELECT ts.student_number, COUNT(ts.exam_code) INTO APcount
FROM apesap AS g
INNER JOIN apscores AS ts
ON (g.student_number = ts.student_number)
GROUP BY ts.student_number;

SELECT * FROM grades WHERE student_number = 218419;

SELECT count AS c, COUNT(student_number) FROM apcount
GROUP BY c
ORDER BY c DESC;


CREATE TABLE college (
	lastfirst VARCHAR,
	GPA REAL,
	high_SAT_CR INT,
	high_SAT_math INT,
	high_SAT_W INT,
	high_SAT_1600 INT,
	high_SAT_2400 INT,
	high_ACT INT,
	student_number INT,
	college VARCHAR,
	admission_type VARCHAR,
	decision VARCHAR,
	attending INT,
	class_of INT,
	PRIMARY KEY (student_number, college, attending)
);


--college admission stats
SELECT class_of, college, 
SUM(CASE WHEN decision = 'Accepted' THEN 1 ELSE 0 END), 
COALESCE(ROUND(100 * SUM(CASE WHEN decision = 'Accepted' THEN 1 END) / SUM(COUNT(*)) OVER(PARTITION BY class_of, college), 2), 0) AS percent_admit,
SUM(COUNT(*)) OVER(PARTITION BY class_of, college) AS applied
FROM college
GROUP BY class_of, college
--ORDER BY college, class_of;
ORDER BY percent_admit ASC, applied DESC;