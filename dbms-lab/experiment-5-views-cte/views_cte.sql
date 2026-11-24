-- =====================================================
-- Experiment 5
-- Aim: Create SQL views for department salary summary and employee hierarchy,
-- test the updatability of views, and implement a recursive CTE to display
-- reporting chains.
-- =====================================================

-- 1. CREATE DEPARTMENT TABLE
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

INSERT INTO department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- 2. CREATE EMPLOYEE TABLE
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    manager_id INT NULL,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

INSERT INTO employee VALUES
(101, 'Amit', 1, NULL, 90000),
(102, 'Neha', 1, 101, 65000),
(103, 'Rahul', 1, 101, 60000),
(104, 'Priya', 2, NULL, 80000),
(105, 'Karan', 2, 104, 55000),
(106, 'Riya', 3, NULL, 85000),
(107, 'Arjun', 3, 106, 50000);

-- 3. VIEW FOR DEPARTMENT SALARY SUMMARY
CREATE VIEW department_salary_summary AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM department d
LEFT JOIN employee e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name;

SELECT * FROM department_salary_summary;

-- 4. VIEW FOR EMPLOYEE HIERARCHY
CREATE VIEW employee_hierarchy AS
SELECT
    e.employee_id,
    e.employee_name,
    e.department_id,
    e.manager_id,
    m.employee_name AS manager_name,
    e.salary
FROM employee e
LEFT JOIN employee m
    ON e.manager_id = m.employee_id;

SELECT * FROM employee_hierarchy;

-- 5. TEST VIEW UPDATABILITY
-- Simple single-table view
CREATE VIEW employee_basic AS
SELECT
    employee_id,
    employee_name,
    salary
FROM employee;

-- Update salary through the view
UPDATE employee_basic
SET salary = salary + 5000
WHERE employee_id = 102;

-- Check updated record (through the view and the base table)
SELECT *
FROM employee_basic
WHERE employee_id = 102;

SELECT *
FROM employee
WHERE employee_id = 102;

-- 6. RECURSIVE CTE FOR REPORTING CHAINS
WITH RECURSIVE reporting_chain AS (
    -- Anchor member: employees who have no manager
    SELECT
        employee_id,
        employee_name,
        manager_id,
        0 AS level,
        CAST(employee_name AS CHAR(1000)) AS reporting_path
    FROM employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: employees reporting to each employee
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        rc.level + 1,
        CONCAT(
            rc.reporting_path,
            ' -> ',
            e.employee_name
        )
    FROM employee e
    INNER JOIN reporting_chain rc
        ON e.manager_id = rc.employee_id
)
SELECT
    employee_id,
    employee_name,
    manager_id,
    level,
    reporting_path
FROM reporting_chain
ORDER BY reporting_path;
