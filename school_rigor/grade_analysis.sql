CREATE TABLE grades
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
	 Exclude_Transcripts BOOLEAN,
	 Term_ID INT,
	 PRIMARY KEY (student_number, Course_Number, Store_Code, Term_ID)
	 );

     SELECT Grade, Teacher, Percent_Grade, COUNT(student_number) FROM grades
WHERE (Grade IN ('A+', 'A', 'A-')) AND (Percent_Grade < 89.5)
GROUP BY Grade, Teacher, Percent_Grade
ORDER BY teacher;

--count grades by teacher
SELECT Teacher, Grade, COUNT(Student_Number) FROM grades
WHERE (Grade IN ('A+', 'A', 'A-') AND (Percent_Grade < 89.5)) OR
(Grade IN ('B+', 'B', 'B-') AND (Percent_Grade NOT BETWEEN 79.5 AND 89.5)) OR
(Grade IN ('C+', 'C', 'C-') AND (Percent_Grade NOT BETWEEN 69.5 AND 79.5)) OR
(Grade IN ('D+', 'D', 'D-') AND (Percent_Grade NOT BETWEEN 59.5 AND 69.5))
GROUP BY Teacher, Grade
ORDER BY COUNT(Student_Number) DESC;

--students who got a bump
SELECT Student_Number, Grade, Percent_Grade FROM grades
WHERE (Grade IN ('A+', 'A', 'A-') AND (Percent_Grade < 89.5)) AND (Teacher LIKE ('%vid'))
ORDER BY percent_grade DESC;

--students who got bump by teacher
SELECT Teacher, (Grade IN ('A+', 'A', 'A-') AND (Percent_Grade < 89.5)) AS A, COUNT(CASE WHEN (Percent_Grade >= 88.5 AND Percent_Grade < 89.5) THEN 1 END) AS [88.5 - 89.5], 
COUNT(CASE WHEN Percent_Grade (Percent_Grade >= 86.5 AND Percent_Grade < 88.5) THEN 1 END) AS [86.5 - 88.5]
FROM grades
WHERE (Grade IN ('A+', 'A', 'A-') AND (Percent_Grade < 89.5));

--bump for all grades, not just A's
SELECT Teacher, Grade,
COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') AND Percent_Grade >= 88.5 AND Percent_Grade < 89.5 THEN 1 END) AS "88.5 - 89.5",
COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') AND Percent_Grade >= 86.5 AND Percent_Grade < 88.5 THEN 1 END) AS "86.5 - 88.5",
COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') AND Percent_Grade >= 80 AND Percent_Grade < 86.5 THEN 1 END) AS "80 - 86.5",
COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') AND Percent_Grade < 80 THEN 1 END) AS "0 - 80",
COUNT(CASE WHEN Grade IN ('B+', 'B', 'B-') AND Percent_Grade >= 89.5 THEN 1 END) AS "Above 89.5",
COUNT(CASE WHEN Grade IN ('B+', 'B', 'B-') AND Percent_Grade >= 78.5 AND Percent_Grade < 79.5 THEN 1 END) AS "78.5 - 79.5",
COUNT(CASE WHEN Grade IN ('B+', 'B', 'B-') AND Percent_Grade >= 75 AND Percent_Grade < 78.5 THEN 1 END) AS "75 - 78.5",
COUNT(CASE WHEN Grade IN ('B+', 'B', 'B-') AND Percent_Grade < 75 THEN 1 END) AS "0 - 75",
COUNT(CASE WHEN Grade IN ('C+', 'C', 'C-') AND Percent_Grade >= 79.5 THEN 1 END) AS "Above 79.5",
COUNT(CASE WHEN Grade IN ('C+', 'C', 'C-') AND Percent_Grade >= 68.5 AND Percent_Grade < 69.5 THEN 1 END) AS "68.5 - 69.5",
COUNT(CASE WHEN Grade IN ('C+', 'C', 'C-') AND Percent_Grade >= 65 AND Percent_Grade < 68.5 THEN 1 END) AS "65 - 68.5",
COUNT(CASE WHEN Grade IN ('C+', 'C', 'C-') AND Percent_Grade < 65 THEN 1 END) AS "0 - 65",
COUNT(CASE WHEN Grade IN ('D+', 'D', 'D-') AND Percent_Grade >= 69.5 THEN 1 END) AS "Above 69.5",
COUNT(CASE WHEN Grade IN ('D+', 'D', 'D-') AND Percent_Grade >= 58.5 AND Percent_Grade < 59.5 THEN 1 END) AS "58.5 - 59.5",
COUNT(CASE WHEN Grade IN ('D+', 'D', 'D-') AND Percent_Grade >= 55 AND Percent_Grade < 58.5 THEN 1 END) AS "55 - 58.5",
COUNT(CASE WHEN Grade IN ('D+', 'D', 'D-') AND Percent_Grade < 55 THEN 1 END) AS "0 - 55"
FROM grades
WHERE (Grade IN ('A+', 'A', 'A-') AND (Percent_Grade < 89.5)) OR
(Grade IN ('B+', 'B', 'B-') AND (Percent_Grade NOT BETWEEN 79.5 AND 89.5)) OR
(Grade IN ('C+', 'C', 'C-') AND (Percent_Grade NOT BETWEEN 69.5 AND 79.5)) OR
(Grade IN ('D+', 'D', 'D-') AND (Percent_Grade NOT BETWEEN 59.5 AND 69.5))
GROUP BY Teacher, Grade
HAVING COUNT(Teacher) > 20
ORDER BY Teacher, Grade;

