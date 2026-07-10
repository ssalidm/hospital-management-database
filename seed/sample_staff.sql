INSERT INTO clinical.departments (
    department_code,
    name,
    description
)
VALUES
    ('EMR', 'Emergency', 'Handles emergency and trauma cases'),
    ('GEN', 'General Medicine', 'Handles general consultations and primary care'),
    ('CARD', 'Cardiology', 'Handles heart-related conditions'),
    ('LAB', 'Laboratory', 'Handles lab tests and results'),
    ('RAD', 'Radiology', 'Handles imaging such as X-rays and scans'),
    ('BILL', 'Billing', 'Handles invoices and payments');

INSERT INTO clinical.staff_members (
    staff_number,
    first_name,
    last_name,
    role,
    department_id,
    phone_number,
    email
)
VALUES
    (
        'STF-2026-000001',
        'John',
        'Nkosi',
        'DOCTOR',
        (SELECT id FROM clinical.departments WHERE department_code = 'GEN'),
        '+27830000001',
        'john.nkosi@hospital.test'
    ),
    (
        'STF-2026-000002',
        'Lerato',
        'Maseko',
        'NURSE',
        (SELECT id FROM clinical.departments WHERE department_code = 'EMR'),
        '+27830000002',
        'lerato.maseko@hospital.test'
    ),
    (
        'STF-2026-000003',
        'Zanele',
        'Khumalo',
        'RECEPTIONIST',
        (SELECT id FROM clinical.departments WHERE department_code = 'EMR'),
        '+27830000003',
        'zanele.khumalo@hospital.test'
    ),
    (
        'STF-2026-000004',
        'Priya',
        'Naidoo',
        'LAB_TECHNICIAN',
        (SELECT id FROM clinical.departments WHERE department_code = 'LAB'),
        '+27830000004',
        'priya.naidoo@hospital.test'
    ),
    (
        'STF-2026-000005',
        'Michael',
        'Botha',
        'BILLING_CLERK',
        (SELECT id FROM clinical.departments WHERE department_code = 'BILL'),
        '+27830000005',
        'michael.botha@hospital.test'
    );