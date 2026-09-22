
DROP DATABASE IF EXISTS test;

CREATE DATABASE `Parks_and_Recreation`;


CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);


CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);

INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);


CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);


INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');


SELECT first_name, last_name, age
FROM employee_demographics
UNION ALL
SELECT first_name, last_name, age
FROM employee_salary;

SELECT first_name, last_name, 'Old' AS label
FROM employee_demographics
WHERE age > 50;



SELECT 
	first_name,
    last_name,
    salary,
    CASE
		WHEN salary < 50000 THEN salary * 1.05
        WHEN salary >= 50000 THEN salary * 1.07
    END AS new_salary,
    CASE
		WHEN dept_id = 6 THEN salary * 0.10
        ELSE 0
    END AS bonus
FROM employee_salary;


SELECT *,
		(new_salary + bonus) AS new_total_salary
FROM (
    SELECT 
        first_name,
        last_name,
        salary,
        CASE
            WHEN salary < 50000 THEN salary * 1.05
            WHEN salary >= 50000 THEN salary * 1.07
        END AS new_salary,
        CASE
            WHEN dept_id = 6 THEN salary * 0.10
            ELSE 0
        END AS bonus
	FROM employee_salary
) t;

SELECT
	gender,
	AVG(salary)
FROM employee_demographics AS ed
JOIN employee_salary AS es
ON ed.employee_id = es.employee_id
GROUP BY gender;

SELECT
	ed.first_name,
    ed.last_name,
	gender,
	AVG(salary)
    OVER(PARTITION BY gender)
FROM employee_demographics AS ed
JOIN employee_salary AS es
ON ed.employee_id = es.employee_id;

SELECT
	ed.first_name,
    ed.last_name,
	gender,
    es.salary,
	SUM(salary)
    OVER(PARTITION BY gender order by ed.employee_id) AS rolling_total
FROM employee_demographics AS ed
JOIN employee_salary AS es
ON ed.employee_id = es.employee_id;
    

SELECT
	ed.employee_id,
	ed.first_name,
    ed.last_name,
	gender,
    es.salary,
	ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
    RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_s,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_s
FROM employee_demographics AS ed
JOIN employee_salary AS es
ON ed.employee_id = es.employee_id;

CREATE PROCEDURE large_salary()
SELECT *
FROM employee_salary
WHERE salary >= 50000;


CREATE PROCEDURE large_salary()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_salary
WHERE salary >= 10000;



CALL large_salary()
    
DELIMITER $$
CREATE PROCEDURE large_salary_3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;

	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;


CALL large_salary_3();


SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jon', 'devid', 'data analyst', 1000000, NULL);


------- events

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age > 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';











