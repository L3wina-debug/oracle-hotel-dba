-- Logical backup (CTAS), simulated data loss and restoration
-- Hotel management database, Oracle 21c XE. Run in SQL*Plus or SQL Developer (F5).

-- BACKUP
CREATE TABLE clients_backup AS SELECT * FROM clients;
CREATE TABLE chambres_backup AS SELECT * FROM chambres;
CREATE TABLE reservations_backup AS SELECT * FROM reservations;
CREATE TABLE services_backup AS SELECT * FROM services;
CREATE TABLE utilisation_services_backup AS SELECT * FROM utilisation_services;
CREATE TABLE paiements_backup AS SELECT * FROM paiements;
CREATE TABLE employes_backup AS SELECT * FROM employes;
CREATE TABLE fournisseurs_backup AS SELECT * FROM fournisseurs;
CREATE TABLE produits_backup AS SELECT * FROM produits;
CREATE TABLE commandes_backup AS SELECT * FROM commandes;
-- Simuler perte
DELETE FROM commandes;
DELETE FROM produits;
DELETE FROM fournisseurs;

DELETE FROM utilisation_services;
DELETE FROM paiements;
DELETE FROM reservations;

DELETE FROM services;
DELETE FROM chambres;
DELETE FROM clients;
DELETE FROM employes;

COMMIT;

-- Vérification de perte de donnee
SELECT COUNT(*) FROM reservations;


-- RESTAURATION
INSERT INTO clients SELECT * FROM clients_backup;
INSERT INTO chambres SELECT * FROM chambres_backup;
INSERT INTO services SELECT * FROM services_backup;
INSERT INTO fournisseurs SELECT * FROM fournisseurs_backup;
INSERT INTO produits SELECT * FROM produits_backup;
INSERT INTO commandes SELECT * FROM commandes_backup;
INSERT INTO reservations SELECT * FROM reservations_backup;
INSERT INTO utilisation_services SELECT * FROM utilisation_services_backup;
INSERT INTO paiements SELECT * FROM paiements_backup;
INSERT INTO employes SELECT * FROM employes_backup;

COMMIT;

-- Vérification de restoration 
SELECT COUNT(*) FROM reservations;
