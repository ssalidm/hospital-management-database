package za.co.pixelly.hospital.patient;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class PatientNotFoundException extends RuntimeException {

    public PatientNotFoundException(String patientNumber) {
        super("Patient not found: " + patientNumber);
    }
}
