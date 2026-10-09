-- ============================================================
-- DBMS PRACTICAL - EXPERIMENT 3
-- Employee-Department-Project Database
-- ============================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS CompanyDB;

USE CompanyDB;


-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

-- Department Table
CREATE TABLE IF NOT EXISTS Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);


-- Project Table
CREATE TABLE IF NOT EXISTS Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);


-- Employee Table
CREATE TABLE IF NOT EXISTS Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    project_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);


-- ============================================================
-- 2. INSERT DEPARTMENTS
-- ============================================================

INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');


-- ============================================================
-- 3. INSERT PROJECTS
-- ============================================================

INSERT INTO Project (project_id, project_name, budget, dept_id) VALUES
(101, 'Cloud Migration', 150000, 1),
(102, 'AI Analytics', 200000, 1),
(103, 'Recruitment Portal', 80000, 2),
(104, 'Financial Dashboard', 120000, 3),
(105, 'Digital Campaign', 90000, 4),
(106, 'Supply Chain System', 180000, 5),
(107, 'Mobile Application', 140000, 1),
(108, 'Employee Wellness', 60000, 2);


-- ============================================================
-- 4. INSERT 30 EMPLOYEES
-- ============================================================

INSERT INTO Employee
(emp_id, emp_name, salary, hire_date, dept_id, project_id)
VALUES
(1, 'Aarav', 65000, '2022-01-10', 1, 101),
(2, 'Vivaan', 72000, '2021-03-15', 1, 102),
(3, 'Aditya', 58000, '2023-06-20', 1, 107),
(4, 'Arjun', 81000, '2020-08-12', 1, 101),
(5, 'Kabir', 69000, '2022-11-05', 1, 102),
(6, 'Reyansh', 62000, '2024-02-18', 1, 107),

(7, 'Ananya', 52000, '2022-04-11', 2, 103),
(8, 'Diya', 48000, '2023-01-22', 2, 108),
(9, 'Myra', 61000, '2021-07-19', 2, 103),
(10, 'Sara', 55000, '2022-09-30', 2, 108),
(11, 'Ishita', 47000, '2024-03-14', 2, 103),
(12, 'Meera', 59000, '2020-12-01', 2, 108),

(13, 'Rohan', 75000, '2021-02-17', 3, 104),
(14, 'Karan', 68000, '2022-05-09', 3, 104),
(15, 'Nikhil', 83000, '2019-10-21', 3, 104),
(16, 'Yash', 62000, '2023-08-13', 3, 104),
(17, 'Manav', 71000, '2021-11-28', 3, 104),
(18, 'Dev', 56000, '2024-01-09', 3, 104),

(19, 'Aanya', 54000, '2022-02-25', 4, 105),
(20, 'Kiara', 63000, '2021-06-16', 4, 105),
(21, 'Tanya', 57000, '2023-04-10', 4, 105),
(22, 'Riya', 66000, '2020-09-07', 4, 105),
(23, 'Avni', 51000, '2024-02-05', 4, 105),
(24, 'Navya', 70000, '2022-12-19', 4, 105),

(25, 'Samar', 60000, '2021-01-12', 5, 106),
(26, 'Dhruv', 73000, '2020-04-23', 5, 106),
(27, 'Atharv', 67000, '2022-07-18', 5, 106),
(28, 'Parth', 59000, '2023-05-29', 5, 106),
(29, 'Rudra', 76000, '2019-08-31', 5, 106),
(30, 'Veer', 64000, '2024-01-20', 5, 106);


-- ============================================================
-- 5. SELECTION
-- Display employees whose salary is greater than 70,000
-- ============================================================

SELECT *
FROM Employee
WHERE salary > 70000;


-- ============================================================
-- 6. PROJECTION
-- Display only employee names and salaries
-- ============================================================

SELECT emp_name, salary
FROM Employee;


-- ============================================================
-- 7. AGGREGATE FUNCTIONS
-- COUNT, AVG, MAX, MIN and SUM
-- ============================================================

SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    SUM(salary) AS total_salary
FROM Employee;


-- ============================================================
-- 8. GROUP BY
-- Display employee count and average salary in each department
-- ============================================================

SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;


-- ============================================================
-- 9. HAVING
-- Display departments whose average salary is greater than 65,000
-- ============================================================

SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 65000;


-- ============================================================
-- 10. CASE EXPRESSION
-- Classify employees according to their salary
-- ============================================================

SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 75000 THEN 'High Salary'
        WHEN salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;


-- ============================================================
-- 11. ORDER BY
-- Display employees in descending order of salary
-- ============================================================

SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;


-- ============================================================
-- 12. JOIN
-- Display employee name, department, project and salary
-- ============================================================

SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
JOIN Project p
    ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;


