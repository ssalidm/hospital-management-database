CREATE TABLE clinical.consultations
(
    id                     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    appointment_id         BIGINT    NOT NULL UNIQUE,
    performed_by_doctor_id BIGINT    NOT NULL,

    consultation_start     TIMESTAMP NOT NULL,
    consultation_end       TIMESTAMP,

    symptoms               TEXT,
    clinical_notes         TEXT,
    treatment_plan         TEXT,

    follow_up_required     BOOLEAN   NOT NULL DEFAULT FALSE,
    follow_up_notes        TEXT,

    created_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_consultations_appointment
        FOREIGN KEY (appointment_id)
            REFERENCES clinical.appointments (id),

    CONSTRAINT fk_consultations_doctor
        FOREIGN KEY (performed_by_doctor_id)
            REFERENCES clinical.doctors (id),

    CONSTRAINT chk_consultations_time_order
        CHECK (
            consultation_end IS NULL
                OR consultation_end > consultation_start
            )
);

CREATE TABLE clinical.diagnoses
(
    id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    consultation_id       BIGINT,

    diagnosis_code        VARCHAR(30),
    diagnosis_description VARCHAR(255) NOT NULL,

    diagnosis_type        VARCHAR(30)  NOT NULL DEFAULT 'PRIMARY',

    notes                 TEXT,

    created_at            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_diagnoses_consultation
        FOREIGN KEY (consultation_id)
            REFERENCES clinical.consultations (id),

    CONSTRAINT chk_diagnoses_type
        CHECK (diagnosis_type IN (
                                  'PRIMARY',
                                  'SECONDARY',
                                  'DIFFERENTIAL'
            ) )
);

CREATE UNIQUE INDEX uq_diagnoses_one_primary_per_consultation
    ON clinical.diagnoses (consultation_id)
    WHERE diagnosis_type = 'PRIMARY';