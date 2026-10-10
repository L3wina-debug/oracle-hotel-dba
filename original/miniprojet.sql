//table clients
CREATE TABLE clients (
    id_client NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    email VARCHAR2(100),
    telephone VARCHAR2(20)
);

//table chambres
CREATE TABLE chambres (
    id_chambre NUMBER PRIMARY KEY,
    type VARCHAR2(30),
    prix NUMBER,
    statut VARCHAR2(20)
);

//table reservations
CREATE TABLE reservations (
    id_reservation NUMBER PRIMARY KEY,
    id_client NUMBER,
    id_chambre NUMBER,
    date_debut DATE,
    date_fin DATE,
    FOREIGN KEY (id_client) REFERENCES clients(id_client),
    FOREIGN KEY (id_chambre) REFERENCES chambres(id_chambre)
);
//table service
CREATE TABLE services (
    id_service NUMBER PRIMARY KEY,
    nom_service VARCHAR2(50),
    prix NUMBER
);
//table utilisation service
CREATE TABLE utilisation_services (
    id_utilisation NUMBER PRIMARY KEY,
    id_reservation NUMBER,
    id_service NUMBER,
    FOREIGN KEY (id_reservation) REFERENCES reservations(id_reservation),
    FOREIGN KEY (id_service) REFERENCES services(id_service)
);
//table paiement 
CREATE TABLE paiements (
    id_paiement NUMBER PRIMARY KEY,
    id_reservation NUMBER,
    montant NUMBER,
    date_paiement DATE,
    FOREIGN KEY (id_reservation) REFERENCES reservations(id_reservation)
);
//table employes
CREATE TABLE employes (
    id_employe NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    poste VARCHAR2(50),
    salaire NUMBER
);
//table fournisseur
CREATE TABLE fournisseurs (
    id_fournisseur NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    telephone VARCHAR2(20)
);
//table produit
CREATE TABLE produits (
    id_produit NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    prix NUMBER,
    id_fournisseur NUMBER,
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseurs(id_fournisseur)
);
//table commandes
CREATE TABLE commandes (
    id_commande NUMBER PRIMARY KEY,
    id_produit NUMBER,
    quantite NUMBER,
    date_commande DATE,
    FOREIGN KEY (id_produit) REFERENCES produits(id_produit)
);

//on ajoute dataset(200 clients)
BEGIN
  FOR i IN 1..200 LOOP
    INSERT INTO clients VALUES (
      i,
      'Client_' || i,
      'client' || i || '@gmail.com',
      '060000' || i
    );
  END LOOP;
END;
/
// on ajoute dataset(100 chambres)
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO chambres VALUES (
      i,
      'Type_' || MOD(i,3),
      200 + (i*10),
      'libre'
    );
  END LOOP;
END;
/
//dataset(5 services)
INSERT INTO services VALUES (1, 'WiFi', 20);
INSERT INTO services VALUES (2, 'Room Service', 50);
INSERT INTO services VALUES (3, 'Petit déjeuner', 30);
INSERT INTO services VALUES (4, 'Parking', 40);
INSERT INTO services VALUES (5, 'Piscine', 60);
//Dataset(20 fournisseures)
BEGIN
  FOR i IN 1..20 LOOP
    INSERT INTO fournisseurs VALUES (
      i,
      'Fournisseur_' || i,
      '070000' || i
    );
  END LOOP;
END;
/
//Dataset de produit (50 produits)
BEGIN
  FOR i IN 1..50 LOOP
    INSERT INTO produits VALUES (
      i,
      'Produit_' || i,
      50 + (i*5),
      MOD(i,20)+1
    );
  END LOOP;
END;
/
//Dataset (100 commandes)
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO commandes VALUES (
      i,
      MOD(i,50)+1,
      MOD(i,10)+1,
      SYSDATE
    );
  END LOOP;
END;
/
// on a joute 300 reservation 
BEGIN
  FOR i IN 1..300 LOOP
    INSERT INTO reservations VALUES (
      i,
      MOD(i,200)+1,
      MOD(i,100)+1,
      SYSDATE,
      SYSDATE + MOD(i,5)
    );
  END LOOP;
END;
/
// on ajoute 200 utilisation services
BEGIN
  FOR i IN 1..200 LOOP
    INSERT INTO utilisation_services VALUES (
      i,
      MOD(i,300)+1,
      MOD(i,5)+1
    );
  END LOOP;
END;
/
// on ajoute 200 paiement 
BEGIN
  FOR i IN 1..200 LOOP
    INSERT INTO paiements VALUES (
      i,
      MOD(i,300)+1,
      100 + (i*10),
      SYSDATE
    );
  END LOOP;
END;
/
// on ajoute 30 employes
BEGIN
  FOR i IN 1..30 LOOP
    INSERT INTO employes VALUES (
      i,
      'Employe_' || i,
      'Poste_' || MOD(i,5),
      3000 + (i*200)
    );
  END LOOP;
END;
/
//enregistrer les donnes
COMMIT;

//Requête simple pour prent info client avec leur reservation
SELECT c.nom, r.id_reservation, r.date_debut, r.date_fin
FROM clients c
JOIN reservations r ON c.id_client = r.id_client;
//Requête2 condition 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
//PARTE3: Analyse AVANT optimisation
EXPLAIN PLAN FOR 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
//(observation : TABLE ACCESS FULL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

//ETAPE 4: Optimisation (Index)
CREATE INDEX idx_nom_client ON clients(nom);
CREATE INDEX idx_res_client ON reservations(id_client);

//ETAPE 5: Analyse APRES optimisation
EXPLAIN PLAN FOR 
SELECT *
FROM clients c
JOIN reservations r ON c.id_client = r.id_client
WHERE c.nom = 'Client_50';
// Observation(utilisation des index → amélioration de performance)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

//BACKUP
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
//Simuler perte
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

//Vérification de perte de donnee
SELECT COUNT(*) FROM reservations;


//RESTAURATION
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

//Vérification de restoration 
SELECT COUNT(*) FROM reservations;