-- ============================================================
-- END OF EXPERIMENT 3
-- ============================================================

-- ============================================================
-- DBMS PRACTICAL - EXPERIMENT 5
-- Views, View Updatability and Recursive CTE
-- ============================================================

USE CompanyDB;


-- ============================================================
-- 1. ADD MANAGER_ID TO EMPLOYEE TABLE
-- ============================================================

ALTER TABLE Employee
ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);


-- ============================================================
-- 2. CREATE EMPLOYEE HIERARCHY
-- Each department has one department head.
-- The remaining employees report to another employee.
-- ============================================================

-- IT
UPDATE Employee SET manager_id = NULL WHERE emp_id = 1;
UPDATE Employee SET manager_id = 1 WHERE emp_id = 2;
UPDATE Employee SET manager_id = 2 WHERE emp_id = 3;
UPDATE Employee SET manager_id = 3 WHERE emp_id = 4;
UPDATE Employee SET manager_id = 4 WHERE emp_id = 5;
UPDATE Employee SET manager_id = 5 WHERE emp_id = 6;

-- HR
UPDATE Employee SET manager_id = NULL WHERE emp_id = 7;
UPDATE Employee SET manager_id = 7 WHERE emp_id = 8;
UPDATE Employee SET manager_id = 8 WHERE emp_id = 9;
UPDATE Employee SET manager_id = 9 WHERE emp_id = 10;
UPDATE Employee SET manager_id = 10 WHERE emp_id = 11;
UPDATE Employee SET manager_id = 11 WHERE emp_id = 12;

-- Finance
UPDATE Employee SET manager_id = NULL WHERE emp_id = 13;
UPDATE Employee SET manager_id = 13 WHERE emp_id = 14;
UPDATE Employee SET manager_id = 14 WHERE emp_id = 15;
UPDATE Employee SET manager_id = 15 WHERE emp_id = 16;
UPDATE Employee SET manager_id = 16 WHERE emp_id = 17;
UPDATE Employee SET manager_id = 17 WHERE emp_id = 18;

-- Marketing
UPDATE Employee SET manager_id = NULL WHERE emp_id = 19;
UPDATE Employee SET manager_id = 19 WHERE emp_id = 20;
UPDATE Employee SET manager_id = 20 WHERE emp_id = 21;
UPDATE Employee SET manager_id = 21 WHERE emp_id = 22;
UPDATE Employee SET manager_id = 22 WHERE emp_id = 23;
UPDATE Employee SET manager_id = 23 WHERE emp_id = 24;

-- Operations
UPDATE Employee SET manager_id = NULL WHERE emp_id = 25;
UPDATE Employee SET manager_id = 25 WHERE emp_id = 26;
UPDATE Employee SET manager_id = 26 WHERE emp_id = 27;
UPDATE Employee SET manager_id = 27 WHERE emp_id = 28;
UPDATE Employee SET manager_id = 28 WHERE emp_id = 29;
UPDATE Employee SET manager_id = 29 WHERE emp_id = 30;


-- ============================================================
-- 3. DEPARTMENT SALARY SUMMARY VIEW
-- ============================================================

CREATE OR REPLACE VIEW department_salary_summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    SUM(e.salary) AS total_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;


-- Verify Department Salary Summary View
SELECT *
FROM department_salary_summary;


-- ============================================================
-- 4. EMPLOYEE HIERARCHY VIEW
-- Display each employee and their immediate manager
-- ============================================================

CREATE OR REPLACE VIEW employee_hierarchy AS
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    d.dept_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.salary
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;


-- Verify Employee Hierarchy View
SELECT *
FROM employee_hierarchy
ORDER BY dept_id, emp_id;


-- ============================================================
-- 5. TEST UPDATABILITY OF EMPLOYEE HIERARCHY VIEW
-- ============================================================

UPDATE employee_hierarchy
SET salary = salary + 1000
WHERE emp_id = 6;


-- Verify the salary
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE emp_id = 6;


-- ============================================================
-- 6. TEST UPDATABILITY OF DEPARTMENT SALARY SUMMARY VIEW
-- ============================================================

UPDATE department_salary_summary
SET average_salary = average_salary + 1000
WHERE dept_id = 1;


-- ============================================================
-- 7. RECURSIVE CTE - REPORTING CHAIN
-- Start from department heads and follow manager relationships
-- ============================================================

