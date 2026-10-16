-- ==========================================
-- 1. CREATE DATABASE AND TABLES
-- ==========================================

CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Department details
CREATE TABLE IF NOT EXISTS Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

-- Project information
CREATE TABLE IF NOT EXISTS Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Employee records
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


-- ==========================================
-- 2. INSERT DEPARTMENT RECORDS
-- ==========================================

INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');


-- ==========================================
-- 3. ADD PROJECT DETAILS
-- ==========================================

INSERT INTO Project (project_id, project_name, budget, dept_id) VALUES
(101, 'Cloud Infrastructure', 155000, 1),
(102, 'Business Intelligence', 210000, 1),
(103, 'Hiring Management', 85000, 2),
(104, 'Accounts Automation', 125000, 3),
(105, 'Online Promotion', 95000, 4),
(106, 'Inventory Management', 175000, 5),
(107, 'Customer App', 145000, 1),
(108, 'Staff Welfare', 65000, 2);


-- ==========================================
-- 4. INSERT EMPLOYEE RECORDS
-- ==========================================

INSERT INTO Employee
(emp_id, emp_name, salary, hire_date, dept_id, project_id)
VALUES
(1, 'Aryan', 66000, '2022-02-10', 1, 101),
(2, 'Ritvik', 73000, '2021-04-15', 1, 102),
(3, 'Ishaan', 59000, '2023-07-20', 1, 107),
(4, 'Kunal', 82000, '2020-09-12', 1, 101),
(5, 'Harsh', 68000, '2022-12-05', 1, 102),
(6, 'Laksh', 63000, '2024-03-18', 1, 107),

(7, 'Aditi', 53000, '2022-05-11', 2, 103),
(8, 'Kavya', 49000, '2023-02-22', 2, 108),
(9, 'Naina', 62000, '2021-08-19', 2, 103),
(10, 'Simran', 56000, '2022-10-30', 2, 108),
(11, 'Pihu', 48000, '2024-04-14', 2, 103),
(12, 'Tara', 60000, '2021-01-01', 2, 108),

(13, 'Rahul', 76000, '2021-03-17', 3, 104),
(14, 'Mohit', 69000, '2022-06-09', 3, 104),
(15, 'Siddharth', 84000, '2019-11-21', 3, 104),
(16, 'Varun', 63000, '2023-09-13', 3, 104),
(17, 'Akash', 72000, '2021-12-28', 3, 104),
(18, 'Naman', 57000, '2024-02-09', 3, 104),

(19, 'Ira', 55000, '2022-03-25', 4, 105),
(20, 'Rhea', 64000, '2021-07-16', 4, 105),
(21, 'Mahi', 58000, '2023-05-10', 4, 105),
(22, 'Anika', 67000, '2020-10-07', 4, 105),
(23, 'Sana', 52000, '2024-03-05', 4, 105),
(24, 'Prisha', 71000, '2023-01-19', 4, 105),

(25, 'Yuvraj', 61000, '2021-02-12', 5, 106),
(26, 'Raghav', 74000, '2020-05-23', 5, 106),
(27, 'Om', 68000, '2022-08-18', 5, 106),
(28, 'Aman', 60000, '2023-06-29', 5, 106),
(29, 'Varun S', 77000, '2019-09-30', 5, 106),
(30, 'Kartik', 65000, '2024-02-20', 5, 106);


-- ==========================================
-- 5. SELECTION
-- Employees earning above 70000
-- ==========================================

SELECT *
FROM Employee
WHERE salary > 70000;


-- ==========================================
-- 6. PROJECTION
-- Show selected employee attributes
-- ==========================================

SELECT emp_name, salary
FROM Employee;


-- ==========================================
-- 7. AGGREGATE FUNCTIONS
-- Calculate overall salary statistics
-- ==========================================

SELECT
    COUNT(*) AS employee_total,
    ROUND(AVG(salary), 2) AS mean_salary,
    MAX(salary) AS maximum_salary,
    MIN(salary) AS minimum_salary,
    SUM(salary) AS salary_sum
FROM Employee;


-- ==========================================
-- 8. GROUP BY
-- Employee count and average salary by department
-- ==========================================

SELECT
    d.dept_name,
    COUNT(e.emp_id) AS staff_count,
    ROUND(AVG(e.salary), 2) AS mean_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id;


-- ==========================================
-- 9. HAVING
-- Departments with average salary above 65000
-- ==========================================

SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS mean_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 65000;


-- ==========================================
-- 10. CASE EXPRESSION
-- Categorize employees by salary range
-- ==========================================

SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 75000 THEN 'High Salary'
        WHEN salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_level
FROM Employee;


-- ==========================================
-- 11. ORDER BY
-- Sort employees by salary, highest first
-- ==========================================

SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC, emp_name ASC;


-- ==========================================
-- 12. JOIN
-- Combine employee, department and project data
-- ==========================================

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


-- ==========================================
-- END OF EXPERIMENT 3
-- ==========================================