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
	AND last_name LIKE 'Q%';

SELECT now();

SELECT 765.32 + 13.03;

SELECT first_name, last_name, hire_date
	FROM employees 
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%'
	ORDER BY first_name;

# asc for ascending order
SELECT first_name, last_name, hire_date
	FROM employees 
	WHERE first_name LIKE 'J%'
	AND last_name LIKE 'Q%'
	ORDER BY first_name, hire_date desc;

# use colum index in the select clause
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

# _ => one character
# % => any number of character
SELECT '(987) 654-3210' LIKE '(___)___=____';
SELECT 'TUVWXYZ' LIKE '%DE%';

# REGEXP
SELECT '123' REGEXP '^[0-9]{3}$';
SELECT 'A23' REGEXP '^[0-9]{3}$';

# NULL is the absence of a value (you have to use IS NULL)
SELECT *
	FROM salaries
	WHERE salary IS NULL

SELECT *
	FROM employees
	WHERE reg_voter <> 'Y'
	OR reg_voter IS NULL;

# video 2.04
# -----------
# Inner joins
SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	JOIN dept_emp de
	ON e.emp_no = de.emp_no
	JOIN departments d
	ON de.dept_no = d.dept_no
	WHERE e.hire_date BETWEEN '1985-01-01' AND '1985-01-31'
	AND de.to_date > now();

# same result as above but dufferent way to write it
SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	JOIN dept_emp de
	ON e.emp_no = de.emp_no
	AND de.to_date > now()
	JOIN departments d
	ON de.dept_no = d.dept_no
	WHERE e.hire_date BETWEEN '1985-01-01' AND '1985-01-31';

SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
	AND dm.to_date > now()
	JOIN departments d
	ON dm.dept_no = d.dept_no;

# Outer join
# LEFT => so the left table of the join will be used to define the number of row here is the e.emp_no
SELECT e.first_name, e.last_name, d.dept_name
	FROM employees e
	LEFT OUTER JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
	AND dm.to_date > now()
	LEFT OUTER JOIN departments d
	ON dm.dept_no = d.dept_no;

# RIGHT => so the right table of the join will be used to define the number of row
# not used much
SELECT e.first_name, e.last_name, d.dept_name
	FROM departments d
	RIGHT OUTER JOIN dept_manager dm
	ON dm.dept_no = d.dept_no
	AND dm.to_date > now()
	RIGHT OUTER JOIN employees e
	ON e.emp_no = dm.emp_no;


SELECT concat_ws(' ', e.first_name, e.last_name) employee_nm, d.dept_name, 
concat_ws(' ', mgr.first_name, mgr.last_name) manager_nm
	FROM employees e
	JOIN dept_emp de
	ON de.emp_no = e.emp_no
	AND de.to_date > now()
	JOIN departments d 
	ON de.dept_no = d.dept_no
	JOIN dept_manager dm
	ON dm.dept_no = d.dept_no
	AND dm.to_date > now()
	JOIN employees mgr
	ON dm.emp_no = mgr.emp_no;

# text 2.05
# -----------

# CROSS JOIN




# video 2.06
# -----------

# No duplicate from 2 datasets
SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE hire_date = cast('1998-12-12' as date)
	UNION
	SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE first_name = 'Pranjal'
	AND year(hire_date) = '1998';

# UNION ALL keep the duplicate
SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE hire_date = cast('1998-12-12' as date)
	UNION ALL
	SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE first_name = 'Pranjal'
	AND year(hire_date) = '1998';

# Intersection (overlaping row)
SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE hire_date = cast('1998-12-12' as date)
	INTERSECT
	SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE first_name = 'Pranjal'
	AND year(hire_date) = '1998';

# simulation of intersect since it is missing in mysql
SELECT e1.first_name, e1.last_name, e1.birth_date, e1.hire_date
	FROM employees e1
	INNER JOIN employees e2
	ON e1.first_name = e2.first_name
	AND e1.last_name = e2.last_name
	WHERE e1.hire_date = cast('1998-12-12' as date)
	AND e2.first_name = 'Pranjal'
	AND year(e2.hire_date) = '1998'; 

