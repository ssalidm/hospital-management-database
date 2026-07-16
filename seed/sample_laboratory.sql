INSERT INTO clinical.lab_tests (test_code,
                                test_name,
                                specimen_type,
                                default_unit,
                                default_reference_range)
VALUES (
        'LAB-GLU',
        'Blood Glucose',
        'BLOOD',
        'mmol/L',
        '4.0 - 7.0'
       ),
       ('LAB-HGB',
        'Haemoglobin',
        'BLOOD',
        'g/dL',
        '12.0 - 17.5'
       ),
       ('LAB-COVID-PCR',
        'COVID-19 PCR',
        'SWAB',
        NULL,
        'Not detected'
       );

INSERT INTO clinical.lab_orders (order_number,
                                 consultation_id,
                                 ordered_by_doctor_id,
                                 priority,
                                 status,
                                 clinical_notes)
VALUES ('LAB-2026-000001',
        (SELECT c.id
         FROM clinical.consultations c
                  JOIN clinical.appointments a
                       ON c.appointment_id = a.id
         WHERE a.appointment_number = 'APT-2026-000008'),
        (SELECT d.id
         FROM clinical.doctors d
                  JOIN clinical.staff_members s
                       ON d.staff_member_id = s.id
         WHERE s.staff_number = 'STF-2026-000011'),
        'ROUTINE',
        'COMPLETED',
        'Check glucose and haemoglobin levels.');

INSERT INTO clinical.lab_order_items (lab_order_id,
                                      lab_test_id,
                                      status,
                                      specimen_collected_at)
VALUES ((SELECT id
         FROM clinical.lab_orders
         WHERE order_number = 'LAB-2026-000001'),
        (SELECT id
         FROM clinical.lab_tests
         WHERE test_code = 'LAB-GLU'),
        'COMPLETED',
        CURRENT_TIMESTAMP - INTERVAL '1 hour'),
       ((SELECT id
         FROM clinical.lab_orders
         WHERE order_number = 'LAB-2026-000001'),
        (SELECT id
         FROM clinical.lab_tests
         WHERE test_code = 'LAB-HGB'),
        'COMPLETED',
        CURRENT_TIMESTAMP - INTERVAL '1 hour');

INSERT INTO  clinical.lab_results (
                                   lab_order_item_id,
                                   recorded_by_staff_id,
                                   result_value,
                                   result_unit,
                                   reference_range_used,
                                   interpretation,
                                   result_status,
                                   verified_at,
                                   notes
)
VALUES
(
 (
     SELECT loi.id
     FROM clinical.lab_order_items loi
     JOIN clinical.lab_orders lo
        ON loi.lab_order_id = lo.id
     JOIN clinical.lab_tests lt
        ON loi.lab_test_id = lt.id
     WHERE lo.order_number = 'LAB-2026-000001'
        AND lt.test_code = 'LAB-GLU'
     ),
 (
     SELECT id
     FROM clinical.staff_members
     WHERE staff_number = 'STF-2026-000017'
     ),
 '5.6',
 'mmol/L',
 '4.0 - 7.0',
 'NORMAL',
 'FINAL',
 CURRENT_TIMESTAMP,
 'Blood glucose is within the expected range.'
),
(
    (
        SELECT loi.id
        FROM clinical.lab_order_items loi
                 JOIN clinical.lab_orders lo
                      ON loi.lab_order_id = lo.id
                 JOIN clinical.lab_tests lt
                      ON loi.lab_test_id = lt.id
        WHERE lo.order_number = 'LAB-2026-000001'
          AND lt.test_code = 'LAB-HGB'
    ),
    (
        SELECT id
        FROM clinical.staff_members
        WHERE staff_number = 'STF-2026-000017'
    ),
    '13.8',
    'g/dL',
    '12.0 - 17.5',
    'NORMAL',
    'FINAL',
    CURRENT_TIMESTAMP,
    'Haemoglobin is within the expected range.'
);



