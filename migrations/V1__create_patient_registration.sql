CREATE SCHEMA IF NOT EXISTS clinical;

CREATE TABLE clinical.patients
(
    id                             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    patient_number                 VARCHAR(20)  NOT NULL UNIQUE,

    first_name                     VARCHAR(100) NOT NULL,
    last_name                      VARCHAR(100) NOT NULL,

    date_of_birth                  DATE         NOT NULL,

    gender                         VARCHAR(20)  NOT NULL,

    phone_number                   VARCHAR(30),
    email                          VARCHAR(150),

    national_id_number             VARCHAR(50),

    address_line_1                 VARCHAR(150),
    address_line_2                 VARCHAR(150),
    city                           VARCHAR(100),
    province                       VARCHAR(100),
    postal_code                    VARCHAR(20),
    country                        VARCHAR(100) NOT NULL DEFAULT 'South Africa',

    emergency_contact_name         VARCHAR(150),
    emergency_contact_phone        VARCHAR(30),
    emergency_contact_relationship VARCHAR(50),

    status                         VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',

    registered_at                  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_patient_date_of_birth
        CHECK (date_of_birth <= CURRENT_DATE),

    CONSTRAINT chk_patients_gender
        CHECK (gender IN ('MALE', 'FEMALE', 'OTHER', 'UNKNOWN')),

    CONSTRAINT chk_patients_status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'DECEASED'))
);