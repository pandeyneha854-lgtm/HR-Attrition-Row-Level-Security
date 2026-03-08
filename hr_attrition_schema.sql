-- Step 1: Reset tables so the script can be re-run safely. --
DROP TABLE IF EXISTS Fact_Performance; -- Drop fact table first because it depends on Dim_Employee.
DROP TABLE IF EXISTS Dim_Employee; -- Drop dimension table after fact table.
DROP TABLE IF EXISTS Dim_Date; -- Drop date dimension after fact table.

-- Step 1: Create the employee dimension with a self-referencing manager hierarchy. --
CREATE TABLE Dim_Employee ( -- Define the employee dimension table.
    Employee_ID INT NOT NULL PRIMARY KEY, -- Unique employee identifier (surrogate key).
    Employee_Name VARCHAR(100) NOT NULL, -- Employee display name.
    Employee_Email VARCHAR(150) NOT NULL, -- Employee email (UPN for RLS matching).
    Manager_ID INT NULL, -- Manager key referencing Employee_ID (NULL for top-level).
    CONSTRAINT FK_Dim_Employee_Manager FOREIGN KEY (Manager_ID) REFERENCES Dim_Employee(Employee_ID) -- Enforce hierarchy integrity.
); -- End Dim_Employee table.

-- Step 1: Insert 50 employees forming an uneven hierarchy with at least 4 levels. --
INSERT INTO Dim_Employee (Employee_ID, Employee_Name, Employee_Email, Manager_ID) VALUES -- Start employee seed data.
(1, 'Ava Johnson', 'ava.johnson@contoso.com', NULL), -- Level 1: CEO.
(2, 'Liam Smith', 'liam.smith@contoso.com', 1), -- Level 2: VP under CEO.
(3, 'Emma Davis', 'emma.davis@contoso.com', 1), -- Level 2: VP under CEO.
(4, 'Noah Brown', 'noah.brown@contoso.com', 1), -- Level 2: VP under CEO.
(5, 'Olivia Wilson', 'olivia.wilson@contoso.com', 2), -- Level 3: Director under VP.
(6, 'William Martinez', 'william.martinez@contoso.com', 2), -- Level 3: Director under VP.
(7, 'Sophia Anderson', 'sophia.anderson@contoso.com', 3), -- Level 3: Director under VP.
(8, 'James Taylor', 'james.taylor@contoso.com', 3), -- Level 3: Director under VP.
(9, 'Isabella Thomas', 'isabella.thomas@contoso.com', 4), -- Level 3: Director under VP.
(10, 'Benjamin Moore', 'benjamin.moore@contoso.com', 4), -- Level 3: Director under VP.
(11, 'Mia Jackson', 'mia.jackson@contoso.com', 5), -- Level 4: Manager under Director.
(12, 'Elijah Martin', 'elijah.martin@contoso.com', 5), -- Level 4: Manager under Director.
(13, 'Charlotte Lee', 'charlotte.lee@contoso.com', 6), -- Level 4: Manager under Director.
(14, 'Lucas Perez', 'lucas.perez@contoso.com', 6), -- Level 4: Manager under Director.
(15, 'Amelia Thompson', 'amelia.thompson@contoso.com', 7), -- Level 4: Manager under Director.
(16, 'Mason White', 'mason.white@contoso.com', 7), -- Level 4: Manager under Director.
(17, 'Harper Harris', 'harper.harris@contoso.com', 8), -- Level 4: Manager under Director.
(18, 'Ethan Clark', 'ethan.clark@contoso.com', 8), -- Level 4: Manager under Director.
(19, 'Evelyn Lewis', 'evelyn.lewis@contoso.com', 9), -- Level 4: Manager under Director.
(20, 'Logan Walker', 'logan.walker@contoso.com', 10), -- Level 4: Manager under Director.
(21, 'Abigail Hall', 'abigail.hall@contoso.com', 11), -- Level 5: IC under Manager.
(22, 'Daniel Allen', 'daniel.allen@contoso.com', 11), -- Level 5: IC under Manager.
(23, 'Ella Young', 'ella.young@contoso.com', 11), -- Level 5: IC under Manager.
(24, 'Henry Hernandez', 'henry.hernandez@contoso.com', 12), -- Level 5: IC under Manager.
(25, 'Avery King', 'avery.king@contoso.com', 12), -- Level 5: IC under Manager.
(26, 'Jackson Wright', 'jackson.wright@contoso.com', 12), -- Level 5: IC under Manager.
(27, 'Sofia Lopez', 'sofia.lopez@contoso.com', 13), -- Level 5: IC under Manager.
(28, 'Sebastian Hill', 'sebastian.hill@contoso.com', 13), -- Level 5: IC under Manager.
(29, 'Grace Scott', 'grace.scott@contoso.com', 13), -- Level 5: IC under Manager.
(30, 'Carter Green', 'carter.green@contoso.com', 14), -- Level 5: IC under Manager.
(31, 'Lily Adams', 'lily.adams@contoso.com', 14), -- Level 5: IC under Manager.
(32, 'Owen Baker', 'owen.baker@contoso.com', 14), -- Level 5: IC under Manager.
(33, 'Chloe Gonzalez', 'chloe.gonzalez@contoso.com', 15), -- Level 5: IC under Manager.
(34, 'Isaac Nelson', 'isaac.nelson@contoso.com', 15), -- Level 5: IC under Manager.
(35, 'Zoe Carter', 'zoe.carter@contoso.com', 15), -- Level 5: IC under Manager.
(36, 'Aiden Mitchell', 'aiden.mitchell@contoso.com', 16), -- Level 5: IC under Manager.
(37, 'Riley Perez', 'riley.perez@contoso.com', 16), -- Level 5: IC under Manager.
(38, 'Nora Roberts', 'nora.roberts@contoso.com', 16), -- Level 5: IC under Manager.
(39, 'Levi Turner', 'levi.turner@contoso.com', 17), -- Level 5: IC under Manager.
(40, 'Stella Phillips', 'stella.phillips@contoso.com', 17), -- Level 5: IC under Manager.
(41, 'Julian Campbell', 'julian.campbell@contoso.com', 17), -- Level 5: IC under Manager.
(42, 'Penelope Parker', 'penelope.parker@contoso.com', 18), -- Level 5: IC under Manager.
(43, 'Luke Evans', 'luke.evans@contoso.com', 18), -- Level 5: IC under Manager.
(44, 'Victoria Edwards', 'victoria.edwards@contoso.com', 18), -- Level 5: IC under Manager.
(45, 'Gabriel Collins', 'gabriel.collins@contoso.com', 19), -- Level 5: IC under Manager.
(46, 'Aria Stewart', 'aria.stewart@contoso.com', 19), -- Level 5: IC under Manager.
(47, 'Dylan Sanchez', 'dylan.sanchez@contoso.com', 19), -- Level 5: IC under Manager.
(48, 'Hazel Morris', 'hazel.morris@contoso.com', 20), -- Level 5: IC under Manager.
(49, 'Grayson Rogers', 'grayson.rogers@contoso.com', 20), -- Level 5: IC under Manager.
(50, 'Layla Reed', 'layla.reed@contoso.com', 20); -- Level 5: IC under Manager.

