USE MyStoreDB
GO

--1.SQL ALIAS using AS statement
SELECT FirstName + ' ' + Lastname as CustomerName, Email as EmailID
FROM [dbo].[Customer]

--2.SQL JOINS
--LETS LOOK AT THE DATA IN SALES AND CUSTOMER TABLES
SELECT * FROM [dbo].[Sales]
SELECT * FROM [dbo].[Customer]

--2.1.INNER JOIN
--Example1
SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,A.CustomerID
,B.[FirstName]
,B.LastName
,B.Phone
FROM [dbo].[Sales] AS A
INNER JOIN [dbo].[Customer] B
ON A.CustomerID = B.CustomerID

--Example2
--INNER JOIN WITH CONCATINATING FirstName AND LastName COLUMN TO GET THE CUSTOMER FULL NAME
SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,A.CustomerID
,B.[FirstName] + ' ' + B.LastName AS CustomerName
,B.Phone
FROM [dbo].[Sales] AS A
INNER JOIN [dbo].[Customer] B ON A.CustomerID = B.CustomerID

--2.2.LEFT OUTER JOIN
SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,B.[FirstName] + ' ' + B.LastName AS CustomerName
,B.Phone
FROM [dbo].[Sales] AS A
LEFT OUTER JOIN [dbo].[Customer] B ON A.CustomerID = B.CustomerID

--2.3.RIGHT OUTER JOIN
SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,B.[FirstName] + ' ' + B.LastName AS CustomerName
,B.Phone
FROM [dbo].[Sales] AS A
RIGHT OUTER JOIN [dbo].[Customer] B ON A.CustomerID = B.CustomerID

SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,A.CustomerID AS A_CustomerID
,B.[FirstName] + ' ' + B.LastName AS CustomerName
,B.CustomerID AS B_CustomerID
,B.Phone
FROM [dbo].[Sales] AS A
RIGHT OUTER JOIN [dbo].[Customer] B ON A.CustomerID = B.CustomerID

--2.4.FULL OUTER JOIN
SELECT 
 A.[InvoiceID]
,A.[SalesDate]
,B.[FirstName] + ' ' + B.LastName AS CustomerName
,B.Phone
FROM [dbo].[Sales] AS A
FULL OUTER JOIN [dbo].[Customer] B
ON A.CustomerID = B.CustomerID

--2.4.SELF JOIN
--CHECK DATA FROM EMPLOYEE TABLE
SELECT * FROM dbo.Employee
--Following SQL Statement will get the Employee's manager name
SELECT	 
		 A.EmployeeID
		,A.FirstName +' ' + A.LastName EmployeeName
		,A.ManagerID
		,B.FirstName +' ' + B.LastName AS ManagerName 
FROM dbo.Employee AS A, dbo.Employee AS B
WHERE A.ManagerID = B.EmployeeID
--ABOVE QUERY IS RETURNING EMPLOYEE NAME AS NULL FOR CUSTOMER ID 6 AS THE LAST NAME IS NULL 
--AND IT IS RETURNING NULL AS NULL IS BEING CONCATINATED WITH A VALUE
--SO WE NEED TO USE ISNULL FUNCTION TO AVOID THIS SITUATION
SELECT	 
		 A.EmployeeID
		,ISNULL(A.FirstName,'') +' ' + ISNULL(A.LastName,'') EmployeeName
		,A.ManagerID
		,B.FirstName +' ' + B.LastName AS ManagerName 
FROM dbo.Employee AS A, dbo.Employee AS B
WHERE A.ManagerID = B.EmployeeID

--LETS GET ONLY THE EMPLOYEES HAING A REPORTING MANAGER
SELECT	 
		 A.EmployeeID
		,ISNULL(A.FirstName,'') +' ' + ISNULL(A.LastName,'') EmployeeName
		,A.ManagerID
		,B.FirstName +' ' + B.LastName AS ManagerName 
FROM dbo.Employee AS A
, dbo.Employee AS B
WHERE A.ManagerID = B.EmployeeID
AND A.ManagerID IS NOT NULL
--SO THIS WILL NOT GET THE TOP MOST EMPLOYEE OR CEO OF THE COMPANY 

--LETS GET EMPLOYEE SALARY BY ADDING A BONUS TO GET THE NEW SALARY
SELECT	 
		 A.EmployeeID
		,ISNULL(A.FirstName,'') +' ' + ISNULL(A.LastName,'') EmployeeName
		,A.ManagerID
		,B.FirstName +' ' + B.LastName AS ManagerName 
		,A.Salary + 25000 AS NewSalary
FROM dbo.Employee AS A
, dbo.Employee AS B
WHERE A.ManagerID = B.EmployeeID

--2.5.CROSS JOIN
--Following SQL Statement will get the all the records from Customer for each record from Sales table. 
--So it will be doing a Cartesian Product of the records from both tables
SELECT C.FirstName + ' ' + C.LastName as CustomerName,S.InvoiceID
FROM dbo.Customer AS C
CROSS JOIN dbo.Sales AS S

--If we add a WHERE clause in this query, then the CROSS JOIN will get the same result as INNER JOIN:
SELECT C.FirstName + ' ' + C.LastName as CustomerName,S.InvoiceID
FROM dbo.Customer AS C
CROSS JOIN dbo.Sales AS S
WHERE S.CustomerID = C.CustomerID

--2.5. USING DIFFERENT TYPE OF JOINS TOGETHER IN A QUERY
SELECT 
S.InvoiceID
,S.CustomerID
,C.FirstName + ' ' + C.LastName AS CustomerName
,S.SalesDate
,SD.LineID
,SD.ProductID
,P.ProductName
,SD.SalesAmount
FROM [dbo].[Sales] AS S
INNER JOIN [dbo].[SalesDetails] AS SD ON S.InvoiceID = SD.InvoiceID
LEFT JOIN [dbo].[Customer] AS C ON C.CustomerID = S.CustomerID
LEFT JOIN [dbo].[Product] AS P ON P.ProductID = SD.ProductID
