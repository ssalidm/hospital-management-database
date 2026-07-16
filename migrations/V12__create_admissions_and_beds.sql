CREATE TABLE clinical.wards
(
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    ward_code     VARCHAR(20)  NOT NULL UNIQUE,
    name          VARCHAR(100) NOT NULL UNIQUE,

    department_id BIGINT       NOT NULL,

    ward_type     VARCHAR(30)  NOT NULL,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,

    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_wards_department
        FOREIGN KEY (department_id)
            REFERENCES clinical.departments (id),

    CONSTRAINT chk_wards_type
        CHECK (ward_type IN (
                             'GENERAL',
                             'ICU',
                             'MATERNITY',
                             'PAEDIATRIC',
                             'SURGICAL',
                             'ISOLATION'
            ))
);

CREATE TABLE clinical.rooms
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    ward_id     BIGINT      NOT NULL,

    room_number VARCHAR(20) NOT NULL,
    room_type   VARCHAR(30) NOT NULL DEFAULT 'SHARED',

    is_active   BOOLEAN     NOT NULL DEFAULT TRUE,

    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rooms_ward
        FOREIGN KEY (ward_id)
            REFERENCES clinical.wards (id),

    CONSTRAINT chk_rooms_type
        CHECK (room_type IN (
                             'PRIVATE',
                             'SHARED',
                             'ICU',
                             'ISOLATION'
            )),

    CONSTRAINT uq_rooms_ward_number
        UNIQUE (ward_id, room_number)
);

CREATE TABLE clinical.beds
(
    id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    room_id            BIGINT      NOT NULL,

    bed_number         VARCHAR(20) NOT NULL,

    operational_status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',

    created_at         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_beds_room
        FOREIGN KEY (room_id)
            REFERENCES clinical.rooms (id),

    CONSTRAINT chk_beds_operational_status
        CHECK (operational_status IN (
                                      'AVAILABLE',
                                      'MAINTENANCE',
                                      'OUT_OF_SERVICE'
            )),

    CONSTRAINT uq_beds_room_number
        UNIQUE (room_id, bed_number)
);

CREATE TABLE clinical.admissions
(
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    admission_number        VARCHAR(30) NOT NULL UNIQUE,

    patient_id              BIGINT      NOT NULL,
    attending_doctor_id     BIGINT      NOT NULL,
    admitted_by_staff_id    BIGINT      NOT NULL,

    admission_type          VARCHAR(30) NOT NULL,
    status                  VARCHAR(30) NOT NULL DEFAULT 'ADMITTED',

    admission_reason        TEXT        NOT NULL,

    admitted_at             TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expected_discharge_date DATE,

    discharged_at           TIMESTAMP,
    discharge_notes         TEXT,

    created_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_admissions_patient
        FOREIGN KEY (patient_id)
            REFERENCES clinical.patients (id),

    CONSTRAINT fk_admissions_doctor
        FOREIGN KEY (attending_doctor_id)
            REFERENCES clinical.doctors (id),

    CONSTRAINT fk_admissions_staff
        FOREIGN KEY (admitted_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_admissions_type
        CHECK (admission_type IN (
                                  'EMERGENCY',
                                  'ELECTIVE',
                                  'TRANSFER',
                                  'OBSERVATION'
            )),

    CONSTRAINT chk_admissions_status
        CHECK (status IN (
                          'ADMITTED',
                          'DISCHARGED',
                          'CANCELLED'
            )),

    CONSTRAINT chk_admissions_discharge_time
        CHECK (
            discharged_at IS NULL
                OR discharged_at >= admitted_at
            ),

    CONSTRAINT chk_admissions_discharge_status
        CHECK (
            (status = 'DISCHARGED' AND discharged_at IS NOT NULL)
                OR
            (status IN ('ADMITTED', 'CANCELLED') AND discharged_at IS NULL)
            )
);

CREATE TABLE clinical.bed_assignments
(
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    admission_id         BIGINT    NOT NULL,
    bed_id               BIGINT    NOT NULL,
    assigned_by_staff_id BIGINT    NOT NULL,

    assigned_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    released_at          TIMESTAMP,

    assignment_reason    TEXT,

    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bed_assignments_admission
        FOREIGN KEY (admission_id)
            REFERENCES clinical.admissions (id),

    CONSTRAINT fk_bed_assignments_bed
        FOREIGN KEY (bed_id)
            REFERENCES clinical.beds (id),

    CONSTRAINT fk_bed_assignments_staff
        FOREIGN KEY (assigned_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_bed_assignments_time
        CHECK (
            released_at IS NULL
                OR released_at > assigned_at
            )
);

CREATE UNIQUE INDEX uq_active_admission_per_patient
    ON clinical.admissions (patient_id)
    WHERE status = 'ADMITTED';

CREATE UNIQUE INDEX uq_active_assignment_per_bed
    ON clinical.bed_assignments (bed_id)
    WHERE released_at IS NULL;

CREATE UNIQUE INDEX uq_active_assignment_per_admission
    ON clinical.bed_assignments (admission_id)
    WHERE released_at IS NULL;