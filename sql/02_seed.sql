-- Seed data: 1 205 rows generated with PL/SQL loops
-- Hotel management database, Oracle 21c XE. Run in SQL*Plus or SQL Developer (F5).

-- on ajoute dataset(200 clients)
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
-- on ajoute dataset(100 chambres)
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
-- dataset(5 services)
INSERT INTO services VALUES (1, 'WiFi', 20);
INSERT INTO services VALUES (2, 'Room Service', 50);
INSERT INTO services VALUES (3, 'Petit déjeuner', 30);
INSERT INTO services VALUES (4, 'Parking', 40);
INSERT INTO services VALUES (5, 'Piscine', 60);
-- Dataset(20 fournisseures)
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
-- Dataset de produit (50 produits)
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
-- Dataset (100 commandes)
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
-- on a joute 300 reservation 
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
-- on ajoute 200 utilisation services
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
-- on ajoute 200 paiement 
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
-- on ajoute 30 employes
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
-- enregistrer les donnes
COMMIT;
