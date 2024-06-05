--CREATE TABLE C1(
-- product_id NUMERIC(5) PRIMARY KEY,
-- product_name VARCHAR(50),
-- product_price NUMERIC(8,2)
--);
-- 
--INSERT INTO C1 VALUES(1, 'COMPUTER', 799.9);  
--INSERT INTO C1 VALUES(2, 'MONITOR', 349.9); 
--
--CREATE TABLE C2(
-- id NUMERIC(5) PRIMARY KEY,
-- price NUMERIC(8,2),
-- name VARCHAR(50)
--);  
-- 
--INSERT INTO C2 VALUES(10, 299.9, 'Printer');  
--INSERT INTO C2 VALUES(20, 149.9, 'Scanner');   
-- 
--CREATE TABLE C3(
-- pname VARCHAR(50),
-- pprice NUMERIC(8,2)
--);  
-- 
--INSERT INTO C3 VALUES('mouse', 29.9);  
--INSERT INTO C3 VALUES('webcam', 19.9);     
-- 
--CREATE TABLE meta(
-- table_name VARCHAR(255),
-- trans_code VARCHAR(10)
--);
-- 
--INSERT INTO meta VALUES('C1', NULL);  
--INSERT INTO meta VALUES('C2', 'CAP');  
--INSERT INTO meta VALUES('C3', 'CAP+CUR'); 
--
--COMMIT;



CREATE OR REPLACE FUNCTION catal() RETURNS VOID AS $$
DECLARE
    nuplet META%ROWTYPE; -- nuplet de la table META
    pname VARCHAR; -- nom du produit
    pprice NUMERIC(8, 2); -- prix du produit
    price_attribute VARCHAR; 
    name_attribute VARCHAR;
    curs REFCURSOR; -- curseur explicite
BEGIN
    -- Supprime la table C_ALL si elle existe
    DROP TABLE IF EXISTS C_ALL;
    -- Cree la table C_ALL qui sera le catalogue unifie
    CREATE TABLE C_ALL( pid SERIAL PRIMARY KEY, pname VARCHAR(50), pprice NUMERIC(8, 2) );

    -- Parcourir la table META pour obtenir les noms des catalogues
    FOR nuplet IN SELECT table_name, trans_code FROM META
    LOOP -- Boucle sur les nuplets de META
        -- Recupere dans le schema de chaque catalogue les noms des attributs qui contiennent name
        EXECUTE 'SELECT column_name FROM INFORMATION_SCHEMA.columns 
        WHERE column_name LIKE ''%name%'' AND table_name=lower('''||nuplet.table_name||''');' INTO name_attribute;
        -- Recupere dans le schema de chaque catalogue les noms des attributs qui contiennent price
        EXECUTE 'SELECT column_name FROM INFORMATION_SCHEMA.columns 
        WHERE column_name LIKE ''%price%'' AND table_name=lower(''' ||nuplet.table_name ||''');' INTO price_attribute;

        -- Charge dynamiquement les donnees de chaque catalogue dans C_ALL
        OPEN curs FOR EXECUTE 'SELECT '||name_attribute||','||price_attribute||' FROM '||nuplet.table_name||';';
        LOOP -- Boucle sur les nuplets du curseur
            -- Recupere le nuplet courant du curseur dans les variables pname et pprice
            FETCH curs INTO pname, pprice;
            EXIT WHEN NOT FOUND ; -- Sort de la boucle si le curseur est vide
            
            -- Applique les transformations necessaires sur les donnees de la table META
            IF nuplet.trans_code LIKE '%CAP%' THEN
                pname = UPPER(pname); -- Met en majuscules
            END IF ;
            IF nuplet.trans_code LIKE '%CUR%' THEN
                pprice = pprice / 1.05; -- Conversion USD -> EUR (on divise par 1.05)
            END IF ;
            
            -- Insere le nuplet dans C_ALL avec un pid genere automatiquement via DEFAULT et SERIAL (identifiant de C_ALL)
            EXECUTE 'INSERT INTO C_ALL VALUES(DEFAULT , ''' || pname || ''', ' || pprice || ');';
        END LOOP; -- Fin de la boucle
        CLOSE curs; -- Ferme le curseur
    END LOOP; -- Fin de la boucle
END; -- Fin de la fonction
$$ LANGUAGE plpgsql;

-- test du fonctionnement de la fonction
select catal(); SELECT * FROM C_ALL;