CREATE OR REPLACE PACKAGE PACHET_PLATI AS
    TYPE tip_detalii_plata IS RECORD (
        id_plata NUMBER,
        id_rata NUMBER,
        id_credit NUMBER,
        numar_rata NUMBER,
        suma_rata NUMBER,
        suma_platita NUMBER,
        suma_ramasa NUMBER,
        penalizare NUMBER,
        data_scadenta DATE,
        data_plata DATE,
        zile_intarziere NUMBER,
        status_rata VARCHAR2(20)
    );
    TYPE tip_restanta IS RECORD (
        id_client NUMBER,
        nume_client VARCHAR2(100),
        id_credit NUMBER,
        id_rata NUMBER,
        numar_rata NUMBER,
        suma_rata NUMBER,
        penalizare NUMBER,
        total_de_plata NUMBER,
        data_scadenta DATE,
        zile_intarziere NUMBER
    );
    TYPE tip_lista_restante IS TABLE OF tip_restanta;

    -- FUNCTII

    FUNCTION calculeaza_penalizare(p_id_rata IN NUMBER) RETURN NUMBER;
    FUNCTION verifica_restante_client(p_id_client IN NUMBER) RETURN NUMBER;
    FUNCTION obtine_total_datorie(p_id_credit IN NUMBER) RETURN NUMBER;

    -- PROCEDURI
    PROCEDURE proceseaza_plata(
        p_id_rata IN NUMBER,
        p_suma_platita IN NUMBER,
        p_metoda_plata IN VARCHAR2 DEFAULT 'TRANSFER'
    );
    PROCEDURE marcheaza_intarzieri;
    PROCEDURE genereaza_raport_restante;

END PACHET_PLATI;
/

