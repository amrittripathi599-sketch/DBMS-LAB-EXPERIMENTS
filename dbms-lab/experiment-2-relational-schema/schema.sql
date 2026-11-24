-- =====================================================
-- Experiment 2
-- Aim: Convert the ER diagram of an Indian E-commerce platform into a relational
-- schema; create MySQL tables with PRIMARY KEY, FOREIGN KEY, NOT NULL and UNIQUE
-- constraints, ON DELETE CASCADE / ON DELETE SET NULL actions; insert sample data;
-- demonstrate referential integrity constraints.
-- =====================================================

CREATE DATABASE college_DB;
USE college_DB;

CREATE TABLE DEPARTMENT (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES DEPARTMENT(Dept_ID)
        ON DELETE SET NULL
);

CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(50) NOT NULL,
    Credits INT NOT NULL
);

CREATE TABLE Enrollment (
    Enroll_ID INT PRIMARY KEY,
    Student_ID INT,
    Course_ID INT,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
        ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
        ON DELETE CASCADE
);

-- Sample data
INSERT INTO DEPARTMENT VALUES (1, 'CSE'), (2, 'AI-ML');

INSERT INTO Student VALUES
(101, 'Rahul', 'rahul12@gmail.com', 1),
(102, 'Vansh', 'vansh@gmail.com', 2);

INSERT INTO Course VALUES
(101, 'DBMS', 4),
(102, 'Operating System', 4);

INSERT INTO Enrollment VALUES
(1, 101, 201),
(2, 102, 202);

-- Verify
SELECT * FROM DEPARTMENT;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;
