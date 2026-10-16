USE CompanyDB;

-- ==========================================
-- 1. INNER JOIN
-- Show employees along with their departments
-- ==========================================

SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.salary,
    d.dept_name AS department
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id
ORDER BY e.emp_id;


-- ==========================================
-- 2. LEFT JOIN
-- List every department and its employees
-- ==========================================

SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name AS employee_name,
    e.salary
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id
ORDER BY d.dept_id, e.emp_id;


-- ==========================================
-- 3. SELF JOIN
-- Compare employees within the same department
-- ==========================================

SELECT
    a.emp_name AS first_employee,
    b.emp_name AS second_employee,
    a.dept_id,
    a.salary AS first_salary,
    b.salary AS second_salary
FROM Employee a
JOIN Employee b
    ON a.dept_id = b.dept_id
   AND a.emp_id < b.emp_id
ORDER BY a.dept_id, a.emp_id
LIMIT 10;


-- ==========================================
-- 4. THREE-TABLE JOIN
-- Retrieve employee, department and project details
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
-- 5. CORRELATED SUBQUERY
-- Find employees earning above their department average
-- ==========================================

SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee e
WHERE e.salary > (
    SELECT AVG(x.salary)
    FROM Employee x
    WHERE x.dept_id = e.dept_id
)
ORDER BY e.dept_id, e.salary DESC;


-- ==========================================
-- 6. EXISTS
-- Find departments with an employee earning above 80000
-- ==========================================

SELECT
    d.dept_id,
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
      AND e.salary > 80000
)
ORDER BY d.dept_id;


-- ==========================================
-- 7. SIMULATED INTERSECT
-- Find IT employees whose salary exceeds 70000
-- ==========================================

SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE dept_id = 1
  AND emp_id IN (
      SELECT emp_id
      FROM Employee
      WHERE salary > 70000
  )
ORDER BY emp_id;


-- ==========================================
-- 8. SIMULATED EXCEPT
-- Find employees earning above 70000, excluding IT
-- ==========================================

SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE salary > 70000
  AND dept_id <> 1
ORDER BY emp_id;


-- ==========================================
-- 9. EXPLAIN: INNER JOIN
-- Examine the execution plan for a join
-- ==========================================

EXPLAIN
SELECT
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.salary > 70000;


-- ==========================================
-- 10. EXPLAIN: CORRELATED SUBQUERY
-- Inspect the department-average comparison plan
-- ==========================================

EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(x.salary)
    FROM Employee x
    WHERE x.dept_id = e.dept_id
);


-- ==========================================
-- 11. EXPLAIN: EXISTS
-- Inspect the department employee-check execution plan
-- ==========================================

EXPLAIN
SELECT
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
      AND e.salary > 80000
);


-- ==========================================
-- END OF EXPERIMENT 4
-- ==========================================