CREATE OR REPLACE PACKAGE BODY PACHET_PLATI AS

    c_penalizare_zi NUMBER := 0.5;
    FUNCTION calculeaza_penalizare(
        p_id_rata IN NUMBER
    ) RETURN NUMBER IS
        v_suma_rata NUMBER;
        v_data_scadenta DATE;
        v_zile_intarziere NUMBER;
        v_penalizare NUMBER := 0;
    BEGIN
        SELECT suma_rata, data_scadenta
        INTO v_suma_rata, v_data_scadenta
        FROM RATA
        WHERE id_rata = p_id_rata;
        v_zile_intarziere := TRUNC(SYSDATE) - TRUNC(v_data_scadenta);
        IF v_zile_intarziere > 0 THEN
            v_penalizare := v_suma_rata*(c_penalizare_zi/100)*v_zile_intarziere;
        END IF;
        RETURN ROUND(v_penalizare, 2);

    END calculeaza_penalizare;
    FUNCTION verifica_restante_client(
        p_id_client IN NUMBER
    ) RETURN NUMBER IS
        v_numar_restante NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_numar_restante
        FROM RATA r
        JOIN CREDIT c ON r.id_credit = c.id_credit
        WHERE c.id_client = p_id_client
        AND r.status_rata IN ('NEPLATITA', 'INTARZIATA')
        AND r.data_scadenta < SYSDATE;
        RETURN v_numar_restante;
    END verifica_restante_client;

    FUNCTION obtine_total_datorie(
        p_id_credit IN NUMBER
    ) RETURN NUMBER IS
        v_total_rate NUMBER := 0;
        v_total_penalizari NUMBER := 0;
        v_total_datorie NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(suma_rata), 0)
        INTO v_total_rate
        FROM RATA
        WHERE id_credit = p_id_credit AND status_rata IN ('NEPLATITA', 'INTARZIATA');

        SELECT NVL(SUM(penalizari), 0)
        INTO v_total_penalizari
        FROM RATA
        WHERE id_credit = p_id_credit
        AND status_rata IN ('NEPLATITA', 'INTARZIATA');

        v_total_datorie := v_total_rate + v_total_penalizari;

        RETURN ROUND(v_total_datorie, 2);

    END obtine_total_datorie;

    PROCEDURE proceseaza_plata(
        p_id_rata IN NUMBER,
        p_suma_platita IN NUMBER,
        p_metoda_plata IN VARCHAR2 DEFAULT 'TRANSFER'
    ) IS
        v_suma_rata NUMBER;
        v_penalizare NUMBER;
        v_total_de_plata NUMBER;
        v_status_nou VARCHAR2(20);
    v_suma_anterioara NUMBER := 0;
    BEGIN
        SELECT suma_rata, penalizari
        INTO v_suma_rata, v_penalizare
        FROM RATA
        WHERE id_rata = p_id_rata;

        SELECT NVL(SUM(suma_platita), 0)
        INTO v_suma_anterioara
        FROM PLATA
        WHERE id_rata = p_id_rata;

        v_total_de_plata := v_suma_rata + v_penalizare;

        IF (v_suma_anterioara + p_suma_platita) >= v_total_de_plata THEN
            v_status_nou := 'PLATITA';
        ELSE
            v_status_nou := 'PARTIAL_PLATITA';
        END IF;

        INSERT INTO PLATA (id_rata, data_plata, suma_platita, metoda_plata
        ) VALUES (p_id_rata, SYSDATE, p_suma_platita, p_metoda_plata);

        UPDATE RATA
        SET status_rata = v_status_nou
        WHERE id_rata = p_id_rata;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(' plata realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('  suma platita: ' || p_suma_platita || ' RON');
        DBMS_OUTPUT.PUT_LINE('  status nou: ' || v_status_nou);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('eroare: rata nu exista!');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('eroare procesare plata: ');
            ROLLBACK;
    END proceseaza_plata;

    PROCEDURE marcheaza_intarzieri IS
        v_count NUMBER := 0;
        v_penalizare NUMBER;
    BEGIN
        FOR rec IN (
            SELECT id_rata
            FROM RATA
            WHERE status_rata = 'NEPLATITA'
            AND data_scadenta < SYSDATE
        ) LOOP
            v_penalizare := calculeaza_penalizare(rec.id_rata);

            UPDATE RATA
            SET status_rata = 'INTARZIATA',
                penalizari = v_penalizare
            WHERE id_rata = rec.id_rata;

            v_count := v_count + 1;
        END LOOP;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('rate marcate' || v_count);
        DBMS_OUTPUT.PUT_LINE('data: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

    END marcheaza_intarzieri;

    PROCEDURE genereaza_raport_restante IS
        v_restante tip_lista_restante;
        v_total_general NUMBER := 0;
    BEGIN
        SELECT
            c.id_client,
            cl.nume ||' '|| cl.prenume,
            c.id_credit,
            r.id_rata,
            r.numar_rata,
            r.suma_rata,
            r.penalizari,
            r.suma_rata + r.penalizari,
            r.data_scadenta,
            TRUNC(SYSDATE) - TRUNC(r.data_scadenta)
        BULK COLLECT INTO v_restante
        FROM RATA r
        JOIN CREDIT c ON r.id_credit = c.id_credit
        JOIN CLIENT cl ON c.id_client = cl.id_client
        WHERE r.status_rata IN ('NEPLATITA', 'INTARZIATA')
        AND r.data_scadenta < SYSDATE
        ORDER BY r.data_scadenta;

        DBMS_OUTPUT.PUT_LINE('RAPORT RESTANTE ACTIVE');
        DBMS_OUTPUT.PUT_LINE('data: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('');

        IF v_restante.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('nu exista restante active.');
        ELSE
            FOR i IN 1..v_restante.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('client: ' || v_restante(i).nume_client);
                DBMS_OUTPUT.PUT_LINE('  credit ID: ' || v_restante(i).id_credit ||' Rata: ' || v_restante(i).numar_rata);
                DBMS_OUTPUT.PUT_LINE('  suma rata: ' || v_restante(i).suma_rata || ' RON');
                DBMS_OUTPUT.PUT_LINE('  penalizare: ' || v_restante(i).penalizare || ' RON');
                DBMS_OUTPUT.PUT_LINE('  TOTAL DE PLATA: ' || v_restante(i).total_de_plata || ' RON');
                DBMS_OUTPUT.PUT_LINE('  scadenta: ' || TO_CHAR(v_restante(i).data_scadenta, 'DD-MON-YYYY'));
                DBMS_OUTPUT.PUT_LINE('  zile intarziere: ' || v_restante(i).zile_intarziere);
                DBMS_OUTPUT.PUT_LINE('----------------------------------------');

                v_total_general := v_total_general + v_restante(i).total_de_plata;
            END LOOP;

            DBMS_OUTPUT.PUT_LINE('total restante: ' || v_restante.COUNT);
            DBMS_OUTPUT.PUT_LINE('suma totala de incasat: ' || ROUND(v_total_general, 2) || ' RON');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('eroare generare raport: ' || SQLERRM);
    END genereaza_raport_restante;

END PACHET_PLATI;
/

BEGIN
    PACHET_PLATI.marcheaza_intarzieri;
END;
/

DECLARE
    v_restante NUMBER;
BEGIN
    --introducem orice client
    v_restante := PACHET_PLATI.verifica_restante_client(1);
    DBMS_OUTPUT.PUT_LINE('clientul 1 are ' || v_restante || ' rate restante.');
END;
/
DECLARE
    v_datorie NUMBER;
BEGIN
    --introducem orice client
    v_datorie := PACHET_PLATI.obtine_total_datorie(1);
    DBMS_OUTPUT.PUT_LINE('datoria totala pentru creditul 1: ' || v_datorie || ' RON');
END;
/
BEGIN
    PACHET_PLATI.proceseaza_plata(1, 1500, 'CARD');
END;
/
BEGIN
    PACHET_PLATI.genereaza_raport_restante;
END;
/
