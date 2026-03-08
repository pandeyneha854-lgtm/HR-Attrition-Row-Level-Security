# HR Attrition & Row-Level Security (PL-300 Focus) Summary

This project delivers a complete, secure HR attrition model for Power BI that supports uneven manager-employee hierarchies and dynamic Row-Level Security (RLS). It includes a SQL data model with mock data and DAX for hierarchy flattening, RLS, and attrition analytics.

## What I Built

- A self-referencing `Dim_Employee` table with 50 rows and a valid, uneven hierarchy that is at least 4 levels deep.
- A `Fact_Performance` table linked to `Dim_Employee` with engagement, salary, risk of flight, and a snapshot date for time filtering.
- A `Dim_Date` table for time intelligence and filtering by date.
- DAX calculated columns to flatten the parent-child hierarchy using `PATH()` and `PATHITEM()`.
- A dynamic RLS filter expression that uses `USERPRINCIPALNAME()` and `PATHCONTAINS()` to restrict data to a user and their subtree.
- Attrition measures including a rate calculation and a hex color measure for conditional formatting.

## Files Created

- `hr_attrition_schema.sql` contains the SQL schema and mock data with line-by-line comments.
- `powerbi_dax.md` contains the DAX calculated columns, RLS filter, and measures with line-by-line comments.
- `SUMMARY.md` is this overview.
- `powerbi_template_instructions.md` provides step-by-step guidance to create a `.pbit` template manually.

## How It Works

- `Dim_Employee` is a parent-child hierarchy where `Manager_ID` references `Employee_ID` and `Employee_Email` matches Power BI UPNs for RLS.
- `HierarchyPath` uses `PATH()` to store each employee’s full ancestor chain.
- `Level1_Manager_Name` through `Level7_Manager_Name` use `PATHITEM()` plus `LOOKUPVALUE()` so each level can be used in slicers.
- Dynamic RLS looks up the current user by UPN, then uses `PATHCONTAINS()` to check if that user is an ancestor in the employee’s path.
- Attrition measures use `Is_Leaver` and `Snapshot_Date` in `Fact_Performance` and the `Dim_Date` table to calculate leavers over any filtered time period.

## How To Apply In Power BI

1. Run `hr_attrition_schema.sql` in your database to create and populate the tables.
2. Load `Dim_Employee` and `Fact_Performance` into Power BI.
3. Create a relationship from `Fact_Performance[Employee_ID]` to `Dim_Employee[Employee_ID]`.
4. Create a relationship from `Fact_Performance[Snapshot_Date]` to `Dim_Date[Date]`.
5. Add the calculated columns from `powerbi_dax.md` to `Dim_Employee`.
6. In Manage Roles, apply the RLS DAX filter (also in `powerbi_dax.md`) to `Dim_Employee`.
7. Add the measures to your model and apply `Attrition Rate Color` for conditional formatting.

## Notes And Assumptions

- The hierarchy levels are defined from the top of the org (Level 1) downwards. If your org has more levels, extend the pattern beyond Level 5.
- The date range in `Dim_Date` covers 2025-01-01 to 2026-12-31. Adjust it to your needs if you want a wider historical range.
- `Snapshot_Date` in `Fact_Performance` is linked to `Dim_Date[Date]` for time intelligence.
- RLS assumes `Dim_Employee[Employee_Email]` matches the UPN returned by `USERPRINCIPALNAME()`.
