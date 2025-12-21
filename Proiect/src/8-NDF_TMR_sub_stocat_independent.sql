CREATE OR REPLACE FUNCTION get_tip_achizitie_credit (
    p_id_credit NUMBER
) RETURN VARCHAR2
IS
    v_tip_achizitie ACHIZITIE.tip_achizitie%TYPE;
BEGIN
    SELECT a.tip_achizitie
    INTO v_tip_achizitie
    FROM credit c
    JOIN evaluare e ON c.id_credit = e.id_credit
    JOIN achizitie a ON e.id_achizitie = a.id_achizitie
    WHERE c.id_credit = p_id_credit;

    RETURN v_tip_achizitie;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,
        'Nu exista nicio achizitie asociata creditului dat');

    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002,
        'Creditul are mai multe achizitii');

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,
        'Eroare neprevazuta');
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_tip_achizitie_credit(2));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_tip_achizitie_credit(1));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_tip_achizitie_credit(999));
END;
/

