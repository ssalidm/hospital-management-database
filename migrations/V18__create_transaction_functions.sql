-- Safe bed assignment
CREATE OR REPLACE FUNCTION clinical.assign_bed(
    p_admission_number VARCHAR,
    p_ward_code VARCHAR,
    p_room_number VARCHAR,
    p_bed_number VARCHAR,
    p_staff_number VARCHAR,
    p_assignment_reason TEXT
)
    RETURNS BIGINT
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_admission_id  BIGINT;
    v_bed_id        BIGINT;
    v_staff_id      BIGINT;
    v_assignment_id BIGINT;
    v_bed_status    VARCHAR(30);
BEGIN
    SELECT id
    INTO STRICT v_admission_id
    FROM clinical.admissions
    WHERE admission_number = p_admission_number
      AND status = 'ADMITTED'
        FOR UPDATE;

    SELECT b.id,
           b.operational_status
    INTO STRICT
        v_bed_id,
        v_bed_status
    FROM clinical.beds b
             JOIN clinical.rooms r
                  ON b.room_id = r.id
             JOIN clinical.wards w
                  ON r.ward_id = w.id
    WHERE w.ward_code = p_ward_code
      AND r.room_number = p_room_number
      AND b.bed_number = p_bed_number
        FOR UPDATE OF b;

    IF v_bed_status <> 'AVAILABLE' THEN
        RAISE EXCEPTION
            'Bed %.%.% is not operationally available',
            p_ward_code,
            p_room_number,
            p_bed_number;
    END IF;

    IF EXISTS (SELECT 1
               FROM clinical.bed_assignments
               WHERE bed_id = v_bed_id
                 AND released_at IS NULL) THEN
        RAISE EXCEPTION
            'Bed %.%.% is already occupied',
            p_ward_code,
            p_room_number,
            p_bed_number;
    END IF;

    IF EXISTS (SELECT 1
               FROM clinical.bed_assignments
               WHERE admission_id = v_admission_id
                 AND released_at IS NULL) THEN
        RAISE EXCEPTION
            'Admission % already has an active bed',
            p_admission_number;
    END IF;

    SELECT id
    INTO STRICT v_staff_id
    FROM clinical.staff_members
    WHERE staff_number = p_staff_number;

    INSERT INTO clinical.bed_assignments (admission_id,
                                          bed_id,
                                          assigned_by_staff_id,
                                          assignment_reason)
    VALUES (v_admission_id,
            v_bed_id,
            v_staff_id,
            p_assignment_reason)
    RETURNING id INTO v_assignment_id;

    RETURN v_assignment_id;
END;
$$;

-- Safe payment recording
CREATE OR REPLACE FUNCTION billing.record_payment(
    p_payment_number VARCHAR,
    p_invoice_number VARCHAR,
    p_staff_number VARCHAR,
    p_amount NUMERIC,
    p_payment_method VARCHAR,
    p_reference_number VARCHAR
)
    RETURNS BIGINT
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_invoice_id     BIGINT;
    v_invoice_status VARCHAR(20);
    v_staff_id       BIGINT;
    v_invoice_total  NUMERIC(12, 2);
    v_total_paid     NUMERIC(12, 2);
    v_balance        NUMERIC(12, 2);
    v_payment_id     BIGINT;
BEGIN
    IF p_amount <= 0 THEN
        RAISE EXCEPTION 'Payment amount must be greater than zero';
    END IF;

    SELECT id,
           status
    INTO STRICT
        v_invoice_id,
        v_invoice_status
    FROM billing.invoices
    WHERE invoice_number = p_invoice_number
        FOR UPDATE;

    IF v_invoice_status <> 'ISSUED' THEN
        RAISE EXCEPTION
            'Invoice % cannot receive payments because its status is %',
            p_invoice_number,
            v_invoice_status;
    END IF;

    SELECT COALESCE(
                   SUM(quantity * unit_price),
                   0
           )
    INTO v_invoice_total
    FROM billing.invoice_items
    WHERE invoice_id = v_invoice_id;

    SELECT COALESCE(
                   SUM(amount),
                   0
           )
    INTO v_total_paid
    FROM billing.payments
    WHERE invoice_id = v_invoice_id
      AND status = 'COMPLETED';

    v_balance := v_invoice_total - v_total_paid;

    IF p_amount > v_balance THEN
        RAISE EXCEPTION
            'Payment % exceeds outstanding balance %',
            p_amount,
            v_balance;
    END IF;

    SELECT id
    INTO STRICT v_staff_id
    FROM clinical.staff_members
    WHERE staff_number = p_staff_number;

    INSERT INTO billing.payments (payment_number,
                                  invoice_id,
                                  received_by_staff_id,
                                  amount,
                                  payment_method,
                                  status,
                                  reference_number)
    VALUES (p_payment_number,
            v_invoice_id,
            v_staff_id,
            p_amount,
            p_payment_method,
            'COMPLETED',
            p_reference_number)
    RETURNING id INTO v_payment_id;

    RETURN v_payment_id;
END;
$$;

GRANT EXECUTE ON FUNCTION clinical.assign_bed(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT
    )
    TO hms_receptionist;

GRANT EXECUTE ON FUNCTION billing.record_payment(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    NUMERIC,
    VARCHAR,
    VARCHAR
    )
    TO hms_billing_clerk;
