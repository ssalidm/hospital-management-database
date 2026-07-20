# Backup and Recovery Plan

## Backup Strategy

The Hospital Management Database uses PostgreSQL logical backups.

Two backup files are created:

1. A custom-format database archive using `pg_dump`.
2. A global roles archive using `pg_dumpall --globals-only`.

Backup files are stored outside Git and must be protected as sensitive data.

## Backup Command

```bash
./scripts/backup_database.sh
```

## Recovery Test

```
./scripts/test_restore.sh backups/<backup-file>.dump
```

The restoration process:

1. Drops the previous restoration test database.
2. Creates a clean restoration database.
3. Restores the PostgreSQL archive.
4. Verifies important table counts.
5. Confirms that schemas, views, relationships, and functions exist.

## Proposed Recovery Objectives
- Development RPO: 24 hours
- Development RTO: 1 hour

## Production Considerations

A production hospital system should also consider:

- encrypted backup storage
- off-site backup copies
- automated backup schedules
- retention policies
- restricted backup access
- WAL archiving
- point-in-time recovery
- regular recovery drills
- backup integrity monitoring