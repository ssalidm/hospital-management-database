package za.co.pixelly.hospital.patient;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record PatientSummary(
        int patientId,
        String patientNumber,
        String firstName,
        String lastName,
        LocalDate dateOfBirth,
        String gender,
        String city,
        String status,
        String phoneNumber,
        String email,
        String preferredLanguage,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {}
