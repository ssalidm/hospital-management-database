CREATE TABLE clinical.lab_tests
(
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    test_code               VARCHAR(30)  NOT NULL UNIQUE,
    test_name               VARCHAR(150) NOT NULL UNIQUE,

    specimen_type           VARCHAR(30)  NOT NULL,

    default_unit            VARCHAR(30),
    default_reference_range VARCHAR(30),

    is_active               BOOLEAN      NOT NULL DEFAULT TRUE,

    created_at              TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_lab_tests_specimen_type
        CHECK ( specimen_type IN (
                                  'BLOOD',
                                  'URINE',
                                  'SWAB',
                                  'STOOL',
                                  'SPUTUM',
                                  'OTHER'
            ))
);

CREATE TABLE clinical.lab_orders
(
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_number         VARCHAR(30) NOT NULL UNIQUE,

    consultation_id      BIGINT      NOT NULL,
    ordered_by_doctor_id BIGINT      NOT NULL,

    priority             VARCHAR(20) NOT NULL DEFAULT 'ROUTINE',
    status               VARCHAR(30) NOT NULL DEFAULT 'ORDERED',

    clinical_notes       TEXT,

    ordered_at           TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at           TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_lab_orders_consultation
        FOREIGN KEY (consultation_id)
            REFERENCES clinical.consultations (id),

    CONSTRAINT fk_lab_orders_doctor
        FOREIGN KEY (ordered_by_doctor_id)
            REFERENCES clinical.doctors (id),

    CONSTRAINT chk_lab_orders_priority
        CHECK ( priority IN (
                             'ROUTINE',
                             'URGENT',
                             'STAT'
            )),

    CONSTRAINT chk_lab_orders_status
        CHECK ( status IN (
                           'ORDERED',
                           'SAMPLE_COLLECTED',
                           'IN_PROGRESS',
                           'COMPLETED',
                           'CANCELLED'
            ))
);

CREATE TABLE clinical.lab_order_items
(
    id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    lab_order_id          BIGINT      NOT NULL,
    lab_test_id           BIGINT      NOT NULL,

    status                VARCHAR(30) NOT NULL DEFAULT 'ORDERED',
    specimen_collected_at TIMESTAMP,

    created_at            TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_lab_order_items_order
        FOREIGN KEY (lab_order_id)
            REFERENCES clinical.lab_orders (id),

    CONSTRAINT fk_lab_order_items_test
        FOREIGN KEY (lab_test_id)
            REFERENCES clinical.lab_tests (id),

    CONSTRAINT chk_lab_order_items_status
        CHECK (status IN (
                          'ORDERED',
                          'SAMPLE_COLLECTED',
                          'IN_PROGRESS',
                          'COMPLETED',
                          'CANCELLED'
            )),

    CONSTRAINT uq_lab_order_items_test
        UNIQUE (lab_order_id, lab_test_id)
);

CREATE TABLE clinical.lab_results
(
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    lab_order_item_id    BIGINT       NOT NULL UNIQUE,
    recorded_by_staff_id BIGINT       NOT NULL,

    result_value         VARCHAR(255) NOT NULL,
    result_unit          VARCHAR(30),
    reference_range_used VARCHAR(100),

    interpretation       VARCHAR(30)  NOT NULL DEFAULT 'NORMAL',
    result_status        VARCHAR(30)  NOT NULL DEFAULT 'FINAL',

    recorded_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at          TIMESTAMP,

    notes                TEXT,

    created_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_lab_results_order_item
        FOREIGN KEY (lab_order_item_id)
            REFERENCES clinical.lab_order_items (id),

    CONSTRAINT fk_lab_results_recorded_by_staff
        FOREIGN KEY (recorded_by_staff_id)
            REFERENCES clinical.staff_members (id),

    CONSTRAINT chk_lab_results_interpretation
        CHECK (interpretation IN (
                                  'NORMAL',
                                  'HIGH',
                                  'LOW',
                                  'ABNORMAL',
                                  'INCONCLUSIVE'
            )),

    CONSTRAINT chk_lab_results_status
        CHECK (result_status IN (
                                 'PRELIMINARY',
                                 'FINAL',
                                 'AMENDED'
            )),

    CONSTRAINT chk_lab_results_verified_time
        CHECK (
            verified_at IS NULL
                OR verified_at >= recorded_at
            )
);