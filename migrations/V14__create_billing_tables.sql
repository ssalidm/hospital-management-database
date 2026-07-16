CREATE SCHEMA IF NOT EXISTS billing;

CREATE TABLE billing.services
(
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    service_code  VARCHAR(30)    NOT NULL UNIQUE,
    name          VARCHAR(150)   NOT NULL,
    description   TEXT,

    default_price NUMERIC(12, 2) NOT NULL,

    is_active     BOOLEAN        NOT NULL DEFAULT TRUE,

    created_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_services_default_price
        CHECK ( default_price >= 0 )
);

CREATE TABLE billing.invoices
(
    id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    invoice_number     VARCHAR(30) NOT NULL UNIQUE,

    patient_id         BIGINT      NOT NULL,
    consultation_id    BIGINT,
    admission_id       BIGINT,

    issued_by_staff_id BIGINT      NOT NULL,

    status             VARCHAR(20) NOT NULL DEFAULT 'ISSUED',

    issued_at          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date           DATE,

    notes              TEXT,

    created_at         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoices_patient
        FOREIGN KEY (patient_id)
            REFERENCES clinical.patients (id),

    CONSTRAINT fk_invoices_consultation
        FOREIGN KEY (consultation_id)
            REFERENCES clinical.consultations (id),

    CONSTRAINT fk_invoices_admission
        FOREIGN KEY (admission_id)
            REFERENCES clinical.admissions (id),

    CONSTRAINT fk_invoices_issued_by_staff
        FOREIGN KEY (issued_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_invoices_status
        CHECK (status IN (
                          'DRAFT',
                          'ISSUED',
                          'CANCELLED'
            )),

    CONSTRAINT chk_invoices_due_date
        CHECK (
            due_date IS NULL
                OR due_date >= issued_at::DATE
            )
);

CREATE TABLE billing.invoice_items
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    invoice_id  BIGINT         NOT NULL,
    service_id  BIGINT         NOT NULL,

    description VARCHAR(255)   NOT NULL,

    quantity    NUMERIC(10, 2) NOT NULL DEFAULT 1,
    unit_price  NUMERIC(12, 2) NOT NULL,

    created_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id)
            REFERENCES billing.invoices (id),

    CONSTRAINT fk_invoice_items_service
        FOREIGN KEY (service_id)
            REFERENCES billing.services (id),

    CONSTRAINT chk_invoice_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_invoice_items_unit_price
        CHECK (unit_price >= 0)
);

CREATE TABLE billing.payments
(
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    payment_number       VARCHAR(30)    NOT NULL UNIQUE,

    invoice_id           BIGINT         NOT NULL,
    received_by_staff_id BIGINT         NOT NULL,

    amount               NUMERIC(12, 2) NOT NULL,

    payment_method       VARCHAR(30)    NOT NULL,
    status               VARCHAR(20)    NOT NULL DEFAULT 'COMPLETED',

    reference_number     VARCHAR(100),
    paid_at              TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    notes                TEXT,

    created_at           TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_invoice
        FOREIGN KEY (invoice_id)
            REFERENCES billing.invoices (id),

    CONSTRAINT fk_payments_received_by_staff
        FOREIGN KEY (received_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_payments_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payments_method
        CHECK (payment_method IN (
                                  'CASH',
                                  'CARD',
                                  'EFT',
                                  'MEDICAL_AID'
            )),

    CONSTRAINT chk_payments_status
        CHECK (status IN (
                          'COMPLETED',
                          'VOIDED'
            ))
);