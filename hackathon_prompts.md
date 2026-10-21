# Hackathon Prompts

### PROMPT MESSAGE 1: EMPLOYEE IDENTITY

**Description:** Creates synthetic employee identity and job records used to assign people to business roles.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named EMPLOYEE_IDENTITY.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real personal data or copy data, IDs, names, or examples from Astra_Role_Patrol_Implementation.md. This is mock People Connect data, not a live system report.

Generate exactly 500 data rows with these columns in this order:

User Name, First Name, Last Name, Email, Manager, Type, Location, Title, Cost Center, Active Status, User Type, Phone Number, GID, Business Group, Manager_GID

Rules:
• Primary key: GID. User Name and Email must also be unique.
• Use GID0001–GID0500 and corresponding usernames USER0001–USER0500.
• Use fictional names, unique ".invalid" email addresses, and unique phone placeholders SYN-PHONE-0001 through SYN-PHONE-0500. Do not generate real phone numbers.
• Leave Type empty on every row.
• Manager_GID is an optional self-referencing foreign key to GID. Manager must match that employee's fictional full name. Top-level managers have both fields empty. No one manages themselves.
• Use only these Business Group values: GM Financial US, GM Financial Canada, GM Financial Mexico.
• Use fictional locations in Country - City, State/Province format. Do not include street addresses or precise location details.
• Use Active or Inactive for Active Status and Employee, Contractor, or Temporary for User Type.
• Create exactly 75 distinct combinations of Title, Cost Center, and Business Group. Reuse each combination across multiple employees where practical. Each combination will correspond to one business role.
• Generate 450 Active and 50 Inactive employees.
• Use three-digit Cost Center values.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 2: BUSINESS ROLE MASTER

**Description:** Defines the mock business roles and assigns an employee owner to each one.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named BUSINESS_ROLE_MASTER.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md. This is mock role data, not a live SailPoint export.

Use the attached EMPLOYEE_IDENTITY.csv as the source of employee attributes. Generate exactly 75 data rows with these columns:

Business_Role_ID, Business_Role_Name, Title, Cost_Center, Business_Group, Active_Status, Role_Owner_GID, Last_Reviewed_Date

Rules:
• Primary key: Business_Role_ID.
• Unique key: Title, Cost_Center, and Business_Group together.
• Role_Owner_GID must reference EMPLOYEE_IDENTITY.GID.
• Use IDs BR0001–BR0075.
• Use exactly the 75 distinct Title, Cost Center, and Business Group combinations in EMPLOYEE_IDENTITY.csv. Do not add or omit combinations.
• Format Business_Role_Name exactly as Title_BusinessGroup_CostCenter, replacing spaces within each component with underscores. Active_Status is not part of the name.
• Use Active or Inactive for Active_Status. If a role has any Active employee, its status must be Active.
• Select an existing Active employee as the role owner, preferably someone whose Business Group matches the role.
• Use Last_Reviewed_Date values between 2025-01-01 and 2026-10-01.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 3: APPLICATION MASTER

**Description:** Defines the fictional applications referenced by the entitlement catalog.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named APPLICATION_MASTER.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real product names or copy data or examples from Astra_Role_Patrol_Implementation.md.

Generate exactly 40 data rows with these columns:

Application_ID, Application_Name, Application_Category, Active_Status

Rules:
• Primary key: Application_ID.
• Application_Name must be unique.
• Use IDs APP001–APP040.
• Create fictional applications in plausible categories such as finance operations, reporting, document management, customer servicing, or case management. Do not use real system or product names.
• Use Active or Inactive for Active_Status; most applications should be Active.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 4: ENTITLEMENT CATALOG

**Description:** Lists mock access items that business roles can require.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named ENTITLEMENT_CATALOG.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md.

Use the attached APPLICATION_MASTER.csv as the source of application IDs and names. Generate exactly 250 data rows with these columns:

Entitlement_ID, Application_ID, Entitlement_Name, Entitlement_Type, Access_Level, Sensitive_Flag, Active_Status

