--Using AIT_1A Database
USE AIT_1A


--Medium Level Problem
--Create table Tbl_EmpR to store Employee Relations
Create Table Tbl_EmpR
(
EmpID INT PRIMARY KEY,
Ename VARCHAR(50) NOT NULL,
Department VARCHAR(50) NOT NULL,
ManagerID INT NULL
FOREIGN KEY(ManagerID) REFERENCES Tbl_EmpR(EmpID)
)
--Constraint added 
ALTER TABLE Tbl_EmpR
ADD CONSTRAINT FK_EMPLOYEE FOREIGN KEY(ManagerID) REFERENCES Tbl_EmpR(EmpID)

--Insert Values to Tbl_EmpR
INSERT INTO Tbl_EmpR(EmpID, EName, Department, ManagerID)
VALUES
(1, 'Alice', 'HR', NULL),        
(2, 'Bob', 'Finance', 1),
(3, 'Charlie', 'IT', 1),
(4, 'David', 'Finance', 2),
(5, 'Eve', 'IT', 3),
(6, 'Frank', 'HR', 1)

--Perform SELF JOIN(LEFT/RIGHT) 
SELECT E1.Ename AS [EMPLOYEE_NAME], E2.Ename AS [MANAGER_NAME],E1.Department AS [DEPARTMENT], E1.ManagerID AS [MANAGER_ID]
FROM Tbl_EmpR AS E1 
LEFT OUTER JOIN 
Tbl_EmpR AS E2 
ON E1.ManagerID=E2.EmpID


--Hard Level Problem
--Create Tbl_Year (holds actual NPV values)
CREATE TABLE Tbl_Year (
    ID INT,
    YEAR INT,
    NPV INT
);

--Create Queries table (requested values)
CREATE TABLE Queries(
    ID INT,
    YEAR INT
);

--Insert data into Tbl_Year
INSERT INTO Tbl_Year (ID, YEAR, NPV)
VALUES
    (1, 2018, 100),
    (7, 2020, 30),
    (13, 2019, 40),
    (1, 2019, 113),
    (2, 2008, 121),
    (3, 2009, 12),
    (11, 2020, 99),
    (7, 2019, 0);

--Insert data into Queries
INSERT INTO Queries (ID, YEAR)
VALUES
    (1, 2019),
    (2, 2008),
    (3, 2009),
    (7, 2018),
    (7, 2019),
    (7, 2020),
    (13, 2019);

--Perform LEFT OUTER JOIN to get NPV from Tbl_Year based on ID and YEAR
SELECT 
    q.ID,
    q.YEAR,
    ISNULL (y.NPV,0) AS NPV
FROM 
    Queries q
LEFT OUTER JOIN 
    Tbl_Year AS y
ON 
    q.ID = y.ID AND q.YEAR = y.YEAR;