WITH RECURSIVE reporting_chain AS (

    -- Anchor Query
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        1 AS level,
        CAST(e.emp_name AS CHAR(500)) AS reporting_path
    FROM Employee e
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Recursive Query
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1,
        CONCAT(rc.reporting_path, ' -> ', e.emp_name)
    FROM Employee e
    JOIN reporting_chain rc
        ON e.manager_id = rc.emp_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_path
FROM reporting_chain
ORDER BY reporting_path;


-- ============================================================
-- END OF EXPERIMENT 5
-- ============================================================


-- ============================================================
-- DBMS PRACTICAL - EXPERIMENT 6
-- Stored Procedure, Triggers, Error Handling and Audit Log
-- ============================================================

USE CompanyDB;


-- ============================================================
-- 1. SALARY AUDIT TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS Employee_Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(30)
);


-- ============================================================
-- 2. REMOVE OLD TRIGGERS / PROCEDURE
-- This makes the script easier to run again during practicals.
-- ============================================================

DROP TRIGGER IF EXISTS validate_employee_salary;
DROP TRIGGER IF EXISTS validate_employee_salary_update;
DROP TRIGGER IF EXISTS audit_salary_update;

DROP PROCEDURE IF EXISTS transfer_employee;


-- ============================================================
-- 3. SALARY VALIDATION TRIGGER - INSERT
-- Salary must be between 30,000 and 1,50,000
-- ============================================================

DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Salary must be between 30000 and 150000';
    END IF;
END//

DELIMITER ;


-- ============================================================
-- 4. SALARY VALIDATION TRIGGER - UPDATE
-- Validate salary before updating an existing employee
-- ============================================================

DELIMITER //

CREATE TRIGGER validate_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Salary must be between 30000 and 150000';
    END IF;
END//

DELIMITER ;


-- ============================================================
-- 5. SALARY AUDIT TRIGGER
-- Store old and new salary after a successful update
-- ============================================================

DELIMITER //

CREATE TRIGGER audit_salary_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO Employee_Salary_Audit
        (
            emp_id,
            old_salary,
            new_salary,
            action
        )
        VALUES
        (
            NEW.emp_id,
            OLD.salary,
            NEW.salary,
            'SALARY UPDATE'
        );
    END IF;
END//

DELIMITER ;


-- ============================================================
-- 6. STORED PROCEDURE - TRANSFER EMPLOYEE
-- ============================================================

DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN

    DECLARE v_emp_count INT DEFAULT 0;
    DECLARE v_dept_count INT DEFAULT 0;
    DECLARE v_old_dept_id INT;

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start transaction
    START TRANSACTION;


    -- --------------------------------------------------------
    -- Check whether employee exists
    -- --------------------------------------------------------

    SELECT COUNT(*)
    INTO v_emp_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;


    -- --------------------------------------------------------
    -- Check whether department exists
    -- --------------------------------------------------------

    SELECT COUNT(*)
    INTO v_dept_count
    FROM Department
    WHERE dept_id = p_new_dept_id;

    IF v_dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;


    -- --------------------------------------------------------
    -- Find employee's current department
    -- --------------------------------------------------------

    SELECT dept_id
    INTO v_old_dept_id
    FROM Employee
    WHERE emp_id = p_emp_id;


    -- --------------------------------------------------------
    -- Check if employee is already in requested department
    -- --------------------------------------------------------

    IF v_old_dept_id = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Employee is already in this department';
    END IF;


    -- --------------------------------------------------------
    -- Transfer employee
    -- --------------------------------------------------------

    UPDATE Employee
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;


    -- Save transaction
    COMMIT;

END//

DELIMITER ;


-- ============================================================
-- 7. TEST SUCCESSFUL TRANSFER
-- Transfer employee 6 to department 4
-- ============================================================

CALL transfer_employee(6, 4);


-- Verify employee's department

SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.emp_id = 6;


-- ============================================================
-- 8. TEST INVALID EMPLOYEE
-- Expected: Employee does not exist
-- ============================================================

CALL transfer_employee(99, 4);


-- ============================================================
-- 9. TEST INVALID DEPARTMENT
-- Expected: Department does not exist
-- ============================================================

CALL transfer_employee(6, 99);


-- ============================================================
-- 10. TEST SAME DEPARTMENT
-- Employee 6 is already in department 4
-- Expected: Employee is already in this department
-- ============================================================

CALL transfer_employee(6, 4);


-- ============================================================
-- 11. TEST INVALID SALARY
-- Expected: Salary validation error
-- ============================================================

UPDATE Employee
SET salary = 20000
WHERE emp_id = 6;


-- ============================================================
-- 12. TEST VALID SALARY UPDATE
-- Expected: Successful update
-- ============================================================

UPDATE Employee
SET salary = 85000
WHERE emp_id = 6;


-- ============================================================
-- 13. DISPLAY SALARY AUDIT LOG
-- ============================================================

SELECT
    audit_id,
    emp_id,
    old_salary,
    new_salary,
    changed_at,
    action
FROM Employee_Salary_Audit
ORDER BY audit_id;


-- ============================================================
-- END OF EXPERIMENT 6
-- ============================================================