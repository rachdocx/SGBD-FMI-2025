CREATE OR REPLACE TRIGGER trg_validare_clasa_risc
AFTER INSERT OR UPDATE ON EVALUARE
DECLARE
    CURSOR c_evaluari IS
        SELECT id_evaluare, scor_risc, clasa_risc
        FROM EVALUARE;

    v_clasa VARCHAR2(10);
BEGIN
    FOR rec IN c_evaluari LOOP
        IF rec.scor_risc < 30 THEN
            v_clasa := 'A';
        ELSIF rec.scor_risc < 50 THEN
            v_clasa := 'B';
        ELSE
            v_clasa := 'C';
        END IF;

        IF rec.clasa_risc != v_clasa THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Clasa risc inconsistenta pentru evaluarea ' || rec.id_evaluare ||
                ': scor=' || rec.scor_risc ||
                ', clasa=' || rec.clasa_risc ||
                ', asteptat=' || v_clasa);
        END IF;
    END LOOP;
END;
/
--declansare trigger
INSERT INTO EVALUARE (id_credit, id_analist, id_achizitie, tip_evaluare, scor_risc, clasa_risc, decizie)
VALUES (2, 1, 1, 'Revizuire', 55, 'A', 'APROBAT');
/
UPDATE EVALUARE
SET clasa_risc = 'B'
WHERE id_evaluare = 1 AND scor_risc = 25;
