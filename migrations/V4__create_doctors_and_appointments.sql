CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE clinical.doctors
(
    id                            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    staff_member_id               BIGINT       NOT NULL UNIQUE,

    medical_license_number        VARCHAR(50)  NOT NULL UNIQUE,
    specialization                VARCHAR(100) NOT NULL,

    is_available_for_appointments BOOLEAN      NOT NULL DEFAULT TRUE,

    created_at                    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_doctors_staff_member
        FOREIGN KEY (staff_member_id)
            REFERENCES clinical.staff_members (id)
);

CREATE TABLE clinical.appointments
(
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    appointment_number  VARCHAR(30) NOT NULL UNIQUE,

    patient_id          BIGINT      NOT NULL,
    doctor_id           BIGINT      NOT NULL,
    created_by_staff_id BIGINT      NOT NULL,

    appointment_start   TIMESTAMP   NOT NULL,
    appointment_end     TIMESTAMP   NOT NULL,

    appointment_type    VARCHAR(30) NOT NULL DEFAULT 'CONSULTATION',
    status              VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED',

    reason              TEXT,
    notes               TEXT,

    created_at          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
            REFERENCES clinical.patients (id),

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
            REFERENCES clinical.doctors (id),

    CONSTRAINT fk_appointments_created_by_staff
        FOREIGN KEY (created_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_appointments_time_order
        CHECK (appointment_end > appointment_start),

    CONSTRAINT chk_appointments_type
        CHECK (appointment_type IN (
                                    'CONSULTATION',
                                    'FOLLOW_UP',
                                    'EMERGENCY',
                                    'LAB_REVIEW',
                                    'SPECIALIST_REFERRAL'
            )),

    CONSTRAINT chk_appointments_status
        CHECK (status IN (
                          'SCHEDULED',
                          'CONFIRMED',
                          'IN_PROGRESS',
                          'COMPLETED',
                          'CANCELLED',
                          'NO_SHOW'
            )),

    CONSTRAINT excl_appointments_doctor_overlap
        EXCLUDE USING gist (
        doctor_id WITH =,
        tsrange(appointment_start, appointment_end, '[)') WITH &&
        )
        WHERE (status IN ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS'))
);