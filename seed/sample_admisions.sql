INSERT INTO clinical.wards (ward_code,
                            name,
                            department_id,
                            ward_type)
VALUES ('WARD-GEN',
        'General Medical Ward',
        (SELECT id
         FROM clinical.departments
         WHERE department_code = 'GEN'),
        'GENERAL');

INSERT INTO clinical.rooms (ward_id,
                            room_number,
                            room_type)
VALUES ((SELECT id
         FROM clinical.wards
         WHERE ward_code = 'WARD-GEN'),
        'M101',
        'SHARED'),
       ((SELECT id
         FROM clinical.wards
         WHERE ward_code = 'WARD-GEN'),
        'M102',
        'SHARED');

INSERT INTO clinical.beds (room_id,
                           bed_number)
VALUES ((SELECT id
         FROM clinical.rooms
         WHERE room_number = 'M101'
           AND ward_id = (SELECT id
                          FROM clinical.wards
                          WHERE ward_code = 'WARD-GEN')),
        'A'),
       ((SELECT id
         FROM clinical.rooms
         WHERE room_number = 'M101'
           AND ward_id = (SELECT id
                          FROM clinical.wards
                          WHERE ward_code = 'WARD-GEN')),
        'B'),
       ((SELECT id
         FROM clinical.rooms
         WHERE room_number = 'M102'
           AND ward_id = (SELECT id
                          FROM clinical.wards
                          WHERE ward_code = 'WARD-GEN')),
        'A');

BEGIN;

INSERT INTO clinical.admissions (admission_number,
                                 patient_id,
                                 attending_doctor_id,
                                 admitted_by_staff_id,
                                 admission_type,
                                 admission_reason,
                                 admitted_at,
                                 expected_discharge_date)
VALUES ('ADM-2026-000001',
        (SELECT id
         FROM clinical.patients
         WHERE patient_number = 'PAT-2026-000002'),
        (SELECT d.id
         FROM clinical.doctors d
                  JOIN clinical.staff_members s
                       ON d.staff_member_id = s.id
         WHERE s.staff_number = 'STF-2026-000001'),
        (SELECT id
         FROM clinical.staff_members
         WHERE staff_number = 'STF-2026-000003'),
        'EMERGENCY',
        'Patient requires observation following severe dizziness.',
        CURRENT_TIMESTAMP,
        CURRENT_DATE + 2);

INSERT INTO clinical.bed_assignments (admission_id,
                                      bed_id,
                                      assigned_by_staff_id,
                                      assignment_reason)
VALUES ((SELECT id
         FROM clinical.admissions
         WHERE admission_number = 'ADM-2026-000001'),
        (SELECT b.id
         FROM clinical.beds b
                  JOIN clinical.rooms r
                       ON b.room_id = r.id
                  JOIN clinical.wards w
                       ON r.ward_id = w.id
         WHERE w.ward_code = 'WARD-GEN'
           AND r.room_number = 'M101'
           AND b.bed_number = 'B'),
        (SELECT id
         FROM clinical.staff_members
         WHERE staff_number = 'STF-2026-000003'),
        'Initial bed assignment during admission.');

COMMIT;