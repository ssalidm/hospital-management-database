package za.co.pixelly.hospital.patient;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DefaultPatientService implements PatientService {

    private final PatientDirectoryRepository repository;

    public DefaultPatientService(PatientDirectoryRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<PatientSummary> findPatients(int limit) {
        return repository.findAll(limit);
    }

    @Override
    public PatientSummary findPatient(String patientNumber) {
        return repository
                .findByPatientNumber(patientNumber)
                .orElseThrow(() -> new PatientNotFoundException(patientNumber));
    }
}
