CREATE OR REPLACE TRIGGER trg_validare_evaluare
BEFORE INSERT OR UPDATE ON ACHIZITIE
FOR EACH ROW
DECLARE
    v_valoare_minima NUMBER;
BEGIN
    v_valoare_minima := :NEW.valoare_piata * 0.70;

    IF :NEW.valoare_evaluare > :NEW.valoare_piata THEN
        RAISE_APPLICATION_ERROR(-20003, 'Valoare evaluare (' || :NEW.valoare_evaluare ||
            ') nu poate depasi valoarea de piata (' || :NEW.valoare_piata || ')');
    END IF;

    IF :NEW.valoare_evaluare < v_valoare_minima THEN
        RAISE_APPLICATION_ERROR(-20004, 'Valoare evaluare (' || :NEW.valoare_evaluare ||
            ') este prea mica. Minim acceptat: ' || v_valoare_minima);
    END IF;
END;
/
INSERT INTO ACHIZITIE (tip_achizitie, procent_finantat, suma_avans, valoare_piata, valoare_evaluare, data_evaluare, descriere)
VALUES ('Apartament', 80, 40000, 200000, 220000, SYSDATE, 'Evaluare supraevaluata');
/
INSERT INTO ACHIZITIE (tip_achizitie, procent_finantat, suma_avans, valoare_piata, valoare_evaluare, data_evaluare, descriere)
VALUES ('Vila', 70, 60000, 300000, 180000, SYSDATE, 'Evaluare subevaluata');
/
UPDATE ACHIZITIE
SET valoare_evaluare = 160000
WHERE id_achizitie = 1;