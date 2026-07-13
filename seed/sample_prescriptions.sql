INSERT INTO clinical.medications (medication_code,
                                  generic_name,
                                  brand_name,
                                  strength,
                                  dosage_form,
                                  is_prescription_required,
                                  is_active)
VALUES ('MED-PAR-TAB-500', 'Paracetamol', 'Panado', '500mg', 'TABLET', FALSE, TRUE),
       ('MED-IBU-TAB-200', 'Ibuprofen', 'Nurofen', '200mg', 'TABLET', FALSE, TRUE),
       ('MED-AMO-CAP-500', 'Amoxicillin', 'Amoxil', '500mg', 'CAPSULE', TRUE, TRUE),
       ('MED-MET-TAB-850', 'Metformin', 'Glucophage', '850mg', 'TABLET', TRUE, TRUE),
       ('MED-AML-TAB-005', 'Amlodipine', 'Norvasc', '5mg', 'TABLET', TRUE, TRUE),
       ('MED-OME-CAP-020', 'Omeprazole', 'Losec', '20mg', 'CAPSULE', TRUE, TRUE),
       ('MED-SAL-INH-100', 'Salbutamol', 'Ventolin', '100mcg/dose', 'INHALER', TRUE, TRUE),
       ('MED-FER-TAB-325', 'Ferrous Sulfate', 'Ferro-Grad', '325mg', 'TABLET', FALSE, TRUE),
       ('MED-MOR-INJ-010', 'Morphine Sulfate', NULL, '10mg/ml', 'INJECTION', TRUE, TRUE),
       ('MED-CEF-INJ-001', 'Cefazolin', 'Ancef', '1g', 'INJECTION', TRUE, TRUE),
       ('MED-DIC-CRE-001', 'Diclofenac Gel', 'Voltaren', '1%', 'CREAM', FALSE, TRUE),
       ('MED-OND-TAB-004', 'Ondansetron', 'Zofran', '4mg', 'TABLET', TRUE, TRUE),
       ('MED-AMO-SYR-250', 'Amoxicillin Syrup', 'Amoxil', '250mg/5ml', 'SYRUP', TRUE, TRUE),
       ('MED-LAT-DRO-005', 'Latanoprost', 'Xalatan', '0.005%', 'DROPS', TRUE, TRUE),
       ('MED-WAR-TAB-005', 'Warfarin', 'Coumadin', '5mg', 'TABLET', TRUE, FALSE);

INSERT INTO clinical.prescriptions (prescription_number,
                                    consultation_id,
                                    prescribed_by_doctor_id,
                                    prescribed_at,
                                    status,
                                    notes)
VALUES
    -- Oncology consultation (Christina Petrova) — anemia + supportive care
    ('RX-2026-000001',
     (SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000008')),
     (SELECT d.id FROM clinical.doctors d JOIN clinical.staff_members s ON s.id = d.staff_member_id WHERE s.staff_number = 'STF-2026-000011'),
       CURRENT_DATE - INTERVAL '2 days' + INTERVAL '10 hours 55 minutes',
     'ISSUED',
     'Iron supplementation and anti-nausea cover for chemotherapy cycle 3');

    -- Trauma consultation (Reza Farahani) — pain management and infection prevention
--     ('RX-2026-000002',
--      (SELECT id FROM clinical.consultations WHERE appointment_id =
--                                                   (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000013')),
--      (SELECT d.id FROM clinical.doctors d JOIN clinical.staff_members s ON s.id = d.staff_member_id WHERE s.staff_number = 'STF-2026-000021'),
--      '2026-07-13 08:10',
--      'DISPENSED',
--      'Initial trauma bay medication, administered by attending nurse');

INSERT INTO clinical.prescription_items (prescription_id,
                                         medication_id,
                                         dosage,
                                         frequency,
                                         duration_days,
                                         quantity,
                                         instructions)
VALUES
    -- Items for RX-2026-000001 (oncology)
    ((SELECT id FROM clinical.prescriptions WHERE prescription_number = 'RX-2026-000001'),
     (SELECT id FROM clinical.medications WHERE medication_code = 'MED-FER-TAB-325'),
     '325mg', 'Once daily', 30, 30,
     'Take with food to reduce stomach upset'),

    ((SELECT id FROM clinical.prescriptions WHERE prescription_number = 'RX-2026-000001'),
     (SELECT id FROM clinical.medications WHERE medication_code = 'MED-OND-TAB-004'),
     '4mg', 'Every 8 hours as needed', 7, 21,
     'Take for nausea, do not exceed 3 doses per day');

    -- Items for RX-2026-000002 (trauma)
--     ((SELECT id FROM clinical.prescriptions WHERE prescription_number = 'RX-2026-000002'),
--      (SELECT id FROM clinical.medications WHERE medication_code = 'MED-000009'),
--      '10mg/ml', 'Every 4 hours as needed', 2, 6,
--      'For acute pain management, administered under supervision'),
--
--     ((SELECT id FROM clinical.prescriptions WHERE prescription_number = 'RX-2026-000002'),
--      (SELECT id FROM clinical.medications WHERE medication_code = 'MED-000010'),
--      '1g', 'Every 8 hours', 5, 15,
--      'Prophylactic antibiotic cover for open laceration');