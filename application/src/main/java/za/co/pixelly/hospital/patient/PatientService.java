package za.co.pixelly.hospital.patient;

import java.util.List;

public interface PatientService {
    public List<PatientSummary> findPatients(int limit);

    public PatientSummary findPatient(String patientNumber);
}
