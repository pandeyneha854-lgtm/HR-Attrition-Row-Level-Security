# Power BI Template (.pbit) Setup Instructions

These steps create a reusable Power BI template with the model, relationships, and RLS role configured. Power BI Desktop does not offer a supported CLI to generate `.pbit` files programmatically, so this is the reliable manual path.

## 1) Load Data

1. Open Power BI Desktop.
2. Get Data and connect to the database where you ran `hr_attrition_schema.sql`.
3. Load `Dim_Employee`, `Dim_Date`, and `Fact_Performance`.

## 2) Model Relationships

1. Create a relationship from `Fact_Performance[Employee_ID]` to `Dim_Employee[Employee_ID]`.
2. Create a relationship from `Fact_Performance[Snapshot_Date]` to `Dim_Date[Date]`.
3. Ensure both relationships are active and single-direction from dimensions to fact.

## 3) Create Calculated Columns (Hierarchy)

1. In `Dim_Employee`, add the calculated columns from `powerbi_dax.md`:
   - `HierarchyPath`
   - `Level1_Manager_ID` through `Level7_Manager_ID`
   - `Level1_Manager_Name` through `Level7_Manager_Name`

## 4) Create Measures

1. In your measures table (or in `Fact_Performance`), add the measures from `powerbi_dax.md`:
   - `Total Leavers`
   - `Average Headcount`
   - `Attrition Rate`
   - `Attrition Rate Color`

## 5) Configure Dynamic RLS

1. Go to Modeling > Manage Roles.
2. Create a role named `ManagerRLS`.
3. On `Dim_Employee`, paste the RLS filter DAX from `powerbi_dax.md`.
4. Test with View As and a known UPN from `Dim_Employee[Employee_Email]`.

## 6) Save As Template

1. File > Export > Power BI template.
2. Name it `HR_Attrition_RLS.pbit`.
3. Save the template alongside your model files.

## Notes

- If you prefer, you can create a dedicated measures table and move measures there for clarity.
- If your organization uses AAD/Entra IDs instead of email UPNs, update the mapping in the RLS filter accordingly.
