-- Schema: 10 tables in 3NF with primary and foreign keys
-- Hotel management database, Oracle 21c XE. Run in SQL*Plus or SQL Developer (F5).

-- table clients
CREATE TABLE clients (
    id_client NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    email VARCHAR2(100),
    telephone VARCHAR2(20)
);

-- table chambres
CREATE TABLE chambres (
    id_chambre NUMBER PRIMARY KEY,
    type VARCHAR2(30),
    prix NUMBER,
    statut VARCHAR2(20)
);

-- table reservations
CREATE TABLE reservations (
    id_reservation NUMBER PRIMARY KEY,
    id_client NUMBER,
    id_chambre NUMBER,
    date_debut DATE,
    date_fin DATE,
    FOREIGN KEY (id_client) REFERENCES clients(id_client),
    FOREIGN KEY (id_chambre) REFERENCES chambres(id_chambre)
);
-- table service
CREATE TABLE services (
    id_service NUMBER PRIMARY KEY,
    nom_service VARCHAR2(50),
    prix NUMBER
);
-- table utilisation service
CREATE TABLE utilisation_services (
    id_utilisation NUMBER PRIMARY KEY,
    id_reservation NUMBER,
    id_service NUMBER,
    FOREIGN KEY (id_reservation) REFERENCES reservations(id_reservation),
    FOREIGN KEY (id_service) REFERENCES services(id_service)
);
-- table paiement 
CREATE TABLE paiements (
    id_paiement NUMBER PRIMARY KEY,
    id_reservation NUMBER,
    montant NUMBER,
    date_paiement DATE,
    FOREIGN KEY (id_reservation) REFERENCES reservations(id_reservation)
);
-- table employes
CREATE TABLE employes (
    id_employe NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    poste VARCHAR2(50),
    salaire NUMBER
);
-- table fournisseur
CREATE TABLE fournisseurs (
    id_fournisseur NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    telephone VARCHAR2(20)
);
-- table produit
CREATE TABLE produits (
    id_produit NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    prix NUMBER,
    id_fournisseur NUMBER,
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseurs(id_fournisseur)
);
-- table commandes
CREATE TABLE commandes (
    id_commande NUMBER PRIMARY KEY,
    id_produit NUMBER,
    quantite NUMBER,
    date_commande DATE,
    FOREIGN KEY (id_produit) REFERENCES produits(id_produit)
);
