# Hospital Management Database

This project is a PostgreSQL-based Hospital Management System database built as a database engineering portfolio project.

The goal of this project is to demonstrate practical database management and engineering skills, including schema design, constraints, relationships, SQL queries, indexing, migrations, seed data, and production-style database thinking.

## Current Progress

### Module 1: Patient Registration

Concepts covered:

* PostgreSQL with Docker
* Database schemas
* Tables and columns
* Primary keys
* Unique constraints
* Check constraints
* Default values
* Sample seed data
* Basic `SELECT` queries

Tables created:

* `clinical.patients`

### Module 2: Departments and Staff

Concepts covered:

* Reference tables
* One-to-many relationships
* Foreign keys
* Joins
* Left joins
* Check constraints
* Basic indexes

Tables created:

* `clinical.departments`
* `clinical.staff_members`

Indexes added:

* `idx_staff_members_department_id`
* `idx_staff_members_role`
* `idx_staff_members_employment_status`

---

## Technology Stack

* PostgreSQL 18
* Docker
* Docker Compose
* SQL
* Git and GitHub

---

## Project Structure

```text
hospital-management-database/
├── README.md
├── docker-compose.yml
├── docs/
├── migrations/
│   ├── V1__create_patient_registration.sql
│   ├── V2__create_departments_and_staff.sql
│   ├── V3__add_staff_indexes.sql
│   ├── V4__create_doctors_and_appointments.sql
│   ├── V5__add_appointment_indexes.sql
│   ├── V6__create_consultations_and_diagnoses.sql
│   ├── V7__add_consultation_indexes.sql
│   ├── V8__create_prescriptions_and_medications.sql
│   └── V9__add_prescription_indexes.sql
│
├── queries/
│   ├── consultation_reports.sql
│   ├── lesson_3_5_sql_practice.sql
│   └── prescription_reports.sql
│
└── seed/
    ├── sample_appointments.sql
    ├── sample_consultations.sql
    ├── sample_patients.sql
    ├── sample_prescriptions.sql
    └── sample_staff.sql
```

---

## Database Setup

The project uses PostgreSQL running inside Docker.

### Start the database

```bash
docker compose up -d
```

### Stop the database

```bash
docker compose down
```

### Stop the database and remove stored data

```bash
docker compose down -v
```

Use this carefully. The `-v` flag deletes the Docker volume, which means the database data will be removed.

---

## PostgreSQL Connection Details

```text
Database: hospital_db
User: hospital_user
Password: hospital_password
Host: localhost
Port: 5432
```

Inside Docker, PostgreSQL runs on port `5432`.

On the local machine, it is exposed as port `5432`.

---

## Connect to PostgreSQL

```bash
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db
```

Once connected, the prompt should look like this:

```text
hospital_db=#
```

Exit PostgreSQL:

```sql
\q
```

---

## Running Migrations Manually

This project currently runs migrations manually so that each database change is easy to understand.

### Run Module 1 migration

```bash
docker cp migrations/V1__create_patient_registration.sql hospital_postgres:/tmp/V1__create_patient_registration.sql
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db -f /tmp/V1__create_patient_registration.sql
```

### Run Module 2 migration

```bash
docker cp migrations/V2__create_departments_and_staff.sql hospital_postgres:/tmp/V2__create_departments_and_staff.sql
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db -f /tmp/V2__create_departments_and_staff.sql
```

### Run Module 3 indexes migration

```bash
docker cp migrations/V3__add_staff_indexes.sql hospital_postgres:/tmp/V3__add_staff_indexes.sql
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db -f /tmp/V3__add_staff_indexes.sql
```

Later in the project, these migrations may be automated using Flyway.

---

## Loading Sample Data

### Insert sample patients

```bash
docker cp seed/sample_patients.sql hospital_postgres:/tmp/sample_patients.sql
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db -f /tmp/sample_patients.sql
```

### Insert sample departments and staff

```bash
docker cp seed/sample_staff.sql hospital_postgres:/tmp/sample_staff.sql
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db -f /tmp/sample_staff.sql
```

---

## Useful PostgreSQL Inspection Commands

Connect to the database first:

```bash
docker exec -it hospital_postgres psql -U hospital_user -d hospital_db
```

### Show schemas

```sql
\dn
```

### Show tables in the clinical schema

```sql
\dt clinical.*
```

### Describe the patients table

```sql
\d clinical.patients
```

### Describe the departments table

```sql
\d clinical.departments
```

### Describe the staff table

```sql
\d clinical.staff_members
```

### Show indexes

```sql
\di clinical.*
```

---

## Useful SQL Queries

### View all patients

```sql
SELECT
    id,
    patient_number,
    first_name,
    last_name,
    date_of_birth,
    gender,
    city,
    status,
    registered_at
FROM clinical.patients;
```

### View staff with their departments

```sql
SELECT
    s.staff_number,
    s.first_name,
    s.last_name,
    s.role,
    d.name AS department,
    s.employment_status
FROM clinical.staff_members s
JOIN clinical.departments d
    ON s.department_id = d.id
ORDER BY d.name, s.last_name;
```

### Count staff per department

```sql
SELECT
    d.name AS department,
    COUNT(s.id) AS staff_count
FROM clinical.departments d
LEFT JOIN clinical.staff_members s
    ON s.department_id = d.id
GROUP BY d.name
ORDER BY d.name;
```

### Show active doctors

