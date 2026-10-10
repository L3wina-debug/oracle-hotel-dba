-- Runs the whole project in order (SQL*Plus):  SQL> @sql/00_run_all.sql
SET ECHO ON
SET SERVEROUTPUT ON
@@01_schema.sql
@@02_seed.sql
@@03_queries.sql
@@04_optimization.sql
@@05_backup_restore.sql
