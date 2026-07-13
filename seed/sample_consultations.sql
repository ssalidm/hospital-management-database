INSERT INTO clinical.consultations (appointment_id,
                                    performed_by_doctor_id,
                                    consultation_start,
                                    consultation_end,
                                    symptoms,
                                    clinical_notes,
                                    treatment_plan,
                                    follow_up_required,
                                    follow_up_notes)
VALUES
    -- Completed oncology follow-up (Christina Petrova)
    ((SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000008'),
     (SELECT d.id FROM clinical.doctors d JOIN clinical.staff_members s ON s.id = d.staff_member_id WHERE s.staff_number = 'STF-2026-000011'),
     CURRENT_DATE - INTERVAL '2 days' + INTERVAL '10 hours', CURRENT_DATE - INTERVAL '2 days' + INTERVAL '11 hours',
     'Fatigue, mild nausea, decreased appetite',
     'Patient tolerating chemotherapy cycle 3 reasonably well. Bloodwork shows mild anemia. No signs of infection.',
     'Continue current chemotherapy regimen. Iron supplementation started. Reassess bloodwork in 2 weeks.',
     TRUE,
     'Book follow-up bloodwork and oncology review in 14 days'),

    -- In-progress emergency trauma case (Reza Farahani)
    ((SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000013'),
     (SELECT d.id FROM clinical.doctors d JOIN clinical.staff_members s ON s.id = d.staff_member_id WHERE s.staff_number = 'STF-2026-000021'),
     CURRENT_DATE + INTERVAL '7 hours 30 minutes', NULL,
     'Chest pain, suspected rib fracture, laceration to left forearm, disorientation',
     'Patient stabilized on arrival. CT scan ordered to rule out internal bleeding. X-ray confirms fractured ribs (left 4th-5th). Laceration cleaned and sutured.',
     'Awaiting CT results before treatment plan finalized. Admit for observation.',
     TRUE,
     'Pending CT results — schedule orthopedic and neuro review if indicated');

INSERT INTO clinical.diagnoses (consultation_id,
                                diagnosis_code,
                                diagnosis_description,
                                diagnosis_type,
                                notes)
VALUES
    -- Diagnoses for the oncology consultation
    ((SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000008')),
     'C50.9', 'Malignant neoplasm of breast, unspecified', 'PRIMARY',
     'Under active chemotherapy treatment, cycle 3 of 6'),

    ((SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000008')),
     'D64.9', 'Anemia, unspecified', 'SECONDARY',
     'Likely chemotherapy-induced, iron supplementation started'),

    -- Diagnoses for the trauma consultation
    ((SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000013')),
     'S22.42', 'Multiple fractures of ribs, left side', 'PRIMARY',
     'Fractures at 4th and 5th ribs confirmed on X-ray'),

    ((SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000013')),
     'S51.812A', 'Laceration of left forearm, initial encounter', 'SECONDARY',
     'Cleaned and sutured in trauma bay'),

    ((SELECT id FROM clinical.consultations WHERE appointment_id =
                                                  (SELECT id FROM clinical.appointments WHERE appointment_number = 'APT-2026-000013')),
     'R41.0', 'Disorientation, unspecified', 'DIFFERENTIAL',
     'Possible mild concussion vs. shock response, pending CT and neuro review');