-- Lesson 3.5 SQL Practice
-- This file contains beginner SQL queries for the hospital database.

-- 1. View selected patient columns
SELECT
    patient_number,
    first_name,
    last_name,
    date_of_birth,
    status
FROM clinical.patients;

-- 2. View active patients only
SELECT
    patient_number,
    first_name,
    last_name,
    status
FROM clinical.patients
WHERE status = 'ACTIVE';

-- 3. View staff with their departments
SELECT
    s.staff_number,
    s.first_name,
    s.last_name,
    s.role,
    d.name AS department
FROM clinical.staff_members s
         JOIN clinical.departments d
              ON s.department_id = d.id
ORDER BY s.staff_number;

-- 4. View appointment schedule with patient and doctor names
SELECT
    a.appointment_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ds.first_name || ' ' || ds.last_name AS doctor_name,
    a.appointment_start,
    a.status
FROM clinical.appointments a
         JOIN clinical.patients p
              ON a.patient_id = p.id
         JOIN clinical.doctors doc
              ON a.doctor_id = doc.id
         JOIN clinical.staff_members ds
              ON doc.staff_member_id = ds.id
ORDER BY a.appointment_start;

-- 5. Check how PostgreSQL plans a patient appointment lookup
EXPLAIN
SELECT
    *
FROM clinical.appointments
WHERE patient_id = 1;