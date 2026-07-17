CREATE ROLE receptionist_dev
    LOGIN
    PASSWORD 'replace-with-a-secure-password';

CREATE ROLE doctor_dev
    LOGIN
    PASSWORD 'replace-with-a-secure-password';

CREATE ROLE lab_dev
    LOGIN
    PASSWORD 'replace-with-a-secure-password';

CREATE ROLE billing_dev
    LOGIN
    PASSWORD 'replace-with-a-secure-password';

CREATE ROLE reporting_dev
    LOGIN
    PASSWORD 'replace-with-a-secure-password';

GRANT hms_receptionist TO receptionist_dev;
GRANT hms_doctor TO doctor_dev;
GRANT hms_lab_technician TO lab_dev;
GRANT hms_billing_clerk TO billing_dev;
GRANT hms_reporting TO reporting_dev;