```sql
SELECT
    s.staff_number,
    s.first_name || ' ' || s.last_name AS full_name,
    d.name AS department
FROM clinical.staff_members s
JOIN clinical.departments d
    ON s.department_id = d.id
WHERE s.role = 'DOCTOR'
  AND s.employment_status = 'ACTIVE'
ORDER BY s.last_name;
```

---

## Database Design Notes

### Why use a `clinical` schema?

The `clinical` schema groups hospital-related clinical data together.

Examples:

```text
clinical.patients
clinical.departments
clinical.staff_members
```

Later, the project can include other schemas such as:

```text
billing.invoices
audit.audit_logs
admin.users
```

This keeps the database organised as it grows.

### Why use foreign keys?

Foreign keys protect relationships between tables.

For example:

```text
clinical.staff_members.department_id
```

must point to a real department in:

```text
clinical.departments.id
```

This prevents invalid data, such as assigning a staff member to a department that does not exist.

### Why use check constraints?

Check constraints protect business rules at the database level.

For example:

```sql
CHECK (gender IN ('MALE', 'FEMALE', 'OTHER', 'UNKNOWN'))
```

This prevents unexpected values from being inserted into the `gender` column.

Another example:

```sql
CHECK (date_of_birth <= CURRENT_DATE)
```

This prevents patients from being registered with a future date of birth.

---

## Git Workflow

After each completed lesson, commit the work.

```bash
git add .
git commit -m "Add departments and staff schema"
```

Example commits:

```text
Create patient registration schema
Add departments and staff schema
Add staff indexes
```

---

## Next Module

The next module will add appointment scheduling.

Planned tables:

* `clinical.appointments`

Planned concepts:

* Relationships between patients and doctors
* Appointment statuses
* Time-based constraints
* Preventing invalid bookings
* Querying appointment schedules

---

## Module 3: Appointment Scheduling

Concepts covered:

- Doctor profiles
- Patient-to-doctor appointments
- Foreign keys
- Multi-table joins
- Appointment statuses
- Time validation
- Exclusion constraints
- Overlap prevention
- Appointment indexes

Tables added:

- `clinical.doctors`
- `clinical.appointments`

Indexes added:

- `idx_appointments_patient_id`
- `idx_appointments_doctor_id`
- `idx_appointments_start`
- `idx_appointments_status`
- `idx_appointments_doctor_start`

### Useful Queries

Patient appointment history:

```sql
SELECT
    a.appointment_number,
    a.appointment_start,
    a.appointment_end,
    ds.first_name || ' ' || ds.last_name AS doctor_name,
    a.appointment_type,
    a.status,
    a.reason
FROM clinical.appointments a
         JOIN clinical.doctors d
              ON a.doctor_id = d.id
         JOIN clinical.staff_members ds
              ON d.staff_member_id = ds.id
WHERE a.patient_id = (
    SELECT id
    FROM clinical.patients
    WHERE patient_number = 'PAT-2026-000001'
)
ORDER BY a.appointment_start DESC;
```

Doctor schedule:

```sql
SELECT
a.appointment_number,
a.appointment_start,
a.appointment_end,
p.first_name || ' ' || p.last_name AS patient_name,
a.status,
a.reason
FROM clinical.appointments a
JOIN clinical.patients p
ON a.patient_id = p.id
WHERE a.doctor_id = (
SELECT d.id
FROM clinical.doctors d
JOIN clinical.staff_members s
ON d.staff_member_id = s.id
WHERE s.staff_number = 'STF-2026-000001'
)
ORDER BY a.appointment_start;
```

Appointments by status:

```sql
SELECT
    status,
    COUNT(*) AS appointment_count
FROM clinical.appointments
GROUP BY status
ORDER BY status;
```
---

## Lesson 3.5: SQL Practice

Concepts reviewed:

- Reading `SELECT` queries
- Filtering with `WHERE`
- Sorting with `ORDER BY`
- Inserting sample data
- Understanding seed files
- Understanding aliases
- Understanding joins
- Understanding subqueries
- Introduction to `EXPLAIN`
- Beginner explanation of indexes

Practice file added:

- `queries/lesson_3_5_sql_practice.sql`

---

## Module 4: Consultations and Diagnoses

Concepts covered:

- Consultation records
- Diagnosis records
- One-to-one relationship between appointments and consultations
- One-to-many relationship between consultations and diagnoses
- Foreign keys
- Check constraints
- Partial unique indexes
- Medical history queries
- Multi-table joins

Tables added:

- `clinical.consultations`
- `clinical.diagnoses`

Indexes added:

- `uq_diagnoses_one_primary_per_consultation`
- `idx_consultations_appointment_id`
- `idx_consultations_doctor_id`
- `idx_diagnoses_consultation_id`
- `idx_diagnoses_code`

Query files added:

- `queries/consultation_reports.sql`

---
## Module 5: Prescriptions and Medications

Concepts covered:

- Medication catalogue
- Prescription records
- Prescription line items
- One-to-many relationships
- Foreign keys
- Unique constraints
- Check constraints
- Prescription report queries
- Indexes for prescription lookups

Tables added:

- `clinical.medications`
- `clinical.prescriptions`
- `clinical.prescription_items`

Indexes added:

- `idx_prescriptions_consultation_id`
- `idx_prescriptions_doctor_id`
- `idx_prescriptions_status`
- `idx_prescription_items_prescription_id`
- `idx_prescription_items_medication_id`
- `idx_medications_generic_name`

Query files added:

- `queries/prescription_reports.sql`