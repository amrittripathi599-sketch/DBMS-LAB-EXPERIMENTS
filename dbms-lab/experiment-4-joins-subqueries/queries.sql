-- =====================================================
-- Experiment 4
-- Aim: Using the Employee schema, write queries with INNER JOIN, LEFT JOIN,
-- self-join, 3-way join, correlated subqueries, EXISTS, and simulated INTERSECT
-- and EXCEPT. Compare execution plans using EXPLAIN.
-- =====================================================

-- 1. CREATE TABLES
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    job_title VARCHAR(50),
    dept_id INT,
    manager_id INT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT,
    budget DECIMAL(12,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

-- 2. INSERT DATA
INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'AI/ML', 'Hyderabad');

INSERT INTO Employee VALUES
(101, 'Rahul', 75000, 'Developer', 1, NULL),
(102, 'Aman', 65000, 'Developer', 1, 101),
(103, 'Priya', 90000, 'Manager', 2, NULL),
(104, 'Neha', 60000, 'HR Executive', 2, 103),
(105, 'Rohit', 85000, 'Analyst', 3, NULL),
(106, 'Sneha', 55000, 'Accountant', 3, 105),
(107, 'Karan', 70000, 'Marketing Executive', 4, NULL),
(108, 'Pooja', 50000, 'Marketing Executive', 4, 107),
(109, 'Arjun', 95000, 'AI Engineer', 5, NULL),
(110, 'Simran', 80000, 'ML Engineer', 5, 109),
(111, 'Vikas', 62000, 'Developer', 1, 101),
(112, 'Anjali', 58000, 'Developer', 1, 101),
(113, 'Mohit', 72000, 'HR Executive', 2, 103),
(114, 'Riya', 68000, 'Analyst', 3, 105),
(115, 'Varun', 78000, 'AI Engineer', 5, 109),
(116, 'Tanya', 52000, 'Marketing Executive', 4, 107),
(117, 'Aditya', 88000, 'Developer', 1, 101),
(118, 'Nisha', 61000, 'Accountant', 3, 105),
(119, 'Yash', 73000, 'ML Engineer', 5, 109),
(120, 'Kriti', 57000, 'HR Executive', 2, 103),
(121, 'Dev', 67000, 'Developer', 1, 101),
(122, 'Isha', 54000, 'Marketing Executive', 4, 107),
(123, 'Manish', 91000, 'AI Engineer', 5, 109),
(124, 'Ayesha', 63000, 'Analyst', 3, 105),
(125, 'Kabir', 76000, 'Developer', 1, 101),
(126, 'Meera', 59000, 'HR Executive', 2, 103),
(127, 'Sahil', 69000, 'Accountant', 3, 105),
(128, 'Diya', 81000, 'ML Engineer', 5, 109),
(129, 'Harsh', 71000, 'Marketing Executive', 4, 107),
(130, 'Muskan', 56000, 'HR Executive', 2, 103);

INSERT INTO Project VALUES
(201, 'Website Development', 1, 500000),
(202, 'Mobile App', 1, 700000),
(203, 'Recruitment System', 2, 300000),
(204, 'Financial Analysis', 3, 600000),
(205, 'Advertisement Campaign', 4, 400000),
(206, 'AI Chatbot', 5, 900000),
(207, 'Machine Learning Model', 5, 1000000),
(208, 'Data Analytics', 3, 800000);

INSERT INTO Employee_Project VALUES
(101,201,120),(102,201,100),(111,202,90),(112,202,80),(117,201,110),
(125,202,100),(103,203,70),(104,203,90),(113,203,80),(120,203,60),
(105,204,100),(106,204,90),(114,208,110),(118,208,80),(124,204,70),
(127,208,90),(107,205,100),(108,205,80),(116,205,70),(122,205,60),
(129,205,90),(109,206,120),(110,206,100),(115,207,110),(119,207,100),
(123,206,90),(128,207,120);

SELECT * FROM Employee;

-- INNER JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;

-- LEFT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
LEFT JOIN Department d
    ON e.dept_id = d.dept_id;

-- SELF JOIN
SELECT
    e.emp_name AS Employee, m.emp_name AS Manager
FROM Employee e
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;

-- THREE-WAY JOIN
SELECT e.emp_name, d.dept_name, p.project_name, ep.hours_worked
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id
INNER JOIN Employee_Project ep
    ON e.emp_id = ep.emp_id
INNER JOIN Project p
    ON ep.project_id = p.project_id;

-- CORRELATED SUBQUERY
SELECT e.emp_id, e.emp_name, e.salary, e.dept_id
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

-- EXISTS
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1 FROM Employee_Project ep WHERE ep.emp_id = e.emp_id
);

-- SIMULATED INTERSECT
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE e.salary > 70000
  AND EXISTS (
      SELECT 1 FROM Employee_Project ep WHERE ep.emp_id = e.emp_id
  );

-- SIMULATED EXCEPT
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1 FROM Employee_Project ep WHERE ep.emp_id = e.emp_id
);

-- EXPLAIN
EXPLAIN
SELECT e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;
