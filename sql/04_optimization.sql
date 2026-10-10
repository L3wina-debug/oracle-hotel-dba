-- Query optimization: execution plan before/after B-Tree indexes
-- Hotel management database, Oracle 21c XE. Run in SQL*Plus or SQL Developer (F5).

-- STEP 3: execution plan BEFORE optimization
EXPLAIN PLAN FOR 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
-- (observation : TABLE ACCESS FULL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ETAPE 4: Optimisation (Index)
CREATE INDEX idx_nom_client ON clients(nom);
CREATE INDEX idx_res_client ON reservations(id_client);

-- Refresh optimizer statistics so the cost-based optimizer sees the new indexes
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'CLIENTS');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'RESERVATIONS');

-- ETAPE 5: Analyse APRES optimisation
EXPLAIN PLAN FOR 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
-- Observation(utilisation des index → amélioration de performance)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
