CREATE TABLE clinical.departments
(
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    department_code VARCHAR(20)  NOT NULL UNIQUE,
    name            VARCHAR(100) NOT NULL UNIQUE,
    description     TEXT,

    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,

    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clinical.staff_members
(
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    staff_number      VARCHAR(20)  NOT NULL UNIQUE,

    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,

    role              VARCHAR(30)  NOT NULL,

    department_id     BIGINT       NOT NULL,

    phone_number      VARCHAR(30),
    email             VARCHAR(150) UNIQUE,

    employment_status VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',

    hired_at          DATE         NOT NULL DEFAULT CURRENT_DATE,

    created_at        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_staff_members_department
        FOREIGN KEY (department_id)
            REFERENCES clinical.departments (id),

    CONSTRAINT chk_staff_members_role
        CHECK (role IN (
                        'DOCTOR',
                        'NURSE',
                        'RECEPTIONIST',
                        'LAB_TECHNICIAN',
                        'PHARMACIST',
                        'BILLING_CLERK',
                        'ADMIN'
            )),

    CONSTRAINT chk_staff_members_employment_status
        CHECK (employment_status IN (
                                     'ACTIVE',
                                     'ON_LEAVE',
                                     'SUSPENDED',
                                     'TERMINATED'
            ))
);