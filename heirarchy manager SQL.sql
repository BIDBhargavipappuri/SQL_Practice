-- Step 1: Create the table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    ManagerID INT NULL,
    Department VARCHAR(50)
);

-- Step 2: Insert sample data
INSERT INTO Employees (EmpID, EmpName, ManagerID, Department) VALUES
(1, 'Alice', NULL, 'Executive'),       -- CEO
(2, 'Bob', 1, 'Finance'),              -- Reports to Alice
(3, 'Charlie', 1, 'IT'),               -- Reports to Alice
(4, 'David', 2, 'Finance'),            -- Reports to Bob
(5, 'Eva', 2, 'Finance'),              -- Reports to Bob
(6, 'Frank', 3, 'IT'),                 -- Reports to Charlie
(7, 'Grace', 3, 'IT'),                 -- Reports to Charlie
(8, 'Hannah', 4, 'Finance'),           -- Reports to David
(9, 'Ian', 6, 'IT');                   -- Reports to Frank

Select * from Employees

 SELECT EmpID, EmpName, ManagerID, Department, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

WITH EmployeeHierarchy AS (
    -- Anchor: start with top-level employees (no manager)
    SELECT EmpID, EmpName, ManagerID, Department, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive: join employees to their managers
    SELECT e.EmpID, e.EmpName, e.ManagerID, e.Department, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmpID
)
SELECT * 
FROM EmployeeHierarchy
ORDER BY Level, ManagerID, EmpID;


Select * from Employees

select e.EmpID,e.EmpName,e.ManagerID,m.ManagerID as ManID,m.EmpName as ManagerName
from Employees e 
left join Employees m on e.ManagerID =m.EmpID

