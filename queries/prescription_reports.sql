-- Full prescription details
SELECT
    pr.prescription_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ds.first_name || ' ' || ds.last_name AS doctor_name,
    m.generic_name,
    m.brand_name,
    m.strength,
    pi.dosage,
    pi.frequency,
    pi.duration_days,
    pi.quantity,
    pr.status
FROM clinical.prescriptions pr
         JOIN clinical.consultations c
              ON pr.consultation_id = c.id
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id
         JOIN clinical.doctors d
              ON pr.prescribed_by_doctor_id = d.id
         JOIN clinical.staff_members ds
              ON d.staff_member_id = ds.id
         JOIN clinical.prescription_items pi
              ON pi.prescription_id = pr.id
         JOIN clinical.medications m
              ON pi.medication_id = m.id
ORDER BY pr.prescribed_at DESC;

-- Count how often each medication is prescribed
SELECT
    m.generic_name,
    m.strength,
    COUNT(pi.id) AS times_prescribed
FROM clinical.prescription_items pi
         JOIN clinical.medications m
              ON pi.medication_id = m.id
GROUP BY m.generic_name, m.strength
ORDER BY times_prescribed DESC;

-- Prescriptions for one patient
SELECT
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    pr.prescription_number,
    pr.prescribed_at,
    pr.status
FROM clinical.prescriptions pr
         JOIN clinical.consultations c
              ON pr.consultation_id = c.id
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id
WHERE p.patient_number = 'PAT-2026-000004'
ORDER BY pr.prescribed_at DESC;