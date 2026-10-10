-- Business queries (joins and filters)
-- Hotel management database, Oracle 21c XE. Run in SQL*Plus or SQL Developer (F5).

-- Requête simple pour prent info client avec leur reservation
SELECT c.nom, r.id_reservation, r.date_debut, r.date_fin
FROM clients c
JOIN reservations r ON c.id_client = r.id_client;
-- Requête2 condition 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
