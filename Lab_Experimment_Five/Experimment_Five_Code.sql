USE CompanyDB;

-- ==========================================
-- 1. ADD MANAGER_ID COLUMN
-- ==========================================

ALTER TABLE Employee
ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_manager
FOREIGN KEY (manager_id)
REFERENCES Employee(emp_id);


-- ==========================================
-- 2. SET EMPLOYEE REPORTING HIERARCHY
-- ==========================================

-- IT Department
UPDATE Employee SET manager_id = NULL WHERE emp_id = 1;
UPDATE Employee SET manager_id = 1 WHERE emp_id = 2;
UPDATE Employee SET manager_id = 1 WHERE emp_id = 3;
UPDATE Employee SET manager_id = 2 WHERE emp_id = 4;
UPDATE Employee SET manager_id = 2 WHERE emp_id = 5;
UPDATE Employee SET manager_id = 3 WHERE emp_id = 6;

-- HR Department
UPDATE Employee SET manager_id = NULL WHERE emp_id = 7;
UPDATE Employee SET manager_id = 7 WHERE emp_id = 8;
UPDATE Employee SET manager_id = 7 WHERE emp_id = 9;
UPDATE Employee SET manager_id = 8 WHERE emp_id = 10;
UPDATE Employee SET manager_id = 9 WHERE emp_id = 11;
UPDATE Employee SET manager_id = 9 WHERE emp_id = 12;

-- Finance Department
UPDATE Employee SET manager_id = NULL WHERE emp_id = 13;
UPDATE Employee SET manager_id = 13 WHERE emp_id = 14;
UPDATE Employee SET manager_id = 13 WHERE emp_id = 15;
UPDATE Employee SET manager_id = 14 WHERE emp_id = 16;
UPDATE Employee SET manager_id = 15 WHERE emp_id = 17;
UPDATE Employee SET manager_id = 15 WHERE emp_id = 18;

-- Marketing Department
UPDATE Employee SET manager_id = NULL WHERE emp_id = 19;
UPDATE Employee SET manager_id = 19 WHERE emp_id = 20;
UPDATE Employee SET manager_id = 19 WHERE emp_id = 21;
UPDATE Employee SET manager_id = 20 WHERE emp_id = 22;
UPDATE Employee SET manager_id = 21 WHERE emp_id = 23;
UPDATE Employee SET manager_id = 21 WHERE emp_id = 24;

-- Operations Department
UPDATE Employee SET manager_id = NULL WHERE emp_id = 25;
UPDATE Employee SET manager_id = 25 WHERE emp_id = 26;
UPDATE Employee SET manager_id = 25 WHERE emp_id = 27;
UPDATE Employee SET manager_id = 26 WHERE emp_id = 28;
UPDATE Employee SET manager_id = 27 WHERE emp_id = 29;
UPDATE Employee SET manager_id = 27 WHERE emp_id = 30;


-- ==========================================
-- 3. CREATE DEPARTMENT SALARY VIEW
-- ==========================================

CREATE OR REPLACE VIEW dept_salary_report AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS lowest_salary,
    MAX(e.salary) AS highest_salary,
    SUM(e.salary) AS salary_expense
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- Display the summary
SELECT * FROM dept_salary_report;


-- ==========================================
-- 4. CREATE EMPLOYEE-MANAGER VIEW
-- ==========================================

CREATE OR REPLACE VIEW staff_reporting_view AS
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.manager_id,
    m.emp_name AS reports_to,
    e.salary
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;

-- View employees and their managers
SELECT *
FROM staff_reporting_view
ORDER BY dept_name, emp_id;


-- ==========================================
-- 5. TEST UPDATABILITY OF EMPLOYEE VIEW
-- ==========================================

-- This simple view can update the underlying table.
UPDATE staff_reporting_view
SET salary = salary + 500
WHERE emp_id = 6;

-- Confirm the updated salary
SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id = 6;


-- ==========================================
-- 6. TEST AGGREGATE VIEW UPDATABILITY
-- ==========================================

-- Aggregate views containing GROUP BY and AVG()
-- are generally not directly updatable in MySQL.
-- The following statement is expected to fail.

-- UPDATE dept_salary_report
-- SET avg_salary = avg_salary + 500
-- WHERE dept_id = 1;

-- Verify the summary without modifying it
SELECT *
FROM dept_salary_report
WHERE dept_id = 1;


-- ==========================================
-- 7. RECURSIVE CTE: EMPLOYEE REPORTING PATH
-- ==========================================

WITH RECURSIVE staff_tree AS (

    -- Anchor: employees who have no manager
    SELECT
        emp_id,
        emp_name,
        manager_id,
        1 AS hierarchy_level,
        CAST(emp_name AS CHAR(1000)) AS reporting_path
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive step: find each employee's subordinates
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        st.hierarchy_level + 1,
        CONCAT(st.reporting_path, ' -> ', e.emp_name)
    FROM Employee e
    JOIN staff_tree st
        ON e.manager_id = st.emp_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    hierarchy_level,
    reporting_path
FROM staff_tree
ORDER BY reporting_path;


-- ==========================================
-- END OF EXPERIMENT 5
-- ==========================================