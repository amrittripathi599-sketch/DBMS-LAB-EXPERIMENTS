-- =====================================================
-- Experiment 6
-- Aim: Create a stored procedure transfer_employee(emp_id, new_dept_id) with
-- validation and error handling, and implement database triggers for salary
-- validation and audit logging.
-- =====================================================

-- 1. CREATE DATABASE TABLES
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

INSERT INTO department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');

INSERT INTO employee VALUES
(101, 'Rahul', 1, 50000),
(102, 'Aman', 2, 45000),
(103, 'Neha', 1, 60000),
(104, 'Priya', 3, 55000),
(105, 'Rohan', 4, 40000);

-- 2. CREATE AUDIT TABLE
CREATE TABLE employee_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_department_id INT,
    new_department_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    action_type VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. STORED PROCEDURE transfer_employee(emp_id, new_dept_id)
DELIMITER //
CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_old_dept_id INT;
    DECLARE v_emp_count INT DEFAULT 0;
    DECLARE v_dept_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Transfer failed.' AS message;
    END;

    START TRANSACTION;

    -- Check employee exists
    SELECT COUNT(*)
    INTO v_emp_count
    FROM employee
    WHERE employee_id = p_emp_id;

    IF v_emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee does not exist.';
    END IF;

    -- Check department exists
    SELECT COUNT(*)
    INTO v_dept_count
    FROM department
    WHERE department_id = p_new_dept_id;

    IF v_dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: New department does not exist.';
    END IF;

    -- Get current department
    SELECT department_id
    INTO v_old_dept_id
    FROM employee
    WHERE employee_id = p_emp_id;

    -- Check if already in department
    IF v_old_dept_id = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee is already in this department.';
    END IF;

    -- Transfer employee
    UPDATE employee
    SET department_id = p_new_dept_id
    WHERE employee_id = p_emp_id;

    COMMIT;
    SELECT 'Employee transferred successfully.' AS message;
END //
DELIMITER ;

-- 4. TRIGGER FOR SALARY VALIDATION (INSERT)
DELIMITER //
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Salary cannot be negative.';
    END IF;
END //
DELIMITER ;

-- 5. TRIGGER FOR SALARY UPDATE VALIDATION
DELIMITER //
CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Salary cannot be negative.';
    END IF;
END //
DELIMITER ;

-- 6. AUDIT TRIGGER — logs department transfers
DELIMITER //
CREATE TRIGGER after_employee_update
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    IF OLD.department_id <> NEW.department_id THEN
        INSERT INTO employee_audit
        (
            employee_id,
            old_department_id,
            new_department_id,
            old_salary,
            new_salary,
            action_type
        )
        VALUES
        (
            OLD.employee_id,
            OLD.department_id,
            NEW.department_id,
            OLD.salary,
            NEW.salary,
            'DEPARTMENT TRANSFER'
        );
    END IF;
END //
DELIMITER ;

-- 7. TESTING
-- Test 1: Valid transfer
CALL transfer_employee(101, 3);
SELECT * FROM employee WHERE employee_id = 101;
SELECT * FROM employee_audit;

-- Test 2: Invalid employee
CALL transfer_employee(999, 2);

-- Test 3: Invalid department
CALL transfer_employee(102, 999);

-- Test 4: Employee already belongs to department
CALL transfer_employee(103, 1);

-- Test 5: Negative salary during INSERT
INSERT INTO employee
VALUES (106, 'Test Employee', 1, -5000);

-- Test 6: Negative salary during UPDATE
UPDATE employee
SET salary = -1000
WHERE employee_id = 102;

-- 8. FINAL DATA
SELECT * FROM employee;
SELECT * FROM employee_audit;
