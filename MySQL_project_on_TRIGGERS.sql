-- MySQL Triggers
USE employees;
COMMIT;
-- Before Insert TRIGGER
DELIMITER $$
CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END $$
DELIMITER ;

-- Inserted a new entry for employee 10001, whose salary is a negative number. The Trigger was activated and it shows 0 for the inserted -92,891
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');

-- Before Update TRIGGER 
DELIMITER $$
CREATE TRIGGER trig_update_salary
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
	END IF; 
END $$
DELIMITER ;

-- UPDATE the entry which will modify the salary value of employee 10001 with another positive value.
UPDATE salaries 
SET 
    salary = 98765
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
 -- The following SELECT statement CHECKS the record to see if its been successfully updated.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';

-- Another UPDATE statement to modify the salary earned by employee with employee number 10001 with a negative value i.e. minus 50,000.
UPDATE salaries 
SET 
    salary = -50000
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';

-- To check adjusted salary value 
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';

-- Exercise for Triggers
DROP TRIGGER IF EXISTS trig_inst_dept_mng;
DELIMITER $$
CREATE TRIGGER trig_inst_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
	DECLARE v_current_salary INT;
SELECT 
    MAX(salary)
INTO v_current_salary FROM
    salaries
WHERE
    emp_no = NEW.emp_no;
	IF v_current_salary IS NOT NULL THEN
		UPDATE salaries 
		SET 
			to_date = SYSDATE()
		WHERE
			emp_no = NEW.emp_no and to_date = NEW.to_date;
		INSERT INTO salaries 
			VALUES (NEW.emp_no, v_current_salary + 20000, NEW.from_date, NEW.to_date);
    END IF;
END $$
DELIMITER ;
COMMIT;

-- INSERTING VALUES INTO DEPARTMENT MANAGER TABLE
INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');
## Practically, this was an ‘after’ trigger clause that automatically added $20,000 to the salary of the employee who was just promoted as a manager. 
## Moreover, it set the start date of the new contract to be the day on which this tigger was executed.

-- Exercise For TRIGGERS
## Trigger that checks if the hire date of an employee is greater than the current date.
## If the condition is true, the date was set to be the current date. Formatting the output appropriately to be YY-MM-DD.
DELIMITER $$
CREATE TRIGGER triger_hire_date  
BEFORE INSERT ON employees
FOR EACH ROW  
BEGIN
	IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN
		SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');
END IF;  
END $$  
DELIMITER ;

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');

-- INDEXES
## The INDEX of a table functions like the index of a book data is taken from a column of the table and stored in a in a distinct place, called an index
-- TO CHECK FOR THE NUMBER OF PEOPLE THAT HAVE BEEN HIRED AFTER THE 1ST OF JANUARY, 2000
SELECT 
    *
FROM
    employees
WHERE
    hire_date > '2000-01-01';
CREATE INDEX i_hire_date ON employees(hire_date);

-- COMPOSITE INDEXES. They are applied to multiple columns
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Georgi'
        AND last_name = 'Facello';
CREATE INDEX i_composite ON employees(first_name, last_name);
-- Exercise for INDEXES
SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;
CREATE INDEX i_salary ON salaries (salary);

