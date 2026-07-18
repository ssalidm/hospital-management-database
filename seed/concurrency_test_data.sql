INSERT INTO clinical.patients (
    patient_number,
    first_name,
    last_name,
    date_of_birth,
    gender
)
VALUES
    (
        'PAT-CONC-000001',
        'Concurrency',
        'Patient One',
        '1990-01-01',
        'OTHER'
    ),
    (
        'PAT-CONC-000002',
        'Concurrency',
        'Patient Two',
        '1992-02-02',
        'OTHER'
    )
ON CONFLICT (patient_number) DO NOTHING;

INSERT INTO clinical.admissions (
    admission_number,
    patient_id,
    attending_doctor_id,
    admitted_by_staff_id,
    admission_type,
    admission_reason
)
VALUES
    (
        'ADM-CONC-000001',

        (
            SELECT id
            FROM clinical.patients
            WHERE patient_number = 'PAT-CONC-000001'
        ),

        (
            SELECT d.id
            FROM clinical.doctors d
                     JOIN clinical.staff_members s
                          ON d.staff_member_id = s.id
            WHERE s.staff_number = 'STF-2026-000001'
        ),

        (
            SELECT id
            FROM clinical.staff_members
            WHERE staff_number = 'STF-2026-000008'
        ),

        'OBSERVATION',
        'Concurrency training admission.'
    ),
    (
        'ADM-CONC-000002',

        (
            SELECT id
            FROM clinical.patients
            WHERE patient_number = 'PAT-CONC-000002'
        ),

        (
            SELECT d.id
            FROM clinical.doctors d
                     JOIN clinical.staff_members s
                          ON d.staff_member_id = s.id
            WHERE s.staff_number = 'STF-2026-000001'
        ),

        (
            SELECT id
            FROM clinical.staff_members
            WHERE staff_number = 'STF-2026-000008'
        ),

        'OBSERVATION',
        'Concurrency training admission.'
    )
ON CONFLICT (admission_number) DO NOTHING;