CREATE SCHEMA IF NOT EXISTS performance;

DROP TABLE IF EXISTS performance.appointment_lookup_demo;

CREATE TABLE performance.appointment_lookup_demo (
                                                     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                                     patient_id BIGINT NOT NULL,
                                                     doctor_id BIGINT NOT NULL,
                                                     appointment_start TIMESTAMP NOT NULL,
                                                     status VARCHAR(20) NOT NULL
);

INSERT INTO performance.appointment_lookup_demo (
    patient_id,
    doctor_id,
    appointment_start,
    status
)
SELECT
    (g % 10000) + 1,
    (g % 100) + 1,
    TIMESTAMP '2026-01-01 08:00:00'
        + g * INTERVAL '1 minute',
    CASE
        WHEN g % 3 = 0 THEN 'SCHEDULED'
        WHEN g % 3 = 1 THEN 'COMPLETED'
        ELSE 'CANCELLED'
        END
FROM generate_series(1, 100000) AS g;

ANALYZE performance.appointment_lookup_demo;