-- Step 1: Create a date dimension for time intelligence. --
CREATE TABLE Dim_Date ( -- Define the date dimension table.
    Date_Key INT NOT NULL PRIMARY KEY, -- Surrogate key in YYYYMMDD format.
    [Date] DATE NOT NULL, -- Actual date value.
    [Year] INT NOT NULL, -- Calendar year.
    [Quarter] INT NOT NULL, -- Calendar quarter.
    Month_Number INT NOT NULL, -- Calendar month number.
    Month_Name VARCHAR(20) NOT NULL, -- Calendar month name.
    Day_Of_Month INT NOT NULL, -- Day of month number.
    Weekday_Number INT NOT NULL, -- Day of week number.
    Weekday_Name VARCHAR(20) NOT NULL, -- Day of week name.
    Is_Month_End BIT NOT NULL, -- 1 if month end, else 0.
    CONSTRAINT UQ_Dim_Date_Date UNIQUE ([Date]) -- Ensure each date is unique.
); -- End Dim_Date table.

-- Step 1: Populate Dim_Date for 2025-01-01 through 2026-12-31. --
;WITH DateRange AS ( -- Generate a contiguous date range.
    SELECT CAST('2025-01-01' AS DATE) AS [Date] -- Start date.
    UNION ALL -- Add one day at a time.
    SELECT DATEADD(DAY, 1, [Date]) -- Next date in sequence.
    FROM DateRange -- Continue from the prior date.
    WHERE [Date] < '2026-12-31' -- Stop at the end date.
) -- End DateRange CTE.
INSERT INTO Dim_Date ( -- Insert generated rows into the date dimension.
    Date_Key, -- Surrogate key.
    [Date], -- Actual date.
    [Year], -- Calendar year.
    [Quarter], -- Calendar quarter.
    Month_Number, -- Calendar month number.
    Month_Name, -- Calendar month name.
    Day_Of_Month, -- Day of month.
    Weekday_Number, -- Day of week number.
    Weekday_Name, -- Day of week name.
    Is_Month_End -- Month end flag.
) -- End column list.
SELECT -- Map each generated date into attributes.
    CONVERT(INT, CONVERT(VARCHAR(8), [Date], 112)) AS Date_Key, -- YYYYMMDD key.
    [Date] AS [Date], -- Actual date.
    YEAR([Date]) AS [Year], -- Calendar year.
    DATEPART(QUARTER, [Date]) AS [Quarter], -- Calendar quarter.
    MONTH([Date]) AS Month_Number, -- Calendar month number.
    DATENAME(MONTH, [Date]) AS Month_Name, -- Calendar month name.
    DAY([Date]) AS Day_Of_Month, -- Day of month.
    DATEPART(WEEKDAY, [Date]) AS Weekday_Number, -- Day of week number.
    DATENAME(WEEKDAY, [Date]) AS Weekday_Name, -- Day of week name.
    CASE WHEN EOMONTH([Date]) = [Date] THEN 1 ELSE 0 END AS Is_Month_End -- Month end flag.
