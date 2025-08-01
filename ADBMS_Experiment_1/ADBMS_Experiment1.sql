--Easy Level Problem
CREATE DATABASE AIT_1A; 
USE AIT_1A;

CREATE TABLE TBL_Author 
(
    Author_id INT PRIMARY KEY, 
    Author_name VARCHAR(50),
    Country VARCHAR(50)
);

CREATE TABLE TBL_Books 
(
    Book_id INT PRIMARY KEY, 
    Book_title VARCHAR(30),
    AuthorId INT, 
    FOREIGN KEY (AuthorId) REFERENCES TBL_Author(Author_id)
);

INSERT INTO TBL_Author (Author_id, Author_name, Country) VALUES
(1, 'Isabel Allende', 'Chile'),
(2, 'Harper Lee', 'United States'),
(3, 'Chimamanda Ngozi Adichie', 'Nigeria'),
(4, 'Neil Gaiman', 'United Kingdom'),
(5, 'Paulo Coelho', 'Brazil'),
(6, 'Salman Rushdie', 'India');

INSERT INTO TBL_Books (Book_id, Book_title, AuthorId) VALUES
(101, 'The House of Spirits', 1),
(102, 'To Kill a Mockingbird', 2),
(103, 'Half of a Yellow Sun', 3),
(104, 'American Gods', 4),
(105, 'The Alchemist', 5),
(106, 'Fury', 6);

SELECT 
    B.Book_title AS [Book Name], 
    A.Author_name AS [Author Name], 
    A.Country AS [Country]
FROM TBL_Books AS B
INNER JOIN TBL_Author AS A 
    ON B.AuthorId = A.Author_id;

--Medium Level Problem

USE AIT_1A; 

CREATE TABLE Department 
(
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);

CREATE TABLE Course 
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

INSERT INTO Department VALUES
(1, 'Computer Science'),
(2, 'Physics'),
(3, 'Mathematics'),
(4, 'Chemistry'),
(5, 'Biology');

INSERT INTO Course VALUES
(101, 'Data Structures', 1),
(102, 'Operating Systems', 1),
(103, 'Quantum Mechanics', 2),
(104, 'Electromagnetism', 2),
(105, 'Linear Algebra', 3),
(106, 'Calculus', 3),
(107, 'Organic Chemistry', 4),
(108, 'Physical Chemistry', 4),
(109, 'Genetics', 5),
(110, 'Computer Networks', 1),
(111, 'Linux/Unix systems', 1),
(112, 'Matrix', 3),
(113, 'Space Physics', 2);

SELECT D.DeptName,
    (SELECT COUNT(*) 
     FROM Course C 
     WHERE C.DeptID = D.DeptID) AS CourseCount
FROM Department D;

SELECT DeptID, DeptName,
    (SELECT COUNT(*) 
     FROM Course 
     WHERE Course.DeptID = Department.DeptID) AS CourseCount
FROM Department 
WHERE (SELECT COUNT(*) 
       FROM Course 
       WHERE Course.DeptID = Department.DeptID) > 2;

CREATE LOGIN Ashlin WITH PASSWORD='#23BAI70722';
CREATE USER Ashlin FOR LOGIN Ashlin;
GRANT SELECT ON Course TO Ashlin;
