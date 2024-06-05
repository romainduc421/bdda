﻿CREATE TABLE C1(
  product_id NUMERIC(5) PRIMARY KEY,
  product_name VARCHAR(50),
  product_price NUMERIC(8,2)
);
  
INSERT INTO C1 VALUES(1, 'COMPUTER', 799.9);  
INSERT INTO C1 VALUES(2, 'MONITOR', 349.9); 

CREATE TABLE C2(
  id NUMERIC(5) PRIMARY KEY,
  price NUMERIC(8,2),
  name VARCHAR(50)
);  
  
INSERT INTO C2 VALUES(10, 299.9, 'Printer');  
INSERT INTO C2 VALUES(20, 149.9, 'Scanner');   
  
CREATE TABLE C3(
  pname VARCHAR(50),
  pprice NUMERIC(8,2)
);  
  
INSERT INTO C3 VALUES('mouse', 29.9);  
INSERT INTO C3 VALUES('webcam', 19.9);     
  
CREATE TABLE meta(
  table_name VARCHAR(255),
  trans_code VARCHAR(10)
);
  
INSERT INTO meta VALUES('C1', NULL);  
INSERT INTO meta VALUES('C2', 'CAP');  
INSERT INTO meta VALUES('C3', 'CAP+CUR'); 

COMMIT;