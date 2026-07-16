INSERT INTO billing.services (
    service_code,
    name,
    description,
    default_price
)
VALUES
    (
        'SRV-CONSULT',
        'General Consultation',
        'General doctor consultation fee',
        850.00
    ),
    (
        'SRV-BED-GEN',
        'General Ward Bed Per Day',
        'Daily charge for a bed in the general ward',
        1200.00
    ),
    (
        'SRV-LAB-GLU',
        'Blood Glucose Test',
        'Laboratory blood glucose test',
        250.00
    );

INSERT INTO billing.invoices (
    invoice_number,
    patient_id,
    admission_id,
    issued_by_staff_id,
    status,
    issued_at,
    due_date,
    notes
)
VALUES (
           'INV-2026-000001',

           (
               SELECT id
               FROM clinical.patients
               WHERE patient_number = 'PAT-2026-000007'
           ),

           (
               SELECT id
               FROM clinical.admissions
               WHERE admission_number = 'ADM-2026-000001'
           ),

           (
               SELECT id
               FROM clinical.staff_members
               WHERE staff_number = 'STF-2026-000024'
           ),

           'ISSUED',
           CURRENT_TIMESTAMP,
           CURRENT_DATE + 14,
           'Invoice created for inpatient treatment.'
       );

INSERT INTO billing.invoice_items (
    invoice_id,
    service_id,
    description,
    quantity,
    unit_price
)
VALUES
    (
        (
            SELECT id
            FROM billing.invoices
            WHERE invoice_number = 'INV-2026-000001'
        ),
        (
            SELECT id
            FROM billing.services
            WHERE service_code = 'SRV-CONSULT'
        ),
        'General medical consultation',
        1,
        850.00
    ),
    (
        (
            SELECT id
            FROM billing.invoices
            WHERE invoice_number = 'INV-2026-000001'
        ),
        (
            SELECT id
            FROM billing.services
            WHERE service_code = 'SRV-BED-GEN'
        ),
        'General ward bed for two days',
        2,
        1200.00
    ),
    (
        (
            SELECT id
            FROM billing.invoices
            WHERE invoice_number = 'INV-2026-000001'
        ),
        (
            SELECT id
            FROM billing.services
            WHERE service_code = 'SRV-LAB-GLU'
        ),
        'Blood glucose laboratory test',
        1,
        250.00
    );

INSERT INTO billing.payments (
    payment_number,
    invoice_id,
    received_by_staff_id,
    amount,
    payment_method,
    status,
    reference_number,
    notes
)
VALUES (
           'PAY-2026-000001',

           (
               SELECT id
               FROM billing.invoices
               WHERE invoice_number = 'INV-2026-000001'
           ),

           (
               SELECT id
               FROM clinical.staff_members
               WHERE staff_number = 'STF-2026-000008'
           ),

           1000.00,
           'CARD',
           'COMPLETED',
           'CARD-REF-10001',
           'Initial partial payment.'
       );