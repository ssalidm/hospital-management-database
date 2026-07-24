CREATE OR REPLACE VIEW  reporting.patient_directory AS
    SELECT
        id AS patient_id,
        patient_number,
        first_name,
        last_name,
        date_of_birth,
        gender,
        city,
        status,
        phone_number,
        email,
        preferred_language,
        registered_at,
        updated_at
    FROM clinical.patients;
