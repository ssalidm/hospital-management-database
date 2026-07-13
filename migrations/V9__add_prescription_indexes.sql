CREATE INDEX idx_prescriptions_consultation_id
    ON clinical.prescriptions(consultation_id);

CREATE INDEX idx_prescriptions_doctor_id
    ON clinical.prescriptions(prescribed_by_doctor_id);

CREATE INDEX idx_prescriptions_status
    ON clinical.prescriptions(status);

CREATE INDEX idx_prescription_items_prescription_id
    ON clinical.prescription_items(prescription_id);

CREATE INDEX idx_prescription_items_medication_id
    ON clinical.prescription_items(medication_id);

CREATE INDEX idx_medications_generic_name
    ON clinical.medications(generic_name);