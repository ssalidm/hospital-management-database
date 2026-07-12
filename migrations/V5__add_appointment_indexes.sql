CREATE INDEX idx_appointments_patient_id
    ON clinical.appointments (patient_id);

CREATE INDEX idx_appointments_doctor_id
    ON clinical.appointments (doctor_id);

CREATE INDEX idx_appointments_start
    ON clinical.appointments (appointment_start);

CREATE INDEX idx_appointments_status
    ON clinical.appointments (status);

CREATE INDEX idx_appointments_doctor_start
    ON clinical.appointments (doctor_id, appointment_start);