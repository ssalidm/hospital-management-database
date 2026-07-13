CREATE TABLE clinical.medications
(
    id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    medication_code          VARCHAR(30)  NOT NULL UNIQUE,
    generic_name            VARCHAR(150) NOT NULL,
    brand_name               VARCHAR(150),

    strength                 VARCHAR(50)  NOT NULL,
    dosage_form              VARCHAR(50)  NOT NULL,

    is_prescription_required BOOLEAN      NOT NULL DEFAULT TRUE,
    is_active                BOOLEAN      NOT NULL DEFAULT TRUE,

    created_at               TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_medications_dosage_form
        CHECK (dosage_form IN (
                               'TABLET',
                               'CAPSULE',
                               'SYRUP',
                               'INJECTION',
                               'CREAM',
                               'DROPS',
                               'INHALER'
            ))
);

CREATE TABLE clinical.prescriptions
(
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    prescription_number     VARCHAR(30) NOT NULL UNIQUE,

    consultation_id         BIGINT      NOT NULL,
    prescribed_by_doctor_id BIGINT      NOT NULL,

    prescribed_at           TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    status                  VARCHAR(30) NOT NULL DEFAULT 'ISSUED',
    notes                   TEXT,

    created_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_prescriptions_consultation
        FOREIGN KEY (consultation_id)
            REFERENCES clinical.consultations (id),

    CONSTRAINT fk_prescriptions_doctor
        FOREIGN KEY (prescribed_by_doctor_id)
            REFERENCES clinical.doctors (id),

    CONSTRAINT chk_prescriptions_status
        CHECK (status IN (
                          'ISSUED',
                          'DISPENSED',
                          'CANCELLED',
                          'EXPIRED'
            ))
);

CREATE TABLE clinical.prescription_items
(
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    prescription_id BIGINT       NOT NULL,
    medication_id   BIGINT       NOT NULL,

    dosage          VARCHAR(100) NOT NULL,
    frequency       VARCHAR(100) NOT NULL,
    duration_days   INTEGER      NOT NULL,

    quantity        INTEGER      NOT NULL,
    instructions    TEXT,

    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_prescription_items_prescription
        FOREIGN KEY (prescription_id)
            REFERENCES clinical.prescriptions (id),

    CONSTRAINT fk_prescription_items_medication
        FOREIGN KEY (medication_id)
            REFERENCES clinical.medications (id),

    CONSTRAINT chk_prescription_items_duration
        CHECK (duration_days > 0),

    CONSTRAINT chk_prescription_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT uq_prescription_items_medication
        UNIQUE (prescription_id, medication_id)
)