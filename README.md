# Oracle Database Administration: Performance and Backup

![Oracle](https://img.shields.io/badge/Oracle-21c%20XE-F80000?logo=oracle&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-PL%2FSQL-336791)
![RMAN](https://img.shields.io/badge/Backup-RMAN-informational)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Context](https://img.shields.io/badge/Master%20AI%20%26%20Cybersecurity-DB%20Administration%20%26%20Security-6242ff)

Design and administration of a **hotel management database** on **Oracle Database 21c Express Edition**: a normalized schema, data generated with **PL/SQL**, query tuning with **EXPLAIN PLAN** and **B-Tree indexes**, and two backup strategies, a logical one in SQL and a physical one with **RMAN**.

> Mini-project for the **Database Administration and Security** module, Master in AI & Cybersecurity (Faculté des Sciences de Kénitra), 2025–2026. The original script is kept in [`original/miniprojet.sql`](original/miniprojet.sql).

## Results

| Area | Technique | Result |
|---|---|---|
| Design | DDL, primary and foreign keys | 10 tables, 3NF |
| Data | PL/SQL `FOR` loops | 1 205 rows |
| Tuning | `EXPLAIN PLAN` + 2 B-Tree indexes + `DBMS_STATS` | `TABLE ACCESS FULL` → `INDEX RANGE SCAN` on CLIENTS |
| | | Cost of the CLIENTS access: 2 → 1 (−50 %), rows read: 200 → 1 |
| SQL backup | `CREATE TABLE ... AS SELECT` | 10 backup tables |
| SQL restore | `INSERT INTO ... SELECT` after a simulated loss | all rows recovered (`COUNT(*)` before = after) |
| RMAN | ARCHIVELOG, full + incremental level 0/1 | 4 backup sets created, 3 validated with `RESTORE DATABASE VALIDATE` |

Measured on Oracle 21c XE (SQL Developer, Windows) during the project.

## Schema

```text
clients ─────────┐
                 ├──< reservations >── chambres
                 │         │
                 │         ├──< utilisation_services >── services
                 │         └──< paiements
fournisseurs ──< produits ──< commandes
employes (independent)
```

| Table | Rows | Table | Rows |
|---|---|---|---|
| clients | 200 | services | 5 |
| chambres | 100 | fournisseurs | 20 |
| reservations | 300 | produits | 50 |
| utilisation_services | 200 | commandes | 100 |
| paiements | 200 | employes | 30 |

## Repository structure

```text
sql/
├── 00_run_all.sql          # runs 01 → 05 in SQL*Plus
├── 01_schema.sql           # 10 tables, PK/FK constraints
├── 02_seed.sql             # PL/SQL data generation (1 205 rows)
├── 03_queries.sql          # joins and filtered queries
├── 04_optimization.sql     # EXPLAIN PLAN before/after, indexes, statistics
├── 05_backup_restore.sql   # CTAS backup, simulated loss, restore, checks
└── 99_drop_all.sql         # clean up
rman/
├── 01_enable_archivelog.rman
├── 02_backups.rman         # full + incremental level 0 / 1
└── 03_validate_and_restore.rman
original/miniprojet.sql     # the script as submitted
```

The scripts in `sql/` are the original script split by step. Its `//` comments were converted to `--`, the Oracle comment syntax, so they run in SQL*Plus, and the `DBMS_STATS` calls described in the report were added.

## How to run

Requirements: Oracle Database 21c XE (or any Oracle 19c+), SQL*Plus or SQL Developer.

```bash
sqlplus your_user/your_password@localhost:1521/XEPDB1 @sql/00_run_all.sql
```

RMAN (as a user with SYSDBA, on the container database):

```bash
rman target / @rman/01_enable_archivelog.rman
rman target / @rman/02_backups.rman
rman target / @rman/03_validate_and_restore.rman
```

Clean up with `@sql/99_drop_all.sql`.

## Errors met and fixed

| Error | Cause | Fix |
|---|---|---|
| RMAN-06149 | `BACKUP DATABASE` while NOARCHIVELOG is active (XE default) | `STARTUP MOUNT` + `ALTER DATABASE ARCHIVELOG` + `OPEN` |
| ORA-19504 (OS 112) | Not enough disk space on drive C: for the incremental backup | Freed disk space, reran the backup |
| ORA-06512 in `DBMS_STATS` | A placeholder user name was passed instead of a real schema | `DBMS_STATS.GATHER_TABLE_STATS(USER, 'CLIENTS')` |
| ORA-02292 on `DELETE` | Child rows still reference the parent | Delete child tables before parent tables |

## What I learned

- **Relational design:** turning a hotel's processes into a 3NF schema with referential integrity.
- **Reading execution plans:** spotting a full table scan, choosing the right indexes, and confirming the gain in the plan and its cost.
- **The cost-based optimizer:** why statistics must be refreshed after creating indexes.
- **Backup and recovery:** the difference between a logical copy (CTAS) and a physical backup (RMAN), ARCHIVELOG mode, incremental levels, and validating backups before you need them.
- **Data integrity under failure:** deleting and restoring in the right order so foreign keys never break.

## Author

**Mahmoud El Aaouadi**, Master's student in AI & Cybersecurity. [Portfolio](https://mahmoud-elaaouadi.netlify.app) · [LinkedIn](https://www.linkedin.com/in/mahmoud-elaaouadi-7b3087416)

## License

[MIT](LICENSE)
