-- Both of these codes work perfectly as Database and Schema are used interchangeably
CREATE DATABASE IF NOT EXISTS Sales;
CREATE SCHEMA IF NOT EXISTS Sales;

-- CREATED A TABLE NAMED customers
USE sales;
CREATE TABLE customers (
    customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    number_of_returns INT
);

-- CREATED ANOTHER TABLE CALLED Sales
CREATE TABLE Sales (
    purchase_number INT NOT NULL AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL,
    customer_id INT,
    item_code VARCHAR(10) NOT NULL,
    PRIMARY KEY (purchase_number)
);

-- I USE ALTER COMMAND To configure an existing TABLE "sales" and added a foreign key constraint
ALTER TABLE Sales 
	ADD FOREIGN KEY (customer_id) 
    REFERENCES customers (customer_id) 
		ON DELETE CASCADE;
        
-- To change column "NOT NULL" constraint to "NULL" 
ALTER TABLE Sales 
	CHANGE COLUMN dept_name dept_name VARCHAR( 40 ) NULL;

-- Inserting "dept_no" into the column in the Sales Table
INSERT INTO departments_dup(dept_no) 
	VALUES ("d011"), ("d012");

-- Adding column to the Table
ALTER TABLE employees.departments_dup 
	ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;
commit;

-- IFNULL command to Retrieve the NAMES of all departmets "IFNOTNULL" and display 'Department name not provided' if its NULL
SELECT 
    dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS Department_name
FROM
    departments_dup;
commit;

-- IFNULL and COALESCE COMMAND (TO RETRIEVE THE FIRST NOT NULL VALUE)
SELECT 
    IFNULL(dept_no, 'N/A') AS dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

-- This is to DROP a column named "departments_dup" If it exists in the ‘departments_dup’ TABLE
ALTER TABLE departments_dup
DROP COLUMN dept_manager;
commit;

-- This is to CHANGE A COLUMN "dept_no" from NOT NULL CONTRAINT TO A NULL CONTRAINT in the ‘departments_dup’ TABLE
ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;
 commit;
 
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

# To DROP the departments duplicate Table
DROP TABLE IF EXISTS departments_dup;

