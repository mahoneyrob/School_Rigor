 -- A2H to PC/PCH
SELECT com.class_of, COUNT(DISTINCT com.student_number) AS total_students,
       SUM(com.PCH) AS total_PCH, 
	   SUM(com.PC) AS total_PC,
	   COUNT(DISTINCT com.student_number) - SUM(com.PCH) - SUM(com.PC) AS no_PC,
	   ROUND(100.0 * SUM(com.PCH) / COUNT(DISTINCT com.student_number), 2) AS percent_PCH,
	   ROUND(100.0 * SUM(com.PC) / COUNT(DISTINCT com.student_number), 2) AS percent_PC,
	   ROUND(100.0 * (SUM(com.PCH) + SUM(com.PC)) / COUNT(DISTINCT com.student_number), 2) AS percent_PCH_or_PC
  FROM (SELECT A2.class_of, A2.student_number,
  		  	    CASE WHEN PC.course_number = 337 THEN 1
      	  	    ELSE 0 
                 END AS PCH,
  		        CASE WHEN PC.course_number = 338 THEN 1
                ELSE 0 
   		         END AS PC
		  FROM (SELECT student_number, 
				       class_of, 
				       fall_year 
            	  FROM grades
         		 WHERE course_number = 331 AND store_code = 'S1' AND fall_year <> 2021 AND grade_level <> 12) AS A2
  		  LEFT JOIN (SELECT student_number, 
					        fall_year, 
				            course_number
	      	           FROM grades
	     		      WHERE course_number IN(337, 338) AND store_code = 'S1') AS PC
            ON (PC.student_number = A2.student_number)) AS com
 WHERE com.class_of NOT IN(2024)
 GROUP BY com.class_of
 ORDER BY com.class_of;

-- PC to calc 
SELECT com.class_of, 
       SUM(com.AB) AS total_AB, 
	   SUM(com.HSC) AS total_HS, 
	   ROUND(AVG(com.AB_GPA), 2) AS GPA_in_AB,
	   ROUND(AVG(com.HSC_GPA), 2) AS GPA_in_HSC,
	   SUM(com.not_calc) AS total_not_calc, 
	   ROUND(100.0 * SUM(com.AB) / (SUM(com.AB) + SUM(com.HSC) + SUM(com.not_calc)), 2) AS percent_AB
  FROM (SELECT PC.class_of,
		  		CASE WHEN AB.course_number = 339 THEN AB.gpa_point
      	  	   ELSE NULL 
                END AS AB_GPA,  		  	   
				CASE WHEN AB.course_number = 340 THEN AB.gpa_point
      	  	   ELSE NULL 
                END AS HSC_GPA,
  		  	   CASE WHEN AB.course_number = 339 THEN 1
      	  	   ELSE 0 
                END AS AB,
				CASE WHEN AB.course_number = 340 THEN 1
      	  	   ELSE 0 
                END AS HSC,
  		       CASE WHEN AB.course_number IS NULL THEN 1
               ELSE 0 
   		        END AS not_calc
  		  FROM (SELECT student_number, 
				       class_of, 
				       fall_year 
            	  FROM grades
         		 WHERE course_number = 338 AND store_code = 'S1' AND grade_level <> 12) AS PC
  		  LEFT JOIN (SELECT student_number, 
					   fall_year, 
				       course_number,
					   GPA_point
	      	      FROM grades
	     		 WHERE course_number IN(339, 340) AND store_code = 'S1') AS AB
            ON (PC.student_number = AB.student_number)) AS com
 WHERE com.class_of NOT IN(2024)
 GROUP BY com.class_of
 ORDER BY com.class_of;