package za.co.pixelly.hospital.patient;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class PatientDirectoryRepository {

    private final JdbcClient jdbcClient;

    public PatientDirectoryRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }

    public List<PatientSummary> findAll(int limit) {
        String sql = """
                SELECT
                    %s
                FROM reporting.patient_directory
                ORDER BY patient_number
                LIMIT :limit
                """.formatted(PATIENT_COLUMNS);

        return jdbcClient
                .sql(sql)
                .param("limit", limit)
                .query(PATIENT_ROW_MAPPER)
                .list();
    }

    public Optional<PatientSummary> findByPatientNumber(
            String patientNUmber
    ) {
        String sql = """
                SELECT
                    %s
                FROM reporting.patient_directory
                WHERE patient_number = :patientNumber
                """.formatted(PATIENT_COLUMNS);

        return jdbcClient
                .sql(sql)
                .param("patientNumber", patientNUmber)
                .query(PATIENT_ROW_MAPPER)
                .optional();
    }

    private static final RowMapper<PatientSummary> PATIENT_ROW_MAPPER =
            (resultSet, rowNumber) -> new PatientSummary(
                    resultSet.getInt("patient_id"),
                    resultSet.getString("patient_number"),
                    resultSet.getString("first_name"),
                    resultSet.getString("last_name"),
                    resultSet.getObject("date_of_birth", LocalDate.class),
                    resultSet.getString("gender"),
                    resultSet.getString("city"),
                    resultSet.getString("status"),
                    resultSet.getString("phone_number"),
                    resultSet.getString("email"),
                    resultSet.getString("preferred_language"),
                    resultSet.getObject("registered_at", LocalDateTime.class),
                    resultSet.getObject("updated_at", LocalDateTime.class)
            );

    private static final String PATIENT_COLUMNS = """
            patient_id,
            patient_number,
            first_name,
            last_name,
            date_of_birth,
            gender,
            city,
            status,
            phone_number,
            email,
            preferred_language,
            registered_at,
            updated_at
            """;
}
