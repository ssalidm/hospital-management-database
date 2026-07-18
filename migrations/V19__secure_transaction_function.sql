-- Run the bed assignment function using its owner's permissions.
    ALTER FUNCTION clinical.assign_bed(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT
    )
    SECURITY DEFINER;

-- Prevent malicious objects from being resolved through an unsafe search path.
    ALTER FUNCTION clinical.assign_bed(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT
    )
    SET search_path TO pg_catalog, clinical;

-- Functions normally allow PUBLIC execution unless revoked.
REVOKE ALL ON FUNCTION clinical.assign_bed(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT
    )
    FROM PUBLIC;

GRANT EXECUTE ON FUNCTION clinical.assign_bed(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT
    )
    TO hms_receptionist;


-- Apply the same protection to the payment function.
    ALTER FUNCTION billing.record_payment(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    NUMERIC,
    VARCHAR,
    VARCHAR
    )
    SECURITY DEFINER;

ALTER FUNCTION billing.record_payment(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    NUMERIC,
    VARCHAR,
    VARCHAR
    )
    SET search_path TO pg_catalog, clinical, billing;

REVOKE ALL ON FUNCTION billing.record_payment(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    NUMERIC,
    VARCHAR,
    VARCHAR
    )
    FROM PUBLIC;

GRANT EXECUTE ON FUNCTION billing.record_payment(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    NUMERIC,
    VARCHAR,
    VARCHAR
    )
    TO hms_billing_clerk;