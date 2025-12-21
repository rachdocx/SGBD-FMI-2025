CREATE OR REPLACE TYPE ani_nt AS TABLE OF NUMBER;
/

CREATE OR REPLACE PROCEDURE analiza_client(p_id_client NUMBER, p_ani ani_nt ) AS
    TYPE venit_nt IS TABLE OF VENIT_CLIENT%ROWTYPE;
    venituri venit_nt;

    TYPE tipuri_t IS TABLE OF BOOLEAN INDEX BY VARCHAR2(100);
    tipuri tipuri_t;

    venit_total NUMBER := 0;
    venit_maxim NUMBER := 0;
    v_tip VARCHAR2(100);

    TYPE credit_v IS VARRAY(10) OF CREDIT%ROWTYPE;
    credite credit_v;
    suma_totala NUMBER := 0;

    TYPE luni_var IS VARRAY(12) OF NUMBER;
    TYPE ani_tab IS TABLE OF luni_var INDEX BY PLS_INTEGER;
    penalizari_ani ani_tab;

    total_penalizari NUMBER := 0;
    numar_penalizari NUMBER := 0;
    temp luni_var;
BEGIN
    SELECT *
    BULK COLLECT INTO venituri
    FROM VENIT_CLIENT
    WHERE id_client = p_id_client;

    FOR i IN 1 .. venituri.COUNT LOOP
        venit_total := venit_total + venituri(i).suma_lunara;
        IF venituri(i).suma_lunara > venit_maxim THEN
            venit_maxim := venituri(i).suma_lunara;
        END IF;
    END LOOP;

    FOR i IN 1 .. venituri.COUNT LOOP
        SELECT v.nume_venit
        INTO v_tip
        FROM VENIT v
        WHERE v.id_venit = venituri(i).id_venit;

        IF NOT tipuri.EXISTS(v_tip) THEN
            tipuri(v_tip) := TRUE;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Venit total: ' || venit_total);
    DBMS_OUTPUT.PUT_LINE('Venit maxim: ' || venit_maxim);
    DBMS_OUTPUT.PUT_LINE('Tipuri de venit:');

    v_tip := tipuri.FIRST;
    WHILE v_tip IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(v_tip);
        v_tip := tipuri.NEXT(v_tip);
    END LOOP;

    SELECT DISTINCT c.*
    BULK COLLECT INTO credite
    FROM CREDIT c
    JOIN EVALUARE e ON c.id_credit = e.id_credit
    WHERE c.id_client = p_id_client
      AND LOWER(e.decizie) = 'aprobat';

    FOR i IN 1 .. credite.COUNT LOOP
        suma_totala := suma_totala + credite(i).suma_aprobata;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Numar credite aprobate: ' || credite.COUNT);
    DBMS_OUTPUT.PUT_LINE('Suma totala aprobata: ' || suma_totala);

    FOR r IN (
        SELECT r.penalizari, r.data_scadenta
        FROM RATA r
        JOIN CREDIT c ON r.id_credit = c.id_credit
        WHERE c.id_client = p_id_client
    ) LOOP
        DECLARE
            an NUMBER := EXTRACT(YEAR FROM r.data_scadenta);
            luna NUMBER := EXTRACT(MONTH FROM r.data_scadenta);
        BEGIN
            IF NOT penalizari_ani.EXISTS(an) THEN
                penalizari_ani(an) := luni_var(0,0,0,0,0,0,0,0,0,0,0,0);
            END IF;

            temp := penalizari_ani(an);
            temp(luna) := temp(luna) + r.penalizari;
            penalizari_ani(an) := temp;

            IF r.penalizari > 0 THEN
                total_penalizari := total_penalizari + r.penalizari;
                numar_penalizari := numar_penalizari + 1;
            END IF;
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Numar penalizari: ' || numar_penalizari);
    DBMS_OUTPUT.PUT_LINE('Suma penalizari: ' || total_penalizari);

    FOR i IN 1 .. p_ani.COUNT LOOP
        IF penalizari_ani.EXISTS(p_ani(i)) THEN
            DBMS_OUTPUT.PUT_LINE('Anul ' || p_ani(i));
            temp := penalizari_ani(p_ani(i));
            FOR j IN 1 .. 12 LOOP
                DBMS_OUTPUT.PUT_LINE(' Luna ' || j || ': ' || temp(j));
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nu exista penalizari in anul ' || p_ani(i));
        END IF;
    END LOOP;
END;
/
BEGIN
    analiza_client(2, ani_nt(2022, 2023, 2024));
END;
/