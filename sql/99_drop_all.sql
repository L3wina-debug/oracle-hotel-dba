-- Removes every object created by the project (children first, then parents).
BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('COMMANDES','PRODUITS','FOURNISSEURS','UTILISATION_SERVICES','PAIEMENTS',
                                 'RESERVATIONS','SERVICES','CHAMBRES','CLIENTS','EMPLOYES')
               OR table_name LIKE '%\_BACKUP' ESCAPE '\') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/
