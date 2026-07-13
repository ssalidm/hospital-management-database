CREATE INDEX idx_consultations_appointment_id
    ON clinical.consultations (appointment_id);

CREATE INDEX idx_consultations_doctor_id
    ON clinical.consultations (performed_by_doctor_id);

CREATE INDEX idx_diagnoses_consultation_id
    ON clinical.diagnoses (consultation_id);

CREATE INDEX idx_diagnoses_code
    ON clinical.diagnoses (diagnosis_code);