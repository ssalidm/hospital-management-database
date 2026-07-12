INSERT INTO clinical.doctors (staff_member_id,
                              medical_license_number,
                              specialization)
VALUES ((SELECT id FROM clinical.staff_members WHERE staff_number = 'STF-2026-000001'),
        'HPCSA-MP-000001',
        'General Medicine');

INSERT INTO clinical.appointments (appointment_number,
                                   patient_id,
                                   doctor_id,
                                   created_by_staff_id,
                                   appointment_start,
                                   appointment_end,
                                   appointment_type,
                                   status,
                                   reason)
VALUES ('APT-2026-000001',
        (SELECT id FROM clinical.patients WHERE patient_number = 'PAT-2026-000001'),
        (SELECT d.id
         FROM clinical.doctors d
                  JOIN clinical.staff_members s
                       ON d.staff_member_id = s.id
         WHERE s.staff_number = 'STF-2026-000001'),
        (SELECT id FROM clinical.staff_members WHERE staff_number = 'STF-2026-000003'),
        CURRENT_DATE + INTERVAL '7 days' + INTERVAL '9 hours',
        CURRENT_DATE + INTERVAL '7 days' + INTERVAL '9 hours 30 minutes',
        'CONSULTATION',
        'SCHEDULED',
        'General check-up'),
       ('APT-2026-000002',
        (SELECT id FROM clinical.patients WHERE patient_number = 'PAT-2026-000002'),
        (SELECT d.id
         FROM clinical.doctors d
                  JOIN clinical.staff_members s
                       ON d.staff_member_id = s.id
         WHERE s.staff_number = 'STF-2026-000001'),
        (SELECT id FROM clinical.staff_members WHERE staff_number = 'STF-2026-000003'),
        CURRENT_DATE + INTERVAL '7 days' + INTERVAL '10 hours',
        CURRENT_DATE + INTERVAL '7 days' + INTERVAL '10 hours 30 minutes',
        'FOLLOW_UP',
        'CONFIRMED',
        'Follow-up consultation');