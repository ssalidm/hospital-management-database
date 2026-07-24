package za.co.pixelly.hospital.patient;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/patients")
public class PatientController {

    private final PatientService patientService;

    public PatientController(PatientService patientService) {
        this.patientService = patientService;
    }

    @GetMapping
    public List<PatientSummary> findPatients(
            @RequestParam(defaultValue = "20")
            @Min(value = 1, message = "Limit must be at least 1")
            @Max(value = 100, message = "Limit cannot exceed 100")
            int limit
    ) {
        return patientService.findPatients(limit);
    }

    @GetMapping("/{patientNumber}")
    public PatientSummary findPatient(@PathVariable String patientNumber) {
        return patientService.findPatient(patientNumber);
    }
}