Rules:
• Primary key: Entitlement_ID.
• Application_ID is a foreign key to APPLICATION_MASTER.Application_ID.
• Entitlement_Name must be unique within its application.
• Use unique IDs beginning at ENT0001.
• Distribute entitlements across the 40 applications, with multiple entitlements per application.
• Entitlement_Type must be Application Role, Security Group, or Permission.
• Access_Level must be Read, Standard, Elevated, or Administrative.
• Sensitive_Flag and Active_Status must be Y or N. Keep Administrative access rare.
• Use concise fictional entitlement names.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 5: ROLE ENTITLEMENTS

**Description:** Shows which entitlements each role requires and whether those entitlements are present, helping identify role gaps.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named ROLE_ENTITLEMENTS.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md.

Use the attached BUSINESS_ROLE_MASTER.csv and ENTITLEMENT_CATALOG.csv as the source of valid IDs. Generate exactly 900 data rows with these columns:

Business_Role_ID, Entitlement_ID, Required_Flag, Present_In_Role_Flag, Gap_Category, Effective_From, Effective_To

Rules:
• Composite primary key: Business_Role_ID and Entitlement_ID together.
• Business_Role_ID references BUSINESS_ROLE_MASTER.Business_Role_ID.
• Entitlement_ID references ENTITLEMENT_CATALOG.Entitlement_ID.
• Create exactly 12 unique entitlement rows per business role.
• Required_Flag and Present_In_Role_Flag must be Y or N.
• Set Gap_Category to Missing Required Entitlement only when Required_Flag = Y and Present_In_Role_Flag = N. For all other combinations, set it to None.
• Keep most roles healthy. Give approximately 15–20 roles one or more missing required entitlements, including multiple gaps in several roles.
• Effective_From must be on or before 2026-10-01. Leave Effective_To empty for current records; otherwise use a date before the snapshot.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 6: ROLE ASSIGNMENTS

**Description:** Connects employees to current and historical roles to support role-alignment and job-change analysis.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named ROLE_ASSIGNMENTS.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md.

Use the attached EMPLOYEE_IDENTITY.csv and BUSINESS_ROLE_MASTER.csv as the source of valid IDs and role attributes. Generate exactly 650 data rows with these columns:

Assignment_ID, GID, Business_Role_ID, Assignment_Status, Effective_From, Effective_To, Assignment_Source

Rules:
• Primary key: Assignment_ID.
• GID references EMPLOYEE_IDENTITY.GID.
• Business_Role_ID references BUSINESS_ROLE_MASTER.Business_Role_ID.
• Use unique IDs beginning at ASN0001.
• Give each Active employee exactly one Active assignment. Its role's Title, Cost_Center, and Business_Group must match the employee's identity fields.
• Inactive employees must have no Active assignment.
• Add ended historical assignments to reach 650 rows. Historical assignments must end before the employee's current assignment begins. No employee may have overlapping assignment periods.
• Use Active with an empty Effective_To for current assignments, and Ended with a populated Effective_To for historical assignments.
• Set Assignment_Source to People Connect Mock.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 7: JML EVENTS

**Description:** Records mock Joiner, Mover, and Leaver events that explain changes in role assignments.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named JML_EVENTS.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md.

Use the attached EMPLOYEE_IDENTITY.csv, BUSINESS_ROLE_MASTER.csv, ROLE_ASSIGNMENTS.csv, and ROLE_ENTITLEMENTS.csv as the source of valid employees, roles, assignments, and role gaps. Generate exactly 175 data rows with these columns:

JML_Event_ID, GID, Event_Type, Event_Date, Previous_Title, Previous_Cost_Center, Previous_Business_Group, New_Title, New_Cost_Center, New_Business_Group, Previous_Business_Role_ID, New_Business_Role_ID, Event_Status

