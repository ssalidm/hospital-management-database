-- Consultation report with patient and doctor names
SELECT
    a.appointment_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ds.first_name || ' ' || ds.last_name AS doctor_name,
    c.consultation_start,
    c.consultation_end,
    c.symptoms,
    c.treatment_plan
FROM clinical.consultations c
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id
         JOIN clinical.doctors d
              ON c.performed_by_doctor_id = d.id
         JOIN clinical.staff_members ds
              ON d.staff_member_id = ds.id
ORDER BY c.consultation_start DESC;

-- Diagnosis history for one patient
SELECT
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    a.appointment_number,
    dg.diagnosis_code,
    dg.diagnosis_description,
    dg.diagnosis_type,
    dg.notes
FROM clinical.diagnoses dg
         JOIN clinical.consultations c
              ON dg.consultation_id = c.id
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id
WHERE p.patient_number = 'PAT-2026-000004'
ORDER BY a.appointment_start DESC, dg.diagnosis_type;

-- Count diagnoses by diagnosis code
SELECT
    diagnosis_code,
    diagnosis_description,
    COUNT(*) AS diagnosis_count
FROM clinical.diagnoses
GROUP BY diagnosis_code, diagnosis_description
ORDER BY diagnosis_count DESC;