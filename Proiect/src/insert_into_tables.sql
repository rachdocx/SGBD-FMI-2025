INSERT INTO VENIT (nume_venit, sursa_venit) VALUES ('Salariu', 'Angajator');
INSERT INTO VENIT (nume_venit, sursa_venit) VALUES ('Chirie', 'Imobil');
INSERT INTO VENIT (nume_venit, sursa_venit) VALUES ('Dividende', 'Investitii');
INSERT INTO VENIT (nume_venit, sursa_venit) VALUES ('PFA', 'Activitate independenta');

INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Popescu', 'Andrei', 'Bucuresti', '0711111111', 'andrei.popescu@mail.com', '1980101123456', 8000, 'BUN', 'ANGAJAT', 20);

INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Ionescu', 'Maria', 'Cluj', '0722222222', 'maria.ionescu@mail.com', '2990202123456', 4000, 'MEDIU', 'PFA', 35);

INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Georgescu', 'Vlad', 'Iasi', '0733333333', 'vlad.georgescu@mail.com', '1960505123456', 6000, 'BUN', 'ANGAJAT', 15);

INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Dumitru', 'Elena', 'Brasov', '0744444444', 'elena.dumitru@mail.com', '2880707123456', 5200, 'MEDIU', 'ANGAJAT', 30);

INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Stan', 'Radu', 'Timisoara', '0755555555', 'radu.stan@mail.com', '1900918123456', 10000, 'FOARTE_BUN', 'ANGAJAT', 10);

INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (1, 1, 6000, 'CIM');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (1, 2, 2000, 'Contract chirie');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (2, 4, 4000, 'PFA activ');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (4, 1, 5200, 'CIM');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (5, 1, 9000, 'CIM');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit) VALUES (5, 3, 1000, 'Portofoliu');

INSERT INTO ANALIST (nume, prenume, adresa, telefon, email, cnp, departament, suma_maxima)
VALUES ('Dumitrescu', 'Ana', 'Bucuresti', '0766666666', 'ana.d@mail.com', '2870303123456', 'Retail', 200000);

INSERT INTO ANALIST (nume, prenume, adresa, telefon, email, cnp, departament, suma_maxima)
VALUES ('Popa', 'Mihai', 'Cluj', '0777777777', 'mihai.p@mail.com', '1850915123456', 'Corporate', 500000);

INSERT INTO ANALIST (nume, prenume, adresa, telefon, email, cnp, departament, suma_maxima)
VALUES ('Enache', 'Ioana', 'Iasi', '0788888888', 'ioana.e@mail.com', '2890101123456', 'Retail', 150000);

INSERT INTO ACHIZITIE (tip_achizitie, procent_finantat, suma_avans, valoare_piata, valoare_evaluare, data_evaluare, descriere)
VALUES ('Apartament', 80, 20000, 120000, 115000, SYSDATE, 'Apartament 2 camere');

INSERT INTO ACHIZITIE (tip_achizitie, procent_finantat, suma_avans, valoare_piata, valoare_evaluare, data_evaluare, descriere)
VALUES ('Casa', 70, 50000, 250000, 240000, SYSDATE, 'Casa individuala');

INSERT INTO ACHIZITIE (tip_achizitie, procent_finantat, suma_avans, valoare_piata, valoare_evaluare, data_evaluare, descriere)
VALUES ('Masina', 60, 8000, 30000, 28000, SYSDATE, 'Autoturism');

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (1, 'Ipotecar', 100000, 90000, SYSDATE, SYSDATE, 12);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (1, 'Nevoi personale', 15000, 12000, SYSDATE, SYSDATE, 24);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (2, 'Consum', 5000, 4500, SYSDATE, SYSDATE, 1);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (4, 'Auto', 20000, 18000, SYSDATE, SYSDATE, 36);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (5, 'Ipotecar', 200000, 180000, SYSDATE, SYSDATE, 240);

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie, comentarii)
VALUES (1, 1, 1, 'Initiala', 25, 'A', 'APROBAT', 'OK');

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie, comentarii)
VALUES (1, 2, 1, 'Revizuire', 30, 'B', 'APROBAT', 'OK');

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie, comentarii)
VALUES (2, 3, 3, 'Initiala', 40, 'C', 'APROBAT', 'Risc mediu');

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie, comentarii)
VALUES (5, 2, 2, 'Initiala', 20, 'A', 'APROBAT', 'Risc scazut');

INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (1, 7500, 'Transfer');
INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (2, 7500, 'Transfer');
INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (3, 7500, 'Transfer');
INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (13, 4500, 'Cash');
INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (14, 750, 'Card');
INSERT INTO PLATA (id_rata, suma_platita, metoda_plata) VALUES (15, 750, 'Card');
INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit)
VALUES (2, 1, 3000, 'CIM part-time');

INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit)
VALUES (2, 2, 1200, 'Contract chirie');

INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit)
VALUES (3, 1, 6500, 'CIM full-time');

INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit)
VALUES (4, 3, 1800, 'Dividende');

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (2, 'Nevoi personale', 12000, 10000, DATE '2022-03-10', DATE '2022-03-15', 10);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (2, 'Auto', 30000, 25000, DATE '2023-01-20', DATE '2023-02-01', 24);

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (1, 'Refinantare', 20000, 18000, DATE '2024-05-10', DATE '2024-05-20', 12);

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (6, 1, 1, 'Initiala', 35, 'B', 'APROBAT');

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (7, 2, 3, 'Initiala', 40, 'C', 'APROBAT');

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (8, 1, 1, 'Initiala', 28, 'A', 'APROBAT');
INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (1, 'Ionescu', 'Mihai', 'prieteni', 8500);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (1, 'Popa', 'Elena', 'sotie', 6200);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (1, 'Dumitrescu', 'Andrei', 'coleg', 9000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (1, 'Popescu', 'Ion', 'tata', 4000);


INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (2, 'Marin', 'Alexandra', 'prietena', 7000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (2, 'Ionescu', 'Vasile', 'tata', 3800);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (2, 'Ionescu', 'Elena', 'mama', 3600);


INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (3, 'Stan', 'Radu', 'frate', 5000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (3, 'Georgescu', 'Ana', 'sora', 5200);


INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (4, 'Pop', 'Ioan', 'asociat', 12000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (4, 'Pop', 'Maria', 'prietena', 7800);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (4, 'Dumitru', 'Elena', 'mama', 4100);


INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (5, 'Stan', 'Alexandru', 'coleg', 15000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (5, 'Stan', 'Roxana', 'sotie', 9000);

INSERT INTO GARANT (id_client, nume, prenume, relatie_client, venit_garant)
VALUES (5, 'Popescu', 'Dan', 'consultant', NULL);

UPDATE RATA
SET penalizari = 150
WHERE id_credit = 6
  AND numar_rata = 3;

UPDATE RATA
SET penalizari = 200
WHERE id_credit = 6
  AND numar_rata = 5;

UPDATE RATA
SET penalizari = 100
WHERE id_credit = 6
  AND numar_rata = 8;

UPDATE RATA
SET penalizari = 250
WHERE id_credit = 7
  AND numar_rata = 4;

UPDATE RATA
SET penalizari = 300
WHERE id_credit = 7
  AND numar_rata = 9;

UPDATE RATA
SET penalizari = 180
WHERE id_credit = 7
  AND numar_rata = 15;

UPDATE RATA
SET penalizari = 90
WHERE id_credit = 8
  AND numar_rata = 2;

UPDATE RATA
SET penalizari = 120
WHERE id_credit = 8
  AND numar_rata = 7;

UPDATE RATA
SET penalizari = 220
WHERE id_credit = 8
  AND numar_rata = 11;

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (3, 'Ipotecar', 200000, 180000, SYSDATE, SYSDATE, 240);

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (9, 1, 2, 'Initiala', 30, 'B', 'APROBAT');


INSERT INTO CLIENT (nume, prenume, adresa, telefon, email, cnp, venit_lunar, status_financiar, status_angajare, grad_indatorare)
VALUES ('Marin', 'Ion', 'Constanta', '0799999999', 'ion.marin@mail.com', '1920505123456', 7000, 'MEDIU', 'ANGAJAT', 45);

INSERT INTO VENIT_CLIENT (id_client, id_venit, suma_lunara, contract_venit)
VALUES (6, 1, 7000, 'CIM');

INSERT INTO CREDIT (id_client, tip_credit, suma_solicitata, suma_aprobata, data_aplicarii, data_acordarii, numar_rate)
VALUES (6, 'Consum', 10000, 9000, SYSDATE, SYSDATE, 12);

INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (10, 1, 3, 'Initiala', 35, 'B', 'APROBAT');

COMMIT;
