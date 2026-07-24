DO
$$
    BEGIN
        IF NOT EXISTS(SELECT 1
                      FROM pg_roles
                      WHERE rolname = 'hms_application') THEN
            CREATE ROLE hms_application NOLOGIN;
        END IF;
    END;
$$;

GRANT CONNECT
    ON DATABASE hospital_db
    TO hms_application;

GRANT USAGE
    ON SCHEMA reporting
    TO hms_application;

GRANT SELECT
    ON reporting.patient_directory
    TO hms_application;
