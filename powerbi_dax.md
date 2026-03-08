# Power BI DAX for HR Attrition & Dynamic RLS

## Step 2: Hierarchy Flattening (Calculated Columns in `Dim_Employee`)

```dax
HierarchyPath = -- Build the parent-child path for the employee.
    PATH( -- Create a delimited list of ancestor Employee_ID values.
        Dim_Employee[Employee_ID], -- Child key (current employee).
        Dim_Employee[Manager_ID] -- Parent key (manager).
    ) -- End PATH.
```

```dax
Level1_Manager_ID = -- Top-level leader (root of the hierarchy).
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 1 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 1, -- Ensure the path has at least 1 level.
        PATHITEM(Dim_Employee[HierarchyPath], 1, INTEGER), -- Extract level 1 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level1_Manager_Name = -- Friendly name for Level 1 manager.
VAR L1 = Dim_Employee[Level1_Manager_ID] -- Capture the level 1 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L1), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L1 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level2_Manager_ID = -- Second-level leader in the hierarchy.
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 2 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 2, -- Ensure the path has at least 2 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 2, INTEGER), -- Extract level 2 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level2_Manager_Name = -- Friendly name for Level 2 manager.
VAR L2 = Dim_Employee[Level2_Manager_ID] -- Capture the level 2 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L2), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L2 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level3_Manager_ID = -- Third-level leader in the hierarchy.
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 3 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 3, -- Ensure the path has at least 3 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 3, INTEGER), -- Extract level 3 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level3_Manager_Name = -- Friendly name for Level 3 manager.
VAR L3 = Dim_Employee[Level3_Manager_ID] -- Capture the level 3 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L3), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L3 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level4_Manager_ID = -- Fourth-level leader in the hierarchy.
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 4 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 4, -- Ensure the path has at least 4 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 4, INTEGER), -- Extract level 4 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level4_Manager_Name = -- Friendly name for Level 4 manager.
VAR L4 = Dim_Employee[Level4_Manager_ID] -- Capture the level 4 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L4), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L4 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level5_Manager_ID = -- Fifth-level leader in the hierarchy (often the employee in a 5-level org).
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 5 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 5, -- Ensure the path has at least 5 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 5, INTEGER), -- Extract level 5 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level5_Manager_Name = -- Friendly name for Level 5 manager.
VAR L5 = Dim_Employee[Level5_Manager_ID] -- Capture the level 5 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L5), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L5 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level6_Manager_ID = -- Sixth-level leader in the hierarchy (extend for larger orgs).
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 6 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 6, -- Ensure the path has at least 6 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 6, INTEGER), -- Extract level 6 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level6_Manager_Name = -- Friendly name for Level 6 manager.
VAR L6 = Dim_Employee[Level6_Manager_ID] -- Capture the level 6 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L6), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L6 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

```dax
Level7_Manager_ID = -- Seventh-level leader in the hierarchy (extend for larger orgs).
VAR PathLength = PATHLENGTH(Dim_Employee[HierarchyPath]) -- Count levels in the path.
RETURN -- Return the Level 7 manager id or blank.
    IF( -- Guard against short paths.
        PathLength >= 7, -- Ensure the path has at least 7 levels.
        PATHITEM(Dim_Employee[HierarchyPath], 7, INTEGER), -- Extract level 7 id.
        BLANK() -- Return blank if the level doesn't exist.
    ) -- End IF.
```

```dax
Level7_Manager_Name = -- Friendly name for Level 7 manager.
VAR L7 = Dim_Employee[Level7_Manager_ID] -- Capture the level 7 manager id.
RETURN -- Return the name or blank.
    IF( -- Only look up when the id exists.
        ISBLANK(L7), -- Check for a missing id.
        BLANK(), -- Return blank when missing.
        LOOKUPVALUE( -- Look up the name by id.
            Dim_Employee[Employee_Name], -- Return column.
            Dim_Employee[Employee_ID], -- Search column.
            L7 -- Search value.
        ) -- End LOOKUPVALUE.
    ) -- End IF.
```

## Step 3: Dynamic Row-Level Security (RLS) Filter on `Dim_Employee`

```dax
VAR CurrentUserUPN = USERPRINCIPALNAME() -- Get the logged-in user's UPN/email.
VAR CurrentUserID = -- Map UPN to Employee_ID.
    LOOKUPVALUE( -- Find the employee id for the current user.
        Dim_Employee[Employee_ID], -- Return column.
        Dim_Employee[Employee_Email], -- Search column.
        CurrentUserUPN -- Search value.
    ) -- End LOOKUPVALUE.
RETURN -- Return TRUE when the row is visible to the user.
    NOT ISBLANK(CurrentUserID) -- Block access if the user isn't in Dim_Employee.
    && ( -- Apply visibility logic.
        Dim_Employee[Employee_ID] = CurrentUserID -- User can see their own row.
        || PATHCONTAINS( -- User can see any row in their management chain.
            Dim_Employee[HierarchyPath], -- Hierarchy path for the row.
            CurrentUserID -- The user id to check within the path.
        ) -- End PATHCONTAINS.
    ) -- End visibility logic.
```

## Step 4: Analytical DAX (Measures)

```dax
Total Leavers = -- Count employees who left in the period.
CALCULATE( -- Apply a filter and aggregate.
    SUM(Fact_Performance[Is_Leaver]), -- Sum the leaver flag.
    Fact_Performance[Is_Leaver] = 1 -- Only include leavers.
) -- End CALCULATE.
```

```dax
Average Headcount = -- Average headcount across the selected period.
AVERAGEX( -- Iterate each snapshot date.
    VALUES(Dim_Date[Date]), -- Distinct dates from the date dimension.
    CALCULATE( -- Re-evaluate headcount per date.
        DISTINCTCOUNT(Fact_Performance[Employee_ID]) -- Headcount per date.
    ) -- End CALCULATE.
) -- End AVERAGEX.
```

```dax
Attrition Rate = -- Total leavers divided by average headcount.
DIVIDE( -- Safe division to avoid divide-by-zero.
    [Total Leavers], -- Numerator.
    [Average Headcount] -- Denominator.
) -- End DIVIDE.
```

```dax
Attrition Rate Color = -- Hex color for conditional formatting.
VAR Rate = [Attrition Rate] -- Capture the current attrition rate.
RETURN -- Return a color based on thresholds.
    SWITCH( -- Choose the first matching condition.
        TRUE(), -- Evaluate conditions in order.
        Rate > 0.15, "#E74C3C", -- Red when above 15%.
        Rate < 0.05, "#2ECC71", -- Green when below 5%.
        "#F1C40F" -- Yellow otherwise.
    ) -- End SWITCH.
```