FROM DateRange -- Pull from the date range CTE.
OPTION (MAXRECURSION 0); -- Allow recursion beyond 100 levels.

-- Step 1: Create the performance fact table with metrics and a snapshot date. --
CREATE TABLE Fact_Performance ( -- Define the performance fact table.
    Employee_ID INT NOT NULL, -- Link to Dim_Employee.
    Engagement_Score DECIMAL(5,2) NOT NULL, -- Engagement score (0-100 scale).
    Salary DECIMAL(10,2) NOT NULL, -- Annual salary.
    Risk_of_Flight VARCHAR(10) NOT NULL, -- Risk band for attrition (High/Medium/Low).
    Snapshot_Date DATE NOT NULL, -- Snapshot date for time-based analysis.
    Is_Leaver BIT NOT NULL, -- 1 if employee left in the period, else 0.
    CONSTRAINT FK_Fact_Performance_Employee FOREIGN KEY (Employee_ID) REFERENCES Dim_Employee(Employee_ID), -- Enforce employee link.
    CONSTRAINT FK_Fact_Performance_Date FOREIGN KEY (Snapshot_Date) REFERENCES Dim_Date([Date]), -- Enforce date link.
    CONSTRAINT CK_Fact_Performance_Risk CHECK (Risk_of_Flight IN ('High', 'Medium', 'Low')) -- Enforce valid risk values.
); -- End Fact_Performance table.

-- Step 1: Insert 50 performance records aligned to employees. --
INSERT INTO Fact_Performance (Employee_ID, Engagement_Score, Salary, Risk_of_Flight, Snapshot_Date, Is_Leaver) VALUES -- Start performance seed data.
(1, 90.00, 220000.00, 'Low', '2026-01-31', 0), -- CEO metrics.
(2, 85.00, 180000.00, 'Low', '2026-01-31', 0), -- VP metrics.
(3, 82.00, 175000.00, 'Low', '2026-01-31', 0), -- VP metrics.
(4, 83.00, 185000.00, 'Low', '2026-01-31', 0), -- VP metrics.
(5, 78.00, 150000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(6, 76.00, 148000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(7, 75.00, 145000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(8, 74.00, 144000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(9, 77.00, 155000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(10, 79.00, 158000.00, 'Medium', '2026-01-31', 0), -- Director metrics.
(11, 72.00, 120000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(12, 70.00, 118000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(13, 71.00, 115000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(14, 69.00, 112000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(15, 68.00, 110000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(16, 67.00, 108000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(17, 66.00, 107000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(18, 65.00, 106000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(19, 64.00, 125000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(20, 63.00, 123000.00, 'Medium', '2026-01-31', 0), -- Manager metrics.
(21, 62.00, 85000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(22, 61.00, 84000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(23, 58.00, 83000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(24, 60.00, 82000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(25, 59.00, 81000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(26, 57.00, 80000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(27, 56.00, 79000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(28, 55.00, 78000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(29, 54.00, 77000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(30, 53.00, 76000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(31, 52.00, 75000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(32, 51.00, 74000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(33, 50.00, 73000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(34, 49.00, 72000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(35, 48.00, 71000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(36, 55.00, 70000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(37, 58.00, 69000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(38, 62.00, 68000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(39, 60.00, 67000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(40, 59.00, 66000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(41, 61.00, 65000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(42, 63.00, 64000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(43, 57.00, 63000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(44, 58.00, 62000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(45, 64.00, 61000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(46, 52.00, 60000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(47, 56.00, 59000.00, 'Medium', '2026-01-31', 0), -- IC metrics.
(48, 67.00, 58000.00, 'Low', '2026-01-31', 0), -- IC metrics.
(49, 54.00, 57000.00, 'High', '2026-01-31', 1), -- IC metrics (leaver).
(50, 65.00, 56000.00, 'Low', '2026-01-31', 0); -- IC metrics.
