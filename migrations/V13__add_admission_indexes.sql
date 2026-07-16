CREATE INDEX idx_rooms_ward_id
    ON clinical.rooms(ward_id);

CREATE INDEX idx_beds_room_id
    ON clinical.beds(room_id);

CREATE INDEX idx_admissions_patient_id
    ON clinical.admissions(patient_id);

CREATE INDEX idx_admissions_doctor_id
    ON clinical.admissions(attending_doctor_id);

CREATE INDEX idx_admissions_status
    ON clinical.admissions(status);

CREATE INDEX idx_admissions_admitted_at
    ON clinical.admissions(admitted_at);

CREATE INDEX idx_bed_assignments_admission_id
    ON clinical.bed_assignments(admission_id);

CREATE INDEX idx_bed_assignments_bed_id
    ON clinical.bed_assignments(bed_id);