--percent A's by course and teacher
SELECT Course_Number, Teacher, (COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') THEN 1 END)) * 100 / COUNT(*) AS Percent_A, ROUND(AVG(GPA_Point),2) AS GPA
FROM grades
WHERE Course_Number NOT IN(870, 719, 920, 576, 115)
--AND Teacher LIKE '%TEACHER LAST NAME HERE%'
--AND Course_Number BETWEEN 200 AND 300 OR Course_Number = 115
--Course_Number = 519
GROUP BY Course_Number, Teacher
ORDER BY Course_Number, (COUNT(CASE WHEN Grade IN ('A+', 'A', 'A-') THEN 1 END)) * 100 / COUNT(*) DESC;

-- teacher count by grade
SELECT Teacher, Grade, COUNT(Grade)
FROM grades
WHERE Teacher LIKE '%NAME%'
GROUP BY Teacher, Grade;


SELECT *
FROM grades
WHERE Teacher = 'NAME' OR Teacher = 'NAME'
--AND Course_Number BETWEEN 500 AND 600
ORDER BY course_number;

-- all grades for Science
SELECT *
FROM grades
WHERE 
--Teacher LIKE '%TEACHER NAME HERE%'
Course_Number = 548
--AND Course_Number BETWEEN 500 AND 600
ORDER BY course_number;

-- table for courses
SELECT Course_Number, Course_Name FROM grades
GROUP BY Course_Number, Course_Name
ORDER BY Course_Number;

CREATE TABLE courses(
	Course_Number INT,
	Course_Name VARCHAR,
	Dept INT,
	level INT,
	PRIMARY KEY (Course_Number, Course_Name));
	
-- grades by department	
SELECT c.Dept, 
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
WHERE (CASE 
		WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
		WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
		WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
		WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
		WHEN g.Grade IN ('F') THEN 'F'	
		END) IS NOT NULL
		AND c.Dept < 7
GROUP BY c.Dept, CASE 
		WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
		WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
		WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
		WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
		WHEN g.Grade IN ('F') THEN 'F'		
		END
ORDER BY c.Dept, CASE 
		WHEN g.Grade IN ('A+', 'A', 'A-') THEN 'A' 
		WHEN g.Grade IN ('B+', 'B', 'B-') THEN 'B' 
		WHEN g.Grade IN ('C+', 'C', 'C-') THEN 'C' 
		WHEN g.Grade IN ('D+', 'D', 'D-') THEN 'D' 
		WHEN g.Grade IN ('F') THEN 'F'	
		END;

-- grades by department, teacher, and course
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
	AND c.Dept < 10
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

SELECT COUNT(PSID) FROM grades WHERE Course_Number = 545;

-- percent of students in certain grade level by course
SELECT grade_level, ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) FROM grades WHERE Course_Number = 735
GROUP BY grade_level;

-- students who go from Chem H to AP physics
SELECT q1.Course_Number, q.Course_Number, q1.Grade_level, COUNT(DISTINCT q1.Student_Number) FROM q1grades AS q1
LEFT JOIN grades AS q
ON (q1.PSID = q.PSID)
WHERE q1.Course_Number = 552 AND q.Course_Number = 531 AND q1.Term_ID = 3101 AND q1.grade_level = 12
GROUP BY q1.Course_Number, q.Course_Number, q1.Grade_Level
ORDER BY q1.Course_Number;

SELECT * FROM q1grades WHERE course_Number = 541;

-- course and teacher grade, GPA, percent breakdown
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
COUNT(DISTINCT g.SectionID) AS Sections,
COUNT(DISTINCT g.Student_Number) AS Students,
CAST((COUNT(DISTINCT g.PSID) / COUNT(DISTINCT g.SectionID)) AS DECIMAL(4, 2)) AS avg_students
FROM q1grades AS g
LEFT JOIN courses AS c
ON (g.course_Name = c.course_name)
--WHERE
--c.course_number NOT IN (9115, 9111, 773, 774)
--c.dept = 5
--Course_Number NOT IN(870, 719, 920, 576, 115)
--g.Course_Number BETWEEN 100 AND 200
GROUP BY 
g.Course_Number,
g.Teacher
ORDER BY g.Course_Number, (COUNT(CASE WHEN g.Grade IN ('A+', 'A', 'A-') THEN 1 END)) * 100 / COUNT(*) DESC;