-- To create a whole new Table called "departments_dup"
CREATE TABLE departments_dup (
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

-- To duplicate departments_dup Table with all data from departments table
INSERT INTO departments_dup
(    
dept_no,
dept_name
)
	SELECT * FROM departments;

-- Adding department name to department duplicate table
INSERT INTO departments_dup (dept_name)
			VALUES('Public Relations');

-- Deleting dept number d002 from the table
 DELETE FROM departments_dup 
WHERE
    dept_no = 'd002';

-- Adding dept_no values to the dept_no column
INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');
commit;

-- Dropping dept_manager_dup TABLE if it exists
DROP TABLE IF EXISTS dept_manager_dup;

-- Creating dept_manager_dup Table
CREATE TABLE dept_manager_dup (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);
commit;
 
-- To duplicate dept_manager_dup Table with all data from dept_manager table 
INSERT INTO dept_manager_dup
SELECT * FROM dept_manager;
 
-- Inserting VALUES into emp_no and from_date column
INSERT INTO dept_manager_dup 
(emp_no, 
from_date)
VALUES
(999904, 
'2017-01-01'),
(999905, 
'2017-01-01'),
(999906, 
'2017-01-01'),
(999907, 
'2017-01-01');
commit;

-- deleting dept_no d001
DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001';
    
INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_dup 
WHERE
    dept_no = 'd002';
    
-- JOIN was used to combine both "dept_manager_dup" and "departments_dup"
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- INNER JOIN EXERCISE. The GROUP BY clause differs most in the records to avoid duplicate rows
SELECT 
    e.emp_no, e.first_name, e.last_name, e.hire_date, d.dept_no
FROM
    employees e
        INNER JOIN
    dept_manager d ON e.emp_no = d.emp_no
GROUP BY e.emp_no
ORDER BY e.emp_no;

-- LEFT JOIN EXERCISE
SELECT 
    e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager d ON e.emp_no = d.emp_no
WHERE
    e.last_name = 'Markovitch'
GROUP BY d.dept_no DESC , e.emp_no;
commit;

-- THE OLD JOINS SYNTAX. The WHERE clause is used instead of the ON clause. The output will be perfectly the same
SELECT 
    dm.dept_no, dm.emp_no, d.dept_name
FROM
    dept_manager_dup dm,
    departments_dup d
WHERE
    dm.dept_no = d.dept_no
ORDER BY dm.dept_no;
commit;

-- JOIN syntax and WHERE clause used together
SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    s.salary > '145000';

-- Exercise for JOIN and WHERE clause used together
SELECT 
    e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    e.first_name = 'Margareta'
        AND e.last_name = 'Markovitch'
ORDER BY e.emp_no;

-- CROSS JOINs. The query returns an output that contains all data from dept_manager and departments TABLE. A potentially large results
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- COMBINING TWO OR MORE TABLES WITHOUTH USING THE CROSS JOIN CLAUSE 
SELECT 
    dm.*, d.*
FROM
    dept_manager dm,
    departments d
ORDER BY dm.emp_no , d.dept_no;

--  WRITING AN INNER JOIN CLAUSE WITHOUTH THE ON STATEMENT AUTOMATICALLY RUNS AS A CROSS JOIN
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        INNER JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;

# JOINING MORE THAN TWO TABLES USING CROSS JOIN. This returns all data from employees tables and departments table
SELECT 
    e.*, d.*
FROM
    departments d
        INNER JOIN
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
WHERE
    d.dept_no <> dm.dept_no
ORDER BY dm.emp_no , d.dept_no;
commit;

-- CROSS JOIN exercise I. The query returns all data from the dept_manager and departments for a customer with the department number 9.
 SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE
    dm.dept_no = 'd009'
ORDER BY d.dept_no;

-- CROSS JOIN exercise II. The query returns all data from the employees and departments for all customers that has employee number less than 10011
SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

-- this query returns the average salary of both male and females employees in the database. The group used to return a distinct gender. 
SELECT 
    e.gender, ROUND(AVG(s.salary), 2) AVERAGE_SALARY
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender;

-- JOINING MORE THAN TWO TABLES
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no;
    
-- Exercise for JOINING MORE THAN TWO TABLES
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
        JOIN
    dept_manager dm ON t.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

-- ANOTHER FORM OF WRTITING THE EXERCISE. This query output is exactly the same with where clause
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
        AND dm.from_date = t.from_date
ORDER BY e.emp_no;

-- LIST ALL THE DEPARMENTS IN WHICH MANAGERS BELONG AND over 60,000 AVERAGE SALARY PAID
SELECT 
    d.dept_name, ROUND(AVG(salary), 2) AS AVERAGE_salary
FROM
    departments d
        JOIN
    dept_manager dm ON d.dept_no = dm.dept_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING AVERAGE_salary > 60000
ORDER BY AVERAGE_salary DESC;

-- NUMBER OF MALES AND FEMALES MANAGERS IN THE EMPLOYEES TABLE
SELECT 
    e.gender, COUNT(gender) Number_of_males_and_females
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender
ORDER BY Number_of_males_and_females DESC;

-- CREATING A DUPLICATE OF THE EMPLOYEES TABLE
DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup (
    emp_no INT(11),
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M', 'F'),
    hire_date DATE
);
commit;
-- DUPLICATING THE STRUCTURE OF THE 'employees' table
INSERT INTO employees_dup
SELECT 
    e.*
FROM
    employees e
LIMIT 20;
commit;
-- INSERT A DUPLICATE OF THE FIRST ROW
INSERT INTO employees_dup VALUES
("10001", "1953-09-02", "Georgi", "Facello", "M", "1986-06-26"); 

-- UNION AND UNION ALL statement
-- UNION ALL statement (returns results with duplicate rows)
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
WHERE
    emp_no = 10001 
UNION ALL SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    dm.dept_no,
    dm.from_date
FROM
    dept_manager dm;
    
-- UNION statement (returns results without duplicate rows)
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
WHERE
    emp_no = 10001 
UNION SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    dm.dept_no,
    dm.from_date
FROM
    dept_manager dm;
    
-- EXERCISE FOR UNION AND UNION ALL
SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = "Denis" 
        UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY - a.emp_no DESC;
 
 -- SUBQUERY OR NESTED QUERY OR INNER QUERY 
 -- SUBQUERY WITH IN NESTED WITH WHERE CLAUSE
 -- The first and last name from the employees table for same EMPLOYEES TABLE that can also be found in the DEPARTMENT MANAGERS table
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            hire_date 
        FROM
            dept_manager dm);
            
-- Exercise for SUBQUERY. All data from the DEPARTMENT MANAGER TABLE for same EMPLOYEES NUMBER that can also be found in the EMPLOYEES table WHERE THEY WERE HIRED BETWEEN JANUARY 1990, AND 1995
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