# Difference
# one set but exculing the overlap from the other set
# Oracle EXCEPT operator
# Sql MINUS operator
# feature missing from mySql

SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE hire_date = cast('1998-12-12' as date)
	MINUS
	SELECT first_name, last_name, birth_date, hire_date
	FROM employees
	WHERE first_name = 'Pranjal'
	AND year(hire_date) = '1998';

# simulation of the minus operator
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
# -----------

# grouping data
SELECT d.dept_name, s.salary
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
ORDER BY d.dept_name, s.salary desc;

SELECT d.dept_name, max(s.salary) highest_salary
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
GROUP BY d.dept_name;

SELECT d.dept_name, max(s.salary) highest_salary
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
GROUP BY d.dept_name;

#function
#max min avg sum count
SELECT d.dept_name, 
	max(s.salary) max_salary,
	min(s.salary) min_salary,
	avg(s.salary) avg_salary,
	sum(s.salary) sum_salary,
	count(s.salary) num_employees
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
GROUP BY d.dept_name;

SELECT d.dept_name, year(e.hire_date) year_hired,
	max(s.salary) max_salary,
	min(s.salary) min_salary
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
GROUP BY d.dept_name, year(e.hire_date)
ORDER BY 1, 2;

SELECT d.dept_name, year(e.hire_date) year_hired,
	max(s.salary) max_salary,
	min(s.salary) min_salary
FROM employees e
	INNER JOIN dept_emp de
		ON de.emp_no = e.emp_no
			AND de.to_date > now()
	INNER JOIN departments d 
		ON de.dept_no = d.dept_no
	INNER JOIN salaries s
		ON s.emp_no = e.emp_no
			AND s.to_date > now()
GROUP BY d.dept_name, year(e.hire_date)
HAVING max(s.salary) - min(s.salary) > 100000
ORDER BY 1, 2;

# WITH ROLLUP
# sub total and grand total

# CUBE
# not available in mySql

# video 2.08
# -----------
# subqueries

SELECT e.first_name, e.last_name, e.hire_date
	FROM employees e 
	WHERE e.hire_date =
		(SELECT max(hire_date)
		FROM employees);

SELECT e.first_name, e.last_name, e.hire_date
	FROM employees e 
	WHERE e.hire_date IN
		(SELECT DISTINCT hire_date
		FROM employees
		WHERE hire_date >= '2000-01-01');

SELECT e.first_name, e.last_name
	FROM employees e 
	WHERE e.emp_no NOT IN
		(SELECT emp_no FROM salaries
		WHERE salary < 125000);

SELECT e.first_name, e.last_name
	FROM employees e
	WHERE (emp_no, hire_date) IN
		(SELECT emp_no, from_date
		FROM salaries
		WHERE salary >= 120000);

# correlated subqueries
SELECT e.first_name, e.last_name
	FROM employees e 
	WHERE EXISTS
		(SELECT 1 FROM titles t 
		WHERE t.emp_no = e.emp_no
			AND t.title = 'Manager');

SELECT e.first_name, e.last_name
	FROM employees e 
	WHERE 3 =
		(SELECT count(distinct title)
		FROM titles t
		WHERE t.emp_no = e.emp_no);


DELETE FROM employees e 
WHERE e.emp_no IN
	(SELECT s.emp_no FROM salaries s 
	GROUP BY s.emp_no
	HAVING max(s.to_date) < now());

# add the column regnisation_date 
ALTER TABLE employees
	AND resignation_date DATE;

UPDATE employees e 
SET e.resignation_date =
	(SELECT max(s.to_date)
	FROM salaries s 
	WHERE s.emp_no = e.emp_no)
WHERE e.emp_no IN
	(SELECT s.emp_no FROM salaries s 
	GROUP BY s.emp_no
	HAVING max(s.to_date) < now());


# video 2.09
# -----------
# Joins using subqueries



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

# video 2.11
# -----------
INSERT INTO department_daily
	(dept_no, daly_dt, dept_name)
	SELECT d.dept_no, '1996-01-02' daly_dt, d.dept_name
	FROM department d;