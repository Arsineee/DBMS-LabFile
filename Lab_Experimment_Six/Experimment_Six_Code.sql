-- =============================================
-- EXPERIMENT 6: PROCEDURES AND TRIGGERS
-- =============================================

USE CompanyDB;

-- 1. CREATE SALARY AUDIT TABLE

CREATE TABLE IF NOT EXISTS Salary_Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    previous_salary DECIMAL(10,2),
    updated_salary DECIMAL(10,2),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operation_type VARCHAR(30)
);


-- 2. REMOVE EXISTING TRIGGERS AND PROCEDURE

DROP TRIGGER IF EXISTS check_salary_insert;
DROP TRIGGER IF EXISTS check_salary_update;
DROP TRIGGER IF EXISTS record_salary_change;

DROP PROCEDURE IF EXISTS change_employee_department;


-- 3. TRIGGER TO VALIDATE SALARY DURING INSERT

DELIMITER //

CREATE TRIGGER check_salary_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Salary should be between 30000 and 150000';
    END IF;
END //

DELIMITER ;


-- 4. TRIGGER TO VALIDATE SALARY DURING UPDATE

DELIMITER //

CREATE TRIGGER check_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Updated salary is outside the permitted range';
    END IF;
END //

DELIMITER ;


-- 5. TRIGGER TO RECORD SALARY CHANGES

DELIMITER //

CREATE TRIGGER record_salary_change
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NOT (OLD.salary <=> NEW.salary) THEN
        INSERT INTO Salary_Audit_Log
        (emp_id, previous_salary, updated_salary, operation_type)
        VALUES
        (NEW.emp_id, OLD.salary, NEW.salary, 'SALARY MODIFIED');
    END IF;
END //

DELIMITER ;


-- 6. STORED PROCEDURE TO CHANGE DEPARTMENT

DELIMITER //

CREATE PROCEDURE change_employee_department(
    IN p_employee_id INT,
    IN p_department_id INT
)
BEGIN
    DECLARE employee_exists INT DEFAULT 0;
    DECLARE department_exists INT DEFAULT 0;
    DECLARE current_department INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Verify employee
    SELECT COUNT(*) INTO employee_exists
    FROM Employee
    WHERE emp_id = p_employee_id;

    IF employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee ID not found';
    END IF;

    -- Verify target department
    SELECT COUNT(*) INTO department_exists
    FROM Department
    WHERE dept_id = p_department_id;

    IF department_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department ID not found';
    END IF;

    -- Get current department
    SELECT dept_id INTO current_department
    FROM Employee
    WHERE emp_id = p_employee_id;

    -- Prevent unnecessary transfer
    IF current_department = p_department_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Employee already belongs to this department';
    END IF;

    -- Perform transfer
    UPDATE Employee
    SET dept_id = p_department_id
    WHERE emp_id = p_employee_id;

    COMMIT;
END //

DELIMITER ;


-- 7. TEST A VALID DEPARTMENT TRANSFER
-- Run once: moves employee 6 to department 4

CALL change_employee_department(6, 4);

SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
WHERE e.emp_id = 6;


-- 8. TEST AN INVALID EMPLOYEE ID
-- Expected: Employee ID not found
-- CALL change_employee_department(99, 4);


-- 9. TEST AN INVALID DEPARTMENT ID
-- Expected: Department ID not found
-- CALL change_employee_department(6, 99);


-- 10. TEST TRANSFER TO THE SAME DEPARTMENT
-- Expected: Employee already belongs to this department
-- CALL change_employee_department(6, 4);


-- 11. TEST SALARY VALIDATION
-- Expected: Trigger rejects the update
-- UPDATE Employee SET salary = 20000 WHERE emp_id = 6;


-- 12. TEST A VALID SALARY UPDATE
-- Expected: Salary updated and audit entry created

UPDATE Employee
SET salary = 85000
WHERE emp_id = 6;


-- 13. DISPLAY SALARY AUDIT RECORDS

SELECT
    log_id,
    emp_id,
    previous_salary,
    updated_salary,
    change_time,
    operation_type
FROM Salary_Audit_Log
ORDER BY log_id;

-- ============================================================
-- END OF EXPERIMENT 6
-- ============================================================