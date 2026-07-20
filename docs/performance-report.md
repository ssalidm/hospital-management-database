# PostgreSQL Performance Report

## Test 1: Patient Appointment Lookup

### Query

Find benchmark appointments using `patient_id`.

### Before Index

Plan used:

- Sequential scan

Observation:

- PostgreSQL inspected most of the 100,000 rows.
- Only a small number of rows matched.

### Index Added

```sql
CREATE INDEX idx_appointment_demo_patient_id
ON performance.appointment_lookup_demo(patient_id);
```

### After Index

Plan used:

- Index scan or bitmap index scan

Observation:

- PostgreSQL used the patient ID lookup structure.
- Fewer rows and buffers needed to be inspected.

## Test 2: Doctor Schedule

### Query

Find one doctor’s appointments ordered by start time.

### Index Added

```sql
CREATE INDEX idx_appointment_demo_doctor_start
ON performance.appointment_lookup_demo(
    doctor_id,
    appointment_start
);
```

Observation:

The composite index supports filtering by doctor and ordering by appointment time.

### Key Findings
- Small tables may be faster with sequential scans.
- Indexes are most useful for selective queries.
- Composite index column order matters.
- Primary key and unique constraints already create indexes.
- Indexes improve reads but add write and storage costs.