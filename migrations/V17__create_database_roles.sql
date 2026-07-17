-- Grant receptions permissions
CREATE ROLE hms_receptionist NOLOGIN;
CREATE ROLE hms_doctor NOLOGIN;
CREATE ROLE hms_lab_technician NOLOGIN;
CREATE ROLE hms_billing_clerk NOLOGIN;
CREATE ROLE hms_reporting NOLOGIN;

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA clinical FROM PUBLIC;
REVOKE ALL ON SCHEMA billing FROM PUBLIC;
REVOKE ALL ON SCHEMA reporting FROM PUBLIC;

GRANT USAGE ON SCHEMA clinical TO hms_receptionist;
GRANT USAGE ON SCHEMA reporting TO hms_receptionist;

GRANT SELECT ON
    clinical.departments,
    clinical.staff_members,
    clinical.doctors,
    clinical.wards,
    clinical.rooms,
    clinical.beds
    TO hms_receptionist;

GRANT SELECT, INSERT, UPDATE ON
    clinical.patients,
    clinical.appointments,
    clinical.admissions,
    clinical.bed_assignments
    TO hms_receptionist;

GRANT SELECT ON
    reporting.patient_directory
    TO hms_receptionist;

-- Grant doctor permissions
GRANT USAGE, SELECT ON ALL SEQUENCES
    IN SCHEMA clinical
    TO hms_receptionist;

GRANT USAGE ON SCHEMA clinical TO hms_doctor;
GRANT USAGE ON SCHEMA reporting TO hms_doctor;

GRANT SELECT ON
    clinical.patients,
    clinical.appointments,
    clinical.staff_members,
    clinical.doctors,
    clinical.consultations,
    clinical.diagnoses,
    clinical.medications,
    clinical.prescriptions,
    clinical.prescription_items,
    clinical.lab_tests,
    clinical.lab_orders,
    clinical.lab_order_items,
    clinical.lab_results
    TO hms_doctor;

GRANT INSERT, UPDATE ON
    clinical.consultations,
    clinical.diagnoses,
    clinical.prescriptions,
    clinical.prescription_items,
    clinical.lab_orders,
    clinical.lab_order_items
    TO hms_doctor;

GRANT SELECT ON
    reporting.patient_directory
    TO hms_doctor;

GRANT USAGE, SELECT ON ALL SEQUENCES
    IN SCHEMA clinical
    TO hms_doctor;

-- Grant lab_technician permissions
GRANT USAGE ON SCHEMA clinical TO hms_lab_technician;
GRANT USAGE ON SCHEMA reporting TO hms_lab_technician;

GRANT SELECT ON
    clinical.lab_tests,
    clinical.lab_orders,
    clinical.lab_order_items,
    clinical.lab_results
    TO hms_lab_technician;

GRANT SELECT ON
    reporting.lab_work_queue
    TO hms_lab_technician;

GRANT INSERT, UPDATE ON
    clinical.lab_results
    TO hms_lab_technician;

GRANT UPDATE (
              status,
              updated_at
    )
    ON clinical.lab_orders
    TO hms_lab_technician;

GRANT UPDATE (
              status,
              specimen_collected_at,
              updated_at
    )
    ON clinical.lab_order_items
    TO hms_lab_technician;

GRANT USAGE, SELECT ON ALL SEQUENCES
    IN SCHEMA clinical
    TO hms_lab_technician;


-- Grant billing_clerk permissions
GRANT USAGE ON SCHEMA clinical TO hms_billing_clerk;
GRANT USAGE ON SCHEMA billing TO hms_billing_clerk;
GRANT USAGE ON SCHEMA reporting TO hms_billing_clerk;

GRANT SELECT ON
    clinical.admissions,
    clinical.consultations
    TO hms_billing_clerk;

GRANT SELECT ON
    reporting.patient_directory,
    reporting.invoice_balances
    TO hms_billing_clerk;

GRANT SELECT, INSERT, UPDATE ON
    billing.invoices,
    billing.invoice_items,
    billing.payments
    TO hms_billing_clerk;

GRANT SELECT ON
    billing.services
    TO hms_billing_clerk;

GRANT USAGE, SELECT ON ALL SEQUENCES
    IN SCHEMA billing
    TO hms_billing_clerk;

-- Grant reporting permissions
GRANT USAGE ON SCHEMA reporting TO hms_reporting;

GRANT SELECT ON ALL TABLES
    IN SCHEMA reporting
    TO hms_reporting;