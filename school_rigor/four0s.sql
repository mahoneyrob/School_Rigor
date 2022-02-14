--output of all years weighted

WITH students AS (
	SELECT g.*, c.added
	FROM grades g
	JOIN courses c
	  ON (g.course_number = c.course_number)
),
	gpasall AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of
),
	four0all AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpasall
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
	gpas9s1 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 9 AND store_code = 'S1' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of
),
	total9s1 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas9s1
	 GROUP BY class_of
),
	four09s1 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas9s1
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
	gpas9s2 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 9 AND store_code = 'S2' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of

),
	total9s2 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas9s2
	 GROUP BY class_of
),
	four09s2 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas9s2
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
    all9 AS (
                SELECT ts19.class_of, four09s1.fours, ts19.totals, ROUND(100.0 * four09s1.fours / ts19.totals, 1),
				   four09s2.fours, ts29.totals, ROUND(100.0 * four09s2.fours / ts29.totals, 1)
                FROM total9s1 ts19
                JOIN four09s1
                  ON (ts19.class_of = four09s1.class_of)
                  LEFT JOIN total9s2 ts29
                    ON (ts19.class_of = ts29.class_of)
                  LEFT JOIN four09s2
                    ON (ts19.class_of = four09s2.class_of)
                 ORDER BY ts19.class_of
),

	gpas10s1 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 10 AND store_code = 'S1' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of
),
	total10s1 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas10s1
	 GROUP BY class_of
),
	four010s1 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas10s1
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
	gpas10s2 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 10 AND store_code = 'S2' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of

),
	total10s2 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas10s2
	 GROUP BY class_of
),
	four010s2 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas10s2
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
    all10 AS (
                SELECT ts1.class_of, four010s1.fours AS "10 S1 4.0", ts1.totals AS "10 S1 students", ROUND(100.0 * four010s1.fours / ts1.totals, 1),
				   four010s2.fours, ts2.totals, ROUND(100.0 * four010s2.fours / ts2.totals, 1)                
                   FROM total10s1 ts1
                JOIN four010s1
                  ON (ts1.class_of = four010s1.class_of)
                  LEFT JOIN total10s2 ts2
                    ON (ts1.class_of = ts2.class_of)
                  LEFT JOIN four010s2
                    ON (ts1.class_of = four010s2.class_of)
                 ORDER BY ts1.class_of
),

	gpas11s1 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 11 AND store_code = 'S1' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of
),
	total11s1 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas11s1
	 GROUP BY class_of
),
	four011s1 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas11s1
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
	gpas11s2 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	WHERE grade_level = 11 AND store_code = 'S2' AND grade NOT IN('CR', 'P')
	GROUP BY student_number, class_of

),
	total11s2 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas11s2
	 GROUP BY class_of
),
	four011s2 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas11s2
 	WHERE wgpa >= 4
 	GROUP BY class_of
),
    all11 AS (
                SELECT ts1.class_of, four011s1.fours, ts1.totals, ROUND(100.0 * four011s1.fours / ts1.totals, 1),
				   four011s2.fours, ts2.totals, ROUND(100.0 * four011s2.fours / ts2.totals, 1)
                FROM total11s1 ts1
                JOIN four011s1
                  ON (ts1.class_of = four011s1.class_of)
                  LEFT JOIN total11s2 ts2
                    ON (ts1.class_of = ts2.class_of)
                  LEFT JOIN four011s2
                    ON (ts1.class_of = four011s2.class_of)
                 ORDER BY ts1.class_of
),

	gpas12s1 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	 WHERE grade_level = 12 AND store_code = 'S1' AND grade NOT IN('CR', 'P')
	 GROUP BY student_number, class_of
),
	total12s1 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas12s1
	 GROUP BY class_of
),
	four012s1 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas12s1
 	 WHERE wgpa >= 4
 	 GROUP BY class_of
),
	gpas12s2 AS (
	SELECT student_number, class_of, AVG(gpa_point + added) wgpa FROM students
	 WHERE grade_level = 12 AND store_code = 'S2' AND grade NOT IN('CR', 'P')
	 GROUP BY student_number, class_of

),
	total12s2 AS (
	SELECT class_of, COUNT(DISTINCT student_number) totals
	  FROM gpas12s2
	 GROUP BY class_of
),
	four012s2 AS (
	SELECT class_of, COUNT(*) fours
  	FROM gpas12s2
 	 WHERE wgpa >= 4
 	 GROUP BY class_of
),
    all12 AS (
                SELECT ts1.class_of, four012s1.fours AS "12 S1 4.0", ts1.totals AS "12 S1 students", ROUND(100.0 * four012s1.fours / ts1.totals, 1),
				   four012s2.fours, ts2.totals, ROUND(100.0 * four012s2.fours / ts2.totals, 1)                
                   FROM total12s1 ts1
                JOIN four012s1
                  ON (ts1.class_of = four012s1.class_of)
                  LEFT JOIN total12s2 ts2
                    ON (ts1.class_of = ts2.class_of)
                  LEFT JOIN four012s2
                    ON (ts1.class_of = four012s2.class_of)
                 ORDER BY ts1.class_of
),
	allyears AS (
				SELECT four0all.class_of, four0all.fours
				FROM four0all
				ORDER BY four0all.class_of
	)

SELECT a9.*, a10.*, a11.*, a12.*, ay.fours, ROUND((100.0 * ay.fours / a12.totals), 1)
  FROM all9 a9
  LEFT JOIN all10 a10
    ON (a9.class_of = a10.class_of)
  LEFT JOIN all11 a11
    ON (a9.class_of = a11.class_of)
  LEFT JOIN all12 a12
    ON (a9.class_of = a12.class_of)
  LEFT JOIN allyears ay
    ON (a9.class_of = ay.class_of);


