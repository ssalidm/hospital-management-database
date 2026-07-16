-- Current admitted patients
SELECT
    ad.admission_number,
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ad.admission_type,
    ad.admitted_at,
    ad.expected_discharge_date
FROM clinical.admissions ad
         JOIN clinical.patients p
              ON ad.patient_id = p.id
WHERE ad.status = 'ADMITTED'
ORDER BY ad.admitted_at;

-- Current bed occupancy
SELECT
    w.name AS ward,
    r.room_number,
    b.bed_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ba.assigned_at
FROM clinical.bed_assignments ba
         JOIN clinical.beds b
              ON ba.bed_id = b.id
         JOIN clinical.rooms r
              ON b.room_id = r.id
         JOIN clinical.wards w
              ON r.ward_id = w.id
         JOIN clinical.admissions ad
              ON ba.admission_id = ad.id
         JOIN clinical.patients p
              ON ad.patient_id = p.id
WHERE ba.released_at IS NULL
ORDER BY w.name, r.room_number, b.bed_number;

-- Available beds
SELECT
    w.name AS ward,
    r.room_number,
    b.bed_number
FROM clinical.beds b
         JOIN clinical.rooms r
              ON b.room_id = r.id
         JOIN clinical.wards w
              ON r.ward_id = w.id
         LEFT JOIN clinical.bed_assignments ba
                   ON b.id = ba.bed_id
                       AND ba.released_at IS NULL
WHERE b.operational_status = 'AVAILABLE'
  AND ba.id IS NULL
ORDER BY w.name, r.room_number, b.bed_number;

-- Patient bed history
SELECT
    ad.admission_number,
    w.name AS ward,
    r.room_number,
    b.bed_number,
    ba.assigned_at,
    ba.released_at
FROM clinical.bed_assignments ba
         JOIN clinical.admissions ad
              ON ba.admission_id = ad.id
         JOIN clinical.beds b
              ON ba.bed_id = b.id
         JOIN clinical.rooms r
              ON b.room_id = r.id
         JOIN clinical.wards w
              ON r.ward_id = w.id
WHERE ad.admission_number = 'ADM-2026-000001'
ORDER BY ba.assigned_at;