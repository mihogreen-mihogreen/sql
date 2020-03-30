SELECT emp_no, award_date, award_amount
	FROM employee_awards
	WHERE emp_no = 253406
	AND award_date = str_to_date('2018-07-20','%Y-%m-%d');

DELETE FROM employee_awards
	WHERE emp_no = 253406
	AND award_date = str_to_date('2018-07-20','%Y-%m-%d');

# video 2.02
# -----------
SELECT first_name, last_name, hire_date
	FROM employees
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%';

SELECT concat_ws('', first_name, last_name) as full_name,
	year(hire_date) as hire_year
	FROM employees 
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%'

SELECT first_name, last_name, hire_date
	FROM employees 
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%'
	ORDER BY first_name;

SELECT first_name, last_name, hire_date
	FROM employees
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%'
	ORDER BY 1, 3 desc;

SELECT year(hire_date), count(*)
	FROM employees
	GROUP BY year(hire_date)
	ORDER BY 1;

SELECT year(hire_date), count(*), max(birth_date)
	FROM employees
	GROUP BY year(hire_date)
	ORDER BY 1;

# video 2.03
# -----------
SELECT first_name, last_name, hire_date
	FROM employees
	WHERE length(concat(first_name, last_name)) > 28;

SELECT 1 = 1 AND (9 > 1 OR 5 < 1);
SELECT NOT(5 < 1 AND 1 = 2);
SELECT 1 = 1 AND NOT 5 < 1;
SELECT '(987) 654-3210' LIKE '(___)___=____';
SELECT 'TUVWXYZ' LIKE '%DE%';

SELECT *
FROM employees
WHERE reg_voter <> 'Y'
OR reg_voter IS NULL;

# video 2.04
# -----------
SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	JOIN dept_emp de
	ON e.emp_no = de.emp_no
	JOIN departments d
	ON de.dept_no = d.dept_no
	WHERE e.hire_date BETWEEN '1985-01-01' AND '1985-01-31';
	AND de.to_date > now();


SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	LEFT OUTER JOIN dep_manager dm
	ON e.emp_no = dm.emp_no
	AND dm.to_date > now()
	LEFT OUTER JOIN departments d
	ON dm.dept_no = d.dept_no;


concat_ws('', e.first_name, e.last_name) employee_nm, d.dept_name, 
concat_ws('', mgr.first_name, mgr.last_name) manager_nm
	FROM employees e
	JOIN dept_emp de
	ON de.emp_no = e.emp_no
	AND de.to_date > now()
	JOIN departments d 
	ON de.dept_no = d.dept_no
	JOIN dep_manager dm
	ON dm.dept_no = d.dept_no
	AND dm.to_date > now()
	JOIN employees mgr
	ON dm.emp_no = mgr.emp_no;


# video 2.06;No duplicate from 2 datasets
# -----------
SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE hire_date = cast('1998-12-12' as date)
	UNION
	SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE first_name = 'Pranjal'
	AND year(hire_date) = '1998';

# video 2.06; Intersect
# -----------
SELECT e1.first_name, e1.last_name, e1.birth_date, e1.hire_date
	FROM employees e1
	INNER JOIN employees e2
	ONe1.first_name = e2.first_name
	AND e1.last_name = e2.last_name
	WHERE e1 hire_date = cast('1998-12-12' as date)
	AND e2.first_name = 'Pranjal'
	AND year (e2.hire_date) = '1998'; 

# video 2.06; Difference
# -----------
SELECT e1.first_name, e1.last_name, e1.birth_date, e1.hire_date
	FROM employees e1
	LEFT OUTER JOIN employees e2
	ON e1.first_name = e2.first_name
	AND e1.last_name = e2.last_name
	AND e2.first_name = 'Pranjal'
	AND year(e2.hire_date) = '1998'
	WHERE e1.hire_date = cast('1998-12-12' as date)
	AND e2.first_name IS NULL; 


# video 2.07
# video 2.10
# -----------
SELECT 'Entry-Level' name, 0 min_value, 49999 max_value
	UNION ALL
	SELECT 'Experienced' name, 50000 min_value, 79999 max_value
	UNION ALL 
	SELECT 'Senior-Level' name, 80000 min_value, 999999999 max_value;

WITH salary_ranges AS
	(SELECT 'Entry-Level' name, 0 min_value, 49999 max_value
	UNION ALL
	SELECT 'Experienced' name, 50000 min_value, 79999 max_value
	UNION ALL 
	SELECT 'Senior-Level' name, 80000 min_value, 999999999 max_value)
	SELECT sr.name salary_grouop, count(*) num_employees,
	min(s.salary) min_salary, max(s.salary) max_salary, 
	avg(s.salary) avg_salary
	FROM salaries s
	INNER JOIN salary_ranges sr
	ON s.salary BETWEEN sr.min_value and sr.max_value
	WHERE now() BETWEEN s.from_date AND s.to_date
	GROUP BY sr.name
	ORDER BY sr.min_value;



