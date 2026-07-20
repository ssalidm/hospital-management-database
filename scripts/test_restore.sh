#!/usr/bin/env bash

set -euo pipefail

CONTAINER="hospital_postgres"
DATABASE_USER="hospital_user"
RESTORE_DATABASE="hospital_restore_test"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"

if [[ ! -f "${BACKUP_FILE}" ]]; then
  echo "Backup file not found: ${BACKUP_FILE}"
  exit 1
fi

echo "Recreating restoration test database..."

docker exec "${CONTAINER}" \
  dropdb \
  -U "${DATABASE_USER}" \
  --if-exists \
  "${RESTORE_DATABASE}"

docker exec "${CONTAINER}" \
  createdb \
  -U "${DATABASE_USER}" \
  "${RESTORE_DATABASE}"

echo "Restoring backup..."

docker exec -i "${CONTAINER}" \
  pg_restore \
  -U "${DATABASE_USER}" \
  -d "${RESTORE_DATABASE}" \
  --no-owner \
  --exit-on-error \
  < "${BACKUP_FILE}"

echo "Running verification queries..."

docker exec "${CONTAINER}" \
  psql \
  -U "${DATABASE_USER}" \
  -d "${RESTORE_DATABASE}" \
  -c "
SELECT 'patients' AS record_type, COUNT(*) AS total
FROM clinical.patients

UNION ALL

SELECT 'appointments', COUNT(*)
FROM clinical.appointments

UNION ALL

SELECT 'admissions', COUNT(*)
FROM clinical.admissions

UNION ALL

SELECT 'invoices', COUNT(*)
FROM billing.invoices

UNION ALL

SELECT 'payments', COUNT(*)
FROM billing.payments;
"

echo "Restoration test completed successfully."