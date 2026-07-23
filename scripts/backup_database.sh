#!/usr/bin/env bash

set -euo pipefail

CONTAINER="hospital_postgres"
DATABASE="hospital_db"
DATABASE_USER="hospital_user"
BACKUP_ROOT="backups"
DAY_STAMP="$(date +%Y-%m-%d)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

BACKUP_DIRECTORY="${BACKUP_ROOT}/${DAY_STAMP}-bak"

DATABASE_BACKUP="${BACKUP_DIRECTORY}/hospital_db_${TIMESTAMP}.dump"
GLOBALS_BACKUP="${BACKUP_DIRECTORY}/postgres_globals_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIRECTORY}"

echo "Creating database backup..."

docker exec "${CONTAINER}" \
  pg_dump \
  -U "${DATABASE_USER}" \
  -d "${DATABASE}" \
  --format=custom \
  --no-owner \
  > "${DATABASE_BACKUP}"

echo "Creating PostgreSQL globals backup..."

docker exec "${CONTAINER}" \
  pg_dumpall \
  -U "${DATABASE_USER}" \
  --globals-only \
  > "${GLOBALS_BACKUP}"

echo "Backup completed:"
echo "  Database: ${DATABASE_BACKUP}"
echo "  Globals: ${GLOBALS_BACKUP}"