-- SQL Subqueries with EXISTS NOT EXISTS nested inside WHERE THE CLAUSE
-- The first and last name of all managers in the database
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no)
ORDER BY emp_no;

-- Exercise for subquery exists not exists clause
-- All informations from the EMPLOYEES TABLE that are all Assistant Engineers by title in the database
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            title = 'Assistant Engineer'
                AND e.emp_no = t.emp_no)
ORDER BY emp_no;

-- SQL Subqueries nested in SELECT and FROM
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;

-- Exercise for complex subqueries
-- FIRST CREATED A TABLE NAMED emp_manager
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);
commit;
-- Then INSERTED VALUES INTO emp_managers TABLE 
INSERT INTO emp_manager
SELECT 
    U.*
FROM
    (SELECT 
        A.*
    FROM
        (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A UNION SELECT 
        B.*
    FROM
        (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 110022
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B UNION SELECT 
        C.*
    FROM
        (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS C UNION SELECT 
        D.*
    FROM
        (SELECT 
        e.emp_no AS employees_ID,
            MIN(de.dept_no) AS Department_CODE,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS Managers_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS D) AS U;
    COMMIT;
    
-- SELF JOINS
-- FROM THE emp_managers TABLE, EXTRACT ALL RECORDS THAT ARE EMPLOYEES
	-- This can be solved in two ways
-- 1
SELECT DISTINCT
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;

-- 2
SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);
            
-- THIS QUERY WAS WRITEN TO COUNT THE NUMBER OF EMPLOYEES THAT HAS CHANGED DEPARTMENT MORE THAN ONCE IN THE DATABASE
-- It turned out no employee has ever changed department thrice
SELECT 
    emp_no, from_date, to_date, COUNT(emp_no) AS Number
FROM
    dept_emp
GROUP BY emp_no
HAVING Number > 1;
commit;
-- SQL VIEWS
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
-- Exercise for SQL VIEWS
CREATE OR REPLACE VIEW v_managers_avg_salary AS
    SELECT 
        dm.emp_no, ROUND(AVG(s.salary), 2)
    FROM
        dept_manager dm
            JOIN
        salaries s ON s.emp_no = dm.emp_no;
	
-- SQL STORED PROCEDURES
USE employees;
DROP PROCEDURE IF EXISTS select_employees;
DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
	SELECT * FROM employees
	LIMIT 1000;
END$$
	DELIMITER ;
COMMIT;

-- EXERCISE FOR STORED PROCEDURES
DROP PROCEDURE IF EXISTS average_salaries_for_all_employees;
DELIMITER $$
CREATE PROCEDURE average_salaries_for_all_employees()
BEGIN
	SELECT 
    salary, ROUND(AVG(salary), 2) AS Average_salary
FROM
    salaries
LIMIT 1000;
END$$
	DELIMITER ;
commit;

-- STORED PROCEDURE WITH AN INPUT PARAMETER
DROP PROCEDURE IF EXISTS emp_salary;
DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary (IN p_emp_no INTEGER)
BEGIN
SELECT e.emp_no, e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE 
	e.emp_no = p_emp_no;
END$$
DELIMITER ;
COMMIT;

-- STORED PROCEDURE WITH AN INPUT PARAMETER
DROP PROCEDURE IF EXISTS emp_AVG_salary;
DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_AVG_salary (IN p_emp_no INTEGER)
BEGIN
SELECT e.emp_no, e.first_name, e.last_name, ROUND(AVG(s.salary), 2) AS AVG_SALARY, s.from_date, s.to_date
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE 
	e.emp_no = p_emp_no;
END$$
DELIMITER $$
commit;

-- STORED PROCEDURE WITH AN INPUT AND OUTPUT PARAMETERS
DROP PROCEDURE IF EXISTS emp_AVG_salary_OUT;
DELIMITER $$
CREATE PROCEDURE emp_AVG_salary_OUT (IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL (10,2))
BEGIN
SELECT AVG(s.salary) AS AVG_SALARY
INTO p_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE 
	e.emp_no = p_emp_no;
END$$
DELIMITER $$
COMMIT;

-- EXERCISE FOR STORED PROCEDURE WITH AN INPUT AND OUTPUT PARAMETERS
DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
SELECT 
    e.emp_no
INTO p_emp_no FROM
    employees e
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;
END$$
COMMIT;

-- VARIBALES IN SQL
SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;
DELIMITER ;
COMMIT;

-- FUNCTIONS IN SQL
DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);
SELECT 
    AVG(s.salary)
INTO v_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
RETURN v_avg_salary;
END$$
DELIMITER ;
COMMIT;