Rules:
• Primary key: JML_Event_ID.
• GID references EMPLOYEE_IDENTITY.GID.
• Previous_Business_Role_ID and New_Business_Role_ID are nullable foreign keys to BUSINESS_ROLE_MASTER.Business_Role_ID.
• Use unique IDs beginning at JML0001.
• Include mostly Mover events, with some Joiner and Leaver events.
• For Mover events, previous and new role attributes must differ in at least one field and match the referenced roles.
• For Joiner events, leave previous attributes and role ID empty. For Leaver events, leave new attributes and role ID empty.
• Use dates from 2025-01-01 through 2026-10-01. Events before 2026-10-01 must be Completed. Events dated 2026-10-01 may be In Progress.
• Keep events consistent with assignment history. Some completed Joiner or Mover events must lead to roles with missing required entitlements; other events must lead to healthy roles.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 8: ACCESS REQUEST TICKETS

**Description:** Represents mock manual access requests, especially those caused by missing required role entitlements.

**Copy and paste this prompt:**

```text
Generate a deterministic, fully synthetic CSV named ACCESS_REQUEST_TICKETS.csv for the Role Patrol hackathon project. Use random seed 20261009. Do not use real data or copy data or examples from Astra_Role_Patrol_Implementation.md. This is mock ticket data, not a live ServiceNow export.

Use the attached EMPLOYEE_IDENTITY.csv, BUSINESS_ROLE_MASTER.csv, APPLICATION_MASTER.csv, ENTITLEMENT_CATALOG.csv, ROLE_ENTITLEMENTS.csv, ROLE_ASSIGNMENTS.csv, and JML_EVENTS.csv as the source of valid IDs and relationships. Generate exactly 600 data rows with these columns:

Ticket_ID, GID, Business_Role_ID, Entitlement_ID, JML_Event_ID, Request_Date, Resolution_Date, Ticket_Status, Request_Type, Priority, Business_Days_To_Resolve, Auto_Assigned_Expected, Present_In_Role_At_Request

Rules:
• Primary key: Ticket_ID.
• GID references EMPLOYEE_IDENTITY.GID.
• Business_Role_ID references BUSINESS_ROLE_MASTER.Business_Role_ID.
• Entitlement_ID references ENTITLEMENT_CATALOG.Entitlement_ID.
• JML_Event_ID is an optional foreign key to JML_EVENTS.JML_Event_ID.
• Use unique IDs beginning at TKT0001.
• Include many tickets where the requested entitlement is required but missing from the employee's assigned role. Link many of these to a relevant completed Joiner or Mover event that occurred before the request.
• For missing required entitlements, set Request_Type to Missing Role Access, Auto_Assigned_Expected to Y, and Present_In_Role_At_Request to N.
• Include some Optional Access and Other Access requests. Use values consistent with ROLE_ENTITLEMENTS.
• Ticket_Status must be Open, In Progress, or Resolved. Open tickets must have an empty Resolution_Date. Resolved tickets must have a Resolution_Date on or after Request_Date.
• Priority must be Low, Medium, or High. Business_Days_To_Resolve must be a non-negative integer when present.
• Use dates from 2025-01-01 through 2026-10-01. Do not include personal notes or real ServiceNow references.
• Output only the CSV with one header row. Do not include commentary.
```

---

### PROMPT MESSAGE 9: VALIDATION

**Copy and paste this prompt after all CSVs have been generated:**

```text
Validate the attached synthetic CSVs without changing them or displaying employee-level records.

Expected data-row counts:
• EMPLOYEE_IDENTITY.csv: 500
• BUSINESS_ROLE_MASTER.csv: 75
• APPLICATION_MASTER.csv: 40
• ENTITLEMENT_CATALOG.csv: 250
• ROLE_ENTITLEMENTS.csv: 900
• ROLE_ASSIGNMENTS.csv: 650
• JML_EVENTS.csv: 175
• ACCESS_REQUEST_TICKETS.csv: 600

Check primary-key uniqueness, foreign-key validity, required role and employee attribute matches, assignment status and non-overlap, role-entitlement gap flags, JML-to-assignment consistency, and ticket-to-role-gap/JML consistency.

Return aggregate row counts and pass/fail results only. Do not include employee